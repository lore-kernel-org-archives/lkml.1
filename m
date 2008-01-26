Return-Path: <linux-kernel-owner+w=401wt.eu-S1760009AbYAZCHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760009AbYAZCHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 21:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759273AbYAZCHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 21:07:18 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:62578 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759209AbYAZCHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 21:07:14 -0500
Date: Fri, 25 Jan 2008 18:13:47 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: change aper valid checking sequence
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <200801251813.48961.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: change aper valid checking sequence

old sequence:
size ==> >4G  ==> point to RAM
changed to
>4G ==> point to RAM ==> size

some bios even leave aper to unclear, so check size at last.
to avoid reporting that like

Node 0: Aperture @ 4a42000000 size 32 MB
Aperture too small (32 MB)

with patch will get

Node 0: Aperture @ 4a42000000 size 32 MB
Aperture beyond 4G. Ignoring.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 0b837bb..608152a 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -85,10 +85,6 @@ static int __init aperture_valid(u64 aper_base, u32 aper_size)
 	if (!aper_base)
 		return 0;
 
-	if (aper_size < 64*1024*1024) {
-		printk(KERN_ERR "Aperture too small (%d MB)\n", aper_size>>20);
-		return 0;
-	}
 	if (aper_base + aper_size > 0x100000000UL) {
 		printk(KERN_ERR "Aperture beyond 4GB. Ignoring.\n");
 		return 0;
@@ -97,6 +93,10 @@ static int __init aperture_valid(u64 aper_base, u32 aper_size)
 		printk(KERN_ERR "Aperture pointing to e820 RAM. Ignoring.\n");
 		return 0;
 	}
+	if (aper_size < 64*1024*1024) {
+		printk(KERN_ERR "Aperture too small (%d MB)\n", aper_size>>20);
+		return 0;
+	}
 
 	return 1;
 }
