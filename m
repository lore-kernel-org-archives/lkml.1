Return-Path: <linux-kernel-owner+w=401wt.eu-S1757036AbZGCBKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbZGCBKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 21:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbZGCBKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 21:10:03 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33152 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878AbZGCBKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 21:10:01 -0400
Date: Fri, 3 Jul 2009 03:10:03 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: tridge@samba.org
cc: Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regression
In-Reply-To: <19021.20449.732095.210252@samba.org>
Message-ID: <alpine.LSU.2.00.0907030254180.22039@fbirervta.pbzchgretzou.qr>
References: <19013.8005.541836.436991@samba.org> <20090630063102.GB1351@ucw.cz> <200907012019.53932.rusty@rustcorp.com.au> <20090701122558.3a7c80d3@lxorguk.ukuu.org.uk> <20090701140503.GA21185@mit.edu> <alpine.LSU.2.00.0907030056210.17183@fbirervta.pbzchgretzou.qr>
 <19021.17576.808138.476600@samba.org> <alpine.LSU.2.00.0907030149020.17183@fbirervta.pbzchgretzou.qr> <19021.20449.732095.210252@samba.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2009-07-03 02:25, tridge@samba.org wrote:
>
> >  (All with DUALNAMES=n)
> >  # mount /dev/sdc1 /mnt -o iocharset=utf8,shortnames=lower
> >  # cp /mnt/dcim/100_fuji/dscf{4160,3004}.jpg
> >  # umount /mnt
> >  # mount /dev/sdc1 /mnt -o iocharset=utf8,shortnames=win95
> >  # cp /mnt/dcim/100_fuji/dscf{4160,3005}.jpg
> >  # umount /mnt
> >  # mount /dev/sdc1 /mnt -o iocharset=utf8,shortnames=winnt
> >  # cp /mnt/dcim/100_fuji/dscf{4160,3006}.jpg
> >  # umount /mnt
> >  # mount /dev/sdc1 /mnt -o iocharset=utf8,shortnames=mixed
> >  # cp /mnt/dcim/100_fuji/dscf{4160,3007}.jpg
> >  # umount /mnt
> > 
> > Result? The camera only displays 3006.
> > 
> > The dualnames patch's filling filenames with random illegal
> > chars does seems to have a really foul side-effect after 
>
>actually, you've just proved the patch works as intended on your
>device!
>
>Only the shortname=winnt would create a 8.3 name when you use the
>filename dscfNNNN.jpg.

The mount(8) manpage becomes pretty ambiguous with the dualnames
patch. By default, "store a long name when the short name is not all
upper case" would apply - and is invoked because I am a lazy typist
who wrote "cp $this dscf3000" instead of "cp $this DSCF3000". Now
since dualnames=n is in effect, no long name would need to be written
because it still fits into 8.3 — subsequently, one would assume an
8.3 is generated for all shortname= cases.

>That is why my first patch in May forced 
>
>   shortname_flags = VFAT_SFN_CREATE_WINNT;

Making WINNT the default would cause many a `ls` output to just
scream at me in uppercaps because there are programs that
create long names with all-uppers.

shortname really needs to be split into "shortname that is applied
during creation" and "shortname that is applied upon readdir".

