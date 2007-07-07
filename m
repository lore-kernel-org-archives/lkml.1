Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbXGGNi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbXGGNi6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 09:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbXGGNit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 09:38:49 -0400
Received: from smtp27.orange.fr ([80.12.242.95]:38313 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbXGGNit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 09:38:49 -0400
X-ME-UUID: 20070707133625675.A4E891C0008E@mwinf2729.orange.fr
In-Reply-To: <468F901B.2000000@imap.cc>
References: <878x9ta320.fsf@wanadoo.fr> <468F901B.2000000@imap.cc>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <0BE121C2-D115-4A9A-A557-E65F0F8CBA26@wanadoo.fr>
Cc: kernel-janitors@lists.osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Julia Lawall <julia@diku.dk>
Content-Transfer-Encoding: 7bit
From: yoann padioleau <padator@wanadoo.fr>
Subject: Re: [PATCH] some kmalloc/memset ->kzalloc (tree wide)
Date: Sat, 7 Jul 2007 15:36:24 +0200
To: Tilman Schmidt <tilman@imap.cc>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On 7 juil. 07, at 15:07, Tilman Schmidt wrote:

> Am 06.07.2007 18:51 schrieb Yoann Padioleau:
>> @@
>> expression E1,E2,E3;
>> @@
>>
>> - kzalloc(E1 * E2,E3)
>> + kcalloc(E1,E2,E3)
>
> This misses the semantic distinction between the first and second
> arguments of kcalloc(). The first argument is supposed to be the
> number of elements to allocate and the second their size. As a
> consequence, the following hunks in your pathc are wrong:

Yes you are right. Andrew Morton fixed the problem in a
subsequent patch.

I should have written a more precise semantic patch such as

@@
expression E;
constant c;
type T;
@@

- kzalloc(sizeof(T) * c, E)
+ kcalloc(c, sizeof(T), E)


Note that sometimes the code is written as  kzalloc(c * sizeof(T), E)
as in   kzalloc(2 * sizeof(struct resource), GFP_KERNEL)  but
our transformation engine can handle the commutativity of '*' and still
performs the right transformation.


>
>> diff --git a/arch/arm/mach-iop13xx/pci.c b/arch/arm/mach-iop13xx/ 
>> pci.c
>> index 9d63d7f..b84955f 100644
>> --- a/arch/arm/mach-iop13xx/pci.c
>> +++ b/arch/arm/mach-iop13xx/pci.c
>> @@ -1002,11 +1002,10 @@ int iop13xx_pci_setup(int nr, struct pci
>>  	if (nr > 1)
>>  		return 0;
>>
>> -	res = kmalloc(sizeof(struct resource) * 2, GFP_KERNEL);
>> +	res = kcalloc(sizeof(struct resource), 2, GFP_KERNEL);
>>  	if (!res)
>>  		panic("PCI: unable to alloc resources");
>>
>> -	memset(res, 0, sizeof(struct resource) * 2);
>>
>>  	/* 'nr' assumptions:
>>  	 * ATUX is always 0
>


