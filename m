Return-Path: <linux-kernel-owner+w=401wt.eu-S1423259AbXBHT2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423259AbXBHT2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 14:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423261AbXBHT2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 14:28:43 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:55795 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423259AbXBHT2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 14:28:42 -0500
Date: Thu, 8 Feb 2007 11:28:30 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@suse.de>, GOTO <y-goto@jp.fujitsu.com>
Subject: Re: Fw: [BUG][PATCH] fix mempolcy's check on a system with
 memory-less-node take3
In-Reply-To: <20070208173608.c31c2e13.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0702081125160.11045@schroedinger.engr.sgi.com>
References: <20070208173608.c31c2e13.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007, KAMEZAWA Hiroyuki wrote:

> @@ -162,6 +162,10 @@
>  			break;
>  		k--;
>  	}
> +	if (!num) {
> +		kfree(zl);
> +		return ERR_PTR(-EINVAL);
> +	}
>  	zl->zones[num] = NULL;
>  	return zl;
>  }

Ok. So you are detecting a set of nodes that has nodes specified but the 
zones that these nodes refer to are empty,  as an error.

Should work.

> @@ -193,9 +197,11 @@
>  		break;
>  	case MPOL_BIND:
>  		policy->v.zonelist = bind_zonelist(nodes);
> -		if (policy->v.zonelist == NULL) {
> +		if (IS_ERR(policy->v.zonelist)) {
> +			void *val = policy->v.zonelist;
> +			policy->v.zonelist = NULL;

void *? Ahh. It takes the error code.

Looks good. But if we are really going down this road of memory-less 
nodes we may want to audit the kernel for other issues.

Could you run a series of tests on that machine?

