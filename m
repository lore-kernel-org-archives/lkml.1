Return-Path: <linux-kernel-owner+w=401wt.eu-S1752515AbZLRHfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbZLRHfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 02:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbZLRHfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 02:35:21 -0500
Received: from webmail.olin.edu ([209.94.128.49]:9170 "EHLO EXCAS01.olin.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbZLRHfV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 02:35:21 -0500
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Dec 2009 02:35:21 EST
From: James Getzendanner <James.Getzendanner@students.olin.edu>
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
CC: "trivial@kernel.org" <trivial@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 18 Dec 2009 02:29:51 -0500
Subject: [PATCH] Userspace pointer dereference in drivers/gpu/vga/vgaarb.c
Thread-Topic: [PATCH] Userspace pointer dereference in
 drivers/gpu/vga/vgaarb.c
Thread-Index: Acp/s+KbX1YZOJKZT3+37xA1ROiIaA==
Message-ID: <DA80C3E6C10BE94E8FCACEB239C2FEE46645317E76@EXVS01.olin.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Getzendanner <james.getzendanner@students.olin.edu>

This patch corrects a userspace pointer dereference in the VGA arbiter
in 2.6.32.1.
Signed-off-by: Andy Getzendanner <james.getzendanner@students.olin.edu>
---
copy_from_user() is used at line 822 to copy the contents of buf into
kbuf, but a call to strncmp() on line 964 uses buf rather than kbuf.
This problem led to a GPF in strncmp() when X was started on my x86_32
systems.  X triggered the behavior with a write of
"target PCI:0000:01:00.0" to /dev/vga_arbiter.
The patch has been tested against 2.6.32.1 and observed to correct the
GPF observed when starting X or manually writing the string
"target PCI:0000:01:00.0" to /dev/vga_arbiter.
Please CC me at james.getzendanner@students.olin.edu in any replies as I
am not on the list.
--- linux-2.6.32.1/drivers/gpu/vga/vgaarb.c.orig	2009-12-18 00:26:31.000000000 -0500
+++ linux-2.6.32.1/drivers/gpu/vga/vgaarb.c	2009-12-18 00:27:14.000000000 -0500
@@ -961,7 +961,7 @@ static ssize_t vga_arb_write(struct file
 		remaining -= 7;
 		pr_devel("client 0x%p called 'target'\n", priv);
 		/* if target is default */
-		if (!strncmp(buf, "default", 7))
+		if (!strncmp(kbuf, "default", 7))
 			pdev = pci_dev_get(vga_default_device());
 		else {
 			if (!vga_pci_str_to_vars(curr_pos, remaining,
