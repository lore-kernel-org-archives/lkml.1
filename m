Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbYIQXuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbYIQXuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 19:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbYIQXuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 19:50:09 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:7843 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbYIQXuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 19:50:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SlLkljGMs1CdHn8pTkI6ntc/T/wLYwcSm1VdVRBz/jJACu4V6CuyWFMAjs6Clqz3kL
         CEdv91Se53Oy/KAjXOsINs7IGqHquudJNzLSWEojwmcbXSzSuvJbKixcUqHD7+RQNfAm
         Cg+luhRX7iJFHMe3o/m9QCAefA9T8PitiJxz8=
Message-ID: <28c262360809171650g1395bbe2ya4e560851d37760d@mail.gmail.com>
Date: Thu, 18 Sep 2008 08:50:05 +0900
From: "MinChan Kim" <minchan.kim@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>, "Rik van Riel" <riel@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Populating multiple ptes at fault time
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>, "Hugh Dickens" <hugh@veritas.com>,
       "Linux Memory Management List" <linux-mm@kvack.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Avi Kivity" <avi@qumranet.com>
In-Reply-To: <48D142B2.3040607@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48D142B2.3040607@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

I have been thinking about this idea in native.
I didn't consider it in minor page fault.
As you know, it costs more cheap than major fault.
However, the page fault is one of big bottleneck on demand-paging system.
I think major fault might be a rather big overhead in many core system.

What do you think about this idea in native ?
Do you really think that this idea don't help much in native ?

If I implement it in native, What kinds of benchmark do I need?
Could you recommend any benchmark ?


On Thu, Sep 18, 2008 at 2:47 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Avi and I were discussing whether we should populate multiple ptes at
> pagefault time, rather than one at at time as we do now.
>
> When Linux is operating as a virtual guest, pte population will
> generally involve some kind of trap to the hypervisor, either to
> validate the pte contents (in Xen's case) or to update the shadow
> pagetable (kvm).  This is relatively expensive, and it would be good to
> amortise the cost by populating multiple ptes at once.
>
> Xen and kvm already batch pte updates where multiple ptes are explicitly
> updated at once (mprotect and unmap, mostly), but in practise that's
> relatively rare.  Most pages are demand faulted into a process one at a
> time.
>
> It seems to me there are two cases: major faults, and minor faults:
>
> Major faults: the page in question is physically missing, and so the
> fault invokes IO.  If we blindly pull in a lot of extra pages that are
> never used, then we'll end up wasting a lot of memory.  However, page at
> a time IO is pretty bad performance-wise too, so I guess we do clustered
> fault-time IO?  If we can distinguish between random and linear fault
> patterns, then we can use that as a basis for deciding how much
> speculative mapping to do.  Certainly, we should create mappings for any
> nearby page which does become physically present.
>
> Minor faults are easier; if the page already exists in memory, we should
> just create mappings to it.  If neighbouring pages are also already
> present, then we can can cheaply create mappings for them too.
>
>
> This seems like an obvious idea, so I'm wondering if someone has
> prototyped it already to see what effects there are.  In the native
> case, pte updates are much cheaper, so perhaps it doesn't help much
> there, though it would potentially reduce the number of faults needed.
> But I think there's scope for measurable benefits in the virtual case.
>
> Thanks,
>    J
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Kinds regards,
MinChan Kim
