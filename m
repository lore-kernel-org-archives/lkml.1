Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbZHCMMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbZHCMMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 08:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbZHCMML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 08:12:11 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:39344 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280AbZHCMMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 08:12:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=VRB5+SSdMz5qOqJy5Lsyne2M0UYowDKp82a93vZBBJF7UdRUEKLlz6qq+wK7AsBhRB
         I3MnA3vO+VNT2C8JXWP2PMYv3+WhSVKBw+CW07BdVIGPqKR484KL2T5HWKbmg7h6Jg17
         jy1wL0h29DuB9DKFOmqGxhz+ZBWQkfZ5m21Ss=
Message-ID: <4A76D4DA.8090905@gmail.com>
Date: Mon, 03 Aug 2009 14:15:22 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: alan@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] serial167: Read buffer overflow
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check whether index is within bounds before grabbing the element.
Also, since NR_PORTS is defined ARRAY_SIZE(cy_port),
cy_port[NR_PORTS] is out of bounds as well. 

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/char/serial167.c b/drivers/char/serial167.c
index 51e7a46..affa5e2 100644
--- a/drivers/char/serial167.c
+++ b/drivers/char/serial167.c
@@ -222,7 +222,7 @@ static inline int serial_paranoia_check(struct cyclades_port *info, char *name,
 	}
 
 	if ((long)info < (long)(&cy_port[0])
-	    || (long)(&cy_port[NR_PORTS]) < (long)info) {
+	    || (long)(&cy_port[NR_PORTS-1]) < (long)info) {
 		printk("Warning: cyclades_port out of range for (%s) in %s\n",
 				name, routine);
 		return 1;
@@ -521,15 +521,13 @@ static irqreturn_t cd2401_tx_interrupt(int irq, void *dev_id)
 		panic("TxInt on debug port!!!");
 	}
 #endif
-
-	info = &cy_port[channel];
-
 	/* validate the port number (as configured and open) */
 	if ((channel < 0) || (NR_PORTS <= channel)) {
 		base_addr[CyIER] &= ~(CyTxMpty | CyTxRdy);
 		base_addr[CyTEOIR] = CyNOTRANS;
 		return IRQ_HANDLED;
 	}
+	info = &cy_port[channel];
 	info->last_active = jiffies;
 	if (info->tty == 0) {
 		base_addr[CyIER] &= ~(CyTxMpty | CyTxRdy);
