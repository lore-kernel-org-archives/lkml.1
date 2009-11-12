Return-Path: <linux-kernel-owner+w=401wt.eu-S1752909AbZKLMGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbZKLMGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 07:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbZKLMGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 07:06:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:54784 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbZKLMGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 07:06:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GbJcAh7YbtFVKSduM/RUGGYScHdjddbiMpK8AMzlcpXQh9WuVr4ZVhAgueLUViViQo
         AMC2M4bKSUSYQlUZ7yOcKCrwIMVxmN/8TCqVJFXHh23QXnik+jQubU2v6aQTpMzU1ves
         p5FyY+Qclvq7W8R/B/coI6sTFmpAFqpBeeim4=
MIME-Version: 1.0
In-Reply-To: <b647ffbd0911120354s755e2dc0g6f07ef03ae28bd86@mail.gmail.com>
References: <1257192496.5941.8.camel@dimm>
	 <b647ffbd0911051040r3987f63es1279c87bf349bcf6@mail.gmail.com>
	 <20091106123403.GB18592@alberich.amd.com>
	 <b647ffbd0911060456x5c37ebfapdb2ece392428f66@mail.gmail.com>
	 <20091106194626.GC18592@alberich.amd.com>
	 <b647ffbd0911070422g154c63bbo2fec62ba63c3c106@mail.gmail.com>
	 <b647ffbd0911110807n17933102g39c124a6eff74a44@mail.gmail.com>
	 <20091111193832.GG18592@alberich.amd.com>
	 <20091112113343.GA1386@elte.hu>
	 <b647ffbd0911120354s755e2dc0g6f07ef03ae28bd86@mail.gmail.com>
Date: Thu, 12 Nov 2009 13:06:36 +0100
Message-ID: <b647ffbd0911120406o6e5bd58eq8aa022946f38f5ef@mail.gmail.com>
Subject: Re: [ RFC, PATCH - 1/2, v2 ] x86-microcode: refactor microcode output 
	messages
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andreas Herrmann <herrmann.der.user@googlemail.com>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Mike Travis <travis@sgi.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Borislav Petkov <borislav.petkov@amd.com>, Andreas Mohr <andi@lisas.de>,
       Jack Steiner <steiner@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/12 Dmitry Adamushko <dmitry.adamushko@gmail.com>:
> 2009/11/12 Ingo Molnar <mingo@elte.hu>:
>>
>> -tip testing found the following bug - there's a _long_ boot delay of
>> 58.6 seconds if the CPU family is not supported:
>>
>> [    1.421761] calling  microcode_init+0x0/0x137 @ 1
>> [    1.426532] platform microcode: firmware: requesting amd-ucode/microcode_amd.bin
>> [   61.433126] microcode: failed to load file amd-ucode/microcode_amd.bin
>> [   61.439682] microcode: CPU0: AMD CPU family 0xf not supported
>> [   61.445441] microcode: CPU1: AMD CPU family 0xf not supported
>> [   61.451273] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
>> [   61.459116] initcall microcode_init+0x0/0x137 returned 0 after 58625622 usecs
>>
>> Where does this delay come from?
>
> My guess is that it's comming from
>
> static int loading_timeout = 60;        /* In seconds */
>
> drivers/base/firmware_class.c
>
> given that you seem to have MICROCODE build in kernel, so this patch
> http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commit;h=d1c84f79a6ba992dc01e312c44a21496303874d6
>
> will result in sending a request for a firmware image to user-space
> (unless that firmware image is also built-in into the kernel) and
> user-space has not started yet.

btw., it doesn't make sense for request_firmware() to even try this if
the system_state != SYSTEM_RUNNING and current == 'init' (it'd perhaps
make some sense if it's been done in a context of another task -- like
in case of a parallel boot).

And perhaps it just makes sense for microcode to use request_firmware_nowait().


-- Dmitry
