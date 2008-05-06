Return-Path: <linux-kernel-owner+w=401wt.eu-S1761024AbYEFMnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761024AbYEFMnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 08:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbYEFMnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 08:43:46 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:58023 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbYEFMnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 08:43:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=fpRaQMONt7qtUscujjmQlnoK9w1fTBXWJBoZY7MJY5kWhGVS8Ir53NqUXT2c/ymTw4UmKzHRAvKmznv2HTBGXVSghsL52QEGSeR4YRLwObY51JzwcSlpK+uiEAUXYipfsh/SO3x5cPmZT13dey0lJkbyQw7VUeUEFDPmKaxd/M8=
Message-ID: <d2b9ea600805060543w6e73d9a8p85fac7543c19a05f@mail.gmail.com>
Date: Tue, 6 May 2008 14:43:43 +0200
From: "Esben Haabendal" <esbenhaabendal@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: IRQ_NOAUTOEN in __set_irq_handler
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Would it be possible to have support for IRQ_NOAUTOEN in
__set_irq_handler and thus set_irq_chained_handler?

Something like:

@@ -582,14 +582,19 @@ __set_irq_handler(unsigned int irq,
irq_flow_handler_t handle, int is_chained,
 	}
 	desc->handle_irq = handle;
 	desc->name = name;

 	if (handle != handle_bad_irq && is_chained) {
-		desc->status &= ~IRQ_DISABLED;
 		desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE;
-		desc->depth = 0;
-		desc->chip->unmask(irq);
+		if (!(desc->status & IRQ_NOAUTOEN)) {
+			desc->depth = 0;
+			desc->status &= ~IRQ_DISABLED;
+			desc->chip->unmask(irq);
+		} else {
+			/* Undo nested disables: */
+			desc->depth = 1;
+		}
 	}
 	spin_unlock_irqrestore(&desc->lock, flags);
 }

 void
