Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbZKUAdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbZKUAdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 19:33:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbZKUAdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 19:33:06 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:39598 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbZKUAdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 19:33:04 -0500
Subject: Re: [PATCH] Allow threads to rename siblings via
 /proc/pid/tasks/tid/comm
From: john stultz <johnstul@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>, Mike Fulton <fultonm@ca.ibm.com>,
       Sean Foley <Sean_Foley@ca.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
In-Reply-To: <20091118135457.6471af1f.akpm@linux-foundation.org>
References: <1256347303.5059.26.camel@localhost.localdomain>
	 <1257557918.3298.21.camel@localhost.localdomain>
	 <87aayy6j8b.fsf@basil.nowhere.org>	<1258405867.10576.2.camel@work-vm>
	 <20091118135457.6471af1f.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Nov 2009 16:33:02 -0800
Message-ID: <1258763582.3993.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-18 at 13:54 -0800, Andrew Morton wrote:
> On Mon, 16 Nov 2009 13:11:07 -0800
> john stultz <johnstul@us.ibm.com> wrote:
> 
> > Setting a thread's comm to be something unique is a very useful ability
> > and is helpful for debugging complicated threaded applications. However
> > currently the only way to set a thread name is for the thread to name
> > itself via the PR_SET_NAME prctl.
> > 
> > However, there may be situations where it would be advantageous for a
> > thread dispatcher to be naming the threads its managing, rather then
> > having the threads self-describe themselves. This sort of behavior is
> > available on other systems via the pthread_setname_np() interface.
> > 
> > This patch exports a task's comm via proc/pid/comm and
> > proc/pid/task/tid/comm interfaces, and allows thread siblings to write
> > to these values.
> > 
> 
> Would be nice to document the new userspace interface. 
> Documentation/filesystems/proc.txt, perhaps.

Initial swipe provided below. I'm not much of a writer, so let me know
if you'd like to see more explanation.

> > +
> > +
> > +static ssize_t
> > +comm_write(struct file *file, const char __user *buf,
> > +	    size_t count, loff_t *offset)
> > +{
> > +	struct inode *inode = file->f_path.dentry->d_inode;
> > +	struct task_struct *p;
> > +	char buffer[TASK_COMM_LEN];
> > +
> > +	memset(buffer, 0, sizeof(buffer));
> > +	if (count > sizeof(buffer) - 1)
> > +		count = sizeof(buffer) - 1;
> 
> Is this the best policy?  If userspace tries to apply a too-long name
> to a thread, the kernel will silently truncate (ie: corrupt) it?  I'd
> have thought that returning an error would be more robust?

The comm is usually a truncated version of cmdline. If you look at most
long-named gnome apps, their comms are cut off, so I think the
truncation is somewhat expected.

For the implementation above, I followed how the PR_SET_NAME prctrl
behaves, where the same argument would apply. 

Personally, I'm not picky, and would ok doing it either way if you or
anyone else feels strongly.


> > +	if (copy_from_user(buffer, buf, count))
> > +		return -EFAULT;
> > +
> > +	p = get_proc_task(inode);
> > +	if (!p)
> > +		return -ESRCH;
> > +
> > +	if (same_thread_group(current, p))
> > +		set_task_comm(p, buffer);
> > +	else
> > +		count = -EINVAL;
> > +
> > +	put_task_struct(p);
> > +
> > +	return count;
> > +}
> 
> Is same_thread_group() sufficient?  Are any security/permission-related
> checks appropriate here, for example?
> 
> The restriction to a separate thread group seems a bit arbitrary,
> really.  There's no reason I can see why we cannot permit unrelated
> (but suitably authorised) processes to do this.

To me it seemed the most sane safe behavior. Applications may not expect
to have their comms changed under them, so excluding it to sibling
threads ensures any changes are expected internally by the application.


> This patch makes task->comm inconsistent with /prod/pid/cmdline.  What
> are the implications of that for userspace?  None, I guess, given that
> this can already be done.

Agreed. PR_SET_NAME would be the precedent.

> > +static int comm_open(struct inode *inode, struct file *filp)
> > +{
> > +	int ret;
> > +
> > +	ret = single_open(filp, comm_show, NULL);
> > +	if (!ret) {
> > +		struct seq_file *m = filp->private_data;
> > +
> > +		m->private = inode;
> > +	}
> > +	return ret;
> > +}
> > +
> > +
> 
> The patch has a seemingly-random inexplicable mixture of \n and \n\n.

Sorry about that, I'll have to fix the programming robot. ;)

thanks
-john



Add some documentation about /proc/<pid>/task/<tid>/comm interface.

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 2c48f94..4e5470d 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -38,6 +38,7 @@ Table of Contents
   3.3	/proc/<pid>/io - Display the IO accounting fields
   3.4	/proc/<pid>/coredump_filter - Core dump filtering settings
   3.5	/proc/<pid>/mountinfo - Information about mounts
+  3.6	/proc/<pid>/comm  & /proc/<pid>/task/<tid>/comm
 
 
 ------------------------------------------------------------------------------
@@ -1408,3 +1409,11 @@ For more information on mount propagation see:
 
   Documentation/filesystems/sharedsubtree.txt
 
+
+3.6	/proc/<pid>/comm  & /proc/<pid>/task/<tid>/comm
+--------------------------------------------------------
+These files provide a method to access a tasks comm value. It also allows for
+a task to set its own or one of its thread siblings comm value. The comm value
+is limited in size compared to the cmdline value, so writing anything longer
+then the kernel's TASK_COMM_LEN (currently 16 chars) will result in a truncated
+comm value.


