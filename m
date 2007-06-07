Return-Path: <linux-kernel-owner+w=401wt.eu-S966084AbXFGAl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966084AbXFGAl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 20:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964970AbXFGAlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 20:41:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55786 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757031AbXFGAls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 20:41:48 -0400
Date: Wed, 6 Jun 2007 17:41:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miloslav Trmac <mitr@redhat.com>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
       Alexander Viro <aviro@redhat.com>
Subject: Re: [PATCH] Audit: Add TTY input auditing
Message-Id: <20070606174113.b7fc31da.akpm@linux-foundation.org>
In-Reply-To: <46668814.7080404@redhat.com>
References: <4666832D.8080603@redhat.com>
	<46668814.7080404@redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jun 2007 12:10:28 +0200 Miloslav Trmac <mitr@redhat.com> wrote:

> From: Miloslav Trmac <mitr@redhat.com>
> 
> Add TTY input auditing, used to audit system administrator's actions.
> TTY input auditing works on a higher level than auditing all system
> calls within the session, which would produce an overwhelming amount of
> mostly useless audit events.
> 
> Add an "audit_tty" attribute, inherited across fork ().  Data read from
> TTYs by process with the attribute is sent to the audit subsystem by the
> kernel.  The audit netlink interface is extended to allow modifying the
> audit_tty attribute, and to allow sending explanatory audit events from
> user-space (for example, a shell might send an event containing the
> final command, after the interactive command-line editing and history
> expansion is performed, which might be difficult to decipher from the
> TTY input alone).
> 
> Because the "audit_tty" attribute is inherited across fork (), it would
> be set e.g. for sshd restarted within an audited session.  To prevent
> this, the audit_tty attribute is cleared when a process with no open TTY
> file descriptors (e.g. after daemon startup) opens a TTY.
> 
> See https://www.redhat.com/archives/linux-audit/2007-June/msg00000.html
> for a more detailed rationale document for an older version of this patch.
> 
> ...
>
> +static void
> +tty_audit_buf_free(struct tty_audit_buf *buf)
> +{

The usual kernel style is

static void tty_audit_buf_free(struct tty_audit_buf *buf)
{

and the style which you've used here is usually only employed if its use
prevents an 80-column overflow.

There are plenty of exceptions to this, and I understand (and actually
agree with) the reason for the style which you've chosen, but
standardisation wins out.

The patch adds a lot of new code to n_tty.c, I suspect it would be neater
to put it all into a new file if possible?

> +/**
> + *	tty_audit_exit	-	Handle a task exit
> + *
> + *	Make sure all buffered data is written out and deallocate the buffer.
> + *	Only needs to be called if current->signal->tty_audit_buf != %NULL.
> + */
> +void
> +tty_audit_exit(void)
> +{
> +	struct tty_audit_buf *buf;
> +
> +	spin_lock(&current->sighand->siglock);

I think you have a bug here.  ->siglock is taken elsewhere in an irq-safe
fashion (multiple instances)

> +/**
> + *	tty_audit_add_data	-	Add data for TTY auditing.
> + *
> + *	Audit @data of @size from @tty, if necessary.
> + */
> +static void
> +tty_audit_add_data(struct tty_struct *tty, unsigned char *data, size_t size)
> +{
> +	struct tty_audit_buf *buf;
> +	int major, minor;
> +
> +	if (unlikely(size == 0))
> +		return;
> +
> +	buf = tty_audit_buf_get(tty);
> +	if (!buf)
> +		return;
> +
> +	mutex_lock(&buf->mutex);
> +	major = tty->driver->major;
> +	minor = tty->driver->minor_start + tty->index;
> +	if (buf->major != major || buf->minor != minor
> +	    || buf->icanon != tty->icanon) {
> +		tty_audit_buf_push_current(buf);
> +		buf->major = major;
> +		buf->minor = minor;
> +		buf->icanon = tty->icanon;
> +	}
> +	do {
> +	  size_t run;
> +
> +	  run = N_TTY_BUF_SIZE - buf->valid;
> +	  if (run > size)
> +	    run = size;
> +	  memcpy(buf->data + buf->valid, data, run);
> +	  buf->valid += run;
> +	  data += run;
> +	  size -= run;
> +	  if (buf->valid == N_TTY_BUF_SIZE)
> +		  tty_audit_buf_push_current(buf);
> +	} while (size != 0);

the whitespace went bad here.

> +	mutex_unlock(&buf->mutex);
> +	tty_audit_buf_put(buf);
> +}
> +
>
> ...
>
> +
> +/* For checking whether a file is a TTY */
> +extern ssize_t tty_read(struct file * file, char __user * buf, size_t count,
> +			loff_t *ppos);

Nope, please don't add extern declarations to C files.  Do it via header
files.

> +/**
> + *	tty_audit_opening	-	A TTY is being opened.
> + *
> + *	As a special hack, tasks that close all their TTYs and open new ones
> + *	are assumed to be system daemons (e.g. getty) and auditing is
> + *	automatically disabled for them.
> + */
> +void
> +tty_audit_opening(void)
> +{
> +	int disable;
> +
> +	disable = 1;
> +	spin_lock(&current->sighand->siglock);
> +	if (current->signal->audit_tty == 0)
> +		disable = 0;
> +	spin_unlock(&current->sighand->siglock);
> +	if (!disable)
> +		return;
> +
> +	task_lock(current);
> +	if (current->files) {
> +		struct fdtable *fdt;
> +		unsigned i;
> +
> +		/*
> +		 * We don't take a ref to the file, so we must hold ->file_lock
> +		 * instead.
> +		 */
> +		spin_lock(&current->files->file_lock);

So we make file_lock nest inside task_lock().  Was that lock ranking
already being used elsewhere in the kernel, or is it a new association?

Has this code had full coverage testing with all lockdep features enabled?

(I suspect not - lockdep should have gone wild over the siglock thing)

> +		fdt = files_fdtable(current->files);
> +		for (i = 0; i < fdt->max_fds; i++) {
> +			struct file *filp;
> +
> +			filp = fcheck_files(current->files, i);
> +			if (!filp)
> +				continue;
> +			if (filp->f_op->read == tty_read) {
> +				disable = 0;
> +				break;
> +			}
> +		}
> +		spin_unlock(&current->files->file_lock);
> +	}
> +	task_unlock(current);
> +	if (!disable)
> +		return;
> +
> +	spin_lock(&current->sighand->siglock);
> +	current->signal->audit_tty = 0;
> +	spin_unlock(&current->sighand->siglock);
> +}
> +#else
> +inline static void
> +tty_audit_add_data(struct tty_struct *tty, unsigned char *data, size_t size)
> +{
> +}

Please use `static inline' rather that `inline static'.  Just a consistency
thing.

> +static void
> +tty_audit_push(struct tty_struct *tty)
> +{
> +}

Probably you meant `static inline' here too.

> +#endif
> +
> +static inline int tty_put_user(struct tty_struct *tty, unsigned char x,
> +			       unsigned char __user *ptr)
> +{
> +	tty_audit_add_data(tty, &x, 1);
> +	return put_user(x, ptr);
> +}
> +
>
> ...
>
> @@ -487,6 +496,7 @@ extern int audit_signals;
>  #define audit_mq_notify(d,n) ({ 0; })
>  #define audit_mq_getsetattr(d,s) ({ 0; })
>  #define audit_ptrace(t) ((void)0)
> +#define audit_enabled 0
>  #define audit_n_rules 0
>  #define audit_signals 0
>  #endif
> @@ -515,6 +525,7 @@ extern void		    audit_log_d_path(struct audit_buffer *ab,
>  					     const char *prefix,
>  					     struct dentry *dentry,
>  					     struct vfsmount *vfsmnt);
> +extern void		    audit_log_lost(const char *message);
>  				/* Private API (for audit.c only) */
>  extern int audit_filter_user(struct netlink_skb_parms *cb, int type);
>  extern int audit_filter_type(int type);
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index d58e74b..3ae4904 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -506,6 +506,8 @@ struct signal_struct {
>  #ifdef CONFIG_TASKSTATS
>  	struct taskstats *stats;
>  #endif
> +	unsigned audit_tty:1;
> +	struct tty_audit_buf *tty_audit_buf;
>  };

hm, bitfields are risky.  If someone adds another one, it will land in
the same word and external locking will be needed.  You do seem to be using
->siglock to cover this - was that to address the bitfield non-atomicity
problem?

A suitable (but somewhat less pretty) way to resolve all this is to not use
bitfields at all: add `unsigned long flags' and use set_bit/clear_bit/etc.

>  extern int n_tty_ioctl(struct tty_struct * tty, struct file * file,
> diff --git a/kernel/audit.c b/kernel/audit.c
> index d13276d..a071a96 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -58,6 +58,7 @@
>  #include <linux/selinux.h>
>  #include <linux/inotify.h>
>  #include <linux/freezer.h>
> +#include <linux/tty.h>
>  
>  #include "audit.h"
>  
> @@ -423,6 +424,32 @@ static int kauditd_thread(void *dummy)
>  	return 0;
>  }
>  
> +static int
> +audit_prepare_user_tty(pid_t pid, uid_t loginuid)
> +{
> +	struct task_struct *tsk;
> +	int err;
> +
> +	read_lock(&tasklist_lock);
> +	tsk = find_task_by_pid(pid);
> +	err = -ESRCH;
> +	if (!tsk)
> +		goto out;
> +	err = 0;
> +
> +	spin_lock(&tsk->sighand->siglock);
> +	if (!tsk->signal->audit_tty)
> +		err = -EPERM;
> +	spin_unlock(&tsk->sighand->siglock);

So siglock nests inside tasklist_lock?  Sounds reasonable.  Is this a
preexisting association, or did this patch just create it?

> +	if (err)
> +		goto out;
> +
> +	tty_audit_push_task(tsk, loginuid);
> +out:
> +	read_unlock(&tasklist_lock);
> +	return err;
> +}
> +
>
> ...
>
>  		break;
> +	case AUDIT_TTY_GET: {
> +		struct audit_tty_status s;
> +		struct task_struct *tsk;
> +
> +		read_lock(&tasklist_lock);
> +		tsk = find_task_by_pid(pid);
> +		if (!tsk)
> +			err = -ESRCH;
> +		else {
> +			spin_lock(&tsk->sighand->siglock);
> +			s.enabled = tsk->signal->audit_tty != 0;
> +			spin_unlock(&tsk->sighand->siglock);

The locking here looks dubious.  tsk->signal->audit_tty can change state
the instant ->siglock gets unlocked, in which case s.enabled is now wrong.

If that is acceptable then we didn't need that locking at all.


