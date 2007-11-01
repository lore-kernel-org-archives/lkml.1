Return-Path: <linux-kernel-owner+w=401wt.eu-S1756266AbXKAFir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbXKAFir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 01:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbXKAFii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 01:38:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49316
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752993AbXKAFih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 01:38:37 -0400
Date: Wed, 31 Oct 2007 22:38:36 -0700 (PDT)
Message-Id: <20071031.223836.162573733.davem@davemloft.net>
To: clameter@sgi.com
Cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       penberg@cs.helsinki.fi
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0710312115520.26072@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0710311810390.25643@schroedinger.engr.sgi.com>
	<20071031.181335.207429553.davem@davemloft.net>
	<Pine.LNX.4.64.0710312115520.26072@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Wed, 31 Oct 2007 21:16:59 -0700 (PDT)

>  /*
>   * Maximum allowed per cpu data per cpu
>   */
> +#ifdef CONFIG_NUMA
> +#define PER_CPU_ALLOC_SIZE (32768 + MAX_NUMNODES * 512)
> +#else
>  #define PER_CPU_ALLOC_SIZE 32768
> +#endif
> +

Christoph, as Rusty found out years ago when he first wrote this code,
you cannot put hard limits on the alloc_percpu() allocations.

They can be done by anyone, any module, and since there was no limit
before you cannot reasonably add one now.

As just one of many examples, several networking devices use
alloc_percpu() for each instance they bring up.  This alone can
request arbitrary amounts of per-cpu data.

Therefore, you'll need to do your optimization without imposing any
size limits.
