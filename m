Return-Path: <linux-kernel-owner+w=401wt.eu-S934051AbXCTUMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934051AbXCTUMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 16:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934062AbXCTUMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 16:12:51 -0400
Received: from smtp.nokia.com ([131.228.20.171]:46737 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934051AbXCTUMu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 16:12:50 -0400
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: David Lang <david.lang@digitalinsight.com>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>, Theodore Tso <tytso@mit.edu>,
       Matt Mackall <mpm@selenic.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <Pine.LNX.4.63.0703201049310.8684@qynat.qvtvafvgr.pbz>
References: <20070318162720.GI10459@waste.org>
	 <1174236579.17249.6.camel@sauron> <20070318191812.GM4892@waste.org>
	 <20070318203149.GC29295@crusty.rchland.ibm.com>
	 <20070319170838.GP4892@waste.org>
	 <1174328188.30079.46.camel@zod.rchland.ibm.com>
	 <20070319195442.GT4892@waste.org> <1174338393.17249.53.camel@sauron>
	 <20070319213628.GW4892@waste.org> <1174393549.17249.101.camel@sauron>
	 <20070320135231.GA6043@thunk.org>
	 <1174406395.30079.139.camel@zod.rchland.ibm.com>
	 <Pine.LNX.4.63.0703201049310.8684@qynat.qvtvafvgr.pbz>
Content-Type: text/plain; charset=utf-8
Date: Tue, 20 Mar 2007 22:05:51 +0200
Message-Id: <1174421151.17249.168.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 20 Mar 2007 20:05:51.0536 (UTC) FILETIME=[28C8C300:01C76B2B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-20 at 10:58 -0800, David Lang wrote:
> the fact that you erase in large blocks and then write in smaller blocks is a 
> difference, and one that the current block layer doesn't understand. but this is 
> a difference that the current block layer could be changed to understand. it's 
> not something that would justify a seperate-but-equal block layer for flash 
> devices.

I am _not_ an block device layer expert. But I think it is silly idea to
abuse it adding a possibility of reading/writing from/to the middle of
the block. Isn't it obvious that the fact that block is _minimal_ I/O
unit is _deep_ inside the design???

We also need few other features as well, like data life-time hints to
help the wear-leveling engine to pick optimal eraseblock. And there are
more features we need to have. Do you want to add all those to block
device infrastructure?

Thomas wrote about how one can reuse all block device goodies, like LVM,
FSes etc. He drew a picture, just roll back and glance. This makes much
more sense.

Guess why we still do not have a decent FTL? Because it is _difficult_.
Now, when we have UBI one can implement FTL much, much easier. It
becomes really possible now. Because UBI already hides many complexities
of flash, and FTL layer should not care about many things. It may
concentrate on FTL problems, for example on a smart garbage collector,
which is also a difficult thing. Also, with UBI, for example, the FTL
layer may store on-flash tables with block mappings, because UBI takes
care of wear-leveling. I mean, FTL may update those tables as may times
as it want, without caring that corresponding eraseblocks go worn-out.

After we have implemented FTL, we can re-use all the block device
infrastructure - LVM, dm-crypt, ext3 and 4, and so on. This does make
sense. And this is at Thomas's picture.

So please, look at UBI as a low-level layer just which hides flash
complexities like wear and bad blocks. It also does write-failure
recovery automatically - this is very important feature. These are
essentially the features which makes our life horrible, and UBI kicks
them out. I am not a newbie in the area and I know how difficult is it
to develop on top of a raw flash. Yes, it allows creating volumes, but
this is not the main feature of it. It gust goes naturally.

And one note: UBI is flash type independent, so you can use it on top of
NOR/NAND/DataFlash/AG-AND/ECCd NOR and so on, as long as MTD support
exists. For example, we do not use OOB at all. I write it just because
Matt always used NAND as an example, just for clarification.

> as Ted notes, the idea that block sizes may not be powers of 2 (128k-128b from 
> his e-mail) _may_ end up being a big enough difference that it's not worth 
> teaching the exising block layer how to deal with, but it's not clear why you 
> are useing this odd size.

Eraseblock size is power of 2. We store the erase counter (needed for
wear-levelling) and logical to physical eraseblock mapping in each
eraseblock. Thus, we reduce the size.

We do not want to have any on-flash table, because we end up with a
chicken-and-egg problem: the tables are updated often, so they cannot
sit in fixed eraseblocks. They should constantly change position to
ensure wear-leveling. This is very difficult and less robust.

> this is why you are being asked for further explinations.

Although we do not have shiny documentation, but all _essential_ are
explained in the existing, not shiny one, so those really interested
could find this there. I mean, if one does not know much about the area,
and does not spend time to explore it, we cannot really help. But
anyway, we will try to write better docs, it just a question of time.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

