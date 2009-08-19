Return-Path: <linux-kernel-owner+w=401wt.eu-S1752515AbZHSOHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbZHSOHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 10:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbZHSOHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 10:07:35 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:33574 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbZHSOHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 10:07:34 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 1/4] perf_counter: Default to higher paranoia level
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, James Morris <jmorris@namei.org>
In-Reply-To: <20090819092023.728070630@chello.nl>
References: <20090819091823.916851355@chello.nl>
	 <20090819092023.728070630@chello.nl>
Content-Type: text/plain
Date: Wed, 19 Aug 2009 16:07:33 +0200
Message-Id: <1250690853.8282.59.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-19 at 11:18 +0200, Peter Zijlstra wrote:

> +static inline bool perf_paranoid_anon(void)
> +{
> +	return !capable(CAP_SYS_ADMIN) && sysctl_perf_counter_paranoid > 1;
>  }
>  
>  static inline bool perf_paranoid_kernel(void)
>  {
> -	return sysctl_perf_counter_paranoid > 1;
> +	return !capable(CAP_SYS_ADMIN) && sysctl_perf_counter_paranoid > 2;
> +}

OK, this is buggy:

 - capable() uses current, which is unlikely to be counter->owner,
 - but even security_real_capable(counter->owner, ...) wouldn't
   work, since the ->capable() callback isn't NMI safe
   (selinux takes locks and does allocations in that path).

This puts a severe strain on more complex anonymizers since its
basically impossible to tell if counter->owner has permissions on
current from NMI context.

I'll fix up this patch to pre-compute the perf_paranoid_anon_ip() per
counter based on creation time state, unless somebody has a better idea.

I could possibly only anonymize IRQ context (SoftIRQ context is
difficult since in_softirq() means both in-softirq and
softirq-disabled).



