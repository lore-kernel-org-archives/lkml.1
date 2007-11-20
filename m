Return-Path: <linux-kernel-owner+w=401wt.eu-S1758941AbXKTVn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941AbXKTVn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:43:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbXKTVns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:43:48 -0500
Received: from odyssey.analogic.com ([204.178.40.5]:3014 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbXKTVnr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:43:47 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 20 Nov 2007 21:43:41.0063 (UTC) FILETIME=[6A804170:01C82BBE]
Content-class: urn:content-classes:message
Subject: Re: [KERNEL]: Avoid divide in IS_ALIGN
Date: Tue, 20 Nov 2007 16:43:40 -0500
Message-ID: <Pine.LNX.4.61.0711201625570.21839@chaos.analogic.com>
In-Reply-To: <20071120135607.GA18346@gondor.apana.org.au>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [KERNEL]: Avoid divide in IS_ALIGN
thread-index: AcgrvmqHkZx7Zx56Tc68Q9hxtDK6NA==
References: <20071120135607.GA18346@gondor.apana.org.au>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 20 Nov 2007, Herbert Xu wrote:

> Hi:
>
> [KERNEL]: Avoid divide in IS_ALIGN
>
> I was happy to discover the brand new IS_ALIGN macro and quickly
> used it in my code.  To my dismay I found that the generated code
> used division to perform the test.
>
> This patch fixes it by changing the % test to an &.  This avoids
> the division.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> Cheers,
> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 94bc996..39b3fa6 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -35,7 +35,7 @@ extern const char linux_proc_banner[];
> #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
> #define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
> #define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
> -#define IS_ALIGNED(x,a)		(((x) % ((typeof(x))(a))) == 0)
> +#define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
>

Your macro modification is wrong.

Take 0x12345600, which is aligned on a 16-byte boundary.
Now, with your macro, we have for a 0x10 alignment:
      (0x12345600 & 0x0f) = (0x00 == 0) == TRUE (correct)
For an 0x20 alignment:
      (0x12345600 & 0x1f) = (0x00 == 0) == TRUE (incorrect)

In other words, the macro may work for some alignments, but
not all. It is therefore wrong. You need the modulus, the
remainder after division. Anything else is broken.

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.30 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
