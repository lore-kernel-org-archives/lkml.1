Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251AbZCaLaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbZCaLaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 07:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbZCaLah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 07:30:37 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:62571 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbZCaLah convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 07:30:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XyzSmN1TlwdlUZQeIvXbKMPoUifojnIeHUcmerltE73hNxtZTS25mel6OS15nzySlx
         jFdsi1GG6CJH2US3uE3pT/r1yq/q2NDsoAZwJzBkDnL75Ie84CVN6tket3aQpZ2xg1hP
         yUglgvrsrKWF/sOCKN9xaG6SoVyEIHjga7IRE=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0903311154570.19028@blonde.anvils>
References: <28c262360903310338k20b8eebbncb86baac9b09e54@mail.gmail.com>
	 <Pine.LNX.4.64.0903311154570.19028@blonde.anvils>
Date: Tue, 31 Mar 2009 20:30:35 +0900
Message-ID: <28c262360903310430jc0411fdm5de88476f39bae4c@mail.gmail.com>
Subject: Re: add_to_swap_cache with GFP_ATOMIC ?
From: Minchan Kim <minchan.kim@gmail.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for quick reply.

On Tue, Mar 31, 2009 at 8:17 PM, Hugh Dickins <hugh@veritas.com> wrote:
> On Tue, 31 Mar 2009, Minchan Kim wrote:
>>
>> I don't know why we should call add_to_swap_cache with GFP_ATOMIC ?
>> Is there a special something for avoiding blocking?
>
> add_to_swap_cache itself does not need to be called with GFP_ATOMIC.
>
> There are three places from which it is called:
>
> read_swap_cache_async (typically used when faulting) masks the
> gfp_mask coming in (typically GFP_HIGHUSER_MOVABLE for the pages
> themselves) to call add_to_swap_cache typically with GFP_KERNEL.
>
> shmem_writepage does call it with GFP_ATOMIC: that's because it's
> holding the shmem_inode's spin_lock while it switches the page between
> file cache and swap cache - IIRC holding page lock isn't quite enough
> for that, because of other cases; but I've not thought that through
> in a long time, we could re-examine if it troubles you.

Yes. My point was that. but I am not sure what are other cases. :(
Now, It don't hurt me but not sure in future.

> The questionable one is add_to_swap (when vmscanning), which calls
> it with __GFP_HIGH|__GFP_NOMEMALLOC|__GFP_NOWARN, i.e. GFP_ATOMIC
> plus __GFP_NOMEMALLOC|__GFP_NOWARN.  That one I have wondered
> about from time to time: GFP_NOIO would be the obvious choice,
> that's what swap_writepage will use to allocate bio soon after.
>
> I've been tempted to change it, but afraid to touch that house
> of cards, and afraid of long testing and justification required.
> Would it be safe to drop that __GFP_HIGH?  What's the effect of the
> __GFP_NOMEMALLOC (we've layer on layer of tweak this one way because
> we're in the reclaim path so let it eat more, then tweak it the other
> way because we don't want it to eat up _too_ much).  I just let it stay.

Sigh.
What a complex thing to change one line.
Thanks for kind explanation.

> Hugh
>



-- 
Kinds regards,
Minchan Kim
