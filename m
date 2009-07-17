Return-Path: <linux-kernel-owner+w=401wt.eu-S933570AbZGQA7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933570AbZGQA7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933111AbZGQA7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:59:44 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57698 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932936AbZGQA7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:59:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 17 Jul 2009 09:57:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Miao Xie <miaox@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Paul Menage <menage@google.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] set_mempolicy(MPOL_INTERLEAV) cause kernel panic
Message-Id: <20090717095745.1d3039b1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090717090003.A903.A69D9226@jp.fujitsu.com>
References: <1247679064.4089.26.camel@useless.americas.hpqcorp.net>
	<alpine.DEB.2.00.0907161257190.31844@chino.kir.corp.google.com>
	<20090717090003.A903.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jul 2009 09:04:46 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > On Wed, 15 Jul 2009, Lee Schermerhorn wrote:
> > 
> > > Interestingly, on ia64, the top cpuset mems_allowed gets set to all
> > > possible nodes, while on x86_64, it gets set to on-line nodes [or nodes
> > > with memory].  Maybe this is a to support hot-plug?
> > > 
> > 
> > numactl --interleave=all simply passes a nodemask with all bits set, so if 
> > cpuset_current_mems_allowed includes offline nodes from node_possible_map, 
> > then mpol_set_nodemask() doesn't mask them off.
> > 
> > Seems like we could handle this strictly in mempolicies without worrying 
> > about top_cpuset like in the following?
> 
> This patch seems band-aid patch. it will change memory-hotplug behavior.
> Please imazine following scenario:
> 
> 1. numactl interleave=all process-A
> 2. memory hot-add
> 
> before 2.6.30:
> 		-> process-A can use hot-added memory
> 
> your proposal patch:
> 		-> process-A can't use hot-added memory
> 

IMHO, the application itseld should be notifed to change its mempolicy by
hot-plug script on the host. While an application uses interleave, a new node
hot-added is just a noise. I think "How pages are interleaved" should not be
changed implicitly. Then, checking at set_mempolicy() seems sane. If notified,
application can do page migration and rebuild his mapping in ideal way.

BUT I don't linke init->mem_allowed contains N_POSSIBLE...it should be initialized
to N_HIGH_MEMORY, IMHO.

Thanks,
-Kame


