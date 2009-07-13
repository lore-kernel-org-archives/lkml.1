Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbZGMOzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbZGMOzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 10:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbZGMOzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 10:55:18 -0400
Received: from cmpxchg.org ([85.214.51.133]:59450 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756071AbZGMOzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 10:55:17 -0400
Date: Mon, 13 Jul 2009 16:54:51 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix vc_screenbuf leak via con_init()
Message-ID: <20090713145451.GA2265@cmpxchg.org>
References: <20090713130921.6441.17011.stgit@pc1117.cambridge.arm.com> <1247493898.14968.0.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247493898.14968.0.camel@penberg-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Mon, Jul 13, 2009 at 05:04:58PM +0300, Pekka Enberg wrote:
> On Mon, 2009-07-13 at 14:12 +0100, Catalin Marinas wrote:
> > Commit a5f4f52e replaced the alloc_bootmem() with kzalloc() but didn't
> > set vc_kmalloced to 1 and the memory block is later leaked. The
> > corresponding kmemleak trace:
> > 
> > unreferenced object 0xdf828000 (size 8192):
> >   comm "swapper", pid 0, jiffies 4294937296
> >   backtrace:
> >     [<c006d473>] __save_stack_trace+0x17/0x1c
> >     [<c000d869>] log_early+0x55/0x84
> >     [<c01cfa4b>] kmemleak_alloc+0x33/0x3c
> >     [<c006c013>] __kmalloc+0xd7/0xe4
> >     [<c00108c7>] con_init+0xbf/0x1b8
> >     [<c0010149>] console_init+0x11/0x20
> >     [<c0008797>] start_kernel+0x137/0x1e4
> > 
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> > ---
> > 
> > (note that detecting this requires additional kmemleak patches for early
> > log stack traces which are planned for the next merging window)
> > 
> >  drivers/char/vt.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/char/vt.c b/drivers/char/vt.c
> > index 7947bd1..f6ac4c2 100644
> > --- a/drivers/char/vt.c
> > +++ b/drivers/char/vt.c
> > @@ -2881,7 +2881,7 @@ static int __init con_init(void)
> >  		INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
> >  		visual_init(vc, currcons, 1);
> >  		vc->vc_screenbuf = kzalloc(vc->vc_screenbuf_size, GFP_NOWAIT);
> > -		vc->vc_kmalloced = 0;
> > +		vc->vc_kmalloced = 1;
> >  		vc_init(vc, vc->vc_rows, vc->vc_cols,
> >  			currcons || !vc->vc_sw->con_save_screen);
> >  	}
> > 
> 
> We can probably get rid of ->vc_kmalloced completely now that the
> bootmem allocator is no longer used by the driver.

That's what I thought, too.  Copied Alan.  Patch as follows:

---
>From 4df0a75bdc567c9f2203dc4b0337d77a26715654 Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Mon, 13 Jul 2009 16:39:46 +0200
Subject: [patch] vt: drop bootmem/slab memory distinction

Bootmem is not used for the vt screen buffer anymore as slab is now
available at the time the console is initialized.

Get rid of the now superfluous distinction between slab and bootmem,
it's always slab.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Catalin Marinas <catalin.marinas@arm.com>
---
 drivers/char/vt.c              |   12 +++---------
 include/linux/console_struct.h |    1 -
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index d9113b4..bdb9c60 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -769,14 +769,12 @@ int vc_allocate(unsigned int currcons)	/* return 0 on success */
 	    visual_init(vc, currcons, 1);
 	    if (!*vc->vc_uni_pagedir_loc)
 		con_set_default_unimap(vc);
-	    if (!vc->vc_kmalloced)
-		vc->vc_screenbuf = kmalloc(vc->vc_screenbuf_size, GFP_KERNEL);
+	    vc->vc_screenbuf = kmalloc(vc->vc_screenbuf_size, GFP_KERNEL);
 	    if (!vc->vc_screenbuf) {
 		kfree(vc);
 		vc_cons[currcons].d = NULL;
 		return -ENOMEM;
 	    }
-	    vc->vc_kmalloced = 1;
 	    vc_init(vc, vc->vc_rows, vc->vc_cols, 1);
 	    vcs_make_sysfs(currcons);
 	    atomic_notifier_call_chain(&vt_notifier_list, VT_ALLOCATE, &param);
@@ -912,10 +910,8 @@ static int vc_do_resize(struct tty_struct *tty, struct vc_data *vc,
 	if (new_scr_end > new_origin)
 		scr_memsetw((void *)new_origin, vc->vc_video_erase_char,
 			    new_scr_end - new_origin);
-	if (vc->vc_kmalloced)
-		kfree(vc->vc_screenbuf);
+	kfree(vc->vc_screenbuf);
 	vc->vc_screenbuf = newscreen;
-	vc->vc_kmalloced = 1;
 	vc->vc_screenbuf_size = new_screen_size;
 	set_origin(vc);
 
@@ -994,8 +990,7 @@ void vc_deallocate(unsigned int currcons)
 		vc->vc_sw->con_deinit(vc);
 		put_pid(vc->vt_pid);
 		module_put(vc->vc_sw->owner);
-		if (vc->vc_kmalloced)
-			kfree(vc->vc_screenbuf);
+		kfree(vc->vc_screenbuf);
 		if (currcons >= MIN_NR_CONSOLES)
 			kfree(vc);
 		vc_cons[currcons].d = NULL;
@@ -2880,7 +2875,6 @@ static int __init con_init(void)
 		INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
 		visual_init(vc, currcons, 1);
 		vc->vc_screenbuf = kzalloc(vc->vc_screenbuf_size, GFP_NOWAIT);
-		vc->vc_kmalloced = 0;
 		vc_init(vc, vc->vc_rows, vc->vc_cols,
 			currcons || !vc->vc_sw->con_save_screen);
 	}
diff --git a/include/linux/console_struct.h b/include/linux/console_struct.h
index d71f7c0..38fe59d 100644
--- a/include/linux/console_struct.h
+++ b/include/linux/console_struct.h
@@ -89,7 +89,6 @@ struct vc_data {
 	unsigned int	vc_need_wrap	: 1;
 	unsigned int	vc_can_do_color	: 1;
 	unsigned int	vc_report_mouse : 2;
-	unsigned int	vc_kmalloced	: 1;
 	unsigned char	vc_utf		: 1;	/* Unicode UTF-8 encoding */
 	unsigned char	vc_utf_count;
 		 int	vc_utf_char;
-- 
1.6.3

