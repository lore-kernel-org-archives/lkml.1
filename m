Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794Ab0CLNMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 08:12:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756555Ab0CLNMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 08:12:17 -0500
Message-ID: <4B9A3DAC.3020008@redhat.com>
Date: Fri, 12 Mar 2010 14:12:12 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Lightning/1.0b1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Matthias Schniedermeyer <ms@citd.de>
CC: Mathias Buren <mathias.buren@ie.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: RAID + LUKS + LVM performance
References: <OF8365E100.57191C87-ON802576E3.0046BDEA-802576E3.0047EFDF@ie.ibm.com> <20100311173604.GA17659@citd.de> <OFDBA54FBA.FB6F3D10-ON802576E4.002FCA7A-802576E4.002FFBCF@ie.ibm.com> <20100312120643.GA26020@citd.de>
In-Reply-To: <20100312120643.GA26020@citd.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2010 01:06 PM, Matthias Schniedermeyer wrote:

> Using one of the Westmere Core i5-6XX, which support AES-NI, should get 
> you better performance (if supported by krcyptd), altough you loose 2 
> cores as onyl have 2. But i don't know what kind of performance 
> improvement (if any) AES-NI provides.
> Or you wait a few weeks and buy on Core I7-980X with 6 core and AES-NI.

dm-crypt uses whatever is implemented in cryptoAPI, AES-NI of course works
when you have proper modules loaded.

The main reason why dm-crypt is single-threaded is that all these new
crypto accelerators uses asynchronous crypto API, so if hw allows
parallel operation it can use it already.
(dm-crypt submits all sectors in bio as separate asynchronous crypto requests).

But note: single threaded per volume - if you have LVM with multiple
encrypted LVs - every LV have its own thread.

If we build another multi-core(thread) processing in dm-crypt, it can
help on multi-core CPU but complicate things otherwise.
(I tried simple implementation and abandoned it, I would prefer
if cryptoAPI can do some parallel processing itself here.
That question was discussed several times on dm-crypt mailing list.)

Anyway, only two real-world examples, where one thread 
in dm-crypt can cause real problems with speed

 - dm-crypt over fast RAID(5)
 - dm-crypt over fast SSD.

And many users of these configurations have now AES-NI acceleration.

Milan
--
mbroz@redhat.com
