Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261AbZKLPUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbZKLPUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 10:20:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbZKLPUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 10:20:30 -0500
Received: from mail-qy0-f174.google.com ([209.85.221.174]:63967 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbZKLPUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 10:20:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XWHWZzMlv+UoPO0FJ0K9trN2OxlRWkUw0TCN5zcaw/gggFXBwS616Q6DmowcRm3bSy
         YAAQqx+L5Im0ng3B6BpjLuysWvl1BCl6wkXcMPbBA/Wr8xBCalK6FjwO6lwhEzn0/7Rc
         +IXIszGI5kKOXCkCBQErPfreUryAIIn2uSUi0=
Date: Thu, 12 Nov 2009 16:20:26 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Borislav Petkov <borislav.petkov@amd.com>, Andreas Mohr <andi@lisas.de>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [ RFC, PATCH - 1/2, v2 ] x86-microcode: refactor microcode
 output messages
Message-ID: <20091112152026.GI18592@alberich.amd.com>
References: <b647ffbd0911051040r3987f63es1279c87bf349bcf6@mail.gmail.com>
 <20091106123403.GB18592@alberich.amd.com>
 <b647ffbd0911060456x5c37ebfapdb2ece392428f66@mail.gmail.com>
 <20091106194626.GC18592@alberich.amd.com>
 <b647ffbd0911070422g154c63bbo2fec62ba63c3c106@mail.gmail.com>
 <b647ffbd0911110807n17933102g39c124a6eff74a44@mail.gmail.com>
 <20091111193832.GG18592@alberich.amd.com>
 <20091112113343.GA1386@elte.hu>
 <b647ffbd0911120354s755e2dc0g6f07ef03ae28bd86@mail.gmail.com>
 <b647ffbd0911120406o6e5bd58eq8aa022946f38f5ef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0911120406o6e5bd58eq8aa022946f38f5ef@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 01:06:36PM +0100, Dmitry Adamushko wrote:
> 2009/11/12 Dmitry Adamushko <dmitry.adamushko@gmail.com>:
> > 2009/11/12 Ingo Molnar <mingo@elte.hu>:
> >>
> >> -tip testing found the following bug - there's a _long_ boot delay of
> >> 58.6 seconds if the CPU family is not supported:
> >>
> >> [    1.421761] calling  microcode_init+0x0/0x137 @ 1
> >> [    1.426532] platform microcode: firmware: requesting amd-ucode/microcode_amd.bin
> >> [   61.433126] microcode: failed to load file amd-ucode/microcode_amd.bin
> >> [   61.439682] microcode: CPU0: AMD CPU family 0xf not supported
> >> [   61.445441] microcode: CPU1: AMD CPU family 0xf not supported
> >> [   61.451273] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> >> [   61.459116] initcall microcode_init+0x0/0x137 returned 0 after 58625622 usecs
> >>
> >> Where does this delay come from?
> >
> > My guess is that it's comming from
> >
> > static int loading_timeout = 60;        /* In seconds */
> >
> > drivers/base/firmware_class.c
> >
> > given that you seem to have MICROCODE build in kernel, so this patch
> > http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commit;h=d1c84f79a6ba992dc01e312c44a21496303874d6
> >
> > will result in sending a request for a firmware image to user-space
> > (unless that firmware image is also built-in into the kernel) and
> > user-space has not started yet.
> 
> btw., it doesn't make sense for request_firmware() to even try this if
> the system_state != SYSTEM_RUNNING and current == 'init' (it'd perhaps
> make some sense if it's been done in a context of another task -- like
> in case of a parallel boot).

> And perhaps it just makes sense for microcode to use request_firmware_nowait().

That would be asynchronous.

I think I should ensure that microcode_amd.c is compiled into
microcode.o if and only if its built as module. microcode_amd.c
supports only the firmware interface.

Thus I suggest to add below.

Regards,
Andreas

----
>From 99cd1e170a30ea81164fd13333a5e5bb9587e4e8 Mon Sep 17 00:00:00 2001
From: Andreas Herrmann <andreas.herrmann3@amd.com>
Date: Thu, 12 Nov 2009 16:08:38 +0100
Subject: [PATCH] x86, ucode-amd: Provide it only if microcode is compiled as module

microcode_amd.c supports only the firmware interface. Thus it depends
on the udev firmware helper. As we won't compile the micorode patches
into the kernel it also doesn't make sense to compile microcode_amd.c
into kernel.

This also ensures that loading an updated AMD microcode patch
container file is always possible via

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 17abcfa..0559ca3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -959,7 +959,7 @@ config MICROCODE_INTEL
 
 config MICROCODE_AMD
 	bool "AMD microcode patch loading support"
-	depends on MICROCODE
+	depends on MICROCODE=m
 	select FW_LOADER
 	---help---
 	  If you select this option, microcode patch loading support for AMD
-- 
1.6.5.2

