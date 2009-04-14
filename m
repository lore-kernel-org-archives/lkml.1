Return-Path: <linux-kernel-owner+w=401wt.eu-S1752193AbZDNTKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbZDNTKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 15:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbZDNTJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 15:09:52 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53550 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbZDNTJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 15:09:51 -0400
To: Jamie Lokier <jamie@shareable.org>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Hugh Dickins <hugh@veritas.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC][PATCH 0/9] File descriptor hot-unplug support
References: <m1skkf761y.fsf@fess.ebiederm.org> <49E4000E.10308@kernel.org>
	<m13acbbs5u.fsf@fess.ebiederm.org> <49E43F1D.3070400@kernel.org>
	<m18wm38ws1.fsf@fess.ebiederm.org>
	<20090414150745.GC26621@shareable.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 14 Apr 2009 12:09:41 -0700
In-Reply-To: <20090414150745.GC26621@shareable.org> (Jamie Lokier's message of "Tue\, 14 Apr 2009 16\:07\:45 +0100")
Message-ID: <m163h72gsq.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: jamie@shareable.org, gregkh@suse.de, alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org, adobriyan@gmail.com, hugh@veritas.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, tj@kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier <jamie@shareable.org> writes:

> Eric W. Biederman wrote:
>> > I don't have anything at hand but multithread/process server accepting
>> > on the same socket comes to mind.  I don't think it would be a very
>> > rare thing.  If you confine the scope to character devices or sysfs,
>> > it could be quite rare tho.
>> 
>> Yes.  I think I can safely exclude sockets, and not bother with
>> reference counting them.
>
> Good idea.  As well as many processes calling accept(), it's not
> unusual to have two threads or processes for reading and writing
> concurrently to TCP sockets, and to have a single UDP socket shared
> among threads/processes for sendto.

I have been playing with what I can see when I instrument up my code.

The first thing that popped up was that we have a lots of reads/writes
to files with f_count > 1.  Which defeats my micro optimization in
fops_read_lock.  So in those cases I still have to pay the full cost
of an atomic even if I have an exclusive cache line.

I have found that for make -j N I tend to get N processes all
reading from the same pipe at the same time.  Not a smoking
gun that my assumption that only one process will be using
a file descriptor at a time in performance paths but it certainly
shows that things are nowhere near as rare as I thought.

The good news is that I have found a much better/cheaper optimization.
Instead of per cpu or per file memory, use per task memory.  It is
always uncontended, and a task appears to never use more than two files
simultaneously (stacking?).

I have just prototyped that and things are looking very promising.
Now I just need to clean everything up and resend my patches.

>> The only strong evidence I have that multi-threading on a single file
>> descriptor is likely to be common is that we have pread and pwrite
>> syscalls.  At the same time the number of races we have in struct file
>> if it is accessed by multiple threads at the same time, suggests
>> that at least for cases where you have an offset it doesn't happen often.
>
> Notice the preadv and pwritev syscalls added recently?  They were
> added because QEMU and KVM need them for performance.  Those programs
> have multiple threads doing I/O to the same file concurrently.  It's
> like a poor man's AIO, except it's more reliable than real Linux AIO :-)
>
> Databases probably should use concurrent p{read,write}{,v} if they're
> not using direct I/O and AIO.  I'm not sure if the well-known
> databases do.  In the past there have been some poor quality
> "emulations" of those syscalls prone to races, on Linux and BSD I believe.
>
> What are the races you've noticed?

Besides the f_pos (which pread variants handle) there is no locking on
the file read ahead state, and f_flags only got locking a month or two
ago.


Eric
