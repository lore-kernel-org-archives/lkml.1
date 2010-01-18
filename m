Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197Ab0ARHfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab0ARHfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 02:35:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028Ab0ARHfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 02:35:22 -0500
Received: from mx.neterion.com ([72.1.205.142]:10817 "EHLO owa.neterion.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666Ab0ARHfW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 02:35:22 -0500
X-Greylist: delayed 913 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jan 2010 02:35:22 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] S2io: two branches the same in wait_for_cmd_complete()
Date: Mon, 18 Jan 2010 02:20:06 -0500
Message-ID: <78C9135A3D2ECE4B8162EBDCE82CAD77061418BF@nekter>
In-Reply-To: <4B53284C.1090405@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] S2io: two branches the same in wait_for_cmd_complete()
Thread-Index: AcqXiq3oaGPMYqLLTRKO9OJuZ6ZP6wAgrK8A
References: <4B53284C.1090405@gmail.com>
From: "Ramkrishna Vepa" <Ramkrishna.Vepa@neterion.com>
To: "Roel Kluin" <roel.kluin@gmail.com>, <netdev@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Regardless of the bit_state, the branches execute the same code.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/net/s2io.c |   13 +++----------
>  1 files changed, 3 insertions(+), 10 deletions(-)
> 
> Maybe something else was intended?
> this was introduced in commit 9fc93a41a1ad11
> 
> diff --git a/drivers/net/s2io.c b/drivers/net/s2io.c
> index cc42186..0e353d6 100644
> --- a/drivers/net/s2io.c
> +++ b/drivers/net/s2io.c
> @@ -3415,16 +3415,9 @@ static int wait_for_cmd_complete(void __iomem
> *addr, u64 busy_bit,
> 
>  	do {
>  		val64 = readq(addr);
> -		if (bit_state == S2IO_BIT_RESET) {
> -			if (!(val64 & busy_bit)) {
> -				ret = SUCCESS;
> -				break;
> -			}
> -		} else {
> -			if (!(val64 & busy_bit)) {
> -				ret = SUCCESS;
> -				break;
> -			}
> +		if (!(val64 & busy_bit)) {
> +			ret = SUCCESS;
> +			break;
>  		}
> 
>  		if (in_interrupt())
> --
Thanks for catching this bug. The fix should be as follows -
--- a/drivers/net/s2io.c
+++ b/drivers/net/s2io.c
@@ -3421,7 +3421,7 @@ static int wait_for_cmd_complete(void __iomem
*addr, u64 busy_bit,
                                break;
                        }
                } else {
-                       if (!(val64 & busy_bit)) {
+                       if (val64 & busy_bit) {
                                ret = SUCCESS;
                                break;
                        }

We've not hit this bug because wait_for_cmd_complete() is always called
with S2IO_BIT_RESET.

Ram
