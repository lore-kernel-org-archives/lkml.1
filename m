Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934235Ab0BQNrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:47:10 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53748 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934232Ab0BQNq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:46:59 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 1/3] tty: Make vt's have a tty_port
To: linux-kernel@vger.kernel.org
Date: Wed, 17 Feb 2010 13:23:03 +0000
Message-ID: <20100217132253.17289.17812.stgit@localhost.localdomain>
In-Reply-To: <20100217131931.17289.68158.stgit@localhost.localdomain>
References: <20100217131931.17289.68158.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vt layer isn't safely handling reference counts to tty object on the input
side. Add a tty port structure to the vt layer in order to implement this using
the standard helpers.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/vt.c              |    2 ++
 include/linux/console_struct.h |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)


diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index bd1d116..8e2cb28 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -768,6 +768,7 @@ int vc_allocate(unsigned int currcons)	/* return 0 on success */
 	    if (!vc)
 		return -ENOMEM;
 	    vc_cons[currcons].d = vc;
+	    tty_port_init(&vc->port);
 	    INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
 	    visual_init(vc, currcons, 1);
 	    if (!*vc->vc_uni_pagedir_loc)
@@ -2908,6 +2909,7 @@ static int __init con_init(void)
 	for (currcons = 0; currcons < MIN_NR_CONSOLES; currcons++) {
 		vc_cons[currcons].d = vc = kzalloc(sizeof(struct vc_data), GFP_NOWAIT);
 		INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
+		tty_port_init(&vc->port);
 		visual_init(vc, currcons, 1);
 		vc->vc_screenbuf = kzalloc(vc->vc_screenbuf_size, GFP_NOWAIT);
 		vc_init(vc, vc->vc_rows, vc->vc_cols,
diff --git a/include/linux/console_struct.h b/include/linux/console_struct.h
index 38fe59d..57e83f1 100644
--- a/include/linux/console_struct.h
+++ b/include/linux/console_struct.h
@@ -21,6 +21,8 @@ struct vt_struct;
 #define NPAR 16
 
 struct vc_data {
+	struct tty_port port;			/* Upper level data */
+
 	unsigned short	vc_num;			/* Console number */
 	unsigned int	vc_cols;		/* [#] Console size */
 	unsigned int	vc_rows;

