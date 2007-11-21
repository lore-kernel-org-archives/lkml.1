Return-Path: <linux-kernel-owner+w=401wt.eu-S1757146AbXKUNHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146AbXKUNHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 08:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbXKUNHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 08:07:41 -0500
Received: from odyssey.analogic.com ([204.178.40.5]:4919 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbXKUNHk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 08:07:40 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 21 Nov 2007 13:06:36.0946 (UTC) FILETIME=[59196F20:01C82C3F]
Content-class: urn:content-classes:message
Subject: Re: [KERNEL]: Avoid divide in IS_ALIGN
Date: Wed, 21 Nov 2007 08:06:36 -0500
Message-ID: <Pine.LNX.4.61.0711210800140.25473@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.61.0711201625570.21839@chaos.analogic.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [KERNEL]: Avoid divide in IS_ALIGN
thread-index: AcgsP1kjYD7QaE2uTX+49McKlVA5hg==
References: <20071120135607.GA18346@gondor.apana.org.au> <Pine.LNX.4.61.0711201625570.21839@chaos.analogic.com>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 20 Nov 2007, Richard B. Johnson wrote:

> On Tue, 20 Nov 2007, Herbert Xu wrote:
>
>> Hi:
>> 
>> [KERNEL]: Avoid divide in IS_ALIGN
>> 
>> I was happy to discover the brand new IS_ALIGN macro and quickly
>> used it in my code.  To my dismay I found that the generated code
>> used division to perform the test.
>> 
>> This patch fixes it by changing the % test to an &.  This avoids
>> the division.
>> 
>> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>> 
>> Cheers,
>> -- 
>> Visit Openswan at http://www.openswan.org/
>> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
>> Home Page: http://gondor.apana.org.au/~herbert/
>> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>> --
>> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
>> index 94bc996..39b3fa6 100644
>> --- a/include/linux/kernel.h
>> +++ b/include/linux/kernel.h
>> @@ -35,7 +35,7 @@ extern const char linux_proc_banner[];
>> #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
>> #define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
>> #define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), 
>> (a)))
>> -#define IS_ALIGNED(x,a)		(((x) % ((typeof(x))(a))) == 0)
>> +#define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
>> 
>
> Your macro modification is wrong.

There was a brain fart on the explaination of why it's wrong.
Here is a better explaination.

Executing this script.............

cat <<EOF >/tmp/xxx.c
#include <stdio.h>

#define IS_ALIGNED(x,a)		(((x) % ((typeof(x))(a))) == 0)
#define _IS_ALIGNED(x, a)	(((x) & ((typeof(x))(a) - 1)) == 0)

int main()
{
    int i;
    long p = 0x12345678;
    for(i=1; i< 0x11; i++)
        printf("Old = %d, new = %d\n", IS_ALIGNED(p, i), _IS_ALIGNED(p, i));
     return 0;
}
EOF
gcc -Wall -o /tmp/xxx /tmp/xxx.c
/tmp/xxx

... produces:
Old = 1, new = 1
Old = 1, new = 1
Old = 1, new = 1
Old = 1, new = 1
Old = 0, new = 1
Old = 1, new = 1
Old = 0, new = 1
Old = 1, new = 1
Old = 1, new = 0
Old = 0, new = 0
Old = 0, new = 0
Old = 1, new = 0
Old = 0, new = 0
Old = 0, new = 0
Old = 0, new = 0
Old = 0, new = 0

Which is clearly different.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.30 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
