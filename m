Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbYIIFAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbYIIFAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 01:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbYIIFAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 01:00:30 -0400
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:36506 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751571AbYIIFA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 01:00:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ENkO701QmB/dz2LhbOj4fESPVUpGKIQKVEX9c/5PA05NjMsvCzsVYICkm6+Fppf51GuTlDV9NNsXJfR2Ny39ajWDY58lRAJc9kfkeD783+JAU3monPiSVteVhsBU4x6iKmpN3JVha3tv+I/TMIPf6FTYTLIzBTCTEMk6IOtX6XA=  ;
X-YMail-OSG: x7e1spEVM1kw4XVYnT7aZQENrGw8wKkQ5PoE3NAzbs8.ltZxOapcYzADYxoxrnIgdTtlGswtQ25Qot0Ks7wGAV3pqp7n12c45YAqs4a21FZqpV55AHc8R0BjKG_uJawe2DktZIL4P4uYHs7JoMw948Py
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] Remove cgroup member from struct page
Date: Tue, 9 Sep 2008 15:00:10 +1000
User-Agent: KMail/1.9.5
Cc: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       hugh@veritas.com, menage@google.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20080901161927.a1fe5afc.kamezawa.hiroyu@jp.fujitsu.com> <200809091358.28350.nickpiggin@yahoo.com.au> <20080909135317.cbff4871.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080909135317.cbff4871.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809091500.10619.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 14:53, KAMEZAWA Hiroyuki wrote:
> On Tue, 9 Sep 2008 13:58:27 +1000
>
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > On Tuesday 09 September 2008 13:57, KAMEZAWA Hiroyuki wrote:
> > > On Mon, 8 Sep 2008 20:58:10 +0530
> > >
> > > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > > Sorry for the delay in sending out the new patch, I am traveling and
> > > > thus a little less responsive. Here is the update patch
> > >
> > > Hmm.. I've considered this approach for a while and my answer is that
> > > this is not what you really want.
> > >
> > > Because you just moves the placement of pointer from memmap to
> > > radix_tree both in GFP_KERNEL, total kernel memory usage is not
> > > changed. So, at least, you have to add some address calculation (as I
> > > did in March) to getting address of page_cgroup. But page_cgroup itself
> > > consumes 32bytes per page. Then.....
> >
> > Just keep in mind that an important point is to make it more attractive
> > to configure cgroup into the kernel, but have it disabled or unused at
> > runtime.
>
> Hmm..kicking out 4bytes per 4096bytes if disabled ?

Yeah of course. 4 or 8 bytes. Everything adds up. There is nothing special
about cgroups that says it is allowed to use fields in struct page where
others cannot. Put it in perspective: we try very hard not to allocate new
*bits* in page flags, which is only 4 bytes per 131072 bytes.


> maybe a routine like SPARSEMEM is a choice.
>
> Following is pointer pre-allocation. (just pointer, not page_cgroup itself)
> ==
> #define PCG_SECTION_SHIFT	(10)
> #define PCG_SECTION_SIZE	(1 << PCG_SECTION_SHIFT)
>
> struct pcg_section {
> 	struct page_cgroup **map[PCG_SECTION_SHIFT]; //array of pointer.
> };
>
> struct page_cgroup *get_page_cgroup(unsigned long pfn)
> {
> 	struct pcg_section *sec;
> 	sec = pcg_section[(pfn >> PCG_SECTION_SHIFT)];
> 	return *sec->page_cgroup[(pfn & ((1 << PCG_SECTTION_SHIFT) - 1];
> }
> ==
> If we go extreme, we can use kmap_atomic() for pointer array.
>
> Overhead of pointer-walk is not so bad, maybe.
>
> For 64bit systems, we can find a way like SPARSEMEM_VMEMMAP.

Yes I too think that would be the ideal way to go to get the best of
performance in the enabled case. However Balbir I believe is interested
in memory savings if not all pages have cgroups... I don't know, I don't
care so much about the "enabled" case, so I'll leave you two to fight it
out :)
