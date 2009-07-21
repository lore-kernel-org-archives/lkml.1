Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbZGUJQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbZGUJQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 05:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbZGUJQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 05:16:19 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:29010
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752827AbZGUJQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 05:16:18 -0400
Message-ID: <4A65875D.7030902@panasas.com>
Date: Tue, 21 Jul 2009 12:16:13 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: tridge@samba.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>, Theodore Tso <tytso@mit.edu>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, torvalds@linux-foundation.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
References: <19013.8005.541836.436991@samba.org>	<alpine.LSU.2.00.0907062221520.27775@fbirervta.pbzchgretzou.qr>	<19026.38137.63807.427511@samba.org>	<200907072356.51553.Martin@lichtvoll.de>	<19028.3736.892828.352905@samba.org>	<20090708110451.1092afa7@lxorguk.ukuu.org.uk>	<1247066878.4159.153.camel@mulgrave.site>	<20090708163736.0f98e7e0@lxorguk.ukuu.org.uk>	<1247069202.4159.212.camel@mulgrave.site>	<20090708171848.21633768@lxorguk.ukuu.org.uk>	<873a96a23x.fsf@devron.myhome.or.jp>	<87hbxhwv0j.fsf@devron.myhome.or.jp> <19045.14307.658887.752950@samba.org>
In-Reply-To: <19045.14307.658887.752950@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Jul 2009 09:16:18.0365 (UTC) FILETIME=[E7BD4ED0:01CA09E3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2009 06:37 AM, tridge@samba.org wrote:
> Thanks to everyone who helped with the testing of the previous round
> of VFAT patent workaround patches.
> 
> I've posted a new set of patches today which tries to address some of
> the technical problems found in the last patch.
> 
> The new patches:
> 
>   - work with Win98
>   - work with Jan's IOneIt MP3 player
>   - work with all the other FAT capable devices I have available for
>     testing
>   - work with existing copies of mtools
> 
> The remaining issues that I am aware of are:
> 
>   - There is a cosmetic issue with the DOS command prompt under
>     Win98. A directory listing works, but displays garbage in the
>     column where a 8.3 short filename would normally go
> 
>   - Similarly, under WinXP, a "dir/x" will show garbage in the 8.3
>     column. For example: http://samba.org/~tridge/dir_test.png
> 

I guess you tried putting a zero at first char and it breaks everybody?

>   - mtools has a similar cosmetic issue, which is fixed with a small
>     patch
> 
>   - devices which only support 8.3 filenames will not be able to see
>     or use files created with long names with the patch enabled
> 
>   - There is a very small chance of WinXP bluescreening if two files
>     in the same directory have the same 11 dummy bytes, and are
>     accessed in quick succession. The chances of this happening is
>     approximately 80x smaller than with the previous patch. As
>     previously noted, this is a very difficult problem to reproduce,
>     and in fact nobody has managed to reproduce it without modifying
>     the patch to use a much smaller number of random bits.
> 

I guess (35^6)*8*7 is not that bad

>   - Similarly, there is a small chance that chkdsk on Windows will
>     rename one file in a directory if they happen to have the same 11
>     byte dummy values. The probability of this happening is
>     approximately 80x lower than with the previous patch.
> 

What if we had a user mode utility that does these short-names
renames that a user can optionally run after umount? since it
only writes the (random) short-names it's also safe.

Kind of the cop that can read and the cop that can write e-literacy
problem, No?

> Some people have also asked that this patch change the name of the
> filesystem to 'lfat' or similar. I have not included that change in
> this patch as I think it is counter productive. Instead I have added a
> printk_once() to produce a warning like this:
> 
>   VFAT: not creating 8.3 short filenames for long names
> 
> when the first long filename is created on a VFAT filesystem with this
> patch enabled.
> 
> The reason I think this is a better option than a filesystem name
> change is that a name change will break a unknown number of userspace
> tools, scripts and config files. For example, desktop tools for
> mounting filesystems, scripts that use -t vfat, module configuration
> options in /etc could all be broken without any ability to give the
> user feedback on why it broke.
> 
> If you have a FAT capable device that you want to test for
> compatibility with the new patches, please have a look at the
> 'Testing' section of the following README:
> 
>   http://kernel.org/pub/linux/kernel/people/tridge/VFAT/README
> 
> It gives details on how you can do testing without having to change
> your kernel.
> 
> Cheers, Tridge
> --

Boaz
