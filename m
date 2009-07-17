Return-Path: <linux-kernel-owner+w=401wt.eu-S933974AbZGQCHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933974AbZGQCHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 22:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933942AbZGQCHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 22:07:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53725 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933935AbZGQCHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 22:07:13 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [BUG] set_mempolicy(MPOL_INTERLEAV) cause kernel panic
Cc: kosaki.motohiro@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Miao Xie <miaox@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Paul Menage <menage@google.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090717095745.1d3039b1.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090717090003.A903.A69D9226@jp.fujitsu.com> <20090717095745.1d3039b1.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20090717104512.A914.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 17 Jul 2009 11:07:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 17 Jul 2009 09:04:46 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > > On Wed, 15 Jul 2009, Lee Schermerhorn wrote:
> > > 
> > > > Interestingly, on ia64, the top cpuset mems_allowed gets set to all
> > > > possible nodes, while on x86_64, it gets set to on-line nodes [or nodes
> > > > with memory].  Maybe this is a to support hot-plug?
> > > > 
> > > 
> > > numactl --interleave=all simply passes a nodemask with all bits set, so if 
> > > cpuset_current_mems_allowed includes offline nodes from node_possible_map, 
> > > then mpol_set_nodemask() doesn't mask them off.
> > > 
> > > Seems like we could handle this strictly in mempolicies without worrying 
> > > about top_cpuset like in the following?
> > 
> > This patch seems band-aid patch. it will change memory-hotplug behavior.
> > Please imazine following scenario:
> > 
> > 1. numactl interleave=all process-A
> > 2. memory hot-add
> > 
> > before 2.6.30:
> > 		-> process-A can use hot-added memory
> > 
> > your proposal patch:
> > 		-> process-A can't use hot-added memory
> > 
> 
> IMHO, the application itseld should be notifed to change its mempolicy by
> hot-plug script on the host. While an application uses interleave, a new node
> hot-added is just a noise. I think "How pages are interleaved" should not be
> changed implicitly. Then, checking at set_mempolicy() seems sane. If notified,
> application can do page migration and rebuild his mapping in ideal way.

Do you really want ABI change?



> BUT I don't linke init->mem_allowed contains N_POSSIBLE...it should be initialized
> to N_HIGH_MEMORY, IMHO.




