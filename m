Return-Path: <linux-kernel-owner+w=401wt.eu-S1759278AbZDOJdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278AbZDOJdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 05:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbZDOJdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 05:33:11 -0400
Received: from iona.labri.fr ([147.210.8.143]:52197 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbZDOJdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 05:33:10 -0400
Message-ID: <49E5A9DC.2050309@inria.fr>
Date: Wed, 15 Apr 2009 11:33:16 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] migration: only migrate_prep() once per move_pages()
References: <49E58D7A.4010708@ens-lyon.org> <20090415164955.41746866.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090415164955.41746866.kamezawa.hiroyu@jp.fujitsu.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Wed, 15 Apr 2009 09:32:10 +0200
> Brice Goglin <Brice.Goglin@ens-lyon.org> wrote:
>
>   
>> migrate_prep() is fairly expensive (72us on 16-core barcelona 1.9GHz).
>> Commit 3140a2273009c01c27d316f35ab76a37e105fdd8 improved move_pages()
>> throughput by breaking it into chunks, but it also made migrate_prep()
>> be called once per chunk (every 128pages or so) instead of once per
>> move_pages().
>>
>> This patch reverts to calling migrate_prep() only once per chunk
>> as we did before 2.6.29.
>> It is also a followup to commit 0aedadf91a70a11c4a3e7c7d99b21e5528af8d5d
>>     mm: move migrate_prep out from under mmap_sem
>>
>> This improves migration throughput on the above machine from 600MB/s
>> to 750MB/s.
>>
>> Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
>>
>>     
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> I think this patch is good. page migration is best-effort syscall ;)
>   

My next feeling now is about improving migrate_prep() itself. It makes
the move_pages() startup overhead very high.

But lru_add_drain_all() touches some code that I am far from
understanding :/ Can we imagine using IPI instead of a deferred
work_struct for this kind of things? Or maybe, for each processor, check
whether drain_cpu_pagevecs() would have something to do before actually
scheduling the local work_struct? It's racy, but migrate_prep() doesn't
guarantee anyway that pages won't be moved out of the LRU before the
actual migration, so...

Also I don't see why the cost of lru_add_drain_all() seems to increase
linearly with the number of cores in the machine. There may be some lock
contention, but it should scale better when there's pretty-much nothing
in the CPU lists...

> BTW, current users of sys_move_pages() does retry when it gets -EBUSY ?
>   

I'd say they ignore it since it doesn't happen often :)

Brice

