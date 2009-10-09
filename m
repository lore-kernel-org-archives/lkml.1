Return-Path: <linux-kernel-owner+w=401wt.eu-S1756221AbZJIF4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbZJIF4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 01:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbZJIF4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 01:56:19 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:53775 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976AbZJIF4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 01:56:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=QrGxL+FQS2scYpw2MKhXnuaWSnsIWzXdIuxHoyqaahxDx72TvnBZt5Q7iFAGVBK1zF
         z1p4FSnoW2KZiORAmCRspyDHvhJJ/iwXiVFXIZQk8p0RWVXkbTbHQTwDtbclTocRv11u
         dKkHL5Q4+ARlMUTRUlDIHMkfaTXEbpnAVIxqE=
MIME-Version: 1.0
Date: Fri, 9 Oct 2009 13:55:43 +0800
Message-ID: <a5b3ea7b0910082255x5767726du4721d2ee38df38fa@mail.gmail.com>
Subject: select system call's implementation may have some bug, need your help 
	and confirm !!!
From: wu Jianfeng <stormplayer@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A process may sleep for ever when he call select system call.
In detail, if the process was scheduled out just at the point it set
its state to TASK_INTERRUPTIBLE.

The events that cause the process to be scheduled out is(in preempt kernel) :
1) time interrupt and the process's time slice is exhausted.
2) an interrupt accured, and wake up another process with high priority.

see the comments after "##"

int do_select(int n, fd_set_bits *fds, s64 *timeout)
{
struct poll_wqueues table;
poll_table *wait;
int retval, i;

rcu_read_lock();
retval = max_select_fd(n, fds);
rcu_read_unlock();

if (retval < 0)
return retval;
n = retval;

poll_initwait(&table);
wait = &table.pt;
if (!*timeout)
wait = NULL;
retval = 0;
for (;;) {
unsigned long *rinp, *routp, *rexp, *inp, *outp, *exp;
long __timeout;

set_current_state(TASK_INTERRUPTIBLE);
## here set the process state TASK_INTERRUPTIBLE

 ## if  the process was scheduled out here, then the process will
never can be waked up, because it has not been attached to any file 's
wait queue.

inp = fds->in; outp = fds->out; exp = fds->ex;
rinp = fds->res_in; routp = fds->res_out; rexp = fds->res_ex;

for (i = 0; i < n; ++rinp, ++routp, ++rexp) {
unsigned long in, out, ex, all_bits, bit = 1, mask, j;
unsigned long res_in = 0, res_out = 0, res_ex = 0;
struct file_operations *f_op = NULL;
struct file *file = NULL;

in = *inp++; out = *outp++; ex = *exp++;
all_bits = in | out | ex;
if (all_bits == 0) {
i += __NFDBITS;
continue;
}

for (j = 0; j < __NFDBITS; ++j, ++i, bit <<= 1) {
if (i >= n)
break;
if (!(bit & all_bits))
continue;
file = fget(i);
if (file) {
f_op = file->f_op;
mask = DEFAULT_POLLMASK;
if (f_op && f_op->poll)
mask = (*f_op->poll)(file, retval ? NULL : wait);
fput(file);
if ((mask & POLLIN_SET) && (in & bit)) {
res_in |= bit;
retval++;
}
if ((mask & POLLOUT_SET) && (out & bit)) {
res_out |= bit;
retval++;
}
if ((mask & POLLEX_SET) && (ex & bit)) {
res_ex |= bit;
retval++;
}
}
cond_resched();
}
if (res_in)
*rinp = res_in;
if (res_out)
*routp = res_out;
if (res_ex)
*rexp = res_ex;
}
wait = NULL;
if (retval || !*timeout || signal_pending(current))
break;
if(table.error) {
retval = table.error;
break;
}

if (*timeout < 0) {
/* Wait indefinitely */
__timeout = MAX_SCHEDULE_TIMEOUT;
} else if (unlikely(*timeout >= (s64)MAX_SCHEDULE_TIMEOUT - 1)) {
/* Wait for longer than MAX_SCHEDULE_TIMEOUT. Do it in a loop */
__timeout = MAX_SCHEDULE_TIMEOUT - 1;
*timeout -= __timeout;
} else {
__timeout = *timeout;
*timeout = 0;
}
__timeout = schedule_timeout(__timeout);
if (*timeout >= 0)
*timeout += __timeout;
}
__set_current_state(TASK_RUNNING);

poll_freewait(&table);

return retval;
}
