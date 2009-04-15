Return-Path: <linux-kernel-owner+w=401wt.eu-S1756297AbZDOCz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbZDOCz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 22:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbZDOCzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 22:55:11 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:35102 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZDOCzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 22:55:09 -0400
To: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <linux-pci@vger.kernel.org>, <linux-mm@kvack.org>,
       <linux-fsdevel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       Hugh Dickins <hugh@veritas.com>, Tejun Heo <tj@kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC][PATCH 5/9] vfs: Introduce basic infrastructure for revoking a file
References: <m1skkf761y.fsf@fess.ebiederm.org>
	<m163hb75ph.fsf@fess.ebiederm.org>
	<20090414161240.73fe6bcd@bike.lwn.net>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 14 Apr 2009 19:55:01 -0700
In-Reply-To: <20090414161240.73fe6bcd@bike.lwn.net> (Jonathan Corbet's message of "Tue\, 14 Apr 2009 16\:12\:40 -0600")
Message-ID: <m1tz4qwrqy.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: corbet@lwn.net, gregkh@suse.de, alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org, adobriyan@gmail.com, tj@kernel.org, hugh@veritas.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet <corbet@lwn.net> writes:

> Hi, Eric,
>
> One little thing I noticed as I was looking at this...
>
>> +int fops_substitute(struct file *file, const struct file_operations *f_op,
>> +			struct vm_operations_struct *vm_ops)
>> +{
>
>  [...]
>
>> +	/*
>> +	 * Wait until there are no more callers in the original
>> +	 * file_operations methods.
>> +	 */
>> +	while (atomic_long_read(&file->f_use) > 0)
>> +		schedule_timeout_interruptible(1);
>
> You use an interruptible sleep here, but there's no signal check to get you
> out of the loop.  So it's not really interruptible.  If f_use never goes to
> zero (a distressingly likely possibility, I fear), this code will create
> the equivalent of an unkillable D-wait state without ever actually showing
> up that way in "ps".

I snagged this idiom out of srcu and hadn't given it much thought.

We have a number of places in the kernel where we aren't performing work
for user space where we fib about the kind of sleep we are doing, so
we don't increase the load.  In this case we are in fs code so I guess
calling this an uninterruptible sleep is fair, especially since it
looks like at some point this code path is going be called from
a syscall.

As for f_use not going to zero, we have strong progress guarantees:

- fops_read_lock at that point will not increment the count of any new
  users of the file.

- There is an additional awaken_all_waiters to wake up any wait queues
  that are causing syscalls to block in the kernel.  


> Actually, now that I look, once you've got a signal pending you'll stay
> in TASK_RUNNING, so the above could turn into a busy-wait.
>
> Unless I've missed something...?

Well we will always schedule, so it shouldn't be a pure busy-wait,
but overall I would call this a good catch.

> I have no idea what the right thing to do in the face of a signal would
> be.  Perhaps the wait-for-zero and release() call stuff should be dumped
> into a workqueue and done asynchronously?  OTOH, I can see a need to know
> when the revoke operation is really done...

Yes.

For sys_revoke the wait doesn't appear necessary.

For umount -f, rmmod, or pci hotunplug we need the wait to know when we it
is safe to free up underlying data structures.  And at least for the latter
two being truly interruptible is a correctness problem.

Eric
