Return-Path: <linux-kernel-owner+w=401wt.eu-S1757888AbYBKSZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbYBKSZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbYBKSZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:25:18 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:54472 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458AbYBKSZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:25:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=QhbuyA3wqLgKl6TU2aM/y7PktBanJKOvnc1Z7rskvOqLSk0YAoAa6TC+S8Nid8M9uJe/AdLjnJGy6Bvmnx8eXduGWhkob9xuCVgjzgRApPc2tZGVN6mVx6kAgrszFiVCfy8Wzop1xW3vFvhp05DMk2AgA4ZK13Bf4bNqZOS0ZT4=
Message-ID: <2f11576a0802111025w4f8d6765w119f9e9c1cddd85e@mail.gmail.com>
Date: Tue, 12 Feb 2008 03:25:15 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "David Rientjes" <rientjes@google.com>
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Paul Jackson" <pj@sgi.com>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>, "Andi Kleen" <ak@suse.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
	 <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>
	 <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>
X-Google-Sender-Auth: 3f6dc2b6f1f4fe75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

In general, I like this feature.
and I found no bug in patch [1/4] and [2/4].

> @@ -218,21 +167,27 @@ static struct mempolicy *mpol_new(enum mempolicy_mode mode,
>                 return ERR_PTR(-ENOMEM);
>         flags &= MPOL_MODE_FLAGS;
>         atomic_set(&policy->refcnt, 1);
> +       cpuset_update_task_memory_state();
> +       nodes_and(cpuset_context_nmask, *nodes, cpuset_current_mems_allowed);
>         switch (mode) {
>         case MPOL_INTERLEAVE:
> -               policy->v.nodes = *nodes;
> +               if (nodes_empty(*nodes))
> +                       return ERR_PTR(-EINVAL);

need kmem_cache_free(policy_cache, policy) before return?

> +               policy->v.nodes = cpuset_context_nmask;
>                 if (nodes_weight(policy->v.nodes) == 0) {
>                         kmem_cache_free(policy_cache, policy);
>                         return ERR_PTR(-EINVAL);
>                 }
>                 break;
>         case MPOL_PREFERRED:
> -               policy->v.preferred_node = first_node(*nodes);
> +               policy->v.preferred_node = first_node(cpuset_context_nmask);
>                 if (policy->v.preferred_node >= MAX_NUMNODES)
>                         policy->v.preferred_node = -1;
>                 break;
>         case MPOL_BIND:
> -               policy->v.zonelist = bind_zonelist(nodes);
> +               if (nodes_empty(*nodes))
> +                       return ERR_PTR(-EINVAL);

ditto

Thanks!
