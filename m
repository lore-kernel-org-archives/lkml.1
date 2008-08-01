Return-Path: <linux-kernel-owner+w=401wt.eu-S1759000AbYHAJ42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000AbYHAJ42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 05:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbYHAJ4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 05:56:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53644 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbYHAJ4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 05:56:20 -0400
Date: Fri, 01 Aug 2008 18:42:21 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC:Patch: 000/008](memory hotplug) rough idea of pgdat removing
Cc: Badari Pulavarty <pbadari@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       linux-mm <linux-mm@kvack.org>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>
In-Reply-To: <4891C66A.3040302@linux-foundation.org>
References: <20080731203549.2A3F.E1E9C6FF@jp.fujitsu.com> <4891C66A.3040302@linux-foundation.org>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080801180522.EC97.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yasunori Goto wrote:
> 
> > Current my idea is using RCU feature for waiting them.
> > Because it is the least impact against reader's performance,
> > and pgdat remover can wait finish of reader's access to pgdat
> > which is removing by synchronize_sched().
> 
> The use of RCU disables preemption which has implications as to
> what can be done in a loop over nodes or zones.

Yeap. It's the one of (big) cons.

> This would also potentially add more overhead to the page allocator hotpaths.

Agree.

To tell the truth, I tried hackbench with 3rd patch which add rcu_read_lock
in hot-path before this post to make rough estimate its impact.

%hackbench 100 process 2000

without patch.
  39.93

with patch
  39.99
(Both is 10 times avarage)

I guess this result has effect of disable preemption.
So, throughput looks not so bad, but probably, latency would be worse
as you mind.

Kame-san advised me I should take more other benchmarks which can get memory
performance. I'll do it next week.

> > If you have better idea, please let me know.
> 
> Use stop_machine()? The removal of a zone or node is a pretty rare event
> after all and it would avoid having to deal with rcu etc etc.
> 

I thought it at first, but are there the following worst case?


   CPU 0                                    CPU 1
-------------------------------------------------------
__alloc_pages()
    
    parsing_zonelist()
        :
    enter page_reclarim()
    sleep (and remember zone)                 :
                                              :
                                        update zonelist and node_online_map
                                          with stop_machine_run()
                                        free pgdat().
                                        remove the Node electrically.

    wake up and touch remembered
       zone,  but it is removed
    (Oops!!!)



Anyway, I'm happy if there is better way than my poor idea. :-)

Thanks for your comment.


-- 
Yasunori Goto 


