Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbYFSWfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbYFSWfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 18:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbYFSWfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 18:35:43 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:17740 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbYFSWfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 18:35:42 -0400
X-IronPort-AV: E=Sophos;i="4.27,674,1204531200"; 
   d="scan'208";a="81797536"
From: Roland Dreier <rdreier@cisco.com>
To: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>, general@lists.openfabrics.org,
       fenkes@de.ibm.com, raisch@de.ibm.com, hnguyen@de.ibm.com
Subject: Re: [PATCH REPOST #2] IB/ehca: In case of lost interrupts, trigger EOI to reenable interrupts
References: <200806131655.43410.ossrosch@linux.vnet.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 19 Jun 2008 15:35:40 -0700
In-Reply-To: <200806131655.43410.ossrosch@linux.vnet.ibm.com> (Stefan
	Roscher's message of "Fri, 13 Jun 2008 16:55:41 +0200")
Message-ID: <adafxr9uk77.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 Jun 2008 22:35:40.0678 (UTC) FILETIME=[CD82BA60:01C8D25C]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > During corner case testing, we noticed that some versions of ehca 
 > do not properly transition to interrupt done in special load situations.
 > This can be resolved by periodically triggering EOI through H_EOI, 
 > if eqes are pending.
 > 
 > Signed-off-by: Stefan Roscher <stefan.roscher@de.ibm.com>
 > ---
 > As firmware team suggested I moved the call of the EOI h_call into 
 > the handler function, this ensures that we will call EOI only when we 
 > find a valid eqe on the event queue.
 > Additionally I changed the calculation of the xirr value as Roland suggested.

paulus / benh -- does this version still get your ack?  Seems that fw
team is OK with it according to Stefan...

If so I will add this to my tree for 2.6.27.

 > diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
 > index ce1ab05..0792d93 100644
 > --- a/drivers/infiniband/hw/ehca/ehca_irq.c
 > +++ b/drivers/infiniband/hw/ehca/ehca_irq.c
 > @@ -531,7 +531,7 @@ void ehca_process_eq(struct ehca_shca *shca, int is_irq)
 >  {
 >  	struct ehca_eq *eq = &shca->eq;
 >  	struct ehca_eqe_cache_entry *eqe_cache = eq->eqe_cache;
 > -	u64 eqe_value;
 > +	u64 eqe_value, ret;
 >  	unsigned long flags;
 >  	int eqe_cnt, i;
 >  	int eq_empty = 0;
 > @@ -583,8 +583,13 @@ void ehca_process_eq(struct ehca_shca *shca, int is_irq)
 >  			ehca_dbg(&shca->ib_device,
 >  				 "No eqe found for irq event");
 >  		goto unlock_irq_spinlock;
 > -	} else if (!is_irq)
 > +	} else if (!is_irq) {
 > +		ret = hipz_h_eoi(eq->ist);
 > +		if (ret != H_SUCCESS)
 > +			ehca_err(&shca->ib_device,
 > +				 "bad return code EOI -rc = %ld\n", ret);
 >  		ehca_dbg(&shca->ib_device, "deadman found %x eqe", eqe_cnt);
 > +	}
 >  	if (unlikely(eqe_cnt == EHCA_EQE_CACHE_SIZE))
 >  		ehca_dbg(&shca->ib_device, "too many eqes for one irq event");
 >  	/* enable irq for new packets */
 > diff --git a/drivers/infiniband/hw/ehca/hcp_if.c b/drivers/infiniband/hw/ehca/hcp_if.c
 > index 5245e13..415d3a4 100644
 > --- a/drivers/infiniband/hw/ehca/hcp_if.c
 > +++ b/drivers/infiniband/hw/ehca/hcp_if.c
 > @@ -933,3 +933,13 @@ u64 hipz_h_error_data(const struct ipz_adapter_handle adapter_handle,
 >  				       r_cb,
 >  				       0, 0, 0, 0);
 >  }
 > +
 > +u64 hipz_h_eoi(int irq)
 > +{
 > +	unsigned long xirr;
 > +
 > +	iosync();
 > +	xirr = (0xffULL << 24) | irq;
 > +
 > +	return plpar_hcall_norets(H_EOI, xirr);
 > +}
 > diff --git a/drivers/infiniband/hw/ehca/hcp_if.h b/drivers/infiniband/hw/ehca/hcp_if.h
 > index 60ce02b..2c3c6e0 100644
 > --- a/drivers/infiniband/hw/ehca/hcp_if.h
 > +++ b/drivers/infiniband/hw/ehca/hcp_if.h
 > @@ -260,5 +260,6 @@ u64 hipz_h_error_data(const struct ipz_adapter_handle adapter_handle,
 >  		      const u64 ressource_handle,
 >  		      void *rblock,
 >  		      unsigned long *byte_count);
 > +u64 hipz_h_eoi(int irq);
 >  
 >  #endif /* __HCP_IF_H__ */
 > -- 
 > 1.5.5
 > 
 > 
