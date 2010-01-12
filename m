Return-Path: <linux-kernel-owner+w=401wt.eu-S1753637Ab0ALPhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab0ALPhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 10:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562Ab0ALPhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 10:37:42 -0500
Received: from server109b.appriver.com ([72.32.253.86]:4678 "EHLO
	server109.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752266Ab0ALPhl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 10:37:41 -0500
X-Policy: GLOBAL - intcomgrp.com
X-Primary: jkosin@intcomgrp.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: JKosin@intcomgrp.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: UNITED STATES->UNITED STATES
X-Note-Sending-IP: 216.54.13.100
X-Note-Reverse-DNS: mail.intcomgrp.com
X-Note-WHTLIST: JKosin@intcomgrp.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G113 G114 G115 G116 G120 G121 G132 G219 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: arm: Optimization for ethernet MAC handling at91_ether.c
Date: Tue, 12 Jan 2010 10:39:25 -0500
Message-ID: <3DBBD805E3BA064A87F551C0E8BD3674028973F5@MAILSRV.intcomgrp.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: arm: Optimization for ethernet MAC handling at91_ether.c
Thread-Index: AcqTnWuda+i8z3DoRiOtF72IH6eohQ==
From: "James Kosin" <JKosin@intcomgrp.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Everyone,

Since, a AT91_EMAC_TUND only happens when the transmitter is unable to
transfer the frame in time for a frame to be sent.  It makes sense to
RETRY the packet in this condition in the ISR.
Or would this overcomplicate a simple task?
                ... see below ...

James

---- code snippet ----

/*
 * MAC interrupt handler
 */
static irqreturn_t at91ether_interrupt(int irq, void *dev_id) { ...

                if (intstatus & AT91_EMAC_TCOM) {       /* Transmit
complete */
                                /* The TCOM bit is set even if the
transmission failed. */
                                if (intstatus & (AT91_EMAC_TUND |
AT91_EMAC_RTRY))
                                                dev->stats.tx_errors +=
1;

                                if (lp->skb) {
 
dev_kfree_skb_irq(lp->skb);
                                                lp->skb = NULL;
                                                dma_unmap_single(NULL,
lp->skb_physaddr, lp->skb_length, DMA_TO_DEVICE);
                                }
                                netif_wake_queue(dev);
                }
...

---- Alternate approach ----

                                /* The TCOM bit is set even if the
transmission failed. */
                                if (intstatus & (AT91_EMAC_TUND)) {
                                                /* Set address of the
data in the Transmit Address register */
 
at91_emac_write(AT91_EMAC_TAR, lp->skb_physaddr);
                                                /* Set length of the
packet in the Transmit Control register */
 
at91_emac_write(AT91_EMAC_TCR, skb->len);
                                }
                                else if (intstatus & (AT91_EMAC_RTRY))
                                                dev->stats.tx_errors +=
1;

...
I do know there needs to be a bit more code then to handle the
successful case below this; but, this is enough to understand what I am
talking about.  The UNDERRUN error should happen infrequently and in
ideal circumstances not happen at all.
 
 


----
James Kosin
Software Engineer
