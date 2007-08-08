Return-Path: <linux-kernel-owner+w=401wt.eu-S938057AbXHHRqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938057AbXHHRqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936932AbXHHRqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:46:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58000 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935869AbXHHRqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:46:01 -0400
Date: Wed, 8 Aug 2007 10:39:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Matt Mackall <mpm@selenic.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
Subject: Re: [PATCH 04/10] mm: slub: add knowledge of reserve pages
Message-Id: <20070808103946.4cece16c.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0708081004290.12652@schroedinger.engr.sgi.com>
References: <20070806102922.907530000@chello.nl>
	<20070806103658.603735000@chello.nl>
	<Pine.LNX.4.64.0708071702560.4941@schroedinger.engr.sgi.com>
	<20070808014435.GG30556@waste.org>
	<Pine.LNX.4.64.0708081004290.12652@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007 10:13:05 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> I think there are two ways to address this in a simpler way:
> 
> 1. Allow recursive calls into reclaim. If we are in a PF_MEMALLOC context 
> then we can still scan lru lists and free up memory of clean pages. Idea 
> patch follows.
> 
> 2. Make pageout figure out if the write action requires actual I/O 
> submission. If so then the submission will *not* immediately free memory 
> and we have to wait for I/O to complete. In that case do not immediately
> initiate I/O (which would not free up memory and its bad to initiate 
> I/O when we have not enough free memory) but put all those pages on a 
> pageout list. When reclaim has reclaimed enough memory then go through the 
> pageout list and trigger I/O. That can be done without PF_MEMALLOC so that 
> additional reclaim could be triggered as needed. Maybe we can just get rid 
> of PF_MEMALLOC and some of the contorted code around it?

3.  Perform page reclaim from hard IRQ context.  Pretty simple to
implement, most of the work would be needed in the rmap code.  It might be
better to make it opt-in via a new __GFP_flag.

