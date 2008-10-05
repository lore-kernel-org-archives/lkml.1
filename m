Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbYJETET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbYJETET (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 15:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755777AbYJETEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 15:04:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:62801 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553AbYJETEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 15:04:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=V1iCW+q0Gxjq4CoAvXR9RbTTs9HDvEE/E3lfwwf2mf/7+4oPyaIBV+5tp9BDnIvSRq
         /lE5dEA84cxtcBZB7w9EddsIA2FylJ3gCAsaVOrQx/sWjoqlXoz6bMA9NXRQnnViLHOs
         SzV6H6qUM0XvMKxMWjmq2mbxVjigy6lAwg+OM=
Message-ID: <19f34abd0810051204u241659b4j6a9ef2ab3616d3fc@mail.gmail.com>
Date: Sun, 5 Oct 2008 21:04:04 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -tip] kmemcheck: fix crash in PnP BIOS calls
Cc: "Ingo Molnar" <mingo@elte.hu>, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081005191555.5715da29@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081005172504.GB24825@localhost.localdomain>
	 <20081005191555.5715da29@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Oct 5, 2008 at 8:15 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> It turns out that BIOS calls are made with a different code segment. So
>> when kmemcheck tries to dereference the EIP/RIP (using the kernel data
>> segment register), we get the unhandled page fault.
>>
>> I think we can solve this by verifying (in the page fault handler) that
>> the faulting code is using the kernel CS.
>
> That isn't an entirely safe assumption and some services such as BIOS32
> are 32bit. Would it be better wrap BIOS calls with a kmemcheck wrapper
> which changes the way kmemcheck works/dumps stuff and also gives you a
> hook after BIOS calls to do stuff like corruption scans or change
> detection on kernel pages ?

Thanks for the heads-up.

I think BIOS32 in particular is safe. I was looking at for instance
check_pcibios() in arch/x86/pci/pcbios.c. It doesn't change any
segment registers, so it means that whatever the actual code address
is, we should be able to dereference it (i.e. inspect the BIOS code)
without taking additional page faults.

And this is really all we need; BIOS code running with the kernel
segments can even access kernel memory and kmemcheck will be able to
catch those reads/writes just fine. I'm not sure if the BIOS code can
change segments (it would need to switch LDT/GDTs, I think), and even
if it did, I find it unlikely that it would directly access kernel
memory using these new segment registers. Do you happen to know of any
such cases?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
