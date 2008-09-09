Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbYIIEtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbYIIEtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 00:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbYIIEsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 00:48:38 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39112 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbYIIEsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 00:48:36 -0400
Date: Tue, 9 Sep 2008 13:53:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       hugh@veritas.com, menage@google.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH] Remove cgroup member from struct page
Message-Id: <20080909135317.cbff4871.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200809091358.28350.nickpiggin@yahoo.com.au>
References: <20080901161927.a1fe5afc.kamezawa.hiroyu@jp.fujitsu.com>
	<20080908152810.GA12065@balbir.in.ibm.com>
	<20080909125751.37042345.kamezawa.hiroyu@jp.fujitsu.com>
	<200809091358.28350.nickpiggin@yahoo.com.au>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2008 13:58:27 +1000
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Tuesday 09 September 2008 13:57, KAMEZAWA Hiroyuki wrote:
> > On Mon, 8 Sep 2008 20:58:10 +0530
> >
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > Sorry for the delay in sending out the new patch, I am traveling and
> > > thus a little less responsive. Here is the update patch
> >
> > Hmm.. I've considered this approach for a while and my answer is that
> > this is not what you really want.
> >
> > Because you just moves the placement of pointer from memmap to
> > radix_tree both in GFP_KERNEL, total kernel memory usage is not changed.
> > So, at least, you have to add some address calculation (as I did in March)
> > to getting address of page_cgroup. But page_cgroup itself consumes 32bytes
> > per page. Then.....
> 
> Just keep in mind that an important point is to make it more attractive
> to configure cgroup into the kernel, but have it disabled or unused at
> runtime.
> 

Hmm..kicking out 4bytes per 4096bytes if disabled ?

maybe a routine like SPARSEMEM is a choice.

Following is pointer pre-allocation. (just pointer, not page_cgroup itself)
==
#define PCG_SECTION_SHIFT	(10)
#define PCG_SECTION_SIZE	(1 << PCG_SECTION_SHIFT)

struct pcg_section {
	struct page_cgroup **map[PCG_SECTION_SHIFT]; //array of pointer.
};

struct page_cgroup *get_page_cgroup(unsigned long pfn)
{
	struct pcg_section *sec;
	sec = pcg_section[(pfn >> PCG_SECTION_SHIFT)];
	return *sec->page_cgroup[(pfn & ((1 << PCG_SECTTION_SHIFT) - 1];
}
==
If we go extreme, we can use kmap_atomic() for pointer array.

Overhead of pointer-walk is not so bad, maybe.

For 64bit systems, we can find a way like SPARSEMEM_VMEMMAP.

Thanks,
-Kame




Thanks,
-Kame

