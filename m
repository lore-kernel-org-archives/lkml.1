Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508Ab0AEVjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab0AEVjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 16:39:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866Ab0AEVjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 16:39:45 -0500
Received: from server109d.appriver.com ([72.32.253.88]:4734 "EHLO
	server109.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754977Ab0AEVjp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 16:39:45 -0500
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
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
x-cr-hashedpuzzle: Bd84 GRhT G/70 IWej IpfW I/PH JiIa JsFx J34K J+py MUJ0 MhRh P1OQ TjSQ UAa1 Wk1B;2;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHIAbwBtAGEAbgBAAGkAbQBzAHkAcwB0AGUAbQBzAC4AcgB1AA==;Sosha1_v1;7;{D8A3EB3E-C971-43FF-8A1C-B43DF1D22C78};agBrAG8AcwBpAG4AQABpAG4AdABjAG8AbQBnAHIAcAAuAGMAbwBtAA==;Tue, 05 Jan 2010 21:41:16 GMT;UABhAGMAawBlAHQAIAByAGUAdAByAHkAIABvAHAAdABpAG0AaQB6AGEAdABpAG8AbgAgAGkAbgAgAGQAcgBpAHYAZQByAHMALwBuAGUAdAAvAGEAcgBtAC8AYQB0ADkAMQBfAGUAaAB0AGUAcgAuAGMA
x-cr-puzzleid: {D8A3EB3E-C971-43FF-8A1C-B43DF1D22C78}
Content-class: urn:content-classes:message
Subject: Packet retry optimization in drivers/net/arm/at91_ehter.c
Date: Tue, 5 Jan 2010 16:41:16 -0500
Message-ID: <3DBBD805E3BA064A87F551C0E8BD3674028971F2@MAILSRV.intcomgrp.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Packet retry optimization in drivers/net/arm/at91_ehter.c
Thread-Index: AcqOQ/FREFZQ27bzScS2K5dp/kvyoQ==
From: "James Kosin" <JKosin@intcomgrp.com>
To: <linux-kernel@vger.kernel.org>
Cc: <roman@imsystems.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since, a AT91_EMAC_TUND only happens when the transmitter is unable to transfer the frame in time for a frame to be sent.  It makes sense to RETRY the packet in this condition in the ISR.
Or would this overcomplicate a simple task?
                ... see below ...

James

---- Attached code snippet ----

/*
 * MAC interrupt handler
 */
static irqreturn_t at91ether_interrupt(int irq, void *dev_id)
{
...

                if (intstatus & AT91_EMAC_TCOM) {       /* Transmit complete */
                                /* The TCOM bit is set even if the transmission failed. */
                                if (intstatus & (AT91_EMAC_TUND | AT91_EMAC_RTRY))
                                                dev->stats.tx_errors += 1;

                                if (lp->skb) {
                                                dev_kfree_skb_irq(lp->skb);
                                                lp->skb = NULL;
                                                dma_unmap_single(NULL, lp->skb_physaddr, lp->skb_length, DMA_TO_DEVICE);
                                }
                                netif_wake_queue(dev);
                }
...

---- Alternate approach ----

                                /* The TCOM bit is set even if the transmission failed. */
                                if (intstatus & (AT91_EMAC_TUND)) {
                                                /* Set address of the data in the Transmit Address register */
                                                at91_emac_write(AT91_EMAC_TAR, lp->skb_physaddr);
                                                /* Set length of the packet in the Transmit Control register */
                                                at91_emac_write(AT91_EMAC_TCR, skb->len);
                                }
                                else if (intstatus & (AT91_EMAC_RTRY))
                                                dev->stats.tx_errors += 1;

...
I do know there needs to be a bit more code then to handle the successful case below this; but, this is enough to understand what I am talking about.  The UNDERRUN error should happen infrequently and in ideal circumstances not happen at all.
 
 
 

----
James Kosin

