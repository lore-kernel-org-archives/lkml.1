Return-Path: <linux-kernel-owner+w=401wt.eu-S1755114AbZEQTb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbZEQTb7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 15:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbZEQTbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 15:31:46 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:54709 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbZEQTbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 15:31:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=lN8Le9BbQAXXPDUqTKFIWq9nqnRX4WcyrlAm4sCVsdaUybINELZSMLg08UFf60tcRU
         qPocxL/oBLJMhJR/aQiWjFSQFfhegSIVWnAc7HTCSfqx4qK/nrlsc/voSahp+em8pMqx
         2zdlQZWMaRg72ZrDMPgWUIAGa8B3yLY4RP5h0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: PATA DMA problem leading to kernel panic on reading movie DVDs
Date: Sun, 17 May 2009 21:35:09 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-00442-ga3668b0; KDE/4.2.2; i686; ; )
Cc: Martin Lottermoser <Martin.Lottermoser@t-online.de>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20090517091224.GA8280@wanza.invalid> <4A10509C.603@gmail.com>
In-Reply-To: <4A10509C.603@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905172135.10136.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 17 May 2009 19:59:56 Robert Hancock wrote:
> Martin Lottermoser wrote:
> > Hello,
> > 
> > newer versions of the Linux kernel overestimate my DVD drive's
> > DMA capabilities, leading either to DMA being disabled or a kernel
> > panic.
> > 
> > My setup is:
> > 
> >   Motherboard: ASUS P4C800-E Deluxe
> >     South bridge: ICH5R
> >       IDE Interface Controller (PATA): Intel 82801EB/ER (PCI: 8086:24db)
> >   DVD drive: Samsung SH-S202N, attached as hdc.
> >     There is also an older CD writer (Lite-On LTR-52327S) attached as
> >     hdd.
> >   Operating system: Debian 5.0.0 with security updates
> > 
> > On upgrading from Debian 4.0 (Linux 2.6.18) to 5.0 (Linux 2.6.26) I
> > found that trying to play movie DVDs with vlc (VideoLAN media player)
> > led to DMA being disabled:
> > 
> >   hdc: cdrom_decode_status: status=0x51 { DriveReady SeekComplete Error }
> >   hdc: cdrom_decode_status: error=0x40 { LastFailedSense=0x04 }
> >   ide: failed opcode was: unknown
> >   <4 more identical groups of these messages>
> >   hdc: DMA disabled
> >   hdc: ide_intr: huh? expected NULL handler on exit
> >   hdc: ATAPI reset complete
> 
> Looks like kind of a comedy of errors. It failed to indicate what the 
> failed command was (though, it seems like the failed opcode is always 
> unknown with the IDE drivers), disabled DMA incorrectly, then seemingly 
> confused itself.
> 
> Seems like the IDE layer grew some regressions at some point. You could 
> try a newer (2.6.29) kernel. However, from a user perspective, quite 
               ^^^^^^

> likely you'll be happier ditching the IDE drivers and using libata 
> instead, it tends to be better tested these days..

Robert, recommending alternatives is of course fine, same cannot be said
about not reading the whole bug-report before making final conclusions...

> > 
> > The resulting configuration is too slow to play movies. I booted the
> > older kernel and everything was fine.
> > 
> > I then tested various versions of the Linux kernel where I happened to
> > have the original sources. The most interesting results were:
> > 
> >   2.6.22.9      works, no errors visible in syslog
> >   2.6.23.14     works, but syslog shows an error (see below)
> >   2.6.24.3	DMA disabled
> >   2.6.29.3	Kernel panic: Fatal exception in interrupt (ide_intr)
      ^^^^^^^^

> >                 on trying to open the DVD with vlc
> > 
> > The error message with 2.6.23.14 was:
> > 
> >   hdc: drive_cmd: status=0x51 { DriveReady SeekComplete Error }
> >   hdc: drive_cmd: error=0x04 { AbortedCommand }
> >   ide: failed opcode was: 0xec

This is more-or-less innocent -- some user-space utility wrongly uses
ATA IDENTIFY command on ATAPI devices and it gets logged as an error...

> > This kernel as well as 2.6.22.9 also showed the following on booting:
> > 
> >   hdc: host side 80-wire cable detection failed, limiting max speed to UDMA33
> > 
> > This is correct: the drive is only capable of Ultra DMA mode 2 33.3 MB/s
> > (see manufacturer's documentation) and is attached with a standard 40-wire
> > ATA cable (black connectors for master and slave).

Martin, this is one of ATAPI drives which support UDMA66 but have broken
cable detection.  Since 2.6.26 we have a special quirk for it ide (commit
3ced5c49bd2d1f2c7f769e3a54385883de63a652) and subsequent one in libata
(commit e9f3340673c1da32041f2a282b166c72cd78632e).

In your system's case the cable detection doesn't seem to work properly
which in turn results in all kind of later problems.

It could be that the quirk itself needs to be revised (I wonder if it was
originally tested with 40-wires cable) or maybe we need some other cable
detection fix...

Please:

* send 'hdparm --Istdout /dev/hdc' output

* try 2.6.30-rc6 (maybe 2.6.29.3 oops has been fixed already and we just
  need to backport it)

also connecting the drive using 80-wires cable and getting another hdparm
output (+ seeing if it helps the other problems) would be very useful.

PS guys, please remember to cc: linux-ide.

Thanks.
Bart
