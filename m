Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbYLATRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbYLATRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 14:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbYLATRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 14:17:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57538 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbYLATRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 14:17:24 -0500
Date: Mon, 1 Dec 2008 20:15:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Al Viro <viro@zeniv.linux.org.uk>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: BUG? "Call fasync() functions without the BKL" is racy
Message-ID: <20081201191555.GA21385@redhat.com>
References: <20081128192508.GA21369@redhat.com> <4933CBB0.2060003@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4933CBB0.2060003@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01, Andi Kleen wrote:
>
> Oleg Nesterov wrote:
>>
>> Let's suppose we have the tasks T1, T2, T3 which share the same file,
>> all do sys_fcntl(file, F_SETFL) in parallel. file->f_flags == 0.
>>
>> setfl(arg) does:
>>
>> 	if ((arg ^ filp->f_flags) & FASYNC)
>> // --- WINDOW_1 ---
>> 		filp->f_op->fasync(fd, filp, (arg & FASYNC) != 0)
>> // --- WINDOW_2 ---
>> 	filp->f_flags = arg;
>>
>> T1 calls setfl(FASYNC), preempted in WINDOW_1.
>>
>> T2 calls setfl(FASYNC), does all job and returns.
>>
>> T3 calls setfl(0), sees ->f_flags & FASYNC, does ->fasync(on => 0),
>> preempted in WINDOW_2.
>>
>> T1 resumes, does ->fasync(on => 1) again, update ->f_flags (it
>> already has FASYNC) and returns.
>>
>> T3 resumes, and clears FASYNC from ->f_flags.
>>
>>
>>
>> Now, this file was added into some "struct fasync_struct", but
>> ->f_flags doesn't have FASYNC. This means __fput() will skip
>> ->fasync(on => 0) and the next kill_fasync() can crash because
>> fa_file points to the freed/reused memory.
>
> Nasty. Thanks for catching.

Actually, this is more simple. Somehow I missed that setf() _always_
updates ->f_flags, so we have a trivial race with 2 threads.

>>
>> I think a238b790d5f99c7832f9b73ac8847025815b85f7 should be reverted.
>> Or do you see the better fix?
>
> Hmm, about checking for this case and retrying?
>
> Or put a fasync mutex into files_struct.

Perhaps, we can add O_LOCK_FLAGS, then something like

	--- a/fs/fcntl.c
	+++ b/fs/fcntl.c
	@@ -175,6 +175,15 @@ static int setfl(int fd, struct file * f
		if (error)
			return error;
	 
	+	spin_lock(&current->files->file_lock);
	+	if (!(filp->f_flags & O_LOCK_FLAGS))
	+		filp->f_flags |= O_LOCK_FLAGS;
	+	else
	+		error = -EAGAIN;
	+	spin_unlock(&current->files->file_lock);
	+	if (error) /* pretend ->f_flags was changed after us */
	+		return 0;
	+
		if ((arg ^ filp->f_flags) & FASYNC) {
			if (filp->f_op && filp->f_op->fasync) {
				error = filp->f_op->fasync(fd, filp, (arg & FASYNC) != 0);
	@@ -183,7 +192,8 @@ static int setfl(int fd, struct file * f
			}
		}
	 
	-	filp->f_flags = (arg & SETFL_MASK) | (filp->f_flags & ~SETFL_MASK);
	+	filp->f_flags = (arg & SETFL_MASK) |
	+			(filp->f_flags & ~(SETFL_MASK | O_LOCK_FLAGS));
	  out:
		return error;
	 }

What do you think?

(btw, ioctl_fioasync() calls lock_kernel() but it doesn't protect ->f_flags)

Oleg.

