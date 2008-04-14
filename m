Return-Path: <linux-kernel-owner+w=401wt.eu-S1758014AbYDNGs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014AbYDNGs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 02:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754503AbYDNGsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 02:48:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:53295 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbYDNGsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 02:48:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexia Death <alexiadeath@gmail.com>
Subject: Re: Problem: non-SDHC 2GB SD cards are unreadable
Date: Mon, 14 Apr 2008 08:48:38 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200804132326.07713.alexiadeath@gmail.com> <200804140245.33171.arnd@arndb.de> <200804140749.57049.alexiadeath@gmail.com>
In-Reply-To: <200804140749.57049.alexiadeath@gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804140848.39226.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/m7cS08/S9189OY/458/artKbOGokO7JkxkCP
 2pjJrecWgFa75hYs74akCMhPukzK6WT4y/U7kfnszNZ/7dH35B
 kfzLxq1x8kEesLkJCbVCA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 April 2008, Alexia Death wrote:
> On Monday 14 April 2008 03:45:32 you wrote:
>
> > My guess is that the problem is the way that the card is presented
> > to the USB mass storage driver by the reader. 
> Yes, Ive come to a conclusion that because reader does not do anything about 
> the speciality of the 2GB cards they wont be readable because Linux usb 
> storage does not know about them either.
>
> > Generally, there is no problem with 2GB SD cards,
> It seems that in case of non-USB card readers, ie the ones built-in to laptops 
> the speciality is taken care of by the reader driver...

Did you find any code in there that made you think so? Generally, the mmc
layer doesn't do much about the layout of the cards but merely represents
what is there.

On the contrary, the USB card readers go through a lot of effort to
make the card look like a SCSI device, and many of these implementations
are buggy in some way. SD cards are defined to have 512 byte sectors, while
USB mass storage can theoretically have a different sector size. Of course
any other size than 512 bytes is likely to break some code, which you have
experienced.

Note that Linux has another driver for USB mass storage, the "ub" block
driver which does not go through the SCSI software layer. It would be good
if you could check whether that has the same problem. Also, it might be
interesting to see if another operating system has the same problem
with the combination of your card and reader.

If it works on another OS, it's probably fixable on Linux, but the
effort may be significant.

> > so it would be good if you can try a different card reader with your cards.
> I have no different reader to try but I did try connecting the camera. It 
> works.
> [1249166.105850] scsi 6:0:0:0: Direct-Access     PENTAX   DIGITAL_CAMERA   
> 1.20 PQ: 0 ANSI: 0
> [1249166.117440] sd 6:0:0:0: [sdb] 3985409 512-byte hardware sectors (2041 MB)
> [1249166.122416] sd 6:0:0:0: [sdb] Write Protect is off
> [1249166.122431] sd 6:0:0:0: [sdb] Mode Sense: 0a 0a 00 01
> [1249166.122438] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> [1249166.137400] sd 6:0:0:0: [sdb] 3985409 512-byte hardware sectors (2041 MB)
> [1249166.142390] sd 6:0:0:0: [sdb] Write Protect is off
> [1249166.142406] sd 6:0:0:0: [sdb] Mode Sense: 0a 0a 00 01
> [1249166.142412] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> [1249166.142430]  sdb: sdb1
> [1249166.176608] sd 6:0:0:0: [sdb] Attached SCSI removable disk
> [1249166.176735] sd 6:0:0:0: Attached scsi generic sg2 type 0
> 
> As you can see the camera rewrites the hw sectors description and presents it 
> quite differently than the card presents itself. Strangely enough my 
> cardreader/photobank itself has no problem copying from these cards but still 
> presents the cards to the pc "as is".

The camera is just another implementation of a USB mass storage device on
top of an SD card. My guess remains that this one works correctly, while
your standalone reader has a quirk that prevents it from being used on Linux.

	Arnd <><
