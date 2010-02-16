Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab0BPEwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 23:52:11 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48549 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601Ab0BPEwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 23:52:10 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/7 -mm] oom: filter tasks not sharing the same cpuset
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.1002151401280.26927@chino.kir.corp.google.com>
References: <20100215115154.727B.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1002151401280.26927@chino.kir.corp.google.com>
Message-Id: <20100216110859.72C6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 16 Feb 2010 13:52:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 15 Feb 2010, KOSAKI Motohiro wrote:
> 
> > > Tasks that do not share the same set of allowed nodes with the task that
> > > triggered the oom should not be considered as candidates for oom kill.
> > > 
> > > Tasks in other cpusets with a disjoint set of mems would be unfairly
> > > penalized otherwise because of oom conditions elsewhere; an extreme
> > > example could unfairly kill all other applications on the system if a
> > > single task in a user's cpuset sets itself to OOM_DISABLE and then uses
> > > more memory than allowed.
> > > 
> > > Killing tasks outside of current's cpuset rarely would free memory for
> > > current anyway.
> > > 
> > > Signed-off-by: David Rientjes <rientjes@google.com>
> > 
> > This patch does right thing and looks promissing. but unfortunately
> > I have to NAK this patch temporary.
> > 
> > This patch is nearly just revert of the commit 7887a3da75. We have to
> > dig archaeology mail log and find why this reverting don't cause
> > the old pain again.
> > 
> 
> Nick is probably wondering why I cc'd him on this patchset, and this is it 
> :)

Good decision :)

> 
> We now determine whether an allocation is constrained by a cpuset by 
> iterating through the zonelist and checking 
> cpuset_zone_allowed_softwall().  This checks for the necessary cpuset 
> restrictions that we need to validate (the GFP_ATOMIC exception is 
> irrelevant, we don't call into the oom killer for those).  We don't need 
> to kill outside of its cpuset because we're not guaranteed to find any 
> memory on those nodes, in fact it allows for needless oom killing if a 
> task sets all of its threads to have OOM_DISABLE in its own cpuset and 
> then runs out of memory.  The oom killer would have killed every other 
> user task on the system even though the offending application can't 
> allocate there.  That's certainly an undesired result and needs to be 
> fixed in this manner.

But this explanation is irrelevant and meaningless. CPUSET can change
restricted node dynamically. So, the tsk->mempolicy at oom time doesn't
represent the place of task's usage memory. plus, OOM_DISABLE can 
always makes undesirable result. it's not special in this case.

The fact is, both current and your heuristics have a corner case. it's
obvious. (I haven't seen corner caseless heuristics). then talking your
patch's merit doesn't help to merge the patch. The most important thing
is, we keep no regression. personally, I incline your one. but It doesn't
mean we can ignore its demerit.



