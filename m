Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021AbYE3Xwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbYE3Xwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 19:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbYE3Xwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 19:52:46 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:56460 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbYE3Xwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 19:52:45 -0400
Message-ID: <48409408.8090901@keyaccess.nl>
Date: Sat, 31 May 2008 01:55:52 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Takashi Iwai <tiwai@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ALSA devel <alsa-devel@alsa-project.org>
Subject: [PATCH] ISA: set 24-bit dma_mask for ISA devices.
References: <4823AAF2.7070102@keyaccess.nl> <482B38D6.5030804@keyaccess.nl> <48406E8D.8050408@keyaccess.nl> <200805301543.42208.bjorn.helgaas@hp.com> <48407B99.4080209@keyaccess.nl>
In-Reply-To: <48407B99.4080209@keyaccess.nl>
Content-Type: multipart/mixed;
 boundary="------------090107060507070503030209"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090107060507070503030209
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit


--------------090107060507070503030209
Content-Type: text/plain;
 name="0002-ISA-set-24-bit-dma_mask-for-ISA-devices.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0002-ISA-set-24-bit-dma_mask-for-ISA-devices.patch"

>From 56e4b14aa58612aeb41b51d73a75f85dd72127a1 Mon Sep 17 00:00:00 2001
From: Rene Herman <rene.herman@gmail.com>
Date: Sat, 31 May 2008 00:31:40 +0200
Subject: [PATCH] ISA: set 24-bit dma_mask for ISA devices.

dma_alloc_coherent() on x86 currently takes a passed in NULL device
pointer to mean that it should allocate an ISA compatible (24-bit)
buffer which is a bit of a hack.

The ALSA ISA drivers are the main consumers of this but have a struct
device in fact readily available.

For the legacy drivers, this sets the device dma_mask in preparation
for using the actual device with the DMA API so as to eventually not
need the NULL hack in dma_alloc_coherent().

This does not fix a current bug -- 2.6.26-rc1 stumbled over the NULL
hack in dma_alloc_coherent() but this has already been fixed in commit
4a367f3a9dbf2e7ffcee4702203479809236ee6e by Takashi Iwai.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/base/isa.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/base/isa.c b/drivers/base/isa.c
index d222239..efd5775 100644
--- a/drivers/base/isa.c
+++ b/drivers/base/isa.c
@@ -7,6 +7,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/dma-mapping.h>
 #include <linux/isa.h>
 
 static struct device isa_bus = {
@@ -141,6 +142,9 @@ int isa_register_driver(struct isa_driver *isa_driver, unsigned int ndev)
 		isa_dev->dev.release		= isa_dev_release;
 		isa_dev->id			= id;
 
+		isa_dev->dev.coherent_dma_mask = DMA_24BIT_MASK;
+		isa_dev->dev.dma_mask = &isa_dev->dev.coherent_dma_mask;
+
 		error = device_register(&isa_dev->dev);
 		if (error) {
 			put_device(&isa_dev->dev);
-- 
1.5.2.2


--------------090107060507070503030209--
