Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbXFDOzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbXFDOzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 10:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbXFDOzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 10:55:11 -0400
Received: from smtp-out.google.com ([216.239.45.13]:8524 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbXFDOzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 10:55:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=iFsqYEbE4l1Pw5gjrU+ravBkTClXaOwSPzYHpraZsDPAs0jGZw5+Eeb+fcfCWoJp/
	GeMeUNe1YUSO+yucs0zgw==
Date: Mon, 4 Jun 2007 07:50:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Stephane Eranian <eranian@frankl.hpl.hp.com>
cc: linux-kernel@vger.kernel.org, eranian@hpl.hp.com
Subject: Re: [PATCH 10/22] 2.6.22-rc3 perfmon2 : PMU context switch support
In-Reply-To: <200705291348.l4TDmOkk019736@frankl.hpl.hp.com>
Message-ID: <alpine.DEB.0.99.0706040749170.11881@chino.kir.corp.google.com>
References: <200705291348.l4TDmOkk019736@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007, Stephane Eranian wrote:

> --- linux-2.6.22.base/perfmon/perfmon_ctxsw.c	1969-12-31 16:00:00.000000000 -0800
> +++ linux-2.6.22/perfmon/perfmon_ctxsw.c	2007-05-29 03:24:14.000000000 -0700
> @@ -0,0 +1,341 @@
> +/*
> + * perfmon_cxtsw.c: perfmon2 context switch code
> + *
> + * This file implements the perfmon2 interface which
> + * provides access to the hardware performance counters
> + * of the host processor.
> + *
> + * The initial version of perfmon.c was written by
> + * Ganesh Venkitachalam, IBM Corp.
> + *
> + * Then it was modified for perfmon-1.x by Stephane Eranian and
> + * David Mosberger, Hewlett Packard Co.
> + *
> + * Version Perfmon-2.x is a complete rewrite of perfmon-1.x
> + * by Stephane Eranian, Hewlett Packard Co.
> + *
> + * Copyright (c) 1999-2006 Hewlett-Packard Development Company, L.P.
> + * Contributed by Stephane Eranian <eranian@hpl.hp.com>
> + *                David Mosberger-Tang <davidm@hpl.hp.com>
> + *
> + * More information about perfmon available at:
> + * 	http://perfmon2.sf.net
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of version 2 of the GNU General Public
> + * License as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
> + * 02111-1307 USA
> + */
> +#include <linux/kernel.h>
> +#include <linux/perfmon.h>
> +
> +/*
> + * used only in UP mode
> + */
> +void pfm_save_prev_context(struct pfm_context *ctxp)
> +{

Is this comment still valid even though there's a call to this function in 
the self-monitoring case in __pfm_load_context()?

> +	struct pfm_event_set *set;
> +
> +	/*
> +	 * in UP per-thread, due to lazy save
> +	 * there could be a context from another
> +	 * task. We need to push it first before
> +	 * installing our new state
> +	 */
> +	set = ctxp->active_set;
> +	pfm_modview_begin(set);
> +	pfm_save_pmds(ctxp, set);
> +	set->view->set_status &= ~PFM_SETVFL_ACTIVE;
> +	pfm_modview_end(set);
> +	/*
> +	 * do not clear ownership because we rewrite
> +	 * right away
> +	 */
> +}
> +
> +void pfm_save_pmds(struct pfm_context *ctx, struct pfm_event_set *set)
> +{
> +	u64 val, hw_val, *pmds, ovfl_mask;
> +	u64 *used_mask, *cnt_mask;
> +	u16 i, num;
> +
> +	ovfl_mask = pfm_pmu_conf->ovfl_mask;
> +	num = set->nused_pmds;
> +	cnt_mask = pfm_pmu_conf->cnt_pmds;
> +	used_mask = set->used_pmds;
> +	pmds = set->view->set_pmds;
> +
> +	for (i = 0; num; i++) {

This should probably be "i++, num--".

> +		if (test_bit(i, ulp(used_mask))) {
> +			hw_val = val = pfm_read_pmd(ctx, i);
> +			if (likely(test_bit(i, ulp(cnt_mask))))
> +				val = (pmds[i] & ~ovfl_mask) |
> +					(hw_val & ovfl_mask);
> +			pmds[i] = val;
> +			num--;
> +		}
> +	}
> +}

You can elimiate the hw_val automatic by eliminating its assignment and 
replacing its use with val.

		David
