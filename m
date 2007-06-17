Return-Path: <linux-kernel-owner+w=401wt.eu-S1759204AbXFQU4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204AbXFQU4O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 16:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbXFQU4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 16:56:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:33398 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbXFQUz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 16:55:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sx5kbMgVJMUdeYsh7Xkz9XOkryuvCm3j7JhVwbjwHbz4lE1UQZwF9fejv1cq1P1EnTn6HeFB2AIkZ56tu36Jw93Fv9qJDk8unwirv7VfvnjV2kkrAPDcXHlf1HH5U9FPxjunleWbz61hxQt1NhCjQqiGA7XHVncEnZl8y7mcz4g=
Message-ID: <dfd4051f0706171355i7bc3d4b7qe9aee2acb904c8c@mail.gmail.com>
Date: Sun, 17 Jun 2007 15:55:57 -0500
From: "Matt Mullins" <mokomull@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Problems with hda_intel, Santa Rosa, and suspend
Cc: linux-kernel@vger.kernel.org, "Jaroslav Kysela" <perex@suse.cz>,
       "Takashi Iwai" <tiwai@suse.de>,
       alsa-devel <alsa-devel@lists.sourceforge.net>
In-Reply-To: <200706171149.27547.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dfd4051f0706161836xa191176ke10deff2868ad8d6@mail.gmail.com>
	 <200706171149.27547.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've been reading up on the Intel HD Audio specifications, and I found
that the problem is most likely that the driver has to resort to PI/O
(single_cmd) mode.  I really haven't had enough time or experience to
figure out what is actually causing this.  This is the first time I've
done any kernel development; thankfully, Intel has good documentation.
 I'm going to keep hacking to see what information I can figure out.

I just tried 2.6.22-rc5, and no behavior has changed.
----
Matt Mullins

On 6/17/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday, 17 June 2007 03:36, Matt Mullins wrote:
> > I just received a Dell Latitude D630, with the new Intel Santa Rosa
> > platform.  Currently, the only major driver issue I have is sound.  It
> > worked fine in Ubuntu Feisty's 2.6.20 kernel, but now I am using Gutsy
> > so I can have graphics drivers.  Gutsy's 2.6.22-rc3-based kernel no
> > longer recognized my soundcard, a Sigmatel STAC9205, which uses the
> > hda_intel driver.  I have since fixed that problem by compiling the
> > hda_intel driver into the kernel (I used 2.6.22-rc4 vanilla sources),
> > instead of a module, but it is still a bug that it does not work as a
> > module.
> >
> > All the following debug information was obtained from kernel 2.6.22-rc4.
> >
> > However, the bug that is currently affecting me is that sound no
> > longer works after using ACPI suspend-to-RAM or swsusp.  I compiled
> > ALSA debugging in, and as soon as I resume, I get tons of messages
> > like:
> > [    8.474830] hda-intel: send_cmd timeout: IRS=0x1, val=0xd0970500
> > [    8.474954] hda-intel: send_cmd timeout: IRS=0x1, val=0xd0af0009
> > [    8.475078] hda-intel: send_cmd timeout: IRS=0x1, val=0xd0a70500
> > [    8.475207] hda-intel: send_cmd timeout: IRS=0x1, val=0xd0bf0009
> > (etc)
> >
> > There may be more before that, but that is more than the kernel
> > message buffer can hold, so I can't ever see it.  I get similar
> > timeout messages each time a PCM gets set up:
> > [    8.972859] hda_codec_setup_stream: NID=0x10, stream=0x5, channel=0, format=0
> > x11
> > [    8.972987] hda-intel: send_cmd timeout: IRS=0x1, val=0x1070650
> > [    9.006071] hda-intel: send_cmd timeout: IRS=0x1, val=0x1020011
> > [    9.006081] hda_codec_setup_stream: NID=0x11, stream=0x5, channel=0, format=0
> > x11
> > [    9.006207] hda-intel: send_cmd timeout: IRS=0x1, val=0x1170650
> > [    9.016117] hda-intel: send_cmd timeout: IRS=0x1, val=0x1120011
> >
> > I read some of sound/pci/hda/hda_intel.c, specifically the code that
> > output those messages.  After octupling my kernel log buffer (to 1MB),
> > I noticed that for the first set of timeouts (immediately upon
> > resume), all the "codec" nibbles are odd, the last word of the val
> > ("verb" and "para") are all either 0x0500 or 0x0009.  For the second
> > set (when something tries to use the card) that last word is 0x0650 or
> > 0x0011.
> >
> > I have yet to go back and re-test compiling snd-hda-intel as a module.
>
> Well, the ALSA people should be notified of that in the first place (CCs
> added).
>
> Greetings,
> Rafael
>
>
> --
> "Premature optimization is the root of all evil." - Donald Knuth
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
