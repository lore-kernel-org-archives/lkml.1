Return-Path: <linux-kernel-owner+w=401wt.eu-S966132AbXIKKeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966132AbXIKKeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 06:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757920AbXIKKdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 06:33:53 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:32008 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753634AbXIKKdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 06:33:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Qv6ma7o5qNyD6l60pP4WaMISHNNJWZ0wKYoJ4BBOOCRREDaDCXlxLpv4JZDb+5pIZ2X3UY3Jl6tgllfoIiMctmREETCjOzispQ86JbJhMrDX+9OYCnFnluC1V498aMZWaawGb77LqXX+46CYNj0IiXVJWmI7rC4af5l+njq6pPQ=  ;
X-YMail-OSG: Md_2qdMVM1nwDRloapjv5ZD0alzXUI4bK728QbzWUZegF4Ud1OSx_Z8V1eJMOxPENHZ2BBTKfg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>, andrea@suse.de
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Tue, 11 Sep 2007 04:52:19 +1000
User-Agent: KMail/1.9.5
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
References: <20070911060349.993975297@sgi.com>
In-Reply-To: <20070911060349.993975297@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709110452.20363.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 September 2007 16:03, Christoph Lameter wrote:

> 5. VM scalability
>    Large block sizes mean less state keeping for the information being
>    transferred. For a 1TB file one needs to handle 256 million page
>    structs in the VM if one uses 4k page size. A 64k page size reduces
>    that amount to 16 million. If the limitation in existing filesystems
>    are removed then even higher reductions become possible. For very
>    large files like that a page size of 2 MB may be beneficial which
>    will reduce the number of page struct to handle to 512k. The variable
>    nature of the block size means that the size can be tuned at file
>    system creation time for the anticipated needs on a volume.

There is a limitation in the VM. Fragmentation. You keep saying this
is a solved issue and just assuming you'll be able to fix any cases
that come up as they happen.

I still don't get the feeling you realise that there is a fundamental
fragmentation issue that is unsolvable with Mel's approach.

The idea that there even _is_ a bug to fail when higher order pages
cannot be allocated was also brushed aside by some people at the
vm/fs summit. I don't know if those people had gone through the
math about this, but it goes somewhat like this: if you use a 64K
page size, you can "run out of memory" with 93% of your pages free.
If you use a 2MB page size, you can fail with 99.8% of your pages
still free. That's 64GB of memory used on a 32TB Altix.

If you don't consider that is a problem because you don't care about
theoretical issues or nobody has reported it from running -mm
kernels, then I simply can't argue against that on a technical basis.
But I'm totally against introducing known big fundamental problems to
the VM at this stage of the kernel. God knows how long it takes to ever
fix them in future after they have become pervasive throughout the 
kernel.

IMO the only thing that higher order pagecache is good for is a quick
hack for filesystems to support larger block sizes. And after seeing it
is fairly ugly to support mmap, I'm not even really happy for it to do
that.

If VM scalability is a problem, then it needs to be addressed in other
areas anyway for order-0 pages, and if contiguous pages helps IO
scalability or crappy hardware, then there is nothing stopping us from
*attempting* to get contiguous memory in the current scheme.

Basically, if you're placing your hopes for VM and IO scalability on this,
then I think that's a totally broken thing to do and will end up making
the kernel worse in the years to come (except maybe on some poor
configurations of bad hardware).
