Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbZDNPIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbZDNPIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbZDNPIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:08:01 -0400
Received: from mail2.shareable.org ([80.68.89.115]:58038 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295AbZDNPH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:07:59 -0400
Date: Tue, 14 Apr 2009 16:07:45 +0100
From: Jamie Lokier <jamie@shareable.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Hugh Dickins <hugh@veritas.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC][PATCH 0/9] File descriptor hot-unplug support
Message-ID: <20090414150745.GC26621@shareable.org>
References: <m1skkf761y.fsf@fess.ebiederm.org> <49E4000E.10308@kernel.org> <m13acbbs5u.fsf@fess.ebiederm.org> <49E43F1D.3070400@kernel.org> <m18wm38ws1.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m18wm38ws1.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> > I don't have anything at hand but multithread/process server accepting
> > on the same socket comes to mind.  I don't think it would be a very
> > rare thing.  If you confine the scope to character devices or sysfs,
> > it could be quite rare tho.
> 
> Yes.  I think I can safely exclude sockets, and not bother with
> reference counting them.

Good idea.  As well as many processes calling accept(), it's not
unusual to have two threads or processes for reading and writing
concurrently to TCP sockets, and to have a single UDP socket shared
among threads/processes for sendto.

> The only strong evidence I have that multi-threading on a single file
> descriptor is likely to be common is that we have pread and pwrite
> syscalls.  At the same time the number of races we have in struct file
> if it is accessed by multiple threads at the same time, suggests
> that at least for cases where you have an offset it doesn't happen often.

Notice the preadv and pwritev syscalls added recently?  They were
added because QEMU and KVM need them for performance.  Those programs
have multiple threads doing I/O to the same file concurrently.  It's
like a poor man's AIO, except it's more reliable than real Linux AIO :-)

Databases probably should use concurrent p{read,write}{,v} if they're
not using direct I/O and AIO.  I'm not sure if the well-known
databases do.  In the past there have been some poor quality
"emulations" of those syscalls prone to races, on Linux and BSD I believe.

What are the races you've noticed?

-- Jamie
