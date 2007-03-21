Return-Path: <linux-kernel-owner+w=401wt.eu-S964873AbXCUUwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964873AbXCUUwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 16:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964896AbXCUUwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 16:52:14 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:53171 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S964873AbXCUUwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 16:52:13 -0400
Date: Wed, 21 Mar 2007 12:26:07 -0800 (PST)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Frank Haverkamp <haver@vnet.ibm.com>
cc: Theodore Tso <tytso@mit.edu>, Artem Bityutskiy <dedekind@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>, Matt Mackall <mpm@selenic.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
In-Reply-To: <1174491487.21506.66.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.63.0703211215170.10000@qynat.qvtvafvgr.pbz>
References: <20070319170838.GP4892@waste.org>  <1174328188.30079.46.camel@zod.rchland.ibm.com>
  <20070319195442.GT4892@waste.org> <1174338393.17249.53.camel@sauron> 
 <20070319213628.GW4892@waste.org> <1174393549.17249.101.camel@sauron> 
 <20070320135231.GA6043@thunk.org>  <1174406395.30079.139.camel@zod.rchland.ibm.com>
  <20070320220312.GC29493@thunk.org> <1174466675.17249.182.camel@sauron> 
 <20070321135033.GA7235@thunk.org> <1174491487.21506.66.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007, Frank Haverkamp wrote:

several of these things sound like they would be useful to other block devices 
as well

> UBI solves here:
> 1. possiblitly to boot a controller with limited resources using NAND
> 2. transparent bitflip correction on read only data e.g. boot-code,
>    kernel, initrd. Note that the mechanisms here are robust against
>    power-loss, that is also very important to us
>
> We wanted to use JFFS2 and found that the traditional update mechanisms
> did not ensure that an interrupted update attempt can be detected as
> such. The UBI volume update ensures, that the volume is only usable
> after it was updated completely.

a dm layer that detects and remaps soft errors before they become hard errors is 
useful for hard drives as well.

> 3. Update mechanism which ensures that incomplete data cannot be used
>
> We found that putting certain flash content at fixed locations with
> fixed size is especially cumbersome if raw NAND is used e.g. if you
> consider that bad blocks have to be skipped. Resizing partitions is a
> pain.
>
> UBI helps us to get rid of those limitations. We can resize the UBI
> volumes and because UBI takes care to find the volume data even our
> second stage boot-code can be located anywhere on the chip.
>
> 4. Volume resizing is easy
>
> Because we want to ensure that we gain maximum lifetime for our systems,
> we want that bitflips are corrected immediately when they are found.
> Feature 2. of UBI does this for us.
>
> I think that the largest portion of what we put in our NAND flashes is
> code and data and basically read-only. Nevertheless data is written
> during operation and, as already pointed out, maximum lifetime is
> important for us, and wear-leveling across the whole flash chip helps
> espcially with our usage-pattern. UBIs ability to copy blocks
> transparently e.g. a read-only block with small erase count to a free
> block with relatively high erase count, helps to get this done.

both of these also sound useful as dm layers (in fact lvm already does some of 
the resizing things)

> 5. wear-leveling across the whole flash chip
>
> We found that being able to use the same code update mechanisms for
> NAND/NOR/? based systems is a nice side effect too. That was one reason
> beside others (see previous mails) to up the UBI meta data into the data
> section of the flashes and sacrifice therefore some space for data and
> of course that the usable size of a block is not n^2 anymore. I think it
> was a good decision, because if we would have put in in NAND OOB area,
> the discussion here might be limited to NAND users only.

wear leveling would also be useful on other block devices (think CD-RAM for 
example)

cross-device wear leveling sounds a lot like putting the wear leveling layer 
above a lvm-like layer that stitches the seperate flash chips togeather into one 
logical device.

additionally, if wear leveling is an optional layer in dm then it can be left 
out when it's not appropriate (like when the FS has features that make it 
unnessasary, or when it's read-only so you don't have writes to worry about (or 
even if it's read-only 99.9999% of the time so writes are so rare that all the 
writes in the expected lifetime of the device won't cause problems)

David Lang
