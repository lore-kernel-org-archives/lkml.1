Return-Path: <linux-kernel-owner+w=401wt.eu-S1763370AbYEVXmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763370AbYEVXmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 19:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758997AbYEVXmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 19:42:22 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:27897 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758548AbYEVXmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 19:42:22 -0400
Date: Fri, 23 May 2008 08:40:36 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: dhowells@redhat.com, clameter@sgi.com, mpm@selenic.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
Message-ID: <20080522234036.GA18434@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Pekka J Enberg <penberg@cs.helsinki.fi>, dhowells@redhat.com,
	clameter@sgi.com, mpm@selenic.com, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0805221907250.4056@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805221907250.4056@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 07:09:04PM +0300, Pekka J Enberg wrote:
> Index: slab-2.6/mm/nommu.c
> ===================================================================
> --- slab-2.6.orig/mm/nommu.c	2008-05-22 18:59:01.000000000 +0300
> +++ slab-2.6/mm/nommu.c	2008-05-22 19:00:36.000000000 +0300
> @@ -109,12 +109,22 @@
>  	 * If the object we have should not have ksize performed on it,
>  	 * return size of 0
>  	 */
> -	if (!objp || (unsigned long)objp >= memory_end || !((page = virt_to_page(objp))))
> +	if (!objp)
> +		return 0;
> +
> +	if ((unsigned long) objp >= memory_end)
> +		return 0;
> +
> +	page = virt_to_head_page(objp);
> +	if (!page)
>  		return 0;
>  
>  	if (PageSlab(page))
>  		return ksize(objp);
>  
Is ksize() happy with taking the head page instead of virt_to_page(objp)?
