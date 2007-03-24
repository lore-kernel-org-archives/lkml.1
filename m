Return-Path: <linux-kernel-owner+w=401wt.eu-S933140AbXCXXtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140AbXCXXtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 19:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932910AbXCXXtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 19:49:22 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:11047 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933140AbXCXXtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 19:49:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=FgUAZqJ5TH9RDlg7Hx/t8aD74SvI4r9eaMBAcC9Z8xZ6Wi0LHh+U5YxyIOc4x17pFDLpuycrQYvDjSWw07UtoAFrfRUKXPuOty9xOh4h3+dBW13DSdV4LD442I3Z4qWYg+KjL6USyf0h+hRapmua2uhHeanw72vwMLXUT8GcYPI=
Message-ID: <5800c1cc0703241649q27157d9aid3d9d51b52efbf65@mail.gmail.com>
Date: Sun, 25 Mar 2007 07:49:20 +0800
From: "Bin Chen" <binary.chen@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: kmem_cache_create loop for find the proper gfporder
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have some doubts about the loop to find the gfporder of a cache. For
the code below, its main purpose is to find a gfporder value that can
make the internal fragmentation less that 1/8 of the total slab size.
It is done by increase gfporder for low number to high(possibly 0 to
MAX_GFP_ORDER). But why increase the gfporder(or slab size) can
decrease the internal fragmentation?)

A simple example, suppose the slab management stuff is kept off-slab,
if the gfporder is zero, and the object size in slab is 1000, the
wasted space is 4096 mod 1000 = 96, but with 4096 * 2(increase
gfporder by 1), the space is 8192 mod 1000 = 192, 192 > 96.

Is it right?

By the way, is the first time gfporder is 0? Who initialized it in
cache_cache?

        /* Cal size (in pages) of slabs, and the num of objs per slab.
         * This could be made much more intelligent.  For now, try to avoid
         * using high page-orders for slabs.  When the gfp() funcs are more
         * friendly towards high-order requests, this should be changed.
         */
        do {
                unsigned int break_flag = 0;
cal_wastage:
                kmem_cache_estimate(cachep->gfporder, size, flags,
                                                &left_over, &cachep->num);
                if (break_flag)
                        break;
                if (cachep->gfporder >= MAX_GFP_ORDER)
                        break;
                if (!cachep->num)
                        goto next;
                if (flags & CFLGS_OFF_SLAB && cachep->num > offslab_limit) {
                        /* Oops, this num of objs will cause problems. */
                        cachep->gfporder--;
                        break_flag++;
                        goto cal_wastage;
                }

                /*
                 * Large num of objs is good, but v. large slabs are currently
                 * bad for the gfp()s.
                 */
                if (cachep->gfporder >= slab_break_gfp_order)
                        break;

                if ((left_over*8) <= (PAGE_SIZE<<cachep->gfporder))
                        break;  /* Acceptable internal fragmentation. */
next:
                cachep->gfporder++;
        } while (1);
