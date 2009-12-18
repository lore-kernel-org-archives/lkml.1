Return-Path: <linux-kernel-owner+w=401wt.eu-S932250AbZLRRoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250AbZLRRoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932201AbZLRRoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:44:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341AbZLRRoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:44:14 -0500
Message-ID: <4B2BBF44.2090104@redhat.com>
Date: Fri, 18 Dec 2009 12:43:32 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>, lwoodman@redhat.com,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: FWD:  [PATCH v2] vmscan: limit concurrent reclaimers in shrink_zone
References: <20091211164651.036f5340@annuminas.surriel.com> <1260810481.6666.13.camel@dhcp-100-19-198.bos.redhat.com> <20091217193818.9FA9.A69D9226@jp.fujitsu.com> <4B2A22C0.8080001@redhat.com> <4B2A8CA8.6090704@redhat.com> <Pine.LNX.4.64.0912172055570.15788@sister.anvils> <20091218162332.GR29790@random.random>
In-Reply-To: <20091218162332.GR29790@random.random>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2009 11:23 AM, Andrea Arcangeli wrote:
> On Thu, Dec 17, 2009 at 09:05:23PM +0000, Hugh Dickins wrote:

>> An rwlock there has been proposed on several occasions, but
>> we resist because that change benefits this case but performs
>> worse on more common cases (I believe: no numbers to back that up).
>
> I think rwlock for anon_vma is a must. Whatever higher overhead of the
> fast path with no contention is practically zero, and in large smp it
> allows rmap on long chains to run in parallel, so very much worth it
> because downside is practically zero and upside may be measurable
> instead in certain corner cases. I don't think it'll be enough, but I
> definitely like it.

I agree, changing the anon_vma lock to an rwlock should
work a lot better than what we have today.  The tradeoff
is a tiny slowdown in medium contention cases, at the
benefit of avoiding catastrophic slowdown in some cases.

With Nick Piggin's fair rwlocks, there should be no issue
at all.

> Rik suggested to me to have a cowed newly allocated page to use its
> own anon_vma. Conceptually Rik's idea is fine one, but the only
> complication then is how to chain the same vma into multiple anon_vma
> (in practice insert/removal will be slower and more metadata will be
> needed for additional anon_vmas and vams queued in more than
> anon_vma). But this only will help if the mapcount of the page is 1,
> if the mapcount is 10000 no change to anon_vma or prio_tree will solve
> this,

It's even more complex than this for anonymous pages.

Anonymous pages get COW copied in child (and parent)
processes, potentially resulting in one page, at each
offset into the anon_vma, for every process attached
to the anon_vma.

As a result, with 10000 child processes, page_referenced
can end up searching through 10000 VMAs even for pages
with a mapcount of 1!

-- 
All rights reversed.
