Return-Path: <linux-kernel-owner+w=401wt.eu-S1763618AbXE2Tqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763618AbXE2Tqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 15:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbXE2Tqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 15:46:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105AbXE2Tqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 15:46:30 -0400
Date: Tue, 29 May 2007 15:46:28 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add procfs tunable to enable immediate panic when there
 are busy inodes after umount
Message-Id: <20070529154628.ae4f6c7a.jlayton@redhat.com>
In-Reply-To: <20070529193813.GC5666@martell.zuzino.mipt.ru>
References: <20070529114042.5fe0b810.jlayton@redhat.com>
	<20070529193813.GC5666@martell.zuzino.mipt.ru>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007 23:38:13 +0400
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Tue, May 29, 2007 at 11:40:42AM -0400, Jeff Layton wrote:
> > After spending quite a bit of time tracking down a "VFS: busy inodes
> > after unmount" problem, it occurs to me that it would be nice to be
> > able to force a panic when that occurs. While an oops message alone is
> > not generally helpful for tracking down this sort of problem,
> > collecting and analyzing a coredump when this occurs can be.
> >
> > The following patch adds a procfs tunable that allows you to force a
> > core when a "busy inodes after umount" problem occurs. It also changes
> > the classic error message to be something a bit less cryptic to users.
> 
> > @@ -303,10 +305,15 @@ void generic_shutdown_super(struct super_block *sb)
> >  			sop->put_super(sb);
> >
> >  		/* Forget any remaining inodes */
> > -		if (invalidate_inodes(sb)) {
> > -			printk("VFS: Busy inodes after unmount of %s. "
> > -			   "Self-destruct in 5 seconds.  Have a nice day...\n",
> > -			   sb->s_id);
> > +		if (busy = invalidate_inodes(sb)) {
> > +			printk("VFS: %d busy inodes after unmount of %s. ",
> > +				 busy, sb->s_id);
> > +			if (umount_debug != 0) {
> > +				printk("Crashing host on request.\n");
> > +				BUG();
> > +			} else {
> > +				printk("This machine will likely crash eventually. Consider a reboot.\n");
> > +			}
> 
> You can add just BUG_ON here and do
> 
> 	echo 1 >/proc/sys/kernel/panic_on_oops
> 

I certainly could, but the problem is that there's little point in
panicing immediately here if you can't collect a coredump. Oops
messages aren't very helpful for tracking this sort of thing down, so
I'd think we want the BUG() conditional on something more granular
than panic_on_oops.

-- 
Jeff Layton <jlayton@redhat.com>
