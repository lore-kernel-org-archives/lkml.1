Return-Path: <linux-kernel-owner+w=401wt.eu-S1757008AbYCNRhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008AbYCNRhE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 13:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbYCNRgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 13:36:53 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:28932 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbYCNRgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 13:36:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SVocN5qJBVIt4daL78OcVdL5XZWii4lFzKOmaL/4bIW4EvHoQ326qi6j4l3acjypABiNAEm0Z/KcHLAY3T8uN9DUSDmLCC+z4ts18pHUX9zoeRZ1//AcZQDxFftrSJ1mTq6kxQUQ45wIxzbp+Fq16IfcicVOUbBT4eQKl01ccqg=
Message-ID: <86802c440803141036m4a508a91o2cf6706157231429@mail.gmail.com>
Date: Fri, 14 Mar 2008 10:36:52 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] mm: fix boundary checking in free_bootmem_core
Cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       mingo@elte.hu, clameter@sgi.com, linux-kernel@vger.kernel.org,
       "Yasunori Goto" <y-goto@jp.fujitsu.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080314165336.GS2522@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440803111801m20349386l58a108cec13eb5ee@mail.gmail.com>
	 <86802c440803121811i262b21bdrfb07df52fd27aaae@mail.gmail.com>
	 <20080312182240.db32c858.akpm@linux-foundation.org>
	 <200803132259.47063.ak@suse.de>
	 <86802c440803131522t3d038d39gbe8eb0d38ddcb634@mail.gmail.com>
	 <87iqzp5xfv.fsf@basil.nowhere.org>
	 <86802c440803140944p302b300fy7515fb758221932b@mail.gmail.com>
	 <20080314165336.GS2522@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 9:53 AM, Andi Kleen <andi@firstfloor.org> wrote:
> On Fri, Mar 14, 2008 at 09:44:50AM -0700, Yinghai Lu wrote:
>  > On 14 Mar 2008 12:58:44 +0100, Andi Kleen <andi@firstfloor.org> wrote:
>  > > "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>  > >  >
>  > >  > then i tried to reserve 64M or 128M RAM before that, and free that
>  > >  > before gart/switotble try to allloc_bootmem under 4g.
>  > >
>  > >  Sounds like an incredible hack. There are far better ways to do that
>  > >  for bootmem allocations. e.g. you can just specify a high enough "goal"
>  > >  That is how swiotlb solves a similar problem (at least before my
>  > >  mask allocator rewrite)
>  >
>  > I don't think so.
>  >
>  > anyway, otherway to workaround it is
>  > change
>  >                 return __earlyonly_bootmem_alloc(node, size, size,
>  >                                 __pa(MAX_DMA_ADDRESS));
>  > in vmemmap_alloc_block to
>  >                 return __earlyonly_bootmem_alloc(node, size, size,
>  >                                 __pa(MAX_DMA_ADDRESS + (1<<27)));
>  > to make room for gart. but that is global change. and may affect other
>  > platform.
>
>  You can just make it an optional architecture defined macro
it is hard to use MACRO, if someone have allsysconfig, that will make
kernel code use a lot.
>
>
>  > and don't make sure gart will get it.
>
>  Has nothing to do with the gart?
>
>
>
>  >
>  > also i assume swiotlb need that range is less than 4g.
>
>  The normal rule is that anybody who needs big bootmem allocations
>  need to make sure they're high enough to not fill up first 4GB.
>  For small allocations like most of bootmem it doesn't matter because
>  they're, um, small.
>
>  If vmemmap doesn't do that vmemmap needs to be fixed.

how to define big?
it has hundreds of 2M block. when numa is on, they span on all nodes,
and if numa is off, they are sitting on first_online_node.

YH
