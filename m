Return-Path: <linux-kernel-owner+w=401wt.eu-S1757001AbXFHEUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001AbXFHEUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 00:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbXFHEUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 00:20:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370AbXFHEUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 00:20:25 -0400
Message-ID: <4668D89C.7010906@redhat.com>
Date: Fri, 08 Jun 2007 06:18:36 +0200
From: Miloslav Trmac <mitr@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
       Alexander Viro <aviro@redhat.com>
Subject: Re: [PATCH] Audit: Add TTY input auditing
References: <4666832D.8080603@redhat.com>	<46668814.7080404@redhat.com> <20070606174113.b7fc31da.akpm@linux-foundation.org>
In-Reply-To: <20070606174113.b7fc31da.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the review.
Andrew Morton napsal(a):
> On Wed, 06 Jun 2007 12:10:28 +0200 Miloslav Trmac <mitr@redhat.com> wrote:
>> +/**
>> + *	tty_audit_opening	-	A TTY is being opened.
>> + *
>> + *	As a special hack, tasks that close all their TTYs and open new ones
>> + *	are assumed to be system daemons (e.g. getty) and auditing is
>> + *	automatically disabled for them.
>> + */
>> +void
>> +tty_audit_opening(void)
>> +{
>> +	int disable;
>> +
>> +	disable = 1;
>> +	spin_lock(&current->sighand->siglock);
>> +	if (current->signal->audit_tty == 0)
>> +		disable = 0;
>> +	spin_unlock(&current->sighand->siglock);
>> +	if (!disable)
>> +		return;
>> +
>> +	task_lock(current);
>> +	if (current->files) {
>> +		struct fdtable *fdt;
>> +		unsigned i;
>> +
>> +		/*
>> +		 * We don't take a ref to the file, so we must hold ->file_lock
>> +		 * instead.
>> +		 */
>> +		spin_lock(&current->files->file_lock);
> 
> So we make file_lock nest inside task_lock().  Was that lock ranking
> already being used elsewhere in the kernel, or is it a new association?
It is used in __do_SAK ().

> Has this code had full coverage testing with all lockdep features enabled?
> 
> (I suspect not - lockdep should have gone wild over the siglock thing)
It was not.  The new version will be.


>> diff --git a/kernel/audit.c b/kernel/audit.c
>> index d13276d..a071a96 100644
>> --- a/kernel/audit.c
>> +++ b/kernel/audit.c
>> @@ -423,6 +424,32 @@ static int kauditd_thread(void *dummy)
>>  	return 0;
>>  }
>>  
>> +static int
>> +audit_prepare_user_tty(pid_t pid, uid_t loginuid)
>> +{
>> +	struct task_struct *tsk;
>> +	int err;
>> +
>> +	read_lock(&tasklist_lock);
>> +	tsk = find_task_by_pid(pid);
>> +	err = -ESRCH;
>> +	if (!tsk)
>> +		goto out;
>> +	err = 0;
>> +
>> +	spin_lock(&tsk->sighand->siglock);
>> +	if (!tsk->signal->audit_tty)
>> +		err = -EPERM;
>> +	spin_unlock(&tsk->sighand->siglock);
> So siglock nests inside tasklist_lock?  Sounds reasonable.  Is this a
> preexisting association, or did this patch just create it?
This is used in send_sig_info() and several other functions in
kernel/signal.c.


>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index d58e74b..3ae4904 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -506,6 +506,8 @@ struct signal_struct {
>>  #ifdef CONFIG_TASKSTATS
>>  	struct taskstats *stats;
>>  #endif
>> +	unsigned audit_tty:1;
>> +	struct tty_audit_buf *tty_audit_buf;
>>  };
> 
> hm, bitfields are risky.  If someone adds another one, it will land in
> the same word and external locking will be needed.  You do seem to be using
> ->siglock to cover this - was that to address the bitfield non-atomicity
> problem?
I don't know what the memory access atomicity assumptions are in the
kernel, so I have used the basic rule that any write<->read conflict on
a variable with type other than atomic_t must be prevented by a lock.
This happens to work for the bit field as well.

> A suitable (but somewhat less pretty) way to resolve all this is to not use
> bitfields at all: add `unsigned long flags' and use set_bit/clear_bit/etc.
The new patch replaces the bit field by a simple "unsigned", a whole
word is allocated for the bit field anyway.

>>
>>  		break;
>> +	case AUDIT_TTY_GET: {
>> +		struct audit_tty_status s;
>> +		struct task_struct *tsk;
>> +
>> +		read_lock(&tasklist_lock);
>> +		tsk = find_task_by_pid(pid);
>> +		if (!tsk)
>> +			err = -ESRCH;
>> +		else {
>> +			spin_lock(&tsk->sighand->siglock);
>> +			s.enabled = tsk->signal->audit_tty != 0;
>> +			spin_unlock(&tsk->sighand->siglock);
> 
> The locking here looks dubious.  tsk->signal->audit_tty can change state
> the instant ->siglock gets unlocked, in which case s.enabled is now wrong.
The user-space process must avoid concurrent AUDIT_TTY_SET to get
reasonable results.  There's nothing better the kernel can do.

> If that is acceptable then we didn't need that locking at all.
So I can assume that int-sized reads are always atomic with respect to
concurrent writes?
	Mirek
