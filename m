Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbZGUDhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbZGUDhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 23:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754803AbZGUDhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 23:37:19 -0400
Received: from fn.samba.org ([216.83.154.106]:51845 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754800AbZGUDhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 23:37:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19045.14307.658887.752950@samba.org>
Date: Tue, 21 Jul 2009 13:37:07 +1000
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>, Theodore Tso <tytso@mit.edu>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, torvalds@linux-foundation.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
In-Reply-To: <87hbxhwv0j.fsf@devron.myhome.or.jp>
References: <19013.8005.541836.436991@samba.org>
	<alpine.LSU.2.00.0907062221520.27775@fbirervta.pbzchgretzou.qr>
	<19026.38137.63807.427511@samba.org>
	<200907072356.51553.Martin@lichtvoll.de>
	<19028.3736.892828.352905@samba.org>
	<20090708110451.1092afa7@lxorguk.ukuu.org.uk>
	<1247066878.4159.153.camel@mulgrave.site>
	<20090708163736.0f98e7e0@lxorguk.ukuu.org.uk>
	<1247069202.4159.212.camel@mulgrave.site>
	<20090708171848.21633768@lxorguk.ukuu.org.uk>
	<873a96a23x.fsf@devron.myhome.or.jp>
	<87hbxhwv0j.fsf@devron.myhome.or.jp>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to everyone who helped with the testing of the previous round
of VFAT patent workaround patches.

I've posted a new set of patches today which tries to address some of
the technical problems found in the last patch.

The new patches:

  - work with Win98
  - work with Jan's IOneIt MP3 player
  - work with all the other FAT capable devices I have available for
    testing
  - work with existing copies of mtools

The remaining issues that I am aware of are:

  - There is a cosmetic issue with the DOS command prompt under
    Win98. A directory listing works, but displays garbage in the
    column where a 8.3 short filename would normally go

  - Similarly, under WinXP, a "dir/x" will show garbage in the 8.3
    column. For example: http://samba.org/~tridge/dir_test.png

  - mtools has a similar cosmetic issue, which is fixed with a small
    patch

  - devices which only support 8.3 filenames will not be able to see
    or use files created with long names with the patch enabled

  - There is a very small chance of WinXP bluescreening if two files
    in the same directory have the same 11 dummy bytes, and are
    accessed in quick succession. The chances of this happening is
    approximately 80x smaller than with the previous patch. As
    previously noted, this is a very difficult problem to reproduce,
    and in fact nobody has managed to reproduce it without modifying
    the patch to use a much smaller number of random bits.

  - Similarly, there is a small chance that chkdsk on Windows will
    rename one file in a directory if they happen to have the same 11
    byte dummy values. The probability of this happening is
    approximately 80x lower than with the previous patch.

Some people have also asked that this patch change the name of the
filesystem to 'lfat' or similar. I have not included that change in
this patch as I think it is counter productive. Instead I have added a
printk_once() to produce a warning like this:

  VFAT: not creating 8.3 short filenames for long names

when the first long filename is created on a VFAT filesystem with this
patch enabled.

The reason I think this is a better option than a filesystem name
change is that a name change will break a unknown number of userspace
tools, scripts and config files. For example, desktop tools for
mounting filesystems, scripts that use -t vfat, module configuration
options in /etc could all be broken without any ability to give the
user feedback on why it broke.

If you have a FAT capable device that you want to test for
compatibility with the new patches, please have a look at the
'Testing' section of the following README:

  http://kernel.org/pub/linux/kernel/people/tridge/VFAT/README

It gives details on how you can do testing without having to change
your kernel.

Cheers, Tridge
