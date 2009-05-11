Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbZEKOAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbZEKOAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbZEKOAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:00:45 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:6861 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbZEKOAo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:00:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=g3xlb2WZK51mHrvgCHC800aH12/GTS25OlOTDY1cnb3o1pV5FFDRML3hOPMLanDYL/
         MiQ+0cVIaK6rBdMye8AjlpQ3zblQ54qIOo8bqG4JVLnp4zRRde8PBUZisl+IpAhZ0V/x
         J78499nOa1cBdlKuHVl/oWr2T2oDxl9ODdIEc=
MIME-Version: 1.0
In-Reply-To: <20090511133840.GA11624@csn.ul.ie>
References: <alpine.DEB.2.00.0905091544470.6884@chino.kir.corp.google.com>
	 <20090511162900.f372edd1.minchan.kim@barrios-desktop>
	 <alpine.DEB.2.00.0905110138160.24726@chino.kir.corp.google.com>
	 <28c262360905110212j9867b79wd8d90b16f6f196be@mail.gmail.com>
	 <28c262360905110421g1b079f2cr798ca95adfb8ee45@mail.gmail.com>
	 <20090511133840.GA11624@csn.ul.ie>
Date: Mon, 11 May 2009 23:00:44 +0900
Message-ID: <28c262360905110700p68f3de35xf0a1d52d2ccfd968@mail.gmail.com>
Subject: Re: [patch -mmotm] mm: invoke oom killer for __GFP_NOFAIL
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mel.

On Mon, May 11, 2009 at 10:38 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Mon, May 11, 2009 at 08:21:21PM +0900, Minchan Kim wrote:
>> On Mon, May 11, 2009 at 6:12 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
>> > On Mon, May 11, 2009 at 5:40 PM, David Rientjes <rientjes@google.com> wrote:
>> >> On Mon, 11 May 2009, Minchan Kim wrote:
>> >>
>> >>> Hmm.. if __alloc_pages_may_oom fail to allocate free page due to order > PAGE_ALLOC_COSTRY_ORDER,
>> >>>
>> >>> It will go to nopage label in __alloc_pages_slowpath.
>> >>> Then it will show the page allocation failure warning and will return.
>> >>> Retrying depends on caller.
>> >>>
>> >>
>> >> Correct.
>> >>
>> >>> So, I think it won't loop forever.
>> >>> Do I miss something ?
>> >>>
>> >>
>> >> __GFP_NOFAIL allocations shouldn't fail, that's the point of the gfp flag.
>> >> So failing without attempting to free some memory is the wrong thing to
>> >> do.
>> >
>> > Thanks for quick reply.
>> > I was confused by your description.
>> > I thought you suggested we have to prevent loop forever.
>> >
>> >>
>> >>> In addition, the OOM killer can help for getting the high order pages ?
>> >>>
>> >>
>> >> Sure, if it selects a task that will free a lot of memory, which is it's
>> >> goal.
>> >>
>> >
>> > How do we know any task have a lot of memory ?
>> > If we select wrong task and kill one ?
>> >
>> > I have a concern about innocent task.
>>
>> Now, I look over __out_of_memory.
>> For selecting better tasks in case of PAGE_ALLOC_COSTRY_ORDER, How
>> about increasing score of task which have VM_HUGETLB vma in badness ?
>>
>
> That is unjustified. It penalises a process even if it only allocated one
> hugepage and it is not a reflection of how much memory the process is using
> or how badly behaved it is.
> Even worse, if the huge page was allocated from the static hugepage pool then
> the hugepages are freed to the hugepage pool and not the page allocator when
> the process is killed. This means that killing a process using hugepages
> does not necessarily help applications requiring more memory unless they
> also want hugepages. However, a hugepage allocation will not trigger the
> OOM killer so killing processes using hugepages still does not help.

Thanks for pointing me.
In fact, I expect your great answer. :)

So, how do we prevent innocent task killing for allocation of high order page ?
I think it is trade off. but at least, we have been prevent it until now.

But this patch increases the probability of innocent task killing.
Is GFP_NOFAIL's early bailout more important than killing of innocent task ?

I am not sure.

> --
> Mel Gorman
> Part-time Phd Student                          Linux Technology Center
> University of Limerick                         IBM Dublin Software Lab
>



-- 
Kinds regards,
Minchan Kim
