Return-Path: <linux-kernel-owner+w=401wt.eu-S1751658AbXBPXON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbXBPXON (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660AbXBPXON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:14:13 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:52127 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbXBPXOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:14:12 -0500
Date: Sat, 17 Feb 2007 00:14:25 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Andrew Morton <akpm@osdl.org>, Mauro Carvalho Chehab <mchehab@linuxtv.org>,
       v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fix SAA7146_CLIPPING_MEM size
Message-ID: <20070216231425.GA11836@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Limit the pci_alloc_consistent size to 128K
PAGE_SIZE can be 64K, which leads to a 896K allocation.

calculate_clipping_registers_rect() uses not more than 257 bytes
because saa7146_video.c:s_fmt limits ov.nclips to 16

But bttv-driver.c does not allow up to 2048 clips in win->clipcount
btcx_screen_clips() may add 4 more clips.

So a max array size of 131329 is enough.
Right now only 56K get allocated.


Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 include/media/saa7146_vv.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/include/media/saa7146_vv.h
===================================================================
--- linux-2.6.orig/include/media/saa7146_vv.h
+++ linux-2.6/include/media/saa7146_vv.h
@@ -239,7 +239,8 @@ void saa7146_res_free(struct saa7146_fh 
 #define SAA7146_HPS_SYNC_PORT_B		0x01
 
 /* some memory sizes */
-#define SAA7146_CLIPPING_MEM	(14*PAGE_SIZE)
+/* see saa7146_hlp.c:calculate_clipping_registers_rect and bttv-driver.c:setup_window */
+#define SAA7146_CLIPPING_MEM	( ( ( 2048 + 4 ) * ( 2 * (2 * 16) ) ) + 1 )
 
 /* some defines for the various clipping-modes */
 #define SAA7146_CLIPPING_RECT		0x4
