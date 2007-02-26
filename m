Return-Path: <linux-kernel-owner+w=401wt.eu-S1161386AbXBZXHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161386AbXBZXHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 18:07:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161392AbXBZXHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 18:07:05 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:28949 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161349AbXBZXHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 18:07:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=B8sbcLbwZPXj8VrkvZkvRSDQAq4m+INQfWUoGzmEbD4xinjt6N0owXeLFRX4ajT6zASoXYU4MDuF9A0an0qMEEHf6qE3mxtEB9rvoWG5I/VF9YYOfuSrCiLqlRvQ+z65ciKTZPspSirhRAo6x4Z+5NN0g+rhJ1SOzB7mzk2FuHs=
Subject: Re: 2.6.21-rc1: framebuffer/console boot failure
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Andrew Nelless <andrew@nelless.net>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <36488.86.7.220.119.1172515738.squirrel@wmbeta.mxes.net>
References: <35472.86.7.220.119.1172237750.squirrel@wmbeta.mxes.net>
	 <20070224030950.074f88d4.akpm@linux-foundation.org>
	 <33525.86.7.220.119.1172358010.squirrel@wmbeta.mxes.net>
	 <1172359843.4415.8.camel@daplas>
	 <34578.86.7.220.119.1172401665.squirrel@wmbeta.mxes.net>
	 <1172493697.20842.6.camel@daplas>
	 <36488.86.7.220.119.1172515738.squirrel@wmbeta.mxes.net>
Content-Type: text/plain
Date: Tue, 27 Feb 2007 07:09:19 +0800
Message-Id: <1172531359.7101.22.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-26 at 18:48 +0000, Andrew Nelless wrote:
> On Mon, February 26, 2007 12:41 pm, Antonino A. Daplas wrote:
> >
> > I don't know, probably the ACPI code can now probably detect the
> > presence or absence of the HPET timer.
> >
> > Can you remove CONFIG_FB_VESA support from your kernel config but boot
> > as if you have vesafb (ie with vga=<VESA mode number>). Your machine may boot to completion but
> > you will have a blank screen.  But you should be able to have an output in netconsole and you
> > can start X. I wanted to know if the lockup is related to the framebuffer.
> >
> > Tony
> >
> >
> 
> I disabled CONFIG_FB_VESA but it is still happening because
> intermittent boots don't pump out anything over NetConsole.
> 

Okay, which rules out console code.  The vga= parameter is processed at
the very start, specifically in arch/x86_64/boot/video.S. This is
probably not mixing very well with the rest of the code.

> It's tempting to think this is a hardware issue but I've been
> booting 2.6.20 daily since -rc3 and this hasn't happened before
> and still doesn't. I've even installed Asus's latest "beta bios"
> (which convenient doesn't come with a changelog) but it had
> no effect.

If your machine was broken right from the beginning, I would say that
this is also a hardware issue, but, no, it's a regression.

> 
> The only thing I can think to do now is another git bisect.
> Now I know this occurs on average about every third boot I
> could do half a dozen reboots between bisections and hopefully
> find out what caused the problem..
> 
> Unfortunately I won't have the time for such a time consuming
> adventure much the weekend..
> 
> Any further ideas?
> 
>  -- Andrew
> 
> P.S. You mentioned HPET, is this HPET config normal?
> andrew@ziggy ~ $ fgrep -i hpet /usr/src/linux-2.6.21-rc1/.config
> CONFIG_HPET_TIMER=y
> CONFIG_HPET_EMULATE_RTC=y
> # CONFIG_HPET is not set

Not sure if the timer override workaround for nvidia chipsets is the
culprit, but if you want, you can choose to revert that to the previous
behavior (which is ignoring ACPI timer override). Open
arch/x86_64/kernel/earlyquirk.c:nvidia_bugs() and change this line:

	if (acpi_table_parse(ACPI_SIG_HPET, nvidia_hpet_check))
		return;
into this:
	
	acpi_table_parse(ACPI_SIG_HPET, nvidia_hpet_check);
		/* return; */

Tony

