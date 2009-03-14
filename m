Return-Path: <linux-kernel-owner+w=401wt.eu-S1759620AbZCNCMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620AbZCNCMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 22:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZCNCM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 22:12:28 -0400
Received: from smtp03.mail.tnz.yahoo.co.jp ([203.216.246.66]:20808 "HELO
	smtp03.mail.tnz.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750777AbZCNCM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 22:12:28 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Mar 2009 22:12:27 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=yj20050223; d=yahoo.co.jp;
  h=Received:X-Apparently-From:Message-ID:From:To:Cc:References:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:X-MSMail-Priority:X-Mailer:X-MimeOLE;
  b=G9VCup2hpxPHRy+9LkCQuwGGpcrXOEORzDoel19ojkn7b3LgJcyHs6SJ2Qm9awC6WbbGtlyFRd+6TuSTLDHQjEM2KxOvXxEnI4xsk6NmnmjRN9fNbJMutN/spfuCaVqx  ;
X-Apparently-From: <n0diamond@yahoo.co.jp>
Message-ID: <A88EBC06918A4B0789B55D31ECDAF1BB@DIAMOND8600>
From: "Norman Diamond" <n0diamond@yahoo.co.jp>
To: "Robert Hancock" <hancockrwd@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
       "Jim Paris" <jim@jtan.com>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Sergei Shtylyov" <sshtylyov@ru.mvista.com>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Mark Lord" <liml@rtr.ca>
References: <20090313074120.48682.qmail@web4108.mail.ogk.yahoo.co.jp> <49BA7172.80908@gmail.com>
Subject: Re: Off-by-one in both LIBATA and IDE drivers
Date: Sat, 14 Mar 2009 11:05:36 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-2022-jp";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Norman Diamond wrote:
>>
>> LIBATA with the patch to ata.h now handles all sectors on
>> hard drives that it recognizes.
>>
>> An example of a hard drive that it recognizes is one that
>> is attached to an Intel ICH7M chipset when hda=noprobe
>> hdc=noprobe have been specified in the boot command.
>>
>> An example of a hard drive that it doesn't recognize is
>> one that is attached to an Intel PIIX4 chipset when
>> hda=noprobe hdc=noprobe have been specified in the boot
>> command.
>>
>> In either case, the boot parameters persuade the old IDE
>> drivers not to grab the controllers.
>>
>> With ICH7M, LIBATA takes over and runs both the hard drive
>> and DVD at full speed.
>>
>> With PIIX4, LIBATA initializes.  End of story.  Slax can't
>> find its own CD.  If I only use hda=noprobe then the old
>> IDE controller assigns hdc to the CD and Slax finds it,
>> but the hard drive is still undetected.  Behaviour is the
>> same under VMware as in a genuine old PC.
>>
>> LIBATA's PIIX drivers are built in along with everything
>> else.  They just seem not to get executed.
>>
>> What am I missing?
>
> I assume that ATA_PIIX is set in the configuration.. The lspci -vn and
> dmesg output from when it fails to detect would be useful.

Yes, and built in (not even as a module).

Sorry I'm away from the machine, but even near the machine it's a pain to
copy text exactly because it's running under Slax (live CD) with no network
shares.  Even when quoting a dump from the TASKFILE breakage in a later
kernel I had to read and type by hand.

I think the PIIX4 devices of VMware server are well known.  Besides vendor
8086 and device 7111, VMware's subsystem is coded into LIBATA's PIIX driver.

For the same PIIX4 devices on a real machine the subsystem is different but
they're still vendor 8086 and device 7111.

If I omit hda=noprobe hdb=noprobe hdc=noprobe hdd=noprobe then dmesg shows
the old IDE driver probing properly, assigning hda to the hard drive and hdc
to Slax's CD-ROM.  After that LIBATA 3.0 loads but has nothing to do.

If I include the four noprobes (or as another experiment, ide0=noprobe
ide1=noprobe hda=none hdb=none hdc=none hdd=none), dmesg shows something
recognizing that PIIX4 isn't completely native (as always), then the old IDE
drivers obediently ignoring those devices and reasonably proceeding to probe
and find nothing on ide2, ide3, ide4, and ide5.  After that LIBATA 3.0 loads
and still does nothing, even though we know what it should be doing.

In comparison, I did the same experiments again on Dell and Lenovo machines
whose BIOSes set ICH7M chipsets to present ATA interfaces, with no option to
present AHCI interfaces.  If I omit the noprobes then the old IDE drivers
take over, the hard drive and DVD drive run UDMA to the ICH7M chips, and the
old IDE drivers run PIO to the ICH7M's ATA interfaces on hda and hdc (with
no option to enable use_dma).  If I include the noprobes then the old IDE
drivers obediently refrain, and this them LIBATA 3.0 takes over as it
should.

As a workaround I recompiled Slax's kernel 2.6.24.3 and Slax's other stuff,
with the old IDE drivers changed to modules instead of built in, and LIBATA
built in the same as before.  Now LIBATA 3.0 takes over as it should, both
for PIIX4 and ICH7M.  But I still worry that someone's going to have
chipsets from UMC or ALi or AMD or VIA or SIS or something, where the old
IDE drivers are necessary, and who knows if this is going to work.  I don't
have all the machines I need for testing.

On a different tangent, LIBATA's off-by-one error was present in 2.6.20.  I
booted that Slax with no modification on a machine with ICH7M, a Toshiba
250GB hard drive got /dev/sda with DMA, and the DVD drive got /dev/hdc and I
forgot to check if it got DMA.  Three dd commands should have all failed:
dd if=/dev/sda of=/dev/null bs=512 skip=268435455 count=1
dd if=/dev/sda of=/dev/null bs=512 skip=268435448 count=8
dd if=/dev/sda of=/dev/null bs=512 skip=268435440 count=16
Somehow the third one worked.  Two error messages and one silence, 100%
repro.  OK, I'm not the only one pulling hair out over this stuff.  I
noticed LIBATA's blacklists for broken firmware in various devices.

--------------------------------------
Power up the Internet with Yahoo! Toolbar.
http://pr.mail.yahoo.co.jp/toolbar/
