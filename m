Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597AbYIVPrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbYIVPrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 11:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbYIVPrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 11:47:36 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49536 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbYIVPrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 11:47:36 -0400
Subject: Re: Re: [PATCH 9/13] memcg: lookup page cgroup (and remove pointer
	from struct page)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: linux-mm@kvack.org, balbir@linux.vnet.ibm.com, nishimura@mxp.nes.nec.co.jp,
       xemul@openvz.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <31600854.1222096483210.kamezawa.hiroyu@jp.fujitsu.com>
References: <1222095177.8533.14.camel@nimitz>
	 <20080922195159.41a9d2bc.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080922201206.e73d9ce6.kamezawa.hiroyu@jp.fujitsu.com>
	 <31600854.1222096483210.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Date: Mon, 22 Sep 2008 08:47:30 -0700
Message-Id: <1222098450.8533.41.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-23 at 00:14 +0900, kamezawa.hiroyu@jp.fujitsu.com wrote:
> >Basing it on max_pfn makes me nervous because of what it will do on
> >machines with very sparse memory.  Is this like sparsemem where the
> >structure can be small enough to actually span all of physical memory,
> >or will it be a large memory user?
> >
> I admit this calcuration is too easy. Hmm, based on totalram_pages is 
> better. ok.

No, I was setting a trap. ;)

If you use totalram_pages, I'll just complain that it doesn't work if a
memory hotplug machine drastically changes its size.  You'll end up with
pretty darn big hash buckets.

You basically can't get away with the fact that you (potentially) have
really sparse addresses to play with here.  Using a hash table is
exactly the same as using an array such as sparsemem except you randomly
index into it instead of using straight arithmetic.

My gut says that you'll need to do exactly the same things sparsemem did
here, which is at *least* have a two-level lookup before you get to the
linear search.  The two-level lookup also makes the hotplug problem
easier.

As I look at this, I always have to bounce between these tradeoffs:

1. deal with sparse address spaces (keeps you from using max_pfn)
2. scale as that sparse address space has memory hotplugged into it
   (keeps you from using boot-time present_pages)
3. deal with performance impacts from new data structures created to
   deal with the other two :)

> >Can you lay out how much memory this will use on a machine like Dave
> >Miller's which has 1GB of memory at 0x0 and 1GB of memory at 1TB up in
> >the address space?
> 
> >Also, how large do the hash buckets get in the average case?
> >
> on my 48GB box, hashtable was 16384bytes. (in dmesg log.)
> (section size was 128MB.)

I'm wondering how long the linear searches of those hlists get.

> I'll rewrite this based on totalram_pages.
> 
> BTW, do you know difference between num_physpages and totalram_pages ?

num_physpages appears to be linked to the size of the address space and
totalram_pages looks like the amount of ram present.  Kinda
spanned_pages and present_pages.  But, who knows how consistent they are
these days. :)

-- Dave

