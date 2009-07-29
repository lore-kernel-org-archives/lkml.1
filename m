Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbZG2KlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbZG2KlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 06:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbZG2KlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 06:41:12 -0400
Received: from cmpxchg.org ([85.214.51.133]:38394 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbZG2KlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 06:41:12 -0400
Date: Wed, 29 Jul 2009 12:39:04 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Another memory leak in drivers/char/vt.c
Message-ID: <20090729103903.GA2175@cmpxchg.org>
References: <1248859884.2305.7.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248859884.2305.7.camel@pc1117.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Catalin,

On Wed, Jul 29, 2009 at 10:31:23AM +0100, Catalin Marinas wrote:
> Hi,
> 
> There was a memory leak fixed recently by commit 1a8f458f6d. However,
> there seems to be another with this kmemleak trace:
> 
> unreferenced object 0xde158000 (size 12288):
>   comm "Xorg", pid 1439, jiffies 4294961016
>   hex dump (first 32 bytes):
>     20 00 20 00 20 00 20 00 20 00 20 00 20 00 20 00   . . . . . . . .
>     20 00 20 00 20 00 20 00 20 00 20 00 20 00 20 00   . . . . . . . .
>   backtrace:
>     [<c006f74b>] __save_stack_trace+0x17/0x1c
>     [<c006f81d>] create_object+0xcd/0x188
>     [<c01f5457>] kmemleak_alloc+0x1b/0x3c
>     [<c006e303>] __kmalloc+0xdb/0xe8
>     [<c012cc4b>] vc_do_resize+0x73/0x1e0
>     [<c012cdf1>] vc_resize+0x15/0x18
>     [<c011afc1>] fbcon_init+0x1f9/0x2b8
>     [<c0129e87>] visual_init+0x9f/0xdc
>     [<c012aff3>] vc_allocate+0x7f/0xfc
>     [<c012b087>] con_open+0x17/0x80
>     [<c0120e43>] tty_open+0x1f7/0x2e4
>     [<c0072fa1>] chrdev_open+0x101/0x118
>     [<c006ffad>] __dentry_open+0x105/0x1cc
>     [<c00700fd>] nameidata_to_filp+0x2d/0x38
>     [<c00788cd>] do_filp_open+0x2c1/0x54c
>     [<c006fdff>] do_sys_open+0x3b/0xb4
> 
> The problem happens in the vc_allocate() function where vc->vc_screenbuf
> is set to the kmalloc() returned value. However, the visual_init()
> function called 3 lines before also allocates the vc->vc_screenbuf.

The common way seems to be that ->con_init(init=1) just sets the
dimensions manually (instead of using vc_resize()) and vc_allocate()
uses them to actually allocate a properly sized screen buffer.

So it seems like fbcon is at fault here.  It calls vc_resize() from
->con_init(init=1) and updates the console dimensions manually on
init=0 (after calling vc_resize()) which is completely mixed up.

I think the quick fix is something like the appended (untested!).

In the long run it is probably good to re-evaluate whether vc_resize()
can be called unconditionally from ->con_init() and remove the
allocation from vc_allocate().

	Hannes

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 471a9a6..3a44695 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -1082,7 +1082,6 @@ static void fbcon_init(struct vc_data *vc, int init)
 	new_rows = FBCON_SWAP(ops->rotate, info->var.yres, info->var.xres);
 	new_cols /= vc->vc_font.width;
 	new_rows /= vc->vc_font.height;
-	vc_resize(vc, new_cols, new_rows);
 
 	/*
 	 * We must always set the mode. The mode of the previous console
@@ -1111,10 +1110,11 @@ static void fbcon_init(struct vc_data *vc, int init)
 	 *  vc_{cols,rows}, but we must not set those if we are only
 	 *  resizing the console.
 	 */
-	if (!init) {
+	if (init) {
 		vc->vc_cols = new_cols;
 		vc->vc_rows = new_rows;
-	}
+	} else
+		vc_resize(vc, new_cols, new_rows);
 
 	if (logo)
 		fbcon_prepare_logo(vc, info, cols, rows, new_cols, new_rows);
