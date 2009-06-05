Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbZFEMS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbZFEMS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 08:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbZFEMSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 08:18:18 -0400
Received: from smtp-out.google.com ([216.239.45.13]:28185 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbZFEMSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 08:18:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=KVZCuJoz4J832nPPBizcREfcAOi78P3ZJ9xa32hiV8EkTIg0HNohxrZOzzUdiqX7F
	wEd+xytoybI8pTi0jDzMg==
MIME-Version: 1.0
In-Reply-To: <20090605113217.GA20786@in.ibm.com>
References: <20090604053649.GA3701@in.ibm.com>
	 <6599ad830906050153i1afd104fqe70f681317349142@mail.gmail.com>
	 <20090605113217.GA20786@in.ibm.com>
Date: Fri, 5 Jun 2009 05:18:13 -0700
Message-ID: <6599ad830906050518t6cd7d477h36a187f2eaf55578@mail.gmail.com>
Subject: Re: [RFC] CPU hard limits
From: Paul Menage <menage@google.com>
To: vatsa@in.ibm.com
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>, Avi Kivity <avi@redhat.com>,
       kvm@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 5, 2009 at 4:32 AM, Srivatsa Vaddagiri<vatsa@in.ibm.com> wrote:
>
> I think the interval over which we need guarantee matters here. Shares
> can generally provide guaranteed share of resource over longer (sometimes
> minutes) intervals. For high-priority bursty workloads, the latency in
> achieving guaranteed resource usage matters.

Well yes, it's true that you *could* just enforce shares over a
granularity of minutes, and limits over a granularity of milliseconds.
But why would you? It could well make sense that you can adjust the
granularity over which shares are enforced - e.g. for batch jobs, only
enforcing over minutes or tens of seconds might be fine. But if you're
doing the fine-grained accounting and scheduling required for the
tight hard limit enforcement, it doesn't seem as though it should be
much harder to enforce shares at the same granularity for those
cgroups that matter. In fact I thought that's what CFS already did -
updated the virtual time accounting at each context switch, and picked
the runnable child with the oldest virtual time. (Maybe someone like
Ingo or Peter who's more familiar than I with the CFS implementation
could comment here?)

> By having hard-limits, we are
> "reserving" (potentially idle) slots where the high-priority group can run and
> claim its guaranteed share almost immediately.

But you can always create an "idle" slot by forcibly preempting
whatever's running currently when you need to - you don't need to keep
the CPU deliberately idle just in case a cgroup with a guarantee wakes
up.

Paul
