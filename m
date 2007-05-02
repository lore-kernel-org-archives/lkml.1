Return-Path: <linux-kernel-owner+w=401wt.eu-S2992702AbXEBEKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992702AbXEBEKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 00:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992705AbXEBEKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 00:10:06 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992702AbXEBEKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 00:10:03 -0400
Date: Tue, 1 May 2007 21:09:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nate Diller <nate.diller@gmail.com>,
       Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] zero_user_page uses in fs/buffer.c and fs/libfs.c
Message-Id: <20070501210955.d2c3d682.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705012046120.28655@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704292313060.3018@schroedinger.engr.sgi.com>
	<a781481a0704292353v34ea217fpbbf732465dd652e8@mail.gmail.com>
	<Pine.LNX.4.64.0704300000430.3147@schroedinger.engr.sgi.com>
	<20070501172643.270bb061.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705011807550.28210@schroedinger.engr.sgi.com>
	<5c49b0ed0705011916y89212c0v1cec1cb1edae052f@mail.gmail.com>
	<5c49b0ed0705011927n66208c1egd7cfdb6985dc901b@mail.gmail.com>
	<Pine.LNX.4.64.0705012046120.28655@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007 20:58:02 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> On Tue, 1 May 2007, Nate Diller wrote:
> 
> > well, leave it to me to reply too quickly, sorry.  i think we should
> > leave simple_prepare_write() the way it is, since it's a library
> > function itself.  the other two callsites in your patch are buffers,
> > which may themselves be smaller than a page so you would need a
> > special function for just those two uses, there's no other way to
> > avoid making two calls to flush_dcache_page().  if it's tremendously
> > important to you to eliminate open coding of these, maybe make a
> > 'static int buffer_prepare_write()' or some such in fs/buffer.c
> 
> All three sites zap two parts of a page. If we had a 
> zero_user_page2 like this
> 
> zero_user_page2(page, start1, end1, start2, end2, kmap)
> 
> then all 3 sites could use the same funtion.
> 
> libfs.c:
> 
> zero_user_page_segments(page, 0, from, to, PAGE_CACHE_SIZE, KM_USER0);
> 
> buffer.c:
> 
> zero_user_page_segments(page, from, block_start, to, block_end, KM_USER0)
> 
> zero_user_page_segments(page, blockstart, from, to, block_end, KM_USER0)
> 

yup.  And perhaps zero_user_page() becomes a caller to
zero_user_page_segments() if we're sure that the compiler will dtrt.

> 
> I did not look through the whole kernel but this zapping segments is 
> likely frequent given the nature of the blocklayer.
> 
> The 3 call sites pretty ugly on their own. I think it would be good 
> to have one clearly commented version of this somewhere. Call sites
> will be much clearer since you do not have the kmap_ obfuscation nor
> the calculation of the length of each segment.

Sure.
