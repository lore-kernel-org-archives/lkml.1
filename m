Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614AbZG2Jba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbZG2Jba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 05:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbZG2Jb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 05:31:29 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:38139 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751536AbZG2Jb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 05:31:28 -0400
Subject: Another memory leak in drivers/char/vt.c
From: Catalin Marinas <catalin.marinas@arm.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 29 Jul 2009 10:31:23 +0100
Message-Id: <1248859884.2305.7.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jul 2009 09:31:25.0032 (UTC) FILETIME=[5775B680:01CA102F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There was a memory leak fixed recently by commit 1a8f458f6d. However,
there seems to be another with this kmemleak trace:

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

The problem happens in the vc_allocate() function where vc->vc_screenbuf
is set to the kmalloc() returned value. However, the visual_init()
function called 3 lines before also allocates the vc->vc_screenbuf.

One solution is below (another would be to kfree the vc_screenbuf and
reallocate):

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 404f4c1..1da75ef 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -770,7 +770,9 @@ int vc_allocate(unsigned int currcons)	/* return 0 on success */
 	    visual_init(vc, currcons, 1);
 	    if (!*vc->vc_uni_pagedir_loc)
 		con_set_default_unimap(vc);
-	    vc->vc_screenbuf = kmalloc(vc->vc_screenbuf_size, GFP_KERNEL);
+	    if (!vc->vc_screenbuf)
+		    vc->vc_screenbuf = kmalloc(vc->vc_screenbuf_size,
+					       GFP_KERNEL);
 	    if (!vc->vc_screenbuf) {
 		kfree(vc);
 		vc_cons[currcons].d = NULL;

Thanks.

-- 
Catalin

