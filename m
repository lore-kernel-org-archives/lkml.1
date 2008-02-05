Return-Path: <linux-kernel-owner+w=401wt.eu-S1761475AbYBEUox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761475AbYBEUox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932345AbYBEUob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:44:31 -0500
Received: from neuf-infra-smtp-out-sp604007av.neufgp.fr ([84.96.92.120]:57780
	"EHLO neuf-infra-smtp-out-sp604007av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932335AbYBEUoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:44:30 -0500
Message-ID: <47A8CA97.30008@cosmosbay.com>
Date: Tue, 05 Feb 2008 21:44:07 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Pekka Paalanen <pq@iki.fi>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86 mmiotrace: fix relay-buffer-full flag for SMP
References: <20080127185238.4bcac54b@daedalus.pq.iki.fi>	<1201660102.8837.9.camel@brick>	<1201660453.8837.13.camel@brick>	<20080130200827.322c4f7d@daedalus.pq.iki.fi>	<20080131150746.GB11996@elte.hu>	<20080131180253.6c007852@daedalus.pq.iki.fi>	<20080131081507.5edcde10@laptopd505.fenrus.org>	<20080203085522.2b63e15b@daedalus.pq.iki.fi>	<20080203070321.GA8293@elte.hu>	<20080205222807.7b35ef2b@daedalus.pq.iki.fi> <20080205223046.668309be@daedalus.pq.iki.fi>
In-Reply-To: <20080205223046.668309be@daedalus.pq.iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Paalanen a écrit :
> Relay has per-cpu buffers, but mmiotrace was using only a single flag
> for detecting buffer full/not-full transitions. The new code makes
> this per-cpu and actually counts missed events.
> 
> Signed-off-by: Pekka Paalanen <pq@iki.fi>
> ---
>  arch/x86/kernel/mmiotrace/mmio-mod.c |   26 ++++++++++++++++----------
>  1 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kernel/mmiotrace/mmio-mod.c b/arch/x86/kernel/mmiotrace/mmio-mod.c
> index 82ae920..f492b65 100644
> --- a/arch/x86/kernel/mmiotrace/mmio-mod.c
> +++ b/arch/x86/kernel/mmiotrace/mmio-mod.c
> @@ -29,6 +29,7 @@
>  #include <asm/pgtable.h>
>  #include <linux/mmiotrace.h>
>  #include <asm/e820.h> /* for ISA_START_ADDRESS */
> +#include <asm/atomic.h>
>  
>  #include "kmmio.h"
>  #include "pf_in.h"
> @@ -47,9 +48,13 @@ struct trap_reason {
>  	int active_traces;
>  };
>  
> +/* Accessed per-cpu. */
>  static struct trap_reason pf_reason[NR_CPUS];
>  static struct mm_io_header_rw cpu_trace[NR_CPUS];
>  
> +/* Access to this is not per-cpu. */
> +static atomic_t dropped[NR_CPUS];
> +

Please dont introduce NR_CPUS new arrays, since people are working hard to zap 
them from kernel.

You probably can use a per_cpu variable ?

Thank you

