Return-Path: <linux-kernel-owner+w=401wt.eu-S932658AbXCTM0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658AbXCTM0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 08:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932759AbXCTM0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 08:26:45 -0400
Received: from smtp.nokia.com ([131.228.20.171]:45267 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932658AbXCTM0n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 08:26:43 -0400
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Matt Mackall <mpm@selenic.com>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20070319213628.GW4892@waste.org>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
	 <20070318162720.GI10459@waste.org> <1174236579.17249.6.camel@sauron>
	 <20070318191812.GM4892@waste.org>
	 <20070318203149.GC29295@crusty.rchland.ibm.com>
	 <20070319170838.GP4892@waste.org>
	 <1174328188.30079.46.camel@zod.rchland.ibm.com>
	 <20070319195442.GT4892@waste.org> <1174338393.17249.53.camel@sauron>
	 <20070319213628.GW4892@waste.org>
Content-Type: text/plain; charset=utf-8
Date: Tue, 20 Mar 2007 14:25:49 +0200
Message-Id: <1174393549.17249.101.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 20 Mar 2007 12:25:54.0686 (UTC) FILETIME=[E7C7A1E0:01C76AEA]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070320142609-43FE8BB0-2736A063/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
>                      iSCSI/nbd(6)
>                           |
> filesystem {        swap  |  ext3        ext3     jffs2
>                       \   |   |            |       /
>                /       \  | dm-crypt->snapshot(5) /
> device mapper -|        \ \   |                  /
>                |         partitioning           /
>                |              |          partitioning(4)
>                |        wear leveling(3)  /
>                |              |          /
>                |      block concatenation
>                |       |    |    |     |
>                \      bad block remapping(2)   
>                        |    |    |     |
> MTD raw block {     raw block devices with no smarts(1)
>                       /     |     \      \
> hardware {         NAND    NAND   NAND   NAND

You failed to clearly define what is block until now, then you blame me
that I do not understand you. So I see block = eraseblock, lets assume
for further conversation.

OK. Suppose we have done what you say, although I _do not_ think it is
makes a lot of sense. So, now we have a block device, with 128KiB block
size. We have LVM, dm-wl or whatever stuff. Fine.

Do you realize that 128KiB is _huge_ block size, and performance will
suck, and suck a lot if you utilize say, ext2 or whatever block device
FS.

Do you realize that I may not be satisfied with slow I/O? Do I have
right to have faster one? Thanks if yes.

To make it faster I have to have a way to do finer grained I/O:
read/write to different positions of 128KiB block. Do you realize how
much you will abuse all the generic block device infrastructure if you
try to add this? Note, all levels up to LVM will need to have this. A
believe it is braindead ((c) tglx) to add this feature.

Also, in UBI we have the following features:
1. data type hints: you basically may help UBI to pick optimal
eraseblock if you specify data life-time - is it long-live data, or
short-live/temporary data.
2. Some other ones, do not want to describe now.

Do you offer to add this stuff to DM-mapper?

So, you approach only makes sense if you are going to work with flash as
block device with block size = eraseblock size. No finer grained access
at all. It is fine, some users may be ok with this. But please, do not
be so naive - the performance will suck a _lot_. Let alone I doubt it
will really fit the DM infrastructure.

We work on different approach. And in general, the picture which Thomas
drew to you makes _much more_ sense. Please, do not be so stuck to your
way, it is not bad or good, it is just _different_, and it has obvious
limitations which we do not want to have, thus we go other way.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

