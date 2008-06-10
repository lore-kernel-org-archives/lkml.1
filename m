Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbYFJRaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbYFJRaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 13:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbYFJRam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 13:30:42 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50720 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751903AbYFJRal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 13:30:41 -0400
Date: Tue, 10 Jun 2008 10:30:36 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Mundt <lethal@linux-sh.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Howells <dhowells@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
       mpm@selenic.com
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB, v2.
In-Reply-To: <20080602072706.GB28268@linux-sh.org>
Message-ID: <Pine.LNX.4.64.0806101027220.17093@schroedinger.engr.sgi.com>
References: <20080602072706.GB28268@linux-sh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2008, Paul Mundt wrote:

> +	page = virt_to_head_page(objp);
> +	if (!page)
> +		return 0;

virt_to_head_page cannot return NULL. virt_to_page also does not return 
NULL. pfn_valid() needs to be used to figure out if a page is valid. 
Otherwise the page struct reference that was returned may have 
PageReserved() set to indicate that it is not a valid page.

> +	 * The ksize() function is only guaranteed to work for pointers
> +	 * returned by kmalloc(). So handle arbitrary pointers, that we expect
> +	 * always to be compound pages, here.
> +	 */
> +	if (PageCompound(page))
> +		order = compound_order(page);

compund order returns 0 if you use compound_order() on a 
non compound page. No need for the PageCompound test.

