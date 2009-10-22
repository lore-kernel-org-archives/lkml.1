Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbZJVMgC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbZJVMgC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 08:36:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754970AbZJVMgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 08:36:01 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:21511 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbZJVMgA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 08:36:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sZ1EGLQl34fW1pm0WGjhRpRUFBDfZk+ppW88PbMJgaEx3qjKv5ZeHglwrzCuDoWg/H
         Mq+q45rXUpkK5e3XNw984lqHSTKDOnwK1/tlnPmaSPuMny+3Wg/5mZhsQRz4FKc8FqVy
         RtPtW6Z6gU+tDhhThWry6LSXH/58WzShZtNQY=
MIME-Version: 1.0
In-Reply-To: <20091022105902.GM11778@csn.ul.ie>
References: <20091020153838.665bc39c.skraw@ithnet.com>
	 <alpine.LRH.2.00.0910211848510.20992@twin.jikos.cz>
	 <alpine.DEB.2.00.0910211409390.20010@chino.kir.corp.google.com>
	 <20091022105902.GM11778@csn.ul.ie>
Date: Thu, 22 Oct 2009 15:36:04 +0300
X-Google-Sender-Auth: 336d2711fe6f3f22
Message-ID: <84144f020910220536k61d43e95x802c2391459e4305@mail.gmail.com>
Subject: Re: page allocation failure message kernel 2.6.31.4 (tty-related)
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: David Rientjes <rientjes@google.com>, Jiri Kosina <jkosina@suse.cz>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Frans Pop <elendil@planet.nl>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 1:59 PM, Mel Gorman <mel@csn.ul.ie> wrote:
>> There's subtleties like where rt tasks are given ALLOC_HARDER even when
>> in_interrupt() that are different from previous kernels and could reduce
>> the amount of ALLOC_HIGH and ALLOC_HARDER memory that can be allocated.
>>
>
> /me checks again
>
> I think you're right. Correct it with something like?
>
> ==== CUT HERE ====
> From bca71e94e10cd93771ec5b17eccb817dd0c85360 Mon Sep 17 00:00:00 2001
> From: Mel Gorman <mel@csn.ul.ie>
> Date: Thu, 22 Oct 2009 11:55:14 +0100
> Subject: [PATCH] page allocator: Do not allow interrupts to use ALLOC_HARDER
>
> Commit 341ce06f69abfafa31b9468410a13dbd60e2b237 altered watermark logic
> slightly by allowing rt_tasks that are handling an interrupt to set
> ALLOC_HARDER. This patch brings the watermark logic more in line with
> 2.6.30.
>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Good catch.

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>

Can we have some of the people that are hitting the OOM problems test
this patch in combination with this patch:

http://patchwork.kernel.org/patch/54215/

Mel, can you also resend these page allocator patches to Andrew? I
haven't seen him pick the above patch in -mm and we probably want to
get fixes into -stable soon because distributors seem to be basing
their next releases on 2.6.31...

> ---
>  mm/page_alloc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index a3e5fed..3ecf819 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1769,7 +1769,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
>                 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
>                 */
>                alloc_flags &= ~ALLOC_CPUSET;
> -       } else if (unlikely(rt_task(p)))
> +       } else if (unlikely(rt_task(p)) && !in_interrupt())
>                alloc_flags |= ALLOC_HARDER;
>
>        if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
