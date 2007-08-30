Return-Path: <linux-kernel-owner+w=401wt.eu-S1761714AbXH3BIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761714AbXH3BIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 21:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbXH3BIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 21:08:41 -0400
Received: from colo.lackof.org ([198.49.126.79]:48215 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbXH3BIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 21:08:41 -0400
Date: Wed, 29 Aug 2007 19:08:22 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [PATCH] local_t Documentation update 2
Message-ID: <20070830010822.GA29129@colo.lackof.org>
References: <20070829121953.GB9734@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070829121953.GB9734@Krystal>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2007 at 08:19:53AM -0400, Mathieu Desnoyers wrote:
> local_t Documentation update 2
> 
> Grant Grundler was asking for more detail about correct usage of local atomic
> operations and suggested adding the resulting summary to local_ops.txt.
> 
> "Please add a bit more detail. If DaveM is correct (he normally is), then
> there must be limits on how the local_t can be used in the kernel process
> and interrupt contexts. I'd like those rules spelled out very clearly
> since it's easy to get wrong and tracking down such a bug is quite painful."
> 
> It applies on top of 2.6.23-rc3-mm1.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Grant Grundler <grundler@parisc-linux.org>

Signed-off-by: Grant Grundler <grundler@parisc-linux.org>

thanks!
grant

> ---
>  Documentation/local_ops.txt |   23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> Index: linux-2.6-lttng/Documentation/local_ops.txt
> ===================================================================
> --- linux-2.6-lttng.orig/Documentation/local_ops.txt	2007-08-29 08:09:34.000000000 -0400
> +++ linux-2.6-lttng/Documentation/local_ops.txt	2007-08-29 08:15:37.000000000 -0400
> @@ -45,6 +45,29 @@ long fails. The definition looks like :
>  typedef struct { atomic_long_t a; } local_t;
>  
>  
> +* Rules to follow when using local atomic operations
> +
> +- Variables touched by local ops must be per cpu variables.
> +- _Only_ the CPU owner of these variables must write to them.
> +- This CPU can use local ops from any context (process, irq, softirq, nmi, ...)
> +  to update its local_t variables.
> +- Preemption (or interrupts) must be disabled when using local ops in
> +  process context to   make sure the process won't be migrated to a
> +  different CPU between getting the per-cpu variable and doing the
> +  actual local op.
> +- When using local ops in interrupt context, no special care must be
> +  taken on a mainline kernel, since they will run on the local CPU with
> +  preemption already disabled. I suggest, however, to explicitly
> +  disable preemption anyway to make sure it will still work correctly on
> +  -rt kernels.
> +- Reading the local cpu variable will provide the current copy of the
> +  variable.
> +- Reads of these variables can be done from any CPU, because updates to
> +  "long", aligned, variables are always atomic. Since no memory
> +  synchronization is done by the writer CPU, an outdated copy of the
> +  variable can be read when reading some _other_ cpu's variables.
> +
> +
>  * How to use local atomic operations
>  
>  #include <linux/percpu.h>
> 
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
