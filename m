Return-Path: <linux-kernel-owner+w=401wt.eu-S1757957AbZGGAbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbZGGAbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 20:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758263AbZGGAVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 20:21:23 -0400
Received: from mail.samba.org ([66.70.73.150]:53470 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759413AbZGGAVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 20:21:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19026.38137.63807.427511@samba.org>
Date: Tue, 7 Jul 2009 10:21:13 +1000
To: Jan Engelhardt <jengelh@medozas.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Theodore Tso <tytso@mit.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, James.Bottomley@hansenpartnership.com
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
In-Reply-To: <alpine.LSU.2.00.0907062221520.27775@fbirervta.pbzchgretzou.qr>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<200907012019.53932.rusty@rustcorp.com.au>
	<20090701122558.3a7c80d3@lxorguk.ukuu.org.uk>
	<20090701140503.GA21185@mit.edu>
	<alpine.LSU.2.00.0907030056210.17183@fbirervta.pbzchgretzou.qr>
	<alpine.LSU.2.00.0907030134291.17183@fbirervta.pbzchgretzou.qr>
	<19021.19842.663727.146474@samba.org>
	<87hbxu60qm.fsf@devron.myhome.or.jp>
	<19021.23231.213863.726785@samba.org>
	<alpine.LSU.2.00.0907030347210.24650@fbirervta.pbzchgretzou.qr>
	<19021.26102.80885.330380@samba.org>
	<alpine.LSU.2.00.0907030403330.26905@fbirervta.pbzchgretzou.qr>
	<19021.31291.642416.956966@samba.org>
	<alpine.LSU.2.00.0907031121250.16093@fbirervta.pbzchgretzou.qr>
	<19021.63615.450348.192109@samba.org>
	<alpine.LSU.2.00.0907061337550.9199@fbirervta.pbzchgretzou.qr>
	<19025.63119.656216.431469@samba.org>
	<alpine.LSU.2.00.0907061932120.20434@fbirervta.pbzchgretzou.qr>
	<alpine.LSU.2.00.0907062221520.27775@fbirervta.pbzchgretzou.qr>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

 > Windows 98 can't make anything of the stunted vfat entries either[3],
 > and there's blanks for 16-bit programs[4]. They too, it seems, always
 > want an 8.3 entry in any case.
 > It does not crash, but neither of these results is usable.

Interesting! Thanks for the testing.

I didn't have a win98 test image, but I've scrounged up a copy of the
install disks now from an old MSDN subscription, and I've built a
win98 virtual machine. I stopped testing Win9X against Samba a long
time ago (along with OS/2) so I didn't have the right setup to hand.

I've now done some experiments, and I have reproduced the problem you
saw. I've also experimented with changing the
vfat_build_dummy_83_buffer() to try some other combinations. I've
found that with a simple memset(msdos_name, ' ', 11) that Win98 works
pretty well:

  http://picpaste.com/Win98-longnames.png

It does show one error though. In the DOS box directory listing on the
left notice that it shows both a long name and a short name for the
files, with the long name being a truncated form of the short
name. The normal commands like xcopy, notepad etc all seem to work
fine though, so practical compatibility seems pretty good.

The problem with that simple memset() approach with spaces is that it
would cause more crashes with WinXP. It does show that there might be
some other combination that works with both though. I'll play a bit
more and see what I can find.

 > This dualnames patch just won't fly in practice.

well, "won't fly" depends on your POV I guess. Unless we're hoping
that all the Microsoft lawyers take early retirement, I think we do
need to have some strategy to avoiding more companies having the same
problems that TomTom had. 

Would it be worth it to lose VFAT compatibility with a dead OS like
Win9X?  Quite possibly it would be for a pretty large number of
vendors.

What we need to explore now is the limits of compatibility that we can
reach. Your testing has really helped with that! I'm trying to track
down a Tekmax or 'IOneIt' mp3 player but no luck on eBay yet - I don't
suppose anyone on this list will sell me one? Are they sold in Germany
somewhere Jan?

Cheers, Tridge
