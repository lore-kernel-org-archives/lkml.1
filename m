Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbXFKTHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbXFKTHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 15:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbXFKTHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 15:07:40 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:39148 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754133AbXFKTHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 15:07:39 -0400
Date: Mon, 11 Jun 2007 12:07:38 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Eric Sesterhenn / Snakebyte <snakebyte@gmx.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: profiling likely/unlikely in slub.c
In-Reply-To: <20070611185608.GB4592@alice>
Message-ID: <Pine.LNX.4.64.0706111205330.19316@schroedinger.engr.sgi.com>
References: <20070611185608.GB4592@alice>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2007, Eric Sesterhenn / Snakebyte wrote:

> 
> +unlikely | 40969931|  6228144  __slab_free()@:mm/slub.c@1606
> +unlikely | 47198075|        0  __slab_free()@:mm/slub.c@1599
> -likely   |        0| 47198075  slab_free()@:mm/slub.c@1660
> +unlikely | 47280864|        0  __slab_alloc()@:mm/slub.c@1475
> +unlikely |    26857|        0  new_slab()@:mm/slub.c@1107
> +unlikely | 47280864|        0  slab_alloc()@:mm/slub.c@1557
> 
> three of the unlikely cases are caused by "if (unlikely(SlabDebug(page)))"
> if SLUB_DEBUG is turned off, it really is unlikely, since SlabDebug()
> always returns 0, if SLUB_DEBUG is turned on it is likely (not sure if there are
> cases where it can return 0) therefore it makes sense to change this
> to likely for the SLUB_DEBUG case. 
> 
> The following patch changes the SlabDebug() functions to defines, so gcc
> can easily optimize the if away entirely and changes the unlikely() to a
> likely().
> 
> Remaining problem is, that if likely/unlikely profiling is turned on,
> gcc does not optimize away a likely(0), and they still show up in the
> stats... guess heisenbug is involved in this :-)

There is a fundamental misunderstanding here to think that SLUB_DEBUG 
would enable debugging. Not true. Debugging is enabled by booting with
"slub_debug".


It is true that SlabDebug() is always false if !CONFIG_SLUB_DEBUG. That is 
only the case for embedded systems that want to conserve memory.
