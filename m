Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbYCESzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbYCESzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 13:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbYCESzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 13:55:44 -0500
Received: from smtp-out.google.com ([216.239.45.13]:1079 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbYCESzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 13:55:43 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=NYq25TZbWV6vIBwc7+yZAsnu9ZMOMCOP0xyVL/nTqnurbDiMW0o3/6v++IzBNRdYs
	VW8Qnq6M/OSH+yVioNoCw==
Message-ID: <6599ad830803051055r56045dffvbb04a50bc903e0dc@mail.gmail.com>
Date: Wed, 5 Mar 2008 10:55:02 -0800
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [RFC] libcg: design and plans
Cc: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org,
       "Balbir Singh" <balbir@in.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Srivatsa Vaddagiri" <vatsa@linux.vnet.ibm.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>
In-Reply-To: <47CEAD38.3080501@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080304152341.GB5659@linux.vnet.ibm.com>
	 <6599ad830803042215n6aedb3eeub0c037e6a4e7bb34@mail.gmail.com>
	 <20080305103343.GA22217@linux.vnet.ibm.com>
	 <6599ad830803050241k590e4389ud95b9b3ef920f8b6@mail.gmail.com>
	 <20080305110730.GB22217@linux.vnet.ibm.com>
	 <6599ad830803050351p91bdacahd47059e863f56817@mail.gmail.com>
	 <47CEAD38.3080501@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2008 at 6:24 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> Paul Menage wrote:
>  > On Wed, Mar 5, 2008 at 3:07 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
>  >>  OK. Hmm, I've not really thought about it. At first thought, it should
>  >>  not be very difficult. Only thing I am not sure is the arbitrary
>  >>  grouping of the groups (ok, a bit confusing).
>  >
>  > I suspect that the main form of composite grouping is going to be
>  > between parents and children. E.g. you might want to say things like:
>  >
>  > create_group(A, memory=1G, cpu=100)
>  > create_group(B, parent=A, memory=inherit, cpu=20)
>  > create_group(C, parent=A, memory=inherit, cpu=30)
>  >
>  > i.e. both B and C inherit/share their memory limit from their parent,
>  > but have their own CPU groups (child groups of their parent?)
>  >
>
>  No, we don't plan on doing that. What we plan on doing is
>
>  1. Specify the mount point for each controller
>  2. In the create group API, specify the name of the group and the various
>  parameters.
>
>  If for example CPU is mounted at /cpu and Memory at /mem
>
>  Then a specification for creation of group A would be of the form
>
>  create_group(A, cpu=100, memory=100M)
>
>  Then,
>
>  /cpu/A has shares set to 100 and /mem/A has memory.limit set to 100M
>
>  If you want to create subgroups under A, you specify
>
>  create_group(A/B, memory=200M, cpu=50)
>
>  That would create /cpu/A/B and /mem/A/B
>
>  Please note that memory and CPU hierarchy needs work in the kernel. The shares
>  and hierarchy support is pending. We need to make the res_counters
>  infrastructure aware of hierarchies.
>

I think there are two different kinds of sharing going on here:

- A and B each have individual limits, and you additionally want their
total usage to be capped by some parent limit. E.g. A and B each have
a 100MB memory limit, and you want their total combined usage to not
exceed 150MB. This kind of sharing has to be handled by the resource
counter abstraction

- you want A and B to be treated identically for the purposes of some
particular resource, e.g. you want a single CFS group to which all
threads in A and B are equal members, or a single memory cgroup for
all allocations by A or B, or the same device control table for A and
B (but you want A and B to be treated separately for some other
resource type). This can be handled in userspace in the way I outlined
above, and it would be good if libcg could handle the setup required
for this. It could also be done in the kernel with something like the
parent/child subsystem group inheritance that I also mentioned above,
if there was demand. But if so it should be a property of cgroups
rather than any individual resource controller, since it's a feature
that could be useful for all cgroups.

Paul
