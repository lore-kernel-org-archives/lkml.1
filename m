Return-Path: <linux-kernel-owner+w=401wt.eu-S1759333AbZFBLcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333AbZFBLcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 07:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757764AbZFBLcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 07:32:25 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:60518 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbZFBLcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 07:32:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=c8Cwrq8zvndQ8ZrToNozlyrR4ThND9suHzJJB/pqBXmBhTyj2U4saJOzpnlGNYo4/G
         Qx4/csuR9ROdSlCfobQkBymPnZbTGo/QlojPyciiK8MN9zeXOw+DtEUx11tkE3mLH+BJ
         1Q81kRxC8srgtqO5mfKMNaokQIIWM7EUGcs5A=
From: Gerard Lledo <gerard.lledo@gmail.com>
Date: Tue, 2 Jun 2009 14:32:16 +0300
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-janitors@vger.kernel.org, dwmw2@infradead.org,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [JFFS2] Move jffs2_gcd_mtd threads to the new kthread
	API
Message-ID: <20090602113216.GA3513@tank>
References: <1243585181-2997-1-git-send-email-gerard.lledo@gmail.com> <20090601162010.ed69436f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601162010.ed69436f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 04:20:10PM -0700, Andrew Morton wrote:
> On Fri, 29 May 2009 11:19:41 +0300
> Gerard Lledo <gerard.lledo@gmail.com> wrote:
> 
> > kernel_thread() is being depracated.  This patch moves the jffs2 garbage
> > collecting thread to the new kthread API with the minimal impact.
> > 
> > Signed-off-by: Gerard Lledo <gerard.lledo@gmail.com>
> > ---
> >  fs/jffs2/background.c |   22 ++++++++++++++--------
> >  1 files changed, 14 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/jffs2/background.c b/fs/jffs2/background.c
> > index e958010..077fa65 100644
> > --- a/fs/jffs2/background.c
> > +++ b/fs/jffs2/background.c
> > @@ -15,6 +15,7 @@
> >  #include <linux/completion.h>
> >  #include <linux/sched.h>
> >  #include <linux/freezer.h>
> > +#include <linux/kthread.h>
> >  #include "nodelist.h"
> >  
> >  
> > @@ -31,7 +32,7 @@ void jffs2_garbage_collect_trigger(struct jffs2_sb_info *c)
> >  /* This must only ever be called when no GC thread is currently running */
> >  int jffs2_start_garbage_collect_thread(struct jffs2_sb_info *c)
> >  {
> > -	pid_t pid;
> > +	struct task_struct *tsk;
> >  	int ret = 0;
> >  
> >  	BUG_ON(c->gc_task);
> > @@ -39,15 +40,16 @@ int jffs2_start_garbage_collect_thread(struct jffs2_sb_info *c)
> >  	init_completion(&c->gc_thread_start);
> >  	init_completion(&c->gc_thread_exit);
> >  
> > -	pid = kernel_thread(jffs2_garbage_collect_thread, c, CLONE_FS|CLONE_FILES);
> > -	if (pid < 0) {
> > -		printk(KERN_WARNING "fork failed for JFFS2 garbage collect thread: %d\n", -pid);
> > +	tsk = kthread_create(jffs2_garbage_collect_thread, c, "jffs2_gcd_mtd%d", c->mtd->index);
> > +	if (IS_ERR(tsk)) {
> > +		printk(KERN_WARNING "fork failed for JFFS2 garbage collect thread: %ld\n", -PTR_ERR(tsk));
> >  		complete(&c->gc_thread_exit);
> > -		ret = pid;
> > +		ret = PTR_ERR(tsk);
> >  	} else {
> > -		/* Wait for it... */
> > -		D1(printk(KERN_DEBUG "JFFS2: Garbage collect thread is pid %d\n", pid));
> > +		D1(printk(KERN_DEBUG "JFFS2: Garbage collect thread is pid %d\n", tsk->pid));
> > +		wake_up_process(tsk);
> >  		wait_for_completion(&c->gc_thread_start);
> > +		ret = tsk->pid;
> >  	}
> 
> A simple kthread_run() would be preferable here.  The code presently
> sort-of open-codes it.
> 
> >  	return ret;
> 
> Also, manipulating kernel threads via their pids is atypical and
> inefficient.  In-kernel it is better to refer to threads via their
> task_struct*.
> 
> Fortunately all callers of this function ignore its return value so I
> expect we can simply change it to be void-returning.  But that's a
> cleanup which would best be done in a spearate patch.
>

OK, I'll redo the previous patch with kthread_run() instead.  I will also post
a different patch to cleanup the return value and use void.
