Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbZIIQp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbZIIQp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 12:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbZIIQp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 12:45:59 -0400
Received: from mail-vw0-f195.google.com ([209.85.212.195]:47353 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbZIIQp6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 12:45:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CNReAOXZNVB2czbKJToH7c4j3hGcRid02oGMvZ/ICm96d2DSEWDQGhIMby9lDWuU6k
         O8f0p09CcsCMbgJKzoYSpE/bMk3/Kt0P06YtavDwYZV3IOKj+s94Wd7X1A2F2Ndxqfek
         J5vysYHYXJqQeMXgmZv66AvUhKZkKAgRMxQOM=
MIME-Version: 1.0
In-Reply-To: <1252513103.4102.14.camel@useless.americas.hpqcorp.net>
References: <alpine.DEB.1.10.0909081110450.30203@V090114053VZO-1>
	 <alpine.DEB.1.10.0909081124240.30203@V090114053VZO-1>
	 <20090909131945.0CF5.A69D9226@jp.fujitsu.com>
	 <28c262360909090839j626ff818of930cf13a6185123@mail.gmail.com>
	 <1252513103.4102.14.camel@useless.americas.hpqcorp.net>
Date: Thu, 10 Sep 2009 01:46:01 +0900
Message-ID: <28c262360909090946n4247c439ka455d3eaa66755dc@mail.gmail.com>
Subject: Re: [rfc] lru_add_drain_all() vs isolation
From: Minchan Kim <minchan.kim@gmail.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <onestero@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Lee.
Long time no see. :)

On Thu, Sep 10, 2009 at 1:18 AM, Lee Schermerhorn
<Lee.Schermerhorn@hp.com> wrote:
> On Thu, 2009-09-10 at 00:39 +0900, Minchan Kim wrote:
>> On Wed, Sep 9, 2009 at 1:27 PM, KOSAKI Motohiro
>> <kosaki.motohiro@jp.fujitsu.com> wrote:
>> >> The usefulness of a scheme like this requires:
>> >>
>> >> 1. There are cpus that continually execute user space code
>> >>    without system interaction.
>> >>
>> >> 2. There are repeated VM activities that require page isolation /
>> >>    migration.
>> >>
>> >> The first page isolation activity will then clear the lru caches of the
>> >> processes doing number crunching in user space (and therefore the first
>> >> isolation will still interrupt). The second and following isolation will
>> >> then no longer interrupt the processes.
>> >>
>> >> 2. is rare. So the question is if the additional code in the LRU handling
>> >> can be justified. If lru handling is not time sensitive then yes.
>> >
>> > Christoph, I'd like to discuss a bit related (and almost unrelated) thing.
>> > I think page migration don't need lru_add_drain_all() as synchronous, because
>> > page migration have 10 times retry.
>> >
>> > Then asynchronous lru_add_drain_all() cause
>> >
>> >  - if system isn't under heavy pressure, retry succussfull.
>> >  - if system is under heavy pressure or RT-thread work busy busy loop, retry failure.
>> >
>> > I don't think this is problematic bahavior. Also, mlock can use asynchrounous lru drain.
>>
>> I think, more exactly, we don't have to drain lru pages for mlocking.
>> Mlocked pages will go into unevictable lru due to
>> try_to_unmap when shrink of lru happens.
>> How about removing draining in case of mlock?
>>
>> >
>> > What do you think?
>
>
> Remember how the code works:  __mlock_vma_pages_range() loops calliing
> get_user_pages() to fault in batches of 16 pages and returns the page
> pointers for mlocking.  Mlocking now requires isolation from the lru.
> If you don't drain after each call to get_user_pages(), up to a
> pagevec's worth of pages [~14] will likely still be in the pagevec and
> won't be isolatable/mlockable().  We can end up with most of the pages

Sorry for confusing.
I said not lru_add_drain but lru_add_drain_all.
Now problem is schedule_on_each_cpu.

Anyway, that case pagevec's worth of pages will be much
increased by the number of CPU as you pointed out.

> still on the normal lru lists.  If we want to move to an almost
> exclusively lazy culling of mlocked pages to the unevictable then we can
> remove the drain.  If we want to be more proactive in culling the
> unevictable pages as we populate the vma, we'll want to keep the drain.
>

It's not good that lazy culling of many pages causes high reclaim overhead.
But now lazy culling of reclaim is doing just only shrink_page_list.
we can do it shrink_active_list's page_referenced so that we can sparse
cost of lazy culling.

> Lee
>
>



-- 
Kind regards,
Minchan Kim
