Return-Path: <linux-kernel-owner+w=401wt.eu-S1759595AbXINMmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595AbXINMmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 08:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbXINMlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 08:41:52 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:32011 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750738AbXINMlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 08:41:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=vrtJAanWP7uuuGhZ9FJdNP8ZI0tSRXRsU9fOfQ4P18aLwIziBEEwBSqJPApem/GqleSDhQ69OxwoCMDog31Dkn4PfBMkdt0Q5Dpco2PLVQoELL8UkvvG44C6TgQ8NNfK7+/oGQOcd+PbME31I2taSQ6tILicL2yeI4m44b5rH1c=  ;
X-YMail-OSG: EI2bZd4VM1mKOmOYVgVCgqBVY2VrHXJkT5IRrPm.OudLewdnEzkfL8Wdnpn1kj_NFfoc_5QZKw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Chinner <dgc@sgi.com>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Fri, 14 Sep 2007 06:48:55 +1000
User-Agent: KMail/1.9.5
Cc: Mel Gorman <mel@skynet.ie>, Christoph Lameter <clameter@sgi.com>,
       andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
References: <20070911060349.993975297@sgi.com> <20070913130342.GT734179@sgi.com> <200709131201.46720.nickpiggin@yahoo.com.au>
In-Reply-To: <200709131201.46720.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709140648.56184.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 September 2007 12:01, Nick Piggin wrote:
> On Thursday 13 September 2007 23:03, David Chinner wrote:
> > Then just do operations on directories with lots of files in them
> > (tens of thousands). Every directory operation will require at
> > least one vmap in this situation - e.g. a traversal will result in
> > lots and lots of blocks being read that will require vmap() for every
> > directory block read from disk and an unmap almost immediately
> > afterwards when the reference is dropped....
>
> Ah, wow, thanks: I can reproduce it.

OK, the vunmap batching code wipes your TLB flushing and IPIs off
the table. Diffstat below, but the TLB portions are here (besides that
_everything_ is probably lower due to less TLB misses caused by the
TLB flushing):

      -170   -99.4% sn2_send_IPI
      -343  -100.0% sn_send_IPI_phys
    -17911   -99.9% smp_call_function


Total performance went up by 30% on a 64-way system (248 seconds to
172 seconds to run parallel finds over different huge directories).

     23012  54790.5% _read_lock
      9427   329.0% __get_vm_area_node
      5792     0.0% __find_vm_area
      1590  53000.0% __vunmap
       107    26.0% _spin_lock
        74   119.4% _xfs_buf_find
        58     0.0% __unmap_kernel_range
        53    36.6% kmem_zone_alloc
      -129  -100.0% pio_phys_write_mmr
      -144  -100.0% unmap_kernel_range
      -170   -99.4% sn2_send_IPI
      -233   -59.1% kfree
      -266  -100.0% find_next_bit
      -343  -100.0% sn_send_IPI_phys
      -564   -19.9% xfs_iget_core
     -1946  -100.0% remove_vm_area
    -17911   -99.9% smp_call_function
    -62726    -7.2% _write_lock
   -438360   -64.2% default_idle
   -482631   -30.4% total

Next I have some patches to scale the vmap locks and data
structures better, but they're not quite ready yet. This looks like it
should result in a further speedup of several times when combined
with the TLB flushing reductions here...
