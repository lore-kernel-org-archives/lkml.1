Return-Path: <linux-kernel-owner+w=401wt.eu-S2992680AbXEBD6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992680AbXEBD6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 23:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992692AbXEBD6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 23:58:08 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53174 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992680AbXEBD6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 23:58:06 -0400
Date: Tue, 1 May 2007 20:58:02 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nate Diller <nate.diller@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] zero_user_page uses in fs/buffer.c and fs/libfs.c
In-Reply-To: <5c49b0ed0705011927n66208c1egd7cfdb6985dc901b@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705012046120.28655@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704292313060.3018@schroedinger.engr.sgi.com> 
 <a781481a0704292353v34ea217fpbbf732465dd652e8@mail.gmail.com> 
 <Pine.LNX.4.64.0704300000430.3147@schroedinger.engr.sgi.com> 
 <20070501172643.270bb061.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0705011807550.28210@schroedinger.engr.sgi.com> 
 <5c49b0ed0705011916y89212c0v1cec1cb1edae052f@mail.gmail.com>
 <5c49b0ed0705011927n66208c1egd7cfdb6985dc901b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007, Nate Diller wrote:

> well, leave it to me to reply too quickly, sorry.  i think we should
> leave simple_prepare_write() the way it is, since it's a library
> function itself.  the other two callsites in your patch are buffers,
> which may themselves be smaller than a page so you would need a
> special function for just those two uses, there's no other way to
> avoid making two calls to flush_dcache_page().  if it's tremendously
> important to you to eliminate open coding of these, maybe make a
> 'static int buffer_prepare_write()' or some such in fs/buffer.c

All three sites zap two parts of a page. If we had a 
zero_user_page2 like this

zero_user_page2(page, start1, end1, start2, end2, kmap)

then all 3 sites could use the same funtion.

libfs.c:

zero_user_page_segments(page, 0, from, to, PAGE_CACHE_SIZE, KM_USER0);

buffer.c:

zero_user_page_segments(page, from, block_start, to, block_end, KM_USER0)

zero_user_page_segments(page, blockstart, from, to, block_end, KM_USER0)


I did not look through the whole kernel but this zapping segments is 
likely frequent given the nature of the blocklayer.

The 3 call sites pretty ugly on their own. I think it would be good 
to have one clearly commented version of this somewhere. Call sites
will be much clearer since you do not have the kmap_ obfuscation nor
the calculation of the length of each segment.

