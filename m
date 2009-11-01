Return-Path: <linux-kernel-owner+w=401wt.eu-S1752559AbZKAOGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbZKAOGe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 09:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbZKAOGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 09:06:34 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:44977 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbZKAOGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 09:06:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=T9UwEkAmPdcRNzSijC+Uy037asqmBF0/Lrtl9zQvyw4kJ/nqtKU2aEVPqSQ/tUUTmX
         SdzEz7laNnl5g5bkg4Ne73ZGSZ2b7+8/gxGcb1hyaCUc0ZWHKMSG4DHxjQ8P7eUnRtpO
         sQQVeRNyaDF4Uxt/+XcqdAMyIWhoMnbCy7jIs=
Message-ID: <4AED9884.7050800@gmail.com>
Date: Sun, 01 Nov 2009 15:17:40 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] FRV: ensure dma is within bounds.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure the index `dma' is within bounds before reading from or
writing to frv_dma_channels[dma] and members.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/frv/kernel/dma.c |   57 ++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 49 insertions(+), 8 deletions(-)

Found by code analysis, is this required?

questions:
* Can is_frv_dma_interrupting() return -EINVAL?
* Do we need more verbosity (i.e. printk's on errors)?

I tried to build test it, but it seems not to work
for me due to an unrelated problem:

  CHECK   /home/roel/development/linux-git/arch/frv/kernel/dma.c
/home/roel/development/linux-git/arch/frv/kernel/dma.c:19:11: error: unable to open 'asm/gpio-regs.h'
make[2]: *** [arch/frv/kernel/dma.o] Fout 1
make[1]: *** [arch/frv/kernel/dma.o] Fout 2
make: *** [sub-make] Fout 2

So this patch was not yet tested.

diff --git a/arch/frv/kernel/dma.c b/arch/frv/kernel/dma.c
index 156184e..7cfa461 100644
--- a/arch/frv/kernel/dma.c
+++ b/arch/frv/kernel/dma.c
@@ -9,6 +9,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
@@ -238,9 +239,14 @@ EXPORT_SYMBOL(frv_dma_open);
  */
 void frv_dma_close(int dma)
 {
-	struct frv_dma_channel *channel = &frv_dma_channels[dma];
+	struct frv_dma_channel *channel;
 	unsigned long flags;
 
+	if (dma < 0 || dma >= ARRAY_SIZE(frv_dma_channels))
+		return;
+
+	channel = &frv_dma_channels[dma];
+
 	write_lock_irqsave(&frv_dma_channels_lock, flags);
 
 	free_irq(channel->irq, channel);
@@ -259,7 +265,12 @@ EXPORT_SYMBOL(frv_dma_close);
  */
 void frv_dma_config(int dma, unsigned long ccfr, unsigned long cctr, unsigned long apr)
 {
-	unsigned long ioaddr = frv_dma_channels[dma].ioaddr;
+	unsigned long ioaddr;
+
+	if (dma < 0 || dma >= ARRAY_SIZE(frv_dma_channels))
+		return;
+
+	ioaddr = frv_dma_channels[dma].ioaddr;
 
 	___set_DMAC(ioaddr, CCFR, ccfr);
 	___set_DMAC(ioaddr, CCTR, cctr);
@@ -278,7 +289,12 @@ void frv_dma_start(int dma,
 		   unsigned long sba, unsigned long dba,
 		   unsigned long pix, unsigned long six, unsigned long bcl)
 {
-	unsigned long ioaddr = frv_dma_channels[dma].ioaddr;
+	unsigned long ioaddr;
+
+	if (dma < 0 || dma >= ARRAY_SIZE(frv_dma_channels))
+		return;
+
+	ioaddr = frv_dma_channels[dma].ioaddr;
 
 	___set_DMAC(ioaddr, SBA,  sba);
 	___set_DMAC(ioaddr, DBA,  dba);
@@ -301,7 +317,12 @@ EXPORT_SYMBOL(frv_dma_start);
  */
 void frv_dma_restart_circular(int dma, unsigned long six)
 {
-	unsigned long ioaddr = frv_dma_channels[dma].ioaddr;
+	unsigned long ioaddr;
+
+	if (dma < 0 || dma >= ARRAY_SIZE(frv_dma_channels))
+		return;
+
+	ioaddr = frv_dma_channels[dma].ioaddr;
 
 	___set_DMAC(ioaddr, SIX,  six);
 	___set_DMAC(ioaddr, CSTR, __get_DMAC(ioaddr, CSTR) & ~DMAC_CSTRx_CE);
@@ -320,9 +341,14 @@ EXPORT_SYMBOL(frv_dma_restart_circular);
  */
 void frv_dma_stop(int dma)
 {
-	unsigned long ioaddr = frv_dma_channels[dma].ioaddr;
+	unsigned long ioaddr;
 	uint32_t cctr;
 
+	if (dma < 0 || dma >= ARRAY_SIZE(frv_dma_channels))
+		return;
+
+	ioaddr = frv_dma_channels[dma].ioaddr;
+
 	___set_DMAC(ioaddr, CSTR, 0);
 	cctr = __get_DMAC(ioaddr, CCTR);
 	cctr &= ~(DMAC_CCTRx_IE | DMAC_CCTRx_ACT);
@@ -340,7 +366,12 @@ EXPORT_SYMBOL(frv_dma_stop);
  */
 int is_frv_dma_interrupting(int dma)
 {
-	unsigned long ioaddr = frv_dma_channels[dma].ioaddr;
+	unsigned long ioaddr;
+
+	if (dma < 0 || dma >= ARRAY_SIZE(frv_dma_channels))
+		return -EINVAL;
+
+	ioaddr = frv_dma_channels[dma].ioaddr;
 
 	return __get_DMAC(ioaddr, CSTR) & (1 << 23);
 
@@ -354,8 +385,13 @@ EXPORT_SYMBOL(is_frv_dma_interrupting);
  */
 void frv_dma_dump(int dma)
 {
-	unsigned long ioaddr = frv_dma_channels[dma].ioaddr;
 	unsigned long cstr, pix, six, bcl;
+	unsigned long ioaddr;
+
+	if (dma < 0 || dma >= ARRAY_SIZE(frv_dma_channels))
+		return;
+
+	ioaddr = frv_dma_channels[dma].ioaddr;
 
 	cstr = __get_DMAC(ioaddr, CSTR);
 	pix  = __get_DMAC(ioaddr, PIX);
@@ -453,8 +489,13 @@ EXPORT_SYMBOL(frv_dma_resume_all);
  */
 void frv_dma_status_clear(int dma)
 {
-	unsigned long ioaddr = frv_dma_channels[dma].ioaddr;
+	unsigned long ioaddr;
 	uint32_t cctr;
+
+	if (dma < 0 || dma >= ARRAY_SIZE(frv_dma_channels))
+		return;
+
+	ioaddr = frv_dma_channels[dma].ioaddr;
 	___set_DMAC(ioaddr, CSTR, 0);
 
 	cctr = __get_DMAC(ioaddr, CCTR);
