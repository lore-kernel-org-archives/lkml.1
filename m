Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbYJTVhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbYJTVhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 17:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527AbYJTVg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 17:36:29 -0400
Received: from kroah.org ([198.145.64.141]:37444 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755717AbYJTVg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 17:36:27 -0400
Date: Mon, 20 Oct 2008 13:57:07 -0700
From: Greg KH <greg@kroah.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 02/46] sysfs: crash debugging
Message-ID: <20081020205707.GA24476@kroah.com>
References: <20081016170954.GA11824@kroah.com> <1224177047-11859-2-git-send-email-gregkh@suse.de> <20081016174055.GA8806@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016174055.GA8806@Krystal>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 01:40:56PM -0400, Mathieu Desnoyers wrote:
> * Greg Kroah-Hartman (gregkh@suse.de) wrote:
> > From: Andrew Morton <akpm@linux-foundation.org>
> > 
> > Print the name of the last-accessed sysfs file when we oops, to help track
> > down oopses which occur in sysfs store/read handlers.  Because these oopses
> > tend to not leave any trace of the offending code in the stack traces.
> > 
> > Cc: Kay Sievers <kay.sievers@vrfy.org>
> > Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > ---
> >  arch/x86/kernel/dumpstack_32.c |    2 ++
> >  arch/x86/kernel/dumpstack_64.c |    2 ++
> >  fs/sysfs/file.c                |   13 +++++++++++++
> >  include/linux/sysfs.h          |    6 ++++++
> >  4 files changed, 23 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
> > index 201ee35..1a78180 100644
> > --- a/arch/x86/kernel/dumpstack_32.c
> > +++ b/arch/x86/kernel/dumpstack_32.c
> > @@ -13,6 +13,7 @@
> >  #include <linux/kexec.h>
> >  #include <linux/bug.h>
> >  #include <linux/nmi.h>
> > +#include <linux/sysfs.h>
> >  
> >  #include <asm/stacktrace.h>
> >  
> > @@ -343,6 +344,7 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
> >  	printk("DEBUG_PAGEALLOC");
> >  #endif
> >  	printk("\n");
> > +	sysfs_printk_last_file();
> >  	if (notify_die(DIE_OOPS, str, regs, err,
> >  			current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)
> >  		return 1;
> > diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
> > index 086cc81..96a5db7 100644
> > --- a/arch/x86/kernel/dumpstack_64.c
> > +++ b/arch/x86/kernel/dumpstack_64.c
> > @@ -13,6 +13,7 @@
> >  #include <linux/kexec.h>
> >  #include <linux/bug.h>
> >  #include <linux/nmi.h>
> > +#include <linux/sysfs.h>
> >  
> >  #include <asm/stacktrace.h>
> >  
> > @@ -489,6 +490,7 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
> >  	printk("DEBUG_PAGEALLOC");
> >  #endif
> >  	printk("\n");
> > +	sysfs_printk_last_file();
> >  	if (notify_die(DIE_OOPS, str, regs, err,
> >  			current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)
> >  		return 1;
> > diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
> > index c9e4e50..ce8339c 100644
> > --- a/fs/sysfs/file.c
> > +++ b/fs/sysfs/file.c
> > @@ -19,10 +19,18 @@
> >  #include <linux/poll.h>
> >  #include <linux/list.h>
> >  #include <linux/mutex.h>
> > +#include <linux/limits.h>
> >  #include <asm/uaccess.h>
> >  
> >  #include "sysfs.h"
> >  
> > +/* used in crash dumps to help with debugging */
> > +static char last_sysfs_file[PATH_MAX];
> > +void sysfs_printk_last_file(void)
> > +{
> > +	printk(KERN_EMERG "last sysfs file: %s\n", last_sysfs_file);
> > +}
> > +
> >  /*
> >   * There's one sysfs_buffer for each open file and one
> >   * sysfs_open_dirent for each sysfs_dirent with one or more open
> > @@ -328,6 +336,11 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
> >  	struct sysfs_buffer *buffer;
> >  	struct sysfs_ops *ops;
> >  	int error = -EACCES;
> > +	char *p;
> > +
> > +	p = d_path(&file->f_path, last_sysfs_file, sizeof(last_sysfs_file));
> > +	if (p)
> 
> if (!IS_ERR(p)) ?
> 
> > +		memmove(last_sysfs_file, p, strlen(p) + 1);
> >  
> 
> Given we do a strlen() here anyway, shouldn't we just use strcpy ?

Probably would be good.

Care to send a patch for both of these?

thanks,

greg k-h
