Return-Path: <linux-kernel-owner+w=401wt.eu-S1758960AbYFOOea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758960AbYFOOea (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 10:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757626AbYFOOeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 10:34:18 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33600 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758641AbYFOOeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 10:34:03 -0400
Subject: Re: [regression] CD-DA delay needed after insertion
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-scsi@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
In-Reply-To: <48550F0C.8030907@panasas.com>
References: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be>
	 <48550F0C.8030907@panasas.com>
Content-Type: text/plain; charset=utf8
Date: Sun, 15 Jun 2008 09:33:56 -0500
Message-Id: <1213540437.3517.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-06-15 at 15:46 +0300, Boaz Harrosh wrote:
> Geert Uytterhoeven wrote:
> > We've found another regression in 2.6.25 w.r.t. CD media change on PS3.
> > 
> > It can easily be reproduced by:
> > 
> >   1. Inserting an audio CD
> >   2. Running the following command as soon as the blue CD/DVD/BD drive LED
> >      stops blinking and is lit continuously:
> >       
> > 	 cdparanoia -Z -q 1-1[:1] /dev/null || echo failed
> > 
> > On 2.6.25 (and current mainline), you have to wait ca. 10 seconds after
> > insertion, or it will fail.
> > On 2.6.24 and older, it just works immediately.
> > 
> > It does not matter whether
> > http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fjejb%2Fscsi-rc-fixes-2.6.git;a=commitdiff_plain;h=d1daeabf0da5bfa1943272ce508e2ba785730bf0
> > is applied or not.
> > 
> > We haven't bisected it yet.
> > 
> > With kind regards,
> > 
> > Geert Uytterhoeven
> > Software Architect
> > 
> > Sony Techsoft Centre
> > The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
> > 
> > Phone:    +32 (0)2 700 8453
> > Fax:      +32 (0)2 700 8622
> > E-mail:   Geert.Uytterhoeven@sonycom.com
> > Internet: http://www.sony-europe.com/
> > 
> > Sony Technology and Software Centre Europe
> > A division of Sony Service Centre (Europe) N.V.
> > Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium
> > VAT BE 0413.825.160 · RPR Brussels
> > Fortis 293-0376800-10 GEBA-BE-BB
> 
> James hi.
> 
> It looks like the same problem as before. Any BLOCK_PC command will 
> eat the UNIT_ATTENTION notification. Which is what I was afraid of. 
> I was thinking of something like below.

It's a bit unlikely to be the cause of a regression, since the code has
behaved this way by design since at least 2.4.  The problem we're
looking for appeared in 2.6.25+

Also, the taxonomy of the regression: errors returned within 10s of
inserting the CD sounds very much like an ignored NOT_READY.

> Totally untested, never even booted. It is just to demonstrate the concept.
> Please tell me if it is at all desirable and I'll spend some time to see
> if it runs, and test it.

Really, no ... not until there's a proveable problem caused by it.  Even
then, not like this: the way you've coded it interferes with the cc_ua
processing code.  It would have to go in scsi_decide_disposition().

James


