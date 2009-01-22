Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbZAVA3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbZAVA3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 19:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbZAVA3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 19:29:46 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60980 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195AbZAVA3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 19:29:45 -0500
Subject: Re: 2.6.28-rc9 panics with crashkernel=256M while booting
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Chandru <chandru@in.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <200901191700.03580.chandru@in.ibm.com>
References: <200812241325.49404.chandru@in.ibm.com>
	 <200901161746.36584.chandru@in.ibm.com> <1232128377.27278.69.camel@nimitz>
	 <200901191700.03580.chandru@in.ibm.com>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 16:29:39 -0800
Message-Id: <1232584180.27278.86.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-19 at 17:00 +0530, Chandru wrote:
> --- linux-2.6.29-rc2/arch/powerpc/mm/numa.c.orig	2009-01-19 16:14:49.000000000 +0530
> +++ linux-2.6.29-rc2/arch/powerpc/mm/numa.c	2009-01-19 16:36:38.000000000 +0530
> @@ -901,7 +901,8 @@ static void mark_reserved_regions_for_ni
>  		get_node_active_region(start_pfn, &node_ar);
>  		while (start_pfn < end_pfn &&
>  			node_ar.start_pfn < node_ar.end_pfn) {
> -			unsigned long reserve_size = size;
> +			unsigned long reserve_size = (size >> PAGE_SHIFT) <<
> +								PAGE_SHIFT;
>  			/*
>  			 * if reserved region extends past active region
>  			 * then trim size to active region
> @@ -917,7 +918,8 @@ static void mark_reserved_regions_for_ni
>  				dbg("reserve_bootmem %lx %lx nid=%d\n",
>  					physbase, reserve_size, node_ar.nid);
>  				reserve_bootmem_node(NODE_DATA(node_ar.nid),
> -						physbase, reserve_size,
> +						(start_pfn << PAGE_SHIFT),
> +						reserve_size,
>  						BOOTMEM_DEFAULT);
>  			}
>  			/*

Chandru, I don't mean to keep ragging on your patches, but I really
don't think this is right, yet.

Let's take, for instance, a 1-byte reservation.  With this code, you've
suddenly turned that into a 0-byte reservation, and that *can't* be
right.  The same thing happens if you have a reservation that spans two
pages.  If you unconditionally round it down, then you might miss the
part that spans a portion of the second page.

It needs to be rounded down like you are suggesting here, but only in
the case where we've gone over the *CURRENT* node's boundary.  This is
kinda what that "if (end_pfn > node_ar.end_pfn)" check is doing.  But,
it evidently screws it up if the overlap isn't by an entire page or
something.

Please also, for pete's sake, use masks (a la PAGE_MASK) or macros if
you're going to page-align something.  Don't shift down and up like
that.  

-- Dave

