Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab0BOWG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 17:06:57 -0500
Received: from smtp-out.google.com ([216.239.44.51]:20475 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756435Ab0BOWGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 17:06:55 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=DcHWNRpfKk8rLTYZ4beaSqlpqikIb9UwL1O7sd6+y4yOI384rN5+upbdR8+315SFz
	2B4WdaLDwe21G1+Fg5zHA==
Date: Mon, 15 Feb 2010 14:06:50 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 1/7 -mm] oom: filter tasks not sharing the same cpuset
In-Reply-To: <20100215115154.727B.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002151401280.26927@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com> <alpine.DEB.2.00.1002100227590.8001@chino.kir.corp.google.com> <20100215115154.727B.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Feb 2010, KOSAKI Motohiro wrote:

> > Tasks that do not share the same set of allowed nodes with the task that
> > triggered the oom should not be considered as candidates for oom kill.
> > 
> > Tasks in other cpusets with a disjoint set of mems would be unfairly
> > penalized otherwise because of oom conditions elsewhere; an extreme
> > example could unfairly kill all other applications on the system if a
> > single task in a user's cpuset sets itself to OOM_DISABLE and then uses
> > more memory than allowed.
> > 
> > Killing tasks outside of current's cpuset rarely would free memory for
> > current anyway.
> > 
> > Signed-off-by: David Rientjes <rientjes@google.com>
> 
> This patch does right thing and looks promissing. but unfortunately
> I have to NAK this patch temporary.
> 
> This patch is nearly just revert of the commit 7887a3da75. We have to
> dig archaeology mail log and find why this reverting don't cause
> the old pain again.
> 

Nick is probably wondering why I cc'd him on this patchset, and this is it 
:)

We now determine whether an allocation is constrained by a cpuset by 
iterating through the zonelist and checking 
cpuset_zone_allowed_softwall().  This checks for the necessary cpuset 
restrictions that we need to validate (the GFP_ATOMIC exception is 
irrelevant, we don't call into the oom killer for those).  We don't need 
to kill outside of its cpuset because we're not guaranteed to find any 
memory on those nodes, in fact it allows for needless oom killing if a 
task sets all of its threads to have OOM_DISABLE in its own cpuset and 
then runs out of memory.  The oom killer would have killed every other 
user task on the system even though the offending application can't 
allocate there.  That's certainly an undesired result and needs to be 
fixed in this manner.
