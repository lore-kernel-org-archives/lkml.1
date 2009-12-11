Return-Path: <linux-kernel-owner+w=401wt.eu-S1762154AbZLKCL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762154AbZLKCL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 21:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761625AbZLKCL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 21:11:27 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:60637 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760725AbZLKCL0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 21:11:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xi+sMJO8e69372PF8FgdQcpws987E6sjTXWfLQszeXcMGkmCWBrFZ9TsFZ8PYW9hD7
         3gUaPVGT1XRqpSEyu7Z4i5Ur0CMCZhlJ52NqiOv8P1Y+XnIS/6439JrT+9daxZ2gvN5+
         mjBNFhSSXREmuM4AAyTu6rCxSU2y5YdAa8OMU=
MIME-Version: 1.0
In-Reply-To: <20091210163429.2568.A69D9226@jp.fujitsu.com>
References: <20091210154822.2550.A69D9226@jp.fujitsu.com>
	 <20091210163429.2568.A69D9226@jp.fujitsu.com>
Date: Fri, 11 Dec 2009 11:11:33 +0900
Message-ID: <28c262360912101811x1d76d1c3v46ff6773620f94a2@mail.gmail.com>
Subject: Re: [RFC][PATCH v2 8/8] Don't deactivate many touched page
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Larry Woodman <lwoodman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kosaki.

On Thu, Dec 10, 2009 at 4:35 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Changelog
>  o from v1
>   - Fix comments.
>   - Rename too_many_young_bit_found() with too_many_referenced()
>     [as Rik's mention].
>  o from andrea's original patch
>   - Rebase topon my patches.
>   - Use list_cut_position/list_splice_tail pair instead
>     list_del/list_add to make pte scan fairness.
>   - Only use max young threshold when soft_try is true.
>     It avoid wrong OOM sideeffect.
>   - Return SWAP_AGAIN instead successful result if max
>     young threshold exceed. It prevent the pages without clear
>     pte young bit will be deactivated wrongly.
>   - Add to treat ksm page logic
>
> Many shared and frequently used page don't need deactivate and
> try_to_unamp(). It's pointless while VM pressure is low, the page
> might reactivate soon. it's only makes cpu wasting.
>
> Then, This patch makes to stop pte scan if wipe_page_reference()
> found lots young pte bit.
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Reviewed-by: Rik van Riel <riel@redhat.com>
> ---
>  include/linux/rmap.h |   18 ++++++++++++++++++
>  mm/ksm.c             |    4 ++++
>  mm/rmap.c            |   19 +++++++++++++++++++
>  3 files changed, 41 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index 499972e..ddf2578 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -128,6 +128,24 @@ int wipe_page_reference_one(struct page *page,
>                            struct page_reference_context *refctx,
>                            struct vm_area_struct *vma, unsigned long address);
>
> +#define MAX_YOUNG_BIT_CLEARED 64
> +/*

This idea is good at embedded system which don't have access bit by hardware.

Such system emulates access bit as minor page fault AFAIK.
It means when VM clears young bit, kernel mark page table as non-permission
or something for refaulting.
So when next touch happens that address, kernel can do young bit set again.
It would be rather costly operation than one which have access bit by hardware.

So  this idea is good in embedded system.
But 64 is rather big. many embedded system don't have many processes.
So I want to scale this number according to memory size like
inactive_raio for example.

Thanks for good idea and effort. :)

-- 
Kind regards,
Minchan Kim
