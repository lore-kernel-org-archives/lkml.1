Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbZFUKVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbZFUKVG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 06:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbZFUKU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 06:20:56 -0400
Received: from mail-fx0-f224.google.com ([209.85.220.224]:34472 "EHLO
	mail-fx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbZFUKUz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 06:20:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KnK/WHjmCkZtxAK7wzCByRQCjnFWCLDWdVvlwPGNO0j8a81/p8PH6GmFvkcA8NBde/
         7a/WLNcB4va2Pl/Q8SsdDVTSgHBZJePdXvf8FWc5VG2FU9ifqJocTBE9mdtAHya/lGyC
         clBD7DxXpEoRt+JHtOMzhbstLIhYb77ckQ7hY=
MIME-Version: 1.0
In-Reply-To: <200906210628.35553.elendil@planet.nl>
References: <20090620154824.72b5cd50@lappy.seanm.ca>
	 <200906202256.46073.elendil@planet.nl>
	 <20090620194250.5a3e826f@lappy.seanm.ca>
	 <200906210628.35553.elendil@planet.nl>
Date: Sun, 21 Jun 2009 13:20:56 +0300
X-Google-Sender-Auth: 520b277c1dac94f7
Message-ID: <84144f020906210320n2984807dw2d4b4fb38afd22cf@mail.gmail.com>
Subject: Re: Badness on the Warp
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Frans Pop <elendil@planet.nl>
Cc: Sean MacLennan <smaclennan@pikatech.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org,
       David Gibson <david@gibson.dropbear.id.au>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 21, 2009 at 7:28 AM, Frans Pop<elendil@planet.nl> wrote:
> On Sunday 21 June 2009, Sean MacLennan wrote:
>> I found the source of the badness. The backtrace is correct:
>>
>> uic_init_one
>
> So that's in arch/powerpc/sysdev/uic.c.
>
>> ___alloc_bootmem
>> ___alloc_bootmem_nopanic
>> alloc_arch_preferred_bootmem
>>
>> In alloc_arch_preferred_bootmem we have:
>>
>>       if (WARN_ON_ONCE(slab_is_available()))
>>               return kzalloc(size, GFP_NOWAIT);
>>
>> Since the slab is available (it had better be or the call will return
>> NULL), we get the badness message, then a successful return from
>> kzalloc.
>>
>> I believe the author wants something like:
>>
>>       if (slab_is_available())
>>               return kzalloc(size, GFP_NOWAIT);
>>       else
>>               WARN_ON_ONCE(1);
>
> Well, I myself have no idea. It could also indicate a bug in the uic code.
>
> But let's CC some people responsible for this code. Pekka recently added
> this WARN that triggers in your case; David and Paul look to be the
> people most involved in the uic code.
>
> Start of the thread is at http://lkml.org/lkml/2009/6/20/165.

The WARN_ON() is there to let us know that someone is doing a bootmem
allocation but the slab allocator is already up. So the proper fix
here is to use kmalloc() directly in the call-site that triggers this
WARN_ON. I'm cc'ing Ben as he has been taking care of the fall-out
from my patches on ppc.

                                  Pekka
