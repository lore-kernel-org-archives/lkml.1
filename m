Return-Path: <linux-kernel-owner+w=401wt.eu-S1762830AbZAHUDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762830AbZAHUDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:03:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758150AbZAHUDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:03:25 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:43395 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757418AbZAHUDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:03:24 -0500
Subject: Re: 2.6.28-rc9 panics with crashkernel=256M while booting
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Chandru <chandru@in.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <200901081559.22204.chandru@in.ibm.com>
References: <200812241325.49404.chandru@in.ibm.com>
	 <200901071828.13719.chandru@in.ibm.com> <1231349125.23462.81.camel@nimitz>
	 <200901081559.22204.chandru@in.ibm.com>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 12:03:12 -0800
Message-Id: <1231444992.23462.138.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-08 at 15:59 +0530, Chandru wrote:
> @@ -898,9 +899,17 @@ static void mark_reserved_regions_for_ni
>                          * if reserved region extends past active region
>                          * then trim size to active region
>                          */
> -                       if (end_pfn > node_ar.end_pfn)
> +                       if (end_pfn > node_ar.end_pfn) {
>                                 reserve_size = (node_ar.end_pfn << PAGE_SHIFT)
>                                         - (start_pfn << PAGE_SHIFT);
> +                               /*
> +                                * resize it further if the reservation could
> +                                * cross the last page in this node
> +                                */
> +                               if (PFN_UP(physbase+reserve_size) >
> +                                                node_end_pfn)
> +                                       reserve_size -= PAGE_SIZE;
> +                       }
>                         /*

Now I'm even more confused.  Could you please send a fully changelogged
patch that describes the problem, and how this fixes it?  This just
seems like an off-by-one error, which isn't what I thought we had before
at all.

I'm also horribly confused why PFN_UP is needed here.  Is 'physbase' not
page aligned?  reserve_size looks like it *has* to be.  'end_pfn' is
always (as far as I have ever seen in the kernel) the pfn of the page
after the area we are interested in and we treat it as such in that
function.  In the case of an unaligned physbase, that wouldn't be true.

Think of the case where we have a 1-byte reservation.  start_pfn will
equal end_pfn and we won't go into that while loop at *all* and won't
reserve anything.

Does 'end_pfn' need fixing?

-- Dave

