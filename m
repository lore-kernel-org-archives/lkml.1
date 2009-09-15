Return-Path: <linux-kernel-owner+w=401wt.eu-S1756953AbZIOXVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbZIOXVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 19:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbZIOXVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 19:21:21 -0400
Received: from james.oetiker.ch ([213.144.138.195]:36603 "EHLO
	james.oetiker.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbZIOXVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 19:21:20 -0400
Date: Wed, 16 Sep 2009 01:21:20 +0200 (CEST)
From: Tobias Oetiker <tobi@oetiker.ch>
To: Daniel J Blueman <daniel.blueman@gmail.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: unfair io behaviour for high load interactive use still present
 in 2.6.31
In-Reply-To: <2612a5ee-4141-43d2-a009-090eac352aa2@n2g2000vba.googlegroups.com>
Message-ID: <alpine.DEB.2.00.0909160043050.14727@sebohet.brgvxre.pu>
References: <dkAXF-4Gg-25@gated-at.bofh.it> <2612a5ee-4141-43d2-a009-090eac352aa2@n2g2000vba.googlegroups.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463760128-17271239-1253056881=:14727"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463760128-17271239-1253056881=:14727
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

Hi Daniel,

Yesterday Daniel J Blueman wrote:

> On Sep 15, 8:50 am, Tobias Oetiker <t...@oetiker.ch> wrote:
> > Experts,
> >
> > We run several busy NFS file servers with Areca HW Raid + LVM2 + ext3
> >
> > We find that the read bandwidth falls dramatically as well as the
> > response times going up to several seconds as soon as the system
> > comes under heavy write strain.
>
> It's worthwhile checking:

>  - that the ext3 filesystem starts at a stripe-aligned offset

yep

>  - that the ext3 filesystem was created with the correct
>  stripe-width and stride (chunk) size

yep

>  - due to the larger amount of memory, ext4 may be a big win (due
>  to delayed allocate), if you'll stay with a newer kernel

ext4 does not seem to change much

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util

dm-18             0.00     0.00    0.00  316.60     0.00     1.24     8.00  2590.22   99.29   3.16 100.00
dm-18             0.00     0.00    1.60 1211.60     0.01     4.73     8.00   692.64 2925.31   0.76  92.00
dm-18             0.00     0.00    2.00 4541.40     0.01    17.74     8.00  1858.21  413.23   0.22  99.52
dm-18             0.00     0.00    0.00 1341.80     0.00     5.24     8.00  1084.59  239.59   0.68  90.96
dm-18             0.00     0.00   10.00 3739.80     0.04    14.61     8.00   914.32  447.29   0.25  93.12
dm-18             0.00     0.00    2.60 2474.20     0.01     9.66     8.00   537.33   23.88   0.36  89.36
dm-18             0.00     0.00    2.00 2569.00     0.01    10.04     8.00  1215.49  658.95   0.33  85.92


>  - if you have battery backup at the right levels:
>   - performance may be better mounting the ext3 filesystem with
> 'barrier=0'

the results look pretty much the same

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util

dm-18             0.00     0.00    1.40 9272.00     0.01    36.22     8.00   413.57  111.78   0.10  88.64
dm-18             0.00     0.00    4.20   71.80     0.02     0.28     8.00    78.24  471.06  12.83  97.52
dm-18             0.00     0.00    0.60 4183.20     0.00    16.34     8.00   988.32  216.66   0.24 100.00
dm-18             0.00     0.00    3.60  792.80     0.01     3.10     8.00  1098.60 1535.50   0.93  74.16
dm-18             0.00     0.00    1.60 6161.20     0.01    24.07     8.00   407.17   42.46   0.16  99.60
dm-18             0.00     0.00    0.00 2128.60     0.00     8.31     8.00  2497.56  368.99   0.47  99.92
dm-18             0.00     0.00    2.60 2657.80     0.01    10.38     8.00  1507.78  937.57   0.34  91.28
dm-18             0.00     0.00    5.80 8872.20     0.02    34.66     8.00   455.43  130.94   0.09  79.20
dm-18             0.00     0.00    2.20 4981.20     0.01    19.46     8.00  1058.84  245.39   0.19  92.24


>   - performance may improve mounting 'data=writeback'

here the effect is that writes get delayed much longer ... it
almost seems as if they got delayed until the reads were done ...

What I am really interested is not perfomance (the total throughput
of the system is pretty ok) the problem is just that there are such
big read delays under heavy load which makes interactive use pretty
hard.

cheers
tobi


-- 
Tobi Oetiker, OETIKER+PARTNER AG, Aarweg 15 CH-4600 Olten, Switzerland
http://it.oetiker.ch tobi@oetiker.ch ++41 62 775 9902 / sb: -9900
---1463760128-17271239-1253056881=:14727--
