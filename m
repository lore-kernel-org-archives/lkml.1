Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993Ab0ALSkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab0ALSkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 13:40:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690Ab0ALSkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 13:40:35 -0500
Received: from server109g.appriver.com ([72.32.253.91]:3792 "EHLO
	server109.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751221Ab0ALSke convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 13:40:34 -0500
X-Greylist: delayed 3021 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jan 2010 13:40:34 EST
X-Policy: GLOBAL - intcomgrp.com
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
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: arm: Optimization for ethernet MAC handling at91_ether.c
Date: Tue, 12 Jan 2010 13:42:19 -0500
Message-ID: <3DBBD805E3BA064A87F551C0E8BD367402897418@MAILSRV.intcomgrp.com>
In-Reply-To: <4B4CBA93.4090909@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: arm: Optimization for ethernet MAC handling at91_ether.c
Thread-Index: AcqTspWCmnn7FjRuR3SQzPFeTMxe6wAANsBQ
References: <3DBBD805E3BA064A87F551C0E8BD3674028973F5@MAILSRV.intcomgrp.com> <4B4CA4E5.7030800@gmail.com> <3DBBD805E3BA064A87F551C0E8BD36740289740E@MAILSRV.intcomgrp.com> <4B4CBA93.4090909@gmail.com>
From: "James Kosin" <JKosin@intcomgrp.com>
To: "Eric Dumazet" <eric.dumazet@gmail.com>
Cc: <linux-kernel@vger.kernel.org>,
       "Linux Netdev List" <netdev@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Eric Dumazet
Sent: Tuesday, January 12, 2010 1:08 PM
To: James Kosin
Cc: linux-kernel@vger.kernel.org; Linux Netdev List
Subject: Re: arm: Optimization for ethernet MAC handling at91_ether.c

Le 12/01/2010 18:51, James Kosin a écrit :
> On 1/12/2010 11:40 AM, Eric Dumazet wrote:

>> If this happens once in a while, why do you want driver to retry the transmit ?
> 
> (a)  It would improve performance by allowing the ISR to handle the re-transmit in this case.
> (b)  It would help in the case of small glitches that may happen from external SDRAM without taxing the polling required to handle the re-transmit of the packet... ie: overhead required to re-queue and initiate a packet delivery... since the packet is already scheduled for delivery now.
> 

OK, but then this also adds an extra check for each tx completion.

I dont have this piece of hardware, but seeing it has a one skb tx queue (!),
I suppose TX performance is not very good anyway...


at91ether_interrupt() should probably handle tx completion before rx, to feed
next frame faster.


---

I know.  Actually, I am using the hardware; and the part is capable of more than this driver is displaying.

1)  The part is able to queue up two packets (1) actively being transmitted, and (1) queued up behind that packet.  The driver doesn't exploit this; probably because this would cause some confusion, since we wouldn't really know which packet failed when this happens.

2)  TX performance is so..so.  With bing on another computer using '-z' option it is reporting a fairly good value of 74Mbps.  I'll have to try with a re-compiled kernel at some point to give better feedback if we can improve this more.

Your interpretation makes some sense on the transmit side.  The RX currently has a DMA queue that extends to a depth of 9 (currently).  So getting one transmit out before checking the RX may improve things a bit.

James
