Return-Path: <linux-kernel-owner+w=401wt.eu-S1752935AbZKLLyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbZKLLyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 06:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbZKLLyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 06:54:19 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:45190 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbZKLLyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 06:54:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=JpPc0SPj3+vXAruaxOGkowkoHVmyv2dDkUa/cX/9DrolJFSqTXev/QhLVsvPGTdUMG
         IlkESnPy+xxoczRsQTYBf/PB/959+NW720DTUUYlt7kieoVbsfzYrpUUFUllT7Z/2mOb
         9NlFhVD//r7WRZTPb4yA3mQKpbRilWbWHZgsc=
MIME-Version: 1.0
In-Reply-To: <20091112113343.GA1386@elte.hu>
References: <1257192496.5941.8.camel@dimm>
	 <20091105153742.GA18592@alberich.amd.com>
	 <b647ffbd0911051040r3987f63es1279c87bf349bcf6@mail.gmail.com>
	 <20091106123403.GB18592@alberich.amd.com>
	 <b647ffbd0911060456x5c37ebfapdb2ece392428f66@mail.gmail.com>
	 <20091106194626.GC18592@alberich.amd.com>
	 <b647ffbd0911070422g154c63bbo2fec62ba63c3c106@mail.gmail.com>
	 <b647ffbd0911110807n17933102g39c124a6eff74a44@mail.gmail.com>
	 <20091111193832.GG18592@alberich.amd.com>
	 <20091112113343.GA1386@elte.hu>
Date: Thu, 12 Nov 2009 12:54:22 +0100
Message-ID: <b647ffbd0911120354s755e2dc0g6f07ef03ae28bd86@mail.gmail.com>
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

2009/11/12 Ingo Molnar <mingo@elte.hu>:
>
> -tip testing found the following bug - there's a _long_ boot delay of
> 58.6 seconds if the CPU family is not supported:
>
> [    1.421761] calling  microcode_init+0x0/0x137 @ 1
> [    1.426532] platform microcode: firmware: requesting amd-ucode/microcode_amd.bin
> [   61.433126] microcode: failed to load file amd-ucode/microcode_amd.bin
> [   61.439682] microcode: CPU0: AMD CPU family 0xf not supported
> [   61.445441] microcode: CPU1: AMD CPU family 0xf not supported
> [   61.451273] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [   61.459116] initcall microcode_init+0x0/0x137 returned 0 after 58625622 usecs
>
> Where does this delay come from?

My guess is that it's comming from

static int loading_timeout = 60;        /* In seconds */

drivers/base/firmware_class.c

given that you seem to have MICROCODE build in kernel, so this patch
http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commit;h=d1c84f79a6ba992dc01e312c44a21496303874d6

will result in sending a request for a firmware image to user-space
(unless that firmware image is also built-in into the kernel) and
user-space has not started yet.

If so, copying the following block from microcode_cpu_init() into
init_microcode_amd() will help.

/* Trigger a delayed update? */
if (system_state != SYSTEM_RUNNING)
        return UCODE_NFOUND;


>
>        Ingo
>

-- Dmitry
