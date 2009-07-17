Return-Path: <linux-kernel-owner+w=401wt.eu-S934064AbZGQClE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934064AbZGQClE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 22:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934016AbZGQClE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 22:41:04 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55248 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934015AbZGQClC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 22:41:02 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 17 Jul 2009 11:39:11 +0900
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
Message-Id: <20090717113911.c49395ae.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090717104512.A914.A69D9226@jp.fujitsu.com>
References: <20090717090003.A903.A69D9226@jp.fujitsu.com>
	<20090717095745.1d3039b1.kamezawa.hiroyu@jp.fujitsu.com>
	<20090717104512.A914.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jul 2009 11:07:09 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > On Fri, 17 Jul 2009 09:04:46 +0900 (JST)
> > KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > 
> > > > On Wed, 15 Jul 2009, Lee Schermerhorn wrote:
> > > > 
> > > > > Interestingly, on ia64, the top cpuset mems_allowed gets set to all
> > > > > possible nodes, while on x86_64, it gets set to on-line nodes [or nodes
> > > > > with memory].  Maybe this is a to support hot-plug?
> > > > > 
> > > > 
> > > > numactl --interleave=all simply passes a nodemask with all bits set, so if 
> > > > cpuset_current_mems_allowed includes offline nodes from node_possible_map, 
> > > > then mpol_set_nodemask() doesn't mask them off.
> > > > 
> > > > Seems like we could handle this strictly in mempolicies without worrying 
> > > > about top_cpuset like in the following?
> > > 
> > > This patch seems band-aid patch. it will change memory-hotplug behavior.
> > > Please imazine following scenario:
> > > 
> > > 1. numactl interleave=all process-A
> > > 2. memory hot-add
> > > 
> > > before 2.6.30:
> > > 		-> process-A can use hot-added memory
> > > 
> > > your proposal patch:
> > > 		-> process-A can't use hot-added memory
> > > 
> > 
> > IMHO, the application itseld should be notifed to change its mempolicy by
> > hot-plug script on the host. While an application uses interleave, a new node
> > hot-added is just a noise. I think "How pages are interleaved" should not be
> > changed implicitly. Then, checking at set_mempolicy() seems sane. If notified,
> > application can do page migration and rebuild his mapping in ideal way.
> 
> Do you really want ABI change?
> 
No ;_

Hmm, IIUC, current handling of nodemask of mempolicy is below.
There should be 3 masks.
  - systems's N_HIGH_MEMORY
  - the mask user specified via mempolicy() (remembered only when MPOL_F_RELATIVE
  - cpusets's one

And pol->v.nodes is just a _cache_ of logical-and of aboves.
Synchronization with cpusets is guaranteed by cpuset's generation.
Synchronization with N_HIGH_MEMORY should be guaranteed by memory hotplug
notifier, but this is not implemented yet.

Then, what I can tell here is...
 - remember what's user requested. (only when MPOL_F_RELATIVE_NODES ?)
 - add notifiers for memory hot-add. (only when MPOL_F_RELATIVE_NODES ?)
 - add notifiers for memory hot-remove (both MPOL_F_STATIC/RELATIVE_NODES ?)

IMHO, for cpusets, don't calculate v.nodes again if MPOL_F_STATIC is good.
But for N_HIGH_MEMORY, v.nodes should be caluculated even if MPOL_F_STATIC is set.

Then, I think the mask user passed should be remembered even if MPOL_F_STATIC is
set and v.nodes should work as cache and should be updated in appropriate way.

Thanks,
-Kame












