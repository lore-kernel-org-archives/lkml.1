Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbYDTIU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbYDTIU3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 04:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYDTIUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 04:20:14 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:35095 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbYDTIUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 04:20:10 -0400
Message-ID: <480AFBE5.1070702@linux.vnet.ibm.com>
Date: Sun, 20 Apr 2008 13:46:37 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Pavel Emelianov <xemul@openvz.org>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, containers@lists.osdl.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][-mm] Memory controller hierarchy support (v1)
References: <20080419053551.10501.44302.sendpatchset@localhost.localdomain> <6599ad830804190849u31f13191m4dcca4e471493c2b@mail.gmail.com>
In-Reply-To: <6599ad830804190849u31f13191m4dcca4e471493c2b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Fri, Apr 18, 2008 at 10:35 PM, Balbir Singh
> <balbir@linux.vnet.ibm.com> wrote:
>>  1. We need to hold cgroup_mutex while walking through the children
>>    in reclaim. We need to figure out the best way to do so. Should
>>    cgroups provide a helper function/macro for it?
> 
> There's already a function, cgroup_lock(). But it would be nice to
> avoid such a heavy locking here, particularly since memory allocations
> can occur with cgroup_mutex held, which could lead to a nasty deadlock
> if the allocation triggered reclaim.
> 

Hmm.. probably..

> One of the things that I've been considering was to put the
> parent/child/sibling hierarchy explicitly in cgroup_subsys_state. This
> would give subsystems their own copy to refer to, and could use their
> own internal locking to synchronize with callbacks from cgroups that
> might change the hierarchy. Cpusets could make use of this too, since
> it has to traverse hierarchies sometimes.
> 

Very cool! I look forward to that infrastructure. I'll also look at the cpuset
code and see how to traverse the hierarchy.

>>  2. Do not allow children to have a limit greater than their parents.
>>  3. Allow the user to select if hierarchial support is required
> 
> My thoughts on this would be:
> 
> 1) Never attach a first-level child's counter to its parent. As
> Yamamoto points out, otherwise we end up with extra global operations
> whenever any cgroup allocates or frees memory. Limiting the total
> system memory used by all user processes doesn't seem to be something
> that people are going to generally want to do, and if they really do
> want to they can just create a non-root child and move the whole
> system into that.
> 
> The one big advantage that you currently get from having all
> first-level children be attached to the root is that the reclaim logic
> automatically scans other groups when it reaches the top-level - but I
> think that can be provided as a special-case in the reclaim traversal,
> avoiding the overhead of hitting the root cgroup that we have in this
> patch.
> 

I've been doing some thinking along these lines, I'll think more about this.

> 2) Always attach other children's counters to their parents - if the
> user didn't want a hierarchy, they could create a flat grouping rather
> than nested groupings.
> 

Yes, that's a TODO

> Paul


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
