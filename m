Return-Path: <linux-kernel-owner+w=401wt.eu-S932458AbXCUPjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458AbXCUPjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 11:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932414AbXCUPjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 11:39:31 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43429 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932458AbXCUPj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 11:39:29 -0400
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
From: Frank Haverkamp <haver@vnet.ibm.com>
Reply-To: haver@vnet.ibm.com
To: Theodore Tso <tytso@mit.edu>
Cc: Artem Bityutskiy <dedekind@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>, Matt Mackall <mpm@selenic.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>
In-Reply-To: <20070321135033.GA7235@thunk.org>
References: <20070319170838.GP4892@waste.org>
	 <1174328188.30079.46.camel@zod.rchland.ibm.com>
	 <20070319195442.GT4892@waste.org> <1174338393.17249.53.camel@sauron>
	 <20070319213628.GW4892@waste.org> <1174393549.17249.101.camel@sauron>
	 <20070320135231.GA6043@thunk.org>
	 <1174406395.30079.139.camel@zod.rchland.ibm.com>
	 <20070320220312.GC29493@thunk.org> <1174466675.17249.182.camel@sauron>
	 <20070321135033.GA7235@thunk.org>
Content-Type: text/plain
Organization: IBM
Date: Wed, 21 Mar 2007 16:38:07 +0100
Message-Id: <1174491487.21506.66.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

On Wed, 2007-03-21 at 09:50 -0400, Theodore Tso wrote:
> Keeping this thought in mind and trying to help them, where in some
> cases perhaps they are lacking in the same knowledge and experience
> and those who have been working on UBI and have spent many months
> thinking about the problem, may help keep things more constructive. 

since I am one of those who are working on UBI together with Artem, I
would like to try to describe how we are using UBI and how it solves
some problems, we could not solve to our satisfaction with existing
solutions.

Our system is using only NAND flashes and we use a nand-flash-controller
for the 1st stage boot-code (we called it IPL - initial program loader)
to appear contiguous in memory. The size of the IPL is limited to 4 KiB.

In these 4KiB code we initialize the processor, and scan the NAND flash
for copies of our 2nd stage boot-loader (SPL), which is stored in one or
even redundantly in multiple static UBI volumes. If the SPL has one-bit
flips we can correct them in the IPL before loading it into RAM.

We want to correct bit-flips as soon as possible to avoid getting
uncorrectable errors. UBI is doing that transparently for us by copying
the block with the bitflip to a free block. The logic in the IPL is able
to cope with the situation where UBI is interrupted when doing that.

Imagine if you have boot-code at a fixed location (skipping bad blocks
of course too): if you erase a block of the SPL to write it back to the
same block (to remove bit-errors), you will not be robust against
power-loss anymore! You could put a 2nd temporary SPL before you could
do this, but that is not nice too.

The static UBI volumes are so simple structured, that it is possible to
load them to RAM using only a few KiB of code. We do not even look at
UBIs volume information table to be able to do this.

UBI solves here:
 1. possiblitly to boot a controller with limited resources using NAND
 2. transparent bitflip correction on read only data e.g. boot-code,
    kernel, initrd. Note that the mechanisms here are robust against
    power-loss, that is also very important to us

We wanted to use JFFS2 and found that the traditional update mechanisms
did not ensure that an interrupted update attempt can be detected as
such. The UBI volume update ensures, that the volume is only usable
after it was updated completely.

 3. Update mechanism which ensures that incomplete data cannot be used

We found that putting certain flash content at fixed locations with
fixed size is especially cumbersome if raw NAND is used e.g. if you
consider that bad blocks have to be skipped. Resizing partitions is a
pain.

UBI helps us to get rid of those limitations. We can resize the UBI
volumes and because UBI takes care to find the volume data even our
second stage boot-code can be located anywhere on the chip.

 4. Volume resizing is easy

Because we want to ensure that we gain maximum lifetime for our systems,
we want that bitflips are corrected immediately when they are found.
Feature 2. of UBI does this for us.

I think that the largest portion of what we put in our NAND flashes is
code and data and basically read-only. Nevertheless data is written
during operation and, as already pointed out, maximum lifetime is
important for us, and wear-leveling across the whole flash chip helps
espcially with our usage-pattern. UBIs ability to copy blocks
transparently e.g. a read-only block with small erase count to a free
block with relatively high erase count, helps to get this done.

 5. wear-leveling across the whole flash chip

We found that being able to use the same code update mechanisms for
NAND/NOR/? based systems is a nice side effect too. That was one reason
beside others (see previous mails) to up the UBI meta data into the data
section of the flashes and sacrifice therefore some space for data and
of course that the usable size of a block is not n^2 anymore. I think it
was a good decision, because if we would have put in in NAND OOB area,
the discussion here might be limited to NAND users only.

Regards,

Frank Haverkamp

