Return-Path: <linux-kernel-owner+w=401wt.eu-S1761990AbZFIKag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761990AbZFIKag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932066AbZFIKUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:20:36 -0400
Received: from kroah.org ([198.145.64.141]:55167 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760806AbZFIKUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:20:35 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:05 2009
Message-Id: <20090609094104.954759812@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Adam Radford <aradford@gmail.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 55/87] [SCSI] 3w-xxxx: scsi_dma_unmap fix
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=3w-xxxx-scsi_dma_unmap-fix.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: adam radford <aradford@gmail.com>

commit 7b14f58ad65f9d74e4273fb45360cfea824495aa upstream.

This patch fixes the following regression that occurred during the
scsi_dma_map()/unmap()
changes when compiling with CONFIG_DMA_API_DEBUG=y :

WARNING: at lib/dma-debug.c:496 check_unmap+0x142/0x542()
Hardware name:
3w-xxxx 0000:02:02.0: DMA-API: device driver tries to free DMA memory
it has not allocated [device address=0x0000000000000000] [size=36
bytes]

Signed-off-by: Adam Radford <aradford@gmail.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/3w-xxxx.c |    5 +++--
 drivers/scsi/3w-xxxx.h |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -6,7 +6,7 @@
    		     Arnaldo Carvalho de Melo <acme@conectiva.com.br>
                      Brad Strand <linux@3ware.com>
 
-   Copyright (C) 1999-2007 3ware Inc.
+   Copyright (C) 1999-2009 3ware Inc.
 
    Kernel compatiblity By: 	Andre Hedrick <andre@suse.com>
    Non-Copyright (C) 2000	Andre Hedrick <andre@suse.com>
@@ -1294,7 +1294,8 @@ static void tw_unmap_scsi_data(struct pc
 {
 	dprintk(KERN_WARNING "3w-xxxx: tw_unmap_scsi_data()\n");
 
-	scsi_dma_unmap(cmd);
+	if (cmd->SCp.phase == TW_PHASE_SGLIST)
+		scsi_dma_unmap(cmd);
 } /* End tw_unmap_scsi_data() */
 
 /* This function will reset a device extension */
--- a/drivers/scsi/3w-xxxx.h
+++ b/drivers/scsi/3w-xxxx.h
@@ -6,7 +6,7 @@
    		     Arnaldo Carvalho de Melo <acme@conectiva.com.br>
                      Brad Strand <linux@3ware.com>
 
-   Copyright (C) 1999-2007 3ware Inc.
+   Copyright (C) 1999-2009 3ware Inc.
 
    Kernel compatiblity By:	Andre Hedrick <andre@suse.com>
    Non-Copyright (C) 2000	Andre Hedrick <andre@suse.com>


