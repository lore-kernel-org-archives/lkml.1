Return-Path: <linux-kernel-owner+w=401wt.eu-S1751051AbZG2RXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751051AbZG2RXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 13:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750901AbZG2RXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 13:23:41 -0400
Received: from cmpxchg.org ([85.214.51.133]:34833 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbZG2RXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 13:23:41 -0400
Date: Wed, 29 Jul 2009 19:21:23 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: [patch] fbcon: don't use vc_resize() on initialization
Message-ID: <20090729172123.GA14192@cmpxchg.org>
References: <1248859884.2305.7.camel@pc1117.cambridge.arm.com> <20090729103903.GA2175@cmpxchg.org> <1248865456.2305.12.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248865456.2305.12.camel@pc1117.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin and kmemleak spotted a leak of a VC screen buffer in
vc_allocate() due to the following chain of events:

	vc_allocate()
	  visual_init(init=1)
	    vc->vc_sw->con_init(init=1)
              fbcon_init()
	        vc_resize()
	          vc->screen_buf = kmalloc()
	  vc->screen_buf = kmalloc()

The common way for the VC drivers is to set the screen dimension
parameters manually in the init case and only call vc_resize() for
!init - which allocates a screen buffer according to the new
dimensions.

fbcon instead would do vc_resize() unconditionally and afterwards set
the dimensions manually (again) for !init - i.e. completely upside
down.  The vc_resize() allocated buffer would then get lost by
vc_allocate() allocating a fresh one.

Use vc_resize() only for actual resizing to close the leak.

Set the dimensions manually only in initialization mode to remove the
redundant setting in resize mode.

The kmemleak trace from Catalin:

unreferenced object 0xde158000 (size 12288):
  comm "Xorg", pid 1439, jiffies 4294961016
  hex dump (first 32 bytes):
    20 00 20 00 20 00 20 00 20 00 20 00 20 00 20 00   . . . . . . . .
    20 00 20 00 20 00 20 00 20 00 20 00 20 00 20 00   . . . . . . . .
  backtrace:
    [<c006f74b>] __save_stack_trace+0x17/0x1c
    [<c006f81d>] create_object+0xcd/0x188
    [<c01f5457>] kmemleak_alloc+0x1b/0x3c
    [<c006e303>] __kmalloc+0xdb/0xe8
    [<c012cc4b>] vc_do_resize+0x73/0x1e0
    [<c012cdf1>] vc_resize+0x15/0x18
    [<c011afc1>] fbcon_init+0x1f9/0x2b8
    [<c0129e87>] visual_init+0x9f/0xdc
    [<c012aff3>] vc_allocate+0x7f/0xfc
    [<c012b087>] con_open+0x17/0x80
    [<c0120e43>] tty_open+0x1f7/0x2e4
    [<c0072fa1>] chrdev_open+0x101/0x118
    [<c006ffad>] __dentry_open+0x105/0x1cc
    [<c00700fd>] nameidata_to_filp+0x2d/0x38
    [<c00788cd>] do_filp_open+0x2c1/0x54c
    [<c006fdff>] do_sys_open+0x3b/0xb4

Reported-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Tested-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/video/console/fbcon.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

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
-- 
1.6.3
