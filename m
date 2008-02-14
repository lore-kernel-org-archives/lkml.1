Return-Path: <linux-kernel-owner+w=401wt.eu-S933099AbYBNMPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099AbYBNMPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 07:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759958AbYBNMPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 07:15:00 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:21214 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758041AbYBNMO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 07:14:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=qa3Ht2KLJ1FViLGEjSRn2FSu20WqplRnv2WLHXqLWLJ6h6oOuxJI8nOAuRcC31PljULBYx1zKlp7img586eqlYnOLnbdqHHReJIRjWk7VObJx6wonI6gdFAMa1QOkF2I7Kjhn3/VL0fnbv5Yp1USOeD4xjZpx9e0XBockELKeZI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: IDE cdrom problem with PLEXTOR DVDR PX-608AL
Date: Thu, 14 Feb 2008 13:24:06 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Hans-Peter Jansen <hpj@urpla.net>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <200802121026.17420.hpj@urpla.net> <200802140037.51450.hpj@urpla.net> <20080214062652.GE13446@gollum.tnic>
In-Reply-To: <20080214062652.GE13446@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802141324.06731.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2008, Borislav Petkov wrote:
> On Thu, Feb 14, 2008 at 12:37:50AM +0100, Hans-Peter Jansen wrote:
> 
> [Added Bart to CC]
> 
> > Am Dienstag, 12. Februar 2008 schrieb Borislav Petkov:
> > > On Tue, Feb 12, 2008 at 10:26:17AM +0100, Hans-Peter Jansen wrote:
> > > > Hi,
> > > >
> > > > I suffer from unreliable cdrom operations (failing DAE and burn
> > > > sessions) with the openSUSE 2.6.18.8-0.7-bigsmp kernel.
> > >
> > > 			^^^^
> > > Hi,
> > >
> > > can please you test this with a more recent kernel. Yours is almost
> > > ancient - from Sep. 2006.
> > 
> > Sure, sorry. Here we go:
> > 
> > Feb 14 00:18:18 kernel: hde: cdrom_pc_intr: The drive appears confused (ireason = 0x01).
> >  Trying to recover by ending request.
> > Feb 14 00:27:27 kernel: hdc: cdrom_pc_intr: The drive appears confused (ireason = 0x01). 
> >  Trying to recover by ending request.
> > 
> > ~> uname -a
> > Linux xrated 2.6.24.1-35-pae #1 SMP 2008/02/12 01:00:18 UTC i686 athlon i386 GNU/Linux
> 
> Actually the interrupt handler in ide-cd got rewritten and you're still using the
> old one (cdrom_pc_intr vs cdrom_newpc_intr). Those changes went into mainline before
> the 2.6.25-rc1 so we'll be able to test the new one only when you try out 2.6.25-rc1
> or wait until 2.6.25 is released in case you don't want to try hazardous materials
> such as an -rc kernel[*] :).
> 
> Bart?
> 
> *. As a matter of fact it runs quite smoothly on my machines.

2.6.25-rc1-git1 if you are using IDE.

however it may still have this problem

	if (ireason == 0) {
		write = 1;
		xferfunc = HWIF(drive)->atapi_output_bytes;
	} else if (ireason == 2 || (ireason == 1 &&
		   (blk_fs_request(rq) || blk_pc_request(rq)))) {

we problably need to call ide_cd_check_ireason() also for REQ_TYPE_ATA_PC
requests and remove (blk_fs_request(rq) || blk_pc_request(rq) here

		write = 0;
		xferfunc = HWIF(drive)->atapi_input_bytes;
	} else {
		printk(KERN_ERR "%s: %s: The drive "
				"appears confused (ireason = 0x%02x). "
				"Trying to recover by ending request.\n",
				drive->name, __FUNCTION__, ireason);
		goto end_request;
	}

Bart
