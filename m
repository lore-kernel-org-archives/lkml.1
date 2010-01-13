Return-Path: <linux-kernel-owner+w=401wt.eu-S1756451Ab0AMVMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab0AMVMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 16:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756430Ab0AMVMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 16:12:17 -0500
Received: from server109j.appriver.com ([72.32.253.94]:1725 "EHLO
	server109.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756421Ab0AMVMQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 16:12:16 -0500
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
Subject: RE: [PATCH 2/2] net: at91_ether.c - Allow transmitter interrupt to be handled first in ISR
Date: Wed, 13 Jan 2010 16:13:59 -0500
Message-ID: <3DBBD805E3BA064A87F551C0E8BD3674028974BF@MAILSRV.intcomgrp.com>
In-Reply-To: <4B4E0C2C.1000101@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] net: at91_ether.c - Allow transmitter interrupt to be handled first in ISR
Thread-Index: AcqUe+LdFtpge1j6T9euGhsGcUwYZQAFGQiw
References: <3DBBD805E3BA064A87F551C0E8BD367402897491@MAILSRV.intcomgrp.com> <4B4E0C2C.1000101@gmail.com>
From: "James Kosin" <JKosin@intcomgrp.com>
To: "Eric Dumazet" <eric.dumazet@gmail.com>
Cc: <linux-kernel@vger.kernel.org>,
       "Linux Netdev List" <netdev@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On >Behalf Of Eric Dumazet
>Sent: Wednesday, January 13, 2010 1:09 PM
>To: James Kosin
>Cc: linux-kernel@vger.kernel.org; Linux Netdev List
>Subject: Re: [PATCH 2/2] net: at91_ether.c - Allow transmitter interrupt to be handled >first in ISR
>
>Le 13/01/2010 18:46, James Kosin a écrit :
>> Ok,
>> 
>> This next patch is optional....
>> 
>
>Are we sure chip doesnt report TUND forever in some situations ?
>Should'nt we have a retry limit for each skb ?
>

Directly from the documentation for the AT91RM9200 MAC registers:

For the transmitter status register:
* UND: Transmit Underrun
Set when transmit DMA was not able to read data from memory in time. If this happens, the transmitter forces bad CRC.
Cleared by writing a one to this bit.

For the interrupt status register:
* TUND: Transmit Buffer Underrun
Ethernet transmit buffer underrun. The transmit DMA did not complete fetch frame data in time for it to be transmitted.
Cleared on read.

In section 36.5.4.1

The transmit address register must be written before the transmit control register. While a frame is being transmitted, it is possible to set up one other frame for transmission by writing new values to the transmit address and control registers. Reading the transmit address register returns the address of the buffer currently being accessed by the transmit FIFO.

This is where we may be able to exploit multiple transmit frames.
I'm not sure how to handle this in the confines of the kernel for this ARM part.  Currently, the architecture strictly limits the number of frames to (1) one only!  I'm not sure why; since there is no comment on this in the source for the driver.  My only guess, is that the authors where worried that if an error occurred on a frame they would not be able to determine which frame was effected by the error.

---


>From the AT91SAM9G20 MAC registers:

* UND: Transmit Underrun
Set when transmit DMA was not able to read data from memory, either because the bus was not granted in time, because
a not OK hresp(bus error) was returned or because a used bit was read midway through frame transmission. If this
occurs, the transmitter forces bad CRC. Cleared by writing a one to this bit.

* TUND: Ethernet Transmit Buffer Underrun
The transmit DMA did not fetch frame data in time for it to be transmitted or hresp returned not OK. Also set if a used bit
is read mid-frame or when a new transmit queue pointer is written. Cleared on read.


The 91SAM9G20 MAC supports transmitter DMA queues; and I don't believe this driver should be used with that part; but, the descriptions on the events causing the error are consistent.
The error should only happen if the MAC is unable to transfer the frame from shared memory due to some situations where the processor or other device is accessing the same memory area.  I'm also guessing if the shared memory area is in SDRAM instead of internal SRAM this could also be caused by mandated SDRAM refresh cycles.

====

Sorry about the patch submitting... it is really my first time and I'm in the process of installing Cygwin to be able to submit a more formal patch and to be able to verify the performance and particulars.  I'll get the git tree ASAP; so, I can diff and compile against that.  Thanks for the tips on this.

I can attach the source file and copy you to look at, if you wish?

Thanks,
James
