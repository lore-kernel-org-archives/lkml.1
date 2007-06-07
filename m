Return-Path: <linux-kernel-owner+w=401wt.eu-S1755786AbXFGIBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbXFGIBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 04:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbXFGIBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 04:01:45 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:59059 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbXFGIBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 04:01:44 -0400
Date: Thu, 7 Jun 2007 01:01:32 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/22] 2.6.22-rc3 perfmon2 : PMU context switch support
Message-ID: <20070607080132.GB14081@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <200705291348.l4TDmOkk019736@frankl.hpl.hp.com> <alpine.DEB.0.99.0706040749170.11881@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.99.0706040749170.11881@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Mon, Jun 04, 2007 at 07:50:27AM -0700, David Rientjes wrote:
> > + * 02111-1307 USA
> > + */
> > +#include <linux/kernel.h>
> > +#include <linux/perfmon.h>
> > +
> > +/*
> > + * used only in UP mode
> > + */
> > +void pfm_save_prev_context(struct pfm_context *ctxp)
> > +{
> 
> Is this comment still valid even though there's a call to this function in 
> the self-monitoring case in __pfm_load_context()?
> 
Yes. I have added the #ifndef CONFIG_SMP if __pfm_load_context(). The reason
for this is that in UP mode we use lazy save/restore on context switch. Thus
when you come in to load a context on the PMU, you may need to push the previous
context out.

> > +
> > +void pfm_save_pmds(struct pfm_context *ctx, struct pfm_event_set *set)
> > +{
> > +	u64 val, hw_val, *pmds, ovfl_mask;
> > +	u64 *used_mask, *cnt_mask;
> > +	u16 i, num;
> > +
> > +	ovfl_mask = pfm_pmu_conf->ovfl_mask;
> > +	num = set->nused_pmds;
> > +	cnt_mask = pfm_pmu_conf->cnt_pmds;
> > +	used_mask = set->used_pmds;
> > +	pmds = set->view->set_pmds;
> > +
> > +	for (i = 0; num; i++) {
> 
> This should probably be "i++, num--".
> 
No. Num represents the number of PMD registers we need to read. We only
read the PMD registers we use. Thus num needs to be decremented only when
i is the index of a *used* PM register.

> > +		if (test_bit(i, ulp(used_mask))) {
> > +			hw_val = val = pfm_read_pmd(ctx, i);
> > +			if (likely(test_bit(i, ulp(cnt_mask))))
> > +				val = (pmds[i] & ~ovfl_mask) |
> > +					(hw_val & ovfl_mask);
> > +			pmds[i] = val;
> > +			num--;
> > +		}
> > +	}
> > +}
> 
> You can elimiate the hw_val automatic by eliminating its assignment and 
> replacing its use with val.
> 
Done.

Thanks for your feedback.

-- 

-Stephane
