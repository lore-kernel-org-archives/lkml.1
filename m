Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbXHTLVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbXHTLVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 07:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757985AbXHTLVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 07:21:15 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:39233 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750908AbXHTLVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 07:21:14 -0400
Date: Mon, 20 Aug 2007 13:21:09 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: NeilBrown <neilb@suse.de>, Satyam Sharma <satyam@infradead.org>
cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>
Subject: Re: [PATCH 002 of 6] Introduce rq_for_each_segment replacing
 rq_for_each_bio
In-Reply-To: <alpine.LFD.0.999.0708182016000.29105@enigma.security.iitk.ac.in>
Message-ID: <Pine.LNX.4.62.0708201313260.6197@pademelon.sonytel.be>
References: <20070816211551.11839.patches@notabene> <1070816112100.12182@suse.de>
 <Pine.LNX.4.62.0708170910120.8381@pademelon.sonytel.be>
 <alpine.LFD.0.999.0708181953560.29105@enigma.security.iitk.ac.in>
 <Pine.LNX.4.64.0708181628350.5186@fbirervta.pbzchgretzou.qr>
 <alpine.LFD.0.999.0708182016000.29105@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-466926404-1187608869=:6197"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-466926404-1187608869=:6197
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sat, 18 Aug 2007, Satyam Sharma wrote:
> On Sat, 18 Aug 2007, Jan Engelhardt wrote:
> > On Aug 18 2007 20:07, Satyam Sharma wrote:
> > >On Fri, 17 Aug 2007, Geert Uytterhoeven wrote:
> > >> On Thu, 16 Aug 2007, NeilBrown wrote:
> > >> [...]
> > >> >  		dev_dbg(&dev->sbd.core,
> > >> >  			"%s:%u: bio %u: %u segs %u sectors from %lu\n",
> > >> > -			__func__, __LINE__, i, bio_segments(bio),
> > >> > -			bio_sectors(bio), sector);
> > >> > -		bio_for_each_segment(bvec, bio, j) {
> > >> > +			__func__, __LINE__, i, bio_segments(iter.bio),
> > >> > +			bio_sectors(iter.bio),
> > >> > +			(unsigned long)iter.bio->bi_sector);
> > >>                         ^^^^^^^^^^^^^^^
> > >> Superfluous cast: PS3 is 64-bit only, and casts are evil.
> > 
> > bi_sector is sector_t. The cast is ok, because printf will warn, and rightfully
> > so since sector_t may just change its shape underneath. It would not be so much
> > of a problem if printf() was not a varargs function, but it is, and hence,
> > passing an object bigger than the format specifier can make problems.
> 
> Oh yeah, that's why the _cast_ _is_ needed in the first place, by the way.
> I was mentioning why the cast itself should be (unsigned long long) otoh.

On 64-bit platforms, sector_t (which is either u64 or unsigned long, depending
on CONFIG_LBD) is unsigned long, so there's no need for a cast. Hence there's
no compiler warning to be silenced by adding the cast.

On the other hand, adding a cast may hide bugs:
  - cast to unsigned long: When reusing parts of this code for a new 32-bit
    driver, the sector_t will be silently truncated,
  - cast to unsigned long long: When sector_t is changed to an even larger
    type, it will be silently truncated as well.
Without the cast, these would cause compiler warnings.

BTW, the resulting code didn't even compile, because of 3 bugs:

| linux-2.6/drivers/block/ps3disk.c: In function ‘ps3disk_scatter_gather’:
| linux-2.6/drivers/block/ps3disk.c:115: error: ‘bio’ undeclared (first use in this function)
| linux-2.6/drivers/block/ps3disk.c:115: error: (Each undeclared identifier is reported only once
| linux-2.6/drivers/block/ps3disk.c:115: error: for each function it appears in.)
| linux-2.6/drivers/block/ps3disk.c:115: error: ‘j’ undeclared (first use in this function)
| linux-2.6/drivers/block/ps3disk.c:116: error: implicit declaration of function ‘bio_kunmap_bvec’
| make[3]: *** [drivers/block/ps3disk.o] Error 1

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-466926404-1187608869=:6197--
