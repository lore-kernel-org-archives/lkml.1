Return-Path: <linux-kernel-owner+w=401wt.eu-S2992440AbXBIRGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992440AbXBIRGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 12:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992436AbXBIRGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 12:06:49 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:42908 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992440AbXBIRGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 12:06:47 -0500
Message-id: <153939770919529864@wsc.cz>
In-reply-to: <d120d5000702090900r1ad57d9dyb0c7f544686e7c40@mail.gmail.com>
References: <45CC8F2D.3070902@gmail.com> <p73lkj71bcm.fsf@bingen.suse.de>
	<d120d5000702090900r1ad57d9dyb0c7f544686e7c40@mail.gmail.com>
Subject: [PATCH 1/1] Input: scan_keyb, remove it
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Fri,  9 Feb 2007 18:06:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On 2/9/07, Andi Kleen <ak@suse.de> wrote:
> > Jiri Slaby <jirislaby@gmail.com> writes:
> >
> > > Hi.
> > >
> > > What's drivers/char/scan_keyb.{c,h} for, when it's referenced in no
> > > place (aside a fact, that it uses some old API and hence is broken)?
> >
> > iirc it was an interface for braille reader modules. Probably they
> > never made it into tree.
> 
> It looks like it is a generic portion of drivers for scan-matrix
> keyboards. I think we can nuke it.

Ok, thanks, the patch follows.

--

scan_keyb, remove it

It's currently unused (unreferenced) beside the fact it's broken.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit a638eeb20ea2777e9c457d6c853cccfc0f821443
tree d5ca43cbd6da5fbc87fdb071610a9706c107b122
parent 402d1a46b4d96c5df8e4db00c62592cb66b8c292
author Jiri Slaby <jirislaby@gmail.com> Fri, 09 Feb 2007 18:03:48 +0100
committer Jiri Slaby <jirislaby@gmail.com> Fri, 09 Feb 2007 18:03:48 +0100

 drivers/char/scan_keyb.c |  148 ----------------------------------------------
 drivers/char/scan_keyb.h |   15 -----
 2 files changed, 0 insertions(+), 163 deletions(-)

diff --git a/drivers/char/scan_keyb.c b/drivers/char/scan_keyb.c
deleted file mode 100644
index 6bf551d..0000000
--- a/drivers/char/scan_keyb.c
+++ /dev/null
@@ -1,148 +0,0 @@
-/*
- *	$Id: scan_keyb.c,v 1.2 2000/07/04 06:24:42 yaegashi Exp $ 
- *	Copyright (C) 2000 YAEGASHI Takeshi
- *	Generic scan keyboard driver
- */
-
-#include <linux/spinlock.h>
-#include <linux/interrupt.h>
-#include <linux/tty.h>
-#include <linux/mm.h>
-#include <linux/signal.h>
-#include <linux/init.h>
-#include <linux/kbd_ll.h>
-#include <linux/delay.h>
-#include <linux/random.h>
-#include <linux/poll.h>
-#include <linux/miscdevice.h>
-#include <linux/slab.h>
-#include <linux/kbd_kern.h>
-#include <linux/timer.h>
-
-#define SCANHZ	(HZ/20)
-
-struct scan_keyboard {
-	struct scan_keyboard *next;
-	int (*scan)(unsigned char *buffer);
-	const unsigned char *table;
-	unsigned char *s0, *s1;
-	int length;
-};
-
-static int scan_jiffies=0;
-static struct scan_keyboard *keyboards=NULL;
-struct timer_list scan_timer;
-
-static void check_kbd(const unsigned char *table,
-		      unsigned char *new, unsigned char *old, int length)
-{
-	int need_tasklet_schedule=0;
-	unsigned int xor, bit;
-	
-	while(length-->0) {
-		if((xor=*new^*old)==0) {
-			table+=8;
-		}
-		else {
-			for(bit=0x01; bit<0x100; bit<<=1) {
-				if(xor&bit) {
-					handle_scancode(*table, !(*new&bit));
-					need_tasklet_schedule=1;
-#if 0
-					printk("0x%x %s\n", *table, (*new&bit)?"released":"pressed");
-#endif
-				}
-				table++;
-			}
-		}
-		new++; old++;
-	}
-
-	if(need_tasklet_schedule)
-		tasklet_schedule(&keyboard_tasklet);
-}
-
-
-static void scan_kbd(unsigned long dummy)
-{
-	struct scan_keyboard *kbd;
-
-	scan_jiffies++;
-
-	for(kbd=keyboards; kbd!=NULL; kbd=kbd->next) {
-		if(scan_jiffies&1) {
-			if(!kbd->scan(kbd->s0))
-				check_kbd(kbd->table,
-					  kbd->s0, kbd->s1, kbd->length);
-			else
-				memcpy(kbd->s0, kbd->s1, kbd->length);
-		}
-		else {
-			if(!kbd->scan(kbd->s1))
-				check_kbd(kbd->table,
-					  kbd->s1, kbd->s0, kbd->length);
-			else
-				memcpy(kbd->s1, kbd->s0, kbd->length);
-		}
-		
-	}
-
-	init_timer(&scan_timer);
-	scan_timer.expires = jiffies + SCANHZ;
-	scan_timer.data = 0;
-	scan_timer.function = scan_kbd;
-	add_timer(&scan_timer);
-}
-
-
-int register_scan_keyboard(int (*scan)(unsigned char *buffer),
-			   const unsigned char *table,
-			   int length)
-{
-	struct scan_keyboard *kbd;
-
-	kbd = kmalloc(sizeof(struct scan_keyboard), GFP_KERNEL);
-	if (kbd == NULL)
-		goto error_out;
-
-	kbd->scan=scan;
-	kbd->table=table;
-	kbd->length=length;
-
-	kbd->s0 = kmalloc(length, GFP_KERNEL);
-	if (kbd->s0 == NULL)
-		goto error_free_kbd;
-
-	kbd->s1 = kmalloc(length, GFP_KERNEL);
-	if (kbd->s1 == NULL)
-		goto error_free_s0;
-
-	memset(kbd->s0, -1, kbd->length);
-	memset(kbd->s1, -1, kbd->length);
-	
-	kbd->next=keyboards;
-	keyboards=kbd;
-
-	return 0;
-
- error_free_s0:
-	kfree(kbd->s0);
-
- error_free_kbd:
-	kfree(kbd);
-
- error_out:
-	return -ENOMEM;
-}
-			      
-			      
-void __init scan_kbd_init(void)
-{
-	init_timer(&scan_timer);
-	scan_timer.expires = jiffies + SCANHZ;
-	scan_timer.data = 0;
-	scan_timer.function = scan_kbd;
-	add_timer(&scan_timer);
-
-	printk(KERN_INFO "Generic scan keyboard driver initialized\n");
-}
diff --git a/drivers/char/scan_keyb.h b/drivers/char/scan_keyb.h
deleted file mode 100644
index b4b6112..0000000
--- a/drivers/char/scan_keyb.h
+++ /dev/null
@@ -1,15 +0,0 @@
-#ifndef	__DRIVER_CHAR_SCAN_KEYB_H
-#define	__DRIVER_CHAR_SCAN_KEYB_H
-/*
- *	$Id: scan_keyb.h,v 1.1 2000/06/10 21:45:30 yaegashi Exp $
- *	Copyright (C) 2000 YAEGASHI Takeshi
- *	Generic scan keyboard driver
- */
-
-int register_scan_keyboard(int (*scan)(unsigned char *buffer),
-			   const unsigned char *table,
-			   int length);
-
-void __init scan_kbd_init(void);
-
-#endif
