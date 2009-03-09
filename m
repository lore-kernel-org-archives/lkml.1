Return-Path: <linux-kernel-owner+w=401wt.eu-S1752917AbZCIHIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbZCIHIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 03:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbZCIHId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 03:08:33 -0400
Received: from smtp-out.google.com ([216.239.45.13]:62348 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbZCIHIc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 03:08:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=RnkP0VgBu61msvyhIjjxzOKIfBbn7MRzZtJKfM9CsDPwTuWGzv4erRYLC1ihTXAKe
	NeZDSgDM0+wtpAWxVSrqw==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0903081438180.30551@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903080917460.25207@chino.kir.corp.google.com>
	 <6599ad830903080953na692dcfh7f455bfe46a895c3@mail.gmail.com>
	 <alpine.DEB.2.00.0903081438180.30551@chino.kir.corp.google.com>
Date: Mon, 9 Mar 2009 00:08:26 -0700
Message-ID: <6599ad830903090008u4418e7efie137c87c6ac42e55@mail.gmail.com>
Subject: Re: [patch -mm] cpusets: add memory_slab_hardwall flag
From: Paul Menage <menage@google.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another thought - it would probably be better to call this flag
kernel_mem_hardwall or mem_hardwall_kernel, to avoid hard-coding its
name to be slab-specific.

Paul

On Sun, Mar 8, 2009 at 2:38 PM, David Rientjes <rientjes@google.com> wrote:
> On Sun, 8 Mar 2009, Paul Menage wrote:
>
>> > +/**
>> > + * current_cpuset_object_allowed - can a slab object be allocated on a node?
>> > + * @node: the node for object allocation
>> > + * @flags: allocation flags
>> > + *
>> > + * Return non-zero if object is allowed, zero otherwise.
>> > + */
>> > +int current_cpuset_object_allowed(int node, gfp_t flags)
>> > +{
>> > +       return !is_slab_hardwall(task_cs(current)) ||
>> > +              cpuset_node_allowed_hardwall(node, flags);
>> > +}
>> > +
>>
>> This should be in rcu_read_lock()/rcu_read_unlock() in order to safely
>> dereference the result of task_cs(current)
>>
>
> I've folded the following into the patch, thanks Paul.
> ---
>  kernel/cpuset.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -1205,8 +1205,12 @@ int current_cpuset_is_being_rebound(void)
>  */
>  int current_cpuset_object_allowed(int node, gfp_t flags)
>  {
> -       return !is_slab_hardwall(task_cs(current)) ||
> -              cpuset_node_allowed_hardwall(node, flags);
> +       int is_hardwall;
> +
> +       rcu_read_lock();
> +       is_hardwall = is_slab_hardwall(task_cs(current));
> +       rcu_read_unlock();
> +       return !is_hardwall || cpuset_node_allowed_hardwall(node, flags);
>  }
>
>  static int update_relax_domain_level(struct cpuset *cs, s64 val)
