Return-Path: <linux-kernel-owner+w=401wt.eu-S1161280AbXDSX7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161280AbXDSX7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 19:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030582AbXDSX7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 19:59:03 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:18218 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030748AbXDSX7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 19:59:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=kLABefOVC3ECE2pqO+X7yMZDcwgU70S2hlR2f1E4PH2WAwsEU0fPNSEcmMVnlAKtpFbsfxnOiHZDhwHWUcSHVLct4ksc5aDLJn86VVv+4bZiMWUDpvaHTrk3HXs3yjXrKFCVnOdk8Xav84gqilROF+7WFLllETbTk2V3cWTmcrs=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [RFC 0/8] Variable Order Page Cache
Date: Fri, 20 Apr 2007 02:58:24 +0300
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>, Andi Kleen <ak@suse.de>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
In-Reply-To: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704200258.24749.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 April 2007 19:35:04 Christoph Lameter wrote:
> Variable Order Page Cache Patchset
> 
> This patchset modifies the core VM so that higher order page cache pages
> become possible. The higher order page cache pages are compound pages
> and can be handled in the same way as regular pages.
> 
> The order of the pages is determined by the order set up in the mapping
> (struct address_space). By default the order is set to zero.
> This means that higher order pages are optional. There is no attempt here
> to generally change the page order of the page cache. 4K pages are effective
> for small files.
> 
> However, it would be good if the VM would support I/O to higher order pages
> to enable efficient support for large scale I/O. If one wants to write a
> long file of a few gigabytes then the filesystem should have a choice of
> selecting a larger page size for that file and handle larger chunks of
> memory at once.
> 
> The support here is only for buffered I/O and only for one filesystem 
(ramfs).
> Modification of other filesystems to support higher order pages may require
> extensive work of other components of the kernel. But I hope this shows that
> there is a relatively easy way to that goal that could be taken in steps..
> 
> Note that the higher order pages are subject to reclaim. This works in 
general
> since we are always operating on a single page struct. Reclaim is fooled to
> think that it is touching page sized objects (there are likely issues to be
> fixed there if we want to go down this road).
> 
> What is currently not supported:
> - Buffer heads for higher order pages (possible with the compound pages in 
mm
>   that do not use page->private requires upgrade of the buffer cache 
layers).
> - Higher order pages in the block layer etc.
> - Mmapping higher order pages
> 
> Note that this is proof-of-concept. Lots of functionality is missing and
> various issues have not been dealt with. Use of higher order pages may cause
> memory fragmentation. Mel Gorman's anti-fragmentation work is probably
> essential if we want to do this. We likely need actual defragmentation
> support.
> 
> The main point of this patchset is to demonstrates that it is basically
> possible to have higher order support with straightforward changes to the
> VM.
> 
> The ramfs driver can be used to test higher order page cache functionality
> (and may help troubleshoot the VM support until we get some real filesystem
> and real devices supporting higher order pages).
> 
> If you apply this patch and then you can f.e. try this:
> 
> mount -tramfs -o10 none /media
> 
> 	Mounts a ramfs filesystem with order 10 pages (4 MB)
> 
> cp linux-2.6.21-rc7.tar.gz /media
> 
> 	Populate the ramfs. Note that we allocate 14 pages of 4M each
> 	instead of 13508..
> 
> umount /media
> 
> 	Gets rid of the large pages again
> 
> Comments appreciated.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Hello,

This is exactly what I wanted some time ago,
Thank you very much, I was almost thinking of doing this myself 
(but decided that it is too difficult now for me and maybe doesn't worth the 
effort)

I want to point out on number of problems that this will solve (and reasons I 
wanted to do that)

First of all, today, packet writing on cd/dvd doesn't work well, it is very 
slow because 
now all file-systems are limited to 4k-barrier and cd/dvd can write only 
32k/64k packets.
This is why a pktcdvd was written and it emulates those 4k sectors by doing 
read/modify/write cycle
This cause a lot of seeks and read/writing switches and thus it is very slow.

By introducing a bigger that 4k page cache a dvd/cd can be divided is 64k/32k 
blocks that will be read an written freely
(Although dvd can read 2k  I don't think that reading a 64k block will hurt 
since most of time drive is busy seeking and locating a specific sector)

Now I thinking to implement this in an other way, I mean I want to teach udf 
filesystem to to packet writing on its own, bypassing disk cache (but not page 
cache)

Secondary 32/64k limitation is present of flash devices too, so they can 
benefit too, and I almost sure that future hard disks will use bigger block 
size too.

To summarize I want to tell that bigger pagesize will allow devices that have 
big hardware sectors to work fine in linux.

Best regards,
	Maxim Levitsky
