Return-Path: <linux-kernel-owner+w=401wt.eu-S1756127AbYDSPt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbYDSPt1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 11:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbYDSPtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 11:49:18 -0400
Received: from smtp-out.google.com ([216.239.33.17]:13543 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbYDSPtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 11:49:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=UrQg9/61Oheowj7ZCyOtLML+emTVEOI8k8wKngYQqU06reEKEiOAAWMb1H6qlP99o
	m1bI22/0kHO1AAYsimT6w==
Message-ID: <6599ad830804190849u31f13191m4dcca4e471493c2b@mail.gmail.com>
Date: Sat, 19 Apr 2008 08:49:02 -0700
From: "Paul Menage" <menage@google.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC][-mm] Memory controller hierarchy support (v1)
Cc: "Pavel Emelianov" <xemul@openvz.org>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       containers@lists.osdl.org,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080419053551.10501.44302.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080419053551.10501.44302.sendpatchset@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 10:35 PM, Balbir Singh
<balbir@linux.vnet.ibm.com> wrote:
>
>  1. We need to hold cgroup_mutex while walking through the children
>    in reclaim. We need to figure out the best way to do so. Should
>    cgroups provide a helper function/macro for it?

There's already a function, cgroup_lock(). But it would be nice to
avoid such a heavy locking here, particularly since memory allocations
can occur with cgroup_mutex held, which could lead to a nasty deadlock
if the allocation triggered reclaim.

One of the things that I've been considering was to put the
parent/child/sibling hierarchy explicitly in cgroup_subsys_state. This
would give subsystems their own copy to refer to, and could use their
own internal locking to synchronize with callbacks from cgroups that
might change the hierarchy. Cpusets could make use of this too, since
it has to traverse hierarchies sometimes.

>  2. Do not allow children to have a limit greater than their parents.
>  3. Allow the user to select if hierarchial support is required

My thoughts on this would be:

1) Never attach a first-level child's counter to its parent. As
Yamamoto points out, otherwise we end up with extra global operations
whenever any cgroup allocates or frees memory. Limiting the total
system memory used by all user processes doesn't seem to be something
that people are going to generally want to do, and if they really do
want to they can just create a non-root child and move the whole
system into that.

The one big advantage that you currently get from having all
first-level children be attached to the root is that the reclaim logic
automatically scans other groups when it reaches the top-level - but I
think that can be provided as a special-case in the reclaim traversal,
avoiding the overhead of hitting the root cgroup that we have in this
patch.

2) Always attach other children's counters to their parents - if the
user didn't want a hierarchy, they could create a flat grouping rather
than nested groupings.

Paul
