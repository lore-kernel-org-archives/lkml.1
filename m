Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbZGUNUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbZGUNUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 09:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbZGUNUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 09:20:07 -0400
Received: from fn.samba.org ([216.83.154.106]:41715 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754373AbZGUNT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 09:19:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19045.49265.255525.260784@samba.org>
Date: Tue, 21 Jul 2009 23:19:45 +1000
To: Pavel Machek <pavel@ucw.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>, Theodore Tso <tytso@mit.edu>,
       Rusty Russell <rusty@rustcorp.com.au>, john.lanza@linux.com,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, torvalds@linux-foundation.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
In-Reply-To: <20090721103100.GF4133@elf.ucw.cz>
References: <200907072356.51553.Martin@lichtvoll.de>
	<19028.3736.892828.352905@samba.org>
	<20090708110451.1092afa7@lxorguk.ukuu.org.uk>
	<1247066878.4159.153.camel@mulgrave.site>
	<20090708163736.0f98e7e0@lxorguk.ukuu.org.uk>
	<1247069202.4159.212.camel@mulgrave.site>
	<20090708171848.21633768@lxorguk.ukuu.org.uk>
	<873a96a23x.fsf@devron.myhome.or.jp>
	<87hbxhwv0j.fsf@devron.myhome.or.jp>
	<19045.14307.658887.752950@samba.org>
	<20090721103100.GF4133@elf.ucw.cz>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

 > >   - Similarly, there is a small chance that chkdsk on Windows will
 > >     rename one file in a directory if they happen to have the same 11
 > >     byte dummy values. The probability of this happening is
 > >     approximately 80x lower than with the previous patch.
 > 
 > The "small chance" seems to be 90% for 30000 files in directory. And
 > no, it is probably not 80x lower. Do the math.

Perhaps you could double check my math? 

The number of combinations available with the current patch is 
35^6 * 7 * 8 for files (for directories there are more combinations, 
but lets ignore that for now).

That comes to 102942875000 combinations.

Now we can do the exponential birthday approximation, which is:

  p = 1.0 - exp(-(n * (n-1)) / (2 * m))

where n is the number of entries in the directory, and m is the total
number of combinations.

That comes to about 0.0052 for 32767 files in a directory
(ie. maximully full), or about 0.5%.

With the previous patch we had 2^30 combinations, which came to 0.393,
or about 39%. So the new patch has about 75x lower chance of a single
collision than the old one.

Similarly for 100 files, the old patch gave a probability of
4.6*10^-6, whereas the new one gives 4.8x10^-8, which is about 96x
lower chance of a single collision. 

My '80x' was very rough of course, but its close enough to be a
reasonable rule of thumb I think. What matters here is orders of
magnitude, not precise numbers.

The chance of an actual bluescreen is much lower again, as a
bluescreen happens when two files that have the same 8.3 entry are
accessed in quick succession. Paul did some modelling of that, which
is where the numbers I gave in my last email came from.

I do agree that it would be much better if the chance was zero, but I
also think that the chances of a problem due to a collision are not
really very high, and it may well be lost in the noise of the (rather
common) bluescreens of the fastfat driver on WinXP.

Please do check my maths though. I'll be extremely surprised if you
get anything like 90% as I have run it for days with randomised
testing, and even with the lower chances of the last patch I couldn't
make it happen. I could make it happen by greatly reducing the amount
of randomness in the patch, which is why I know it can happen, but the
probability drops off pretty rapidly with more bits.

Still, my combinatorics is a little rusty, so please correct me if I
have made a mistake.

Cheers, Tridge
