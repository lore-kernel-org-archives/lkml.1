Return-Path: <linux-kernel-owner+w=401wt.eu-S1758788AbXFQBhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788AbXFQBhA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 21:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbXFQBgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 21:36:52 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:15415 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbXFQBgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 21:36:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=KMeCkCp1sjHNwoTDDMP41DPSxKn5xqm90DdupMZjrHgFasYxnk9MuaTBUkjIWiWyBJQekM0/snVlSGVfGd+SsMdxQD6FsyIlq1aUNzc/COQDz0MOnQe8GjdOhkvIuz8vhe4Q9ZISZgZk4pUdXyJmFdTD8UBONZGXCHHdCIRO/2s=
Message-ID: <dfd4051f0706161836xa191176ke10deff2868ad8d6@mail.gmail.com>
Date: Sat, 16 Jun 2007 20:36:49 -0500
From: "Matt Mullins" <mokomull@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Problems with hda_intel, Santa Rosa, and suspend
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I just received a Dell Latitude D630, with the new Intel Santa Rosa
platform.  Currently, the only major driver issue I have is sound.  It
worked fine in Ubuntu Feisty's 2.6.20 kernel, but now I am using Gutsy
so I can have graphics drivers.  Gutsy's 2.6.22-rc3-based kernel no
longer recognized my soundcard, a Sigmatel STAC9205, which uses the
hda_intel driver.  I have since fixed that problem by compiling the
hda_intel driver into the kernel (I used 2.6.22-rc4 vanilla sources),
instead of a module, but it is still a bug that it does not work as a
module.

All the following debug information was obtained from kernel 2.6.22-rc4.

However, the bug that is currently affecting me is that sound no
longer works after using ACPI suspend-to-RAM or swsusp.  I compiled
ALSA debugging in, and as soon as I resume, I get tons of messages
like:
[    8.474830] hda-intel: send_cmd timeout: IRS=0x1, val=0xd0970500
[    8.474954] hda-intel: send_cmd timeout: IRS=0x1, val=0xd0af0009
[    8.475078] hda-intel: send_cmd timeout: IRS=0x1, val=0xd0a70500
[    8.475207] hda-intel: send_cmd timeout: IRS=0x1, val=0xd0bf0009
(etc)

There may be more before that, but that is more than the kernel
message buffer can hold, so I can't ever see it.  I get similar
timeout messages each time a PCM gets set up:
[    8.972859] hda_codec_setup_stream: NID=0x10, stream=0x5, channel=0, format=0
x11
[    8.972987] hda-intel: send_cmd timeout: IRS=0x1, val=0x1070650
[    9.006071] hda-intel: send_cmd timeout: IRS=0x1, val=0x1020011
[    9.006081] hda_codec_setup_stream: NID=0x11, stream=0x5, channel=0, format=0
x11
[    9.006207] hda-intel: send_cmd timeout: IRS=0x1, val=0x1170650
[    9.016117] hda-intel: send_cmd timeout: IRS=0x1, val=0x1120011

I read some of sound/pci/hda/hda_intel.c, specifically the code that
output those messages.  After octupling my kernel log buffer (to 1MB),
I noticed that for the first set of timeouts (immediately upon
resume), all the "codec" nibbles are odd, the last word of the val
("verb" and "para") are all either 0x0500 or 0x0009.  For the second
set (when something tries to use the card) that last word is 0x0650 or
0x0011.

I have yet to go back and re-test compiling snd-hda-intel as a module.

Thank you in advance,
Matt Mullins
