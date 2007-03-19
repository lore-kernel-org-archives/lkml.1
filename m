Return-Path: <linux-kernel-owner+w=401wt.eu-S966034AbXCSRb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966034AbXCSRb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 13:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030384AbXCSRb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 13:31:28 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43659 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966034AbXCSRb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 13:31:27 -0400
Date: Mon, 19 Mar 2007 19:31:26 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <clameter@sgi.com>
cc: akpm@linux-foundation.org, ast@domdv.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
In-Reply-To: <Pine.LNX.4.64.0703191007230.23929@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0703191915380.24129@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0703191022310.8671@sbz-30.cs.Helsinki.FI>
 <Pine.LNX.4.64.0703191007230.23929@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007, Christoph Lameter wrote:
> Hmmm.. kmem_cache_free is significantly different. One also needs to 
> specify the slab cache.

No, it really isn't. Why would we want kfree() to be special? It's only 
going to confuse people which results in bugs.

On Mon, 19 Mar 2007, Christoph Lameter wrote:
> Could we fix the BUG instead?

Yes, it should be fixed. But we still have a problem with block layer 
(and probably others) passing NULL to mempool_free. But where should we 
fix it if not slab? Is the problem ih bio_alloc_bioset() in fs/bio.c as 
it's leaving a ->bi_io_vec NULL? Or is it in bio_free() forgetting to 
check for NULL? Or maybe in mempool_free() in mm/mempool.c? It gets messy 
real quick because you do need to be able to say "this data is optional." 
Furthemore, the NULL sematics of kfree() are also useful for error 
handling.

It's much safer to deal with this at slab level so why leave it out?

			Pekka
