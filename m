Return-Path: <linux-kernel-owner+w=401wt.eu-S1757927AbYCMWWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbYCMWWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756611AbYCMWWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:22:40 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:38066 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbYCMWWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:22:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bLtASkbtMnLsoHtTacxKNPqD8Cr++vkK8MhZXQP9FcORYsilQngXoRAAfX3XV+L9xIU6BQx3W0CXqYH4CiHcHTs9VujKPcK++0ZgD/g5l5aGI36BuxUFaJ9V0MC0wmNfvy8+hBbjmYhzAx6Vxjc8PDxbyqU29LsIQ6+SjmZQwzY=
Message-ID: <86802c440803131522t3d038d39gbe8eb0d38ddcb634@mail.gmail.com>
Date: Thu, 13 Mar 2008 15:22:39 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] mm: fix boundary checking in free_bootmem_core
Cc: "Andrew Morton" <akpm@linux-foundation.org>, mingo@elte.hu,
       clameter@sgi.com, linux-kernel@vger.kernel.org,
       "Yasunori Goto" <y-goto@jp.fujitsu.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200803132259.47063.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440803111801m20349386l58a108cec13eb5ee@mail.gmail.com>
	 <86802c440803121811i262b21bdrfb07df52fd27aaae@mail.gmail.com>
	 <20080312182240.db32c858.akpm@linux-foundation.org>
	 <200803132259.47063.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 2:59 PM, Andi Kleen <ak@suse.de> wrote:
> On Thursday 13 March 2008 02:22:40 Andrew Morton wrote:
>  > On Wed, 12 Mar 2008 18:11:41 -0700 "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>  >
>  > > >  <looks at it>
>  > > >
>  > > >  Sorry, but I find the changelog very hard to amke sense of.  I presently
>  > > >  have:
>  > > >
>  > > >
>  > > >   So call it when numa is enabled, we don't know which node have that
>  > > >   range.  and make it more robust.
>  > > >
>  > > >   Try to trim it to get valid sidx, and eidx.
>  > > >
>  > > >  Could you please expand on this?
>  > >
>  > > please check following...
>  > >
>  >
>  > Heaps better, thanks ;)  Below is what I now have.
>  >
>  > (cc's people)
>  >
>  > Guys, could you please review this?  Maybe test it a bit?
>  >
>  > Thanks.
>  >
>  >
>  > From: "Yinghai Lu" <yhlu.kernel@gmail.com>
>  >
>  > With numa enabled, some callers could have a range o fmemory on one node but
>  > try to free that on other node.  This can cause some pages to be freed
>  > wrongly.
>
>  Concrete examples?
>
>  If that happens it's really just a problem that the bootmem API
>  is wrong. I was always annoyed by the hardcoded NODE_DATA(0)s in
>  free_bootmem.
>
>  I would suggest if that happens you just fix free_bootmem to search
>  for the correct node instead of hardcoding 0 and then eliminate
>  free_bootmem_node() everywhere and replace it with free_bootmem()
>
> >
>  > For example: when we try to allocate 128g boot ram early for gart/swiotlb, and
>  > free that range later so gart/swiotlb can get some range afterwards.
>
>  I'm confused by the example. AFAIK there is no memory freeing in either
>  gart nor swiotlb. At least there wasn't until very recently.

For big system when numa=off or disabled, vmemmap will use 3.6g ram
when you have 256g. if you don't allocate the PMD continuous.

then i tried to reserve 64M or 128M RAM before that, and free that
before gart/switotble try to allloc_bootmem under 4g.

that patch will make the system without ram on node0 not happy.
because of free_bootmem is hardcoded to use node0.

>
>
>  >
>  > With this patch, we don't need to care which node holds the range, just loop
>  > to call free_bootmem_node for all online nodes.
>  >
>  > This patch make free_bootmem_core() more robust by trimming the sidx and eidx
>  > according the ram range that the node has.
>
>  I think you should just kill free_bootmem_node() and replace it everywhere
>  with your improved free_bootmem()

using phys_to_nid()? it seems we only have that on x86_64.

also there is assumpation that reserve_bootmem_node, reserver_bootmem
can not cross the nodes.
I want to remove that constrient too.


YH
