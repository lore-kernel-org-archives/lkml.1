Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbZLaCrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbZLaCrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 21:47:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbZLaCrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 21:47:09 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:34108 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbZLaCrG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 21:47:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Jj+TXSwyO03DUFzNlOLaQTwwVHw8ZD5zjG7LBZMU9NS5ppLNrowdt2ssQtMOYuEW6c
         xPPO43pn4uxuNSWz1We8729+rlEro4LxhtD9lWTni8A9N7K3Sb+sqTQiOHlum9sUPT1/
         b6PGTZv6rIgd0KUE3Qk1pHzJ4zVf4oN2pCPRw=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.0912301612180.3369@sister.anvils>
References: <20091228134619.92ba28f6.minchan.kim@barrios-desktop>
	 <1262117339.3000.2023.camel@calx>
	 <20091230103349.1ec71aac.minchan.kim@barrios-desktop>
	 <alpine.LSU.2.00.0912301612180.3369@sister.anvils>
Date: Thu, 31 Dec 2009 11:47:05 +0900
Message-ID: <28c262360912301847u5600e0c7m3bada2ebb2bb5064@mail.gmail.com>
Subject: Re: [PATCH -mmotm-2009-12-10-17-19] Fix wrong rss count of smaps
From: Minchan Kim <minchan.kim@gmail.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 31, 2009 at 1:19 AM, Hugh Dickins
<hugh.dickins@tiscali.co.uk> wrote:
> On Wed, 30 Dec 2009, Minchan Kim wrote:
>> On Tue, 29 Dec 2009 14:08:59 -0600
>> Matt Mackall <mpm@selenic.com> wrote:
>> > On Mon, 2009-12-28 at 13:46 +0900, Minchan Kim wrote:
>> > > I am not sure we have to account zero page with file_rss.
>> > > Hugh and Kame's new zero page doesn't do it.
>> > > As side effect of this, we can prevent innocent process which have a lot
>> > > of zero page when OOM happens.
>> > > (But I am not sure there is a process like this :)
>> > > So I think not file_rss counting is not bad.
>> > >
>> > > RSS counting zero page with file_rss helps any program using smaps?
>> > > If we have to keep the old behavior, I have to remake this patch.
>> > >
>> > > == CUT_HERE ==
>> > >
>> > > Long time ago, We regards zero page as file_rss and
>> > > vm_normal_page doesn't return NULL.
>> > >
>> > > But now, we reinstated ZERO_PAGE and vm_normal_page's implementation
>> > > can return NULL in case of zero page. Also we don't count it with
>> > > file_rss any more.
>> > >
>> > > Then, RSS and PSS can't be matched.
>> > > For consistency, Let's ignore zero page in smaps_pte_range.
>> > >
>> >
>> > Not counting the zero page in RSS is fine with me. But will this patch
>> > make the total from smaps agree with get_mm_rss()?
>>
>> Yes. Anon page fault handler also don't count zero page any more, now.
>> Nonetheless, smaps counts it with resident.
>>
>> It's point of this patch.
>>
>> But I reposted both anon fault handler and here counts it as file_rss
>> as compatibility with old zero page counting.
>> Pz, Look at that. :)
>
> I am getting confused between your different patches in this area,
> heading in different directions, not increments in the same series.
> But I think this is the one to which, like Matt, I'll say
>
> Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Thanks for ACK, Hugh.
It's my old version.
This patch can be changed according to account zero page as file_rss or not.
Anyway, We need consistency regardless of it.

>
>>
>> >
>> > Regarding OOM handling: arguably RSS should play no role in OOM as it's
>> > practically meaningless in a shared memory system. If we were instead
>>
>> It's very arguable issue for us that OOM depens on RSS.
>>
>> > used per-process unshared pages as the metric (aka USS), we'd have a
>> > much better notion of how much memory an OOM kill would recover.
>> > Unfortunately, that's not trivial to track as the accounting on COW
>> > operations is not lightweight.
>>
>> I think we can approximate it with the size of VM_SHARED vma of process
>> when VM calculate badness.
>> What do you think about it?
>
> Sounds like it'll end up even harder to understand than by size or by rss.

Yes. If we settle down OOM issue, I will repost this issue. :)

>
>>
>> Thanks for good idea, Matt.
>>
>> >
>> > > CC: Matt Mackall <mpm@selenic.com>
>> > > Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> > > ---
>> > >  fs/proc/task_mmu.c |    3 +--
>> > >  1 files changed, 1 insertions(+), 2 deletions(-)
>> > >
>> > > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
>> > > index 47c03f4..f277c4a 100644
>> > > --- a/fs/proc/task_mmu.c
>> > > +++ b/fs/proc/task_mmu.c
>> > > @@ -361,12 +361,11 @@ static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>> > >           if (!pte_present(ptent))
>> > >                   continue;
>> > >
>> > > -         mss->resident += PAGE_SIZE;
>> > > -
>> > >           page = vm_normal_page(vma, addr, ptent);
>> > >           if (!page)
>> > >                   continue;
>> > >
>> > > +         mss->resident += PAGE_SIZE;
>> > >           /* Accumulate the size in pages that have been accessed. */
>> > >           if (pte_young(ptent) || PageReferenced(page))
>> > >                   mss->referenced += PAGE_SIZE;
>> > > --
>



-- 
Kind regards,
Minchan Kim
