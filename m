Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbZDNHjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbZDNHjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 03:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbZDNHjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 03:39:35 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:45989 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbZDNHje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 03:39:34 -0400
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
       Hugh Dickins <hugh@veritas.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC][PATCH 0/9] File descriptor hot-unplug support
References: <m1skkf761y.fsf@fess.ebiederm.org> <49E4000E.10308@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 14 Apr 2009 00:39:25 -0700
In-Reply-To: <49E4000E.10308@kernel.org> (Tejun Heo's message of "Tue\, 14 Apr 2009 12\:16\:30 +0900")
Message-ID: <m13acbbs5u.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: tj@kernel.org, gregkh@suse.de, alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org, adobriyan@gmail.com, hugh@veritas.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello, Eric.
>
> Eric W. Biederman wrote:
>> A couple of weeks ago I found myself looking at the uio, seeing that
>> it does not support pci hot-unplug, and thinking "Great yet another
>> implementation of hotunplug logic that needs to be added".
>> 
>> I decided to see what it would take to add a generic implementation of
>> the code we have for supporting hot unplugging devices in sysfs, proc,
>> sysctl, tty_io, and now almost in the tun driver.
>> 
>> Not long after I touched the tun driver and made it safe to delete the
>> network device while still holding it's file descriptor open I someone
>> else touch the code adding a different feature and my careful work
>> went up in flames.  Which brought home another point at the best of it
>> this is ultimately complex tricky code that subsystems should not need
>> to worry about.
>
> I like the way it's headed.  I'm trying to add similar 'revoke' or
> 'sever' mechanism at block and char device layers so that low level
> drivers don't have to worry about object lifetimes and so on.  Doing
> it at the file layer makes sense and can probably replace whatever
> mechanism at the chardev.
>
> The biggest obstacle was the extra in-use reference count overhead.  I
> thought it could be solved by implementing generic percpu reference
> count similar to the one used for module reference counting.  Hot path
> overhead could be reduced to local_t cmpxchg (w/o LOCK prefix) on
> per-cpu variable + one branch, which was pretty good.  The problem was
> that space and access overhead for dynamic per-cpu variables wasn't
> too good, so I started working on dynamic percpu allocator.
>
> The dynamic per-cpu allocator is pretty close to completion.  Only
> several archs need to be converted and it's likely to happen during
> next few months.  The plan after that was 1. add per-cpu local_t
> accessors (might replace local_t completely) 2. add generic per-cpu
> reference counter and move module reference counting to it
> 3. implement block/chardev sever (or revoke) support.
>
> I think #3 can be merged with what you're working on.  What do you
> think?

Sounds reasonable.

Do you know of a case where we actually have multiple tasks accessing
a file simultaneously?

I just instrumented up my patch an so far the only case I have found
are multiple processes closing the same file.  Some weird part of
bash forking extra processes.

Eric
