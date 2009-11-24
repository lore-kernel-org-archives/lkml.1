Return-Path: <linux-kernel-owner+w=401wt.eu-S1752241AbZKXFRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbZKXFRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 00:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbZKXFRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 00:17:45 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:53198 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbZKXFRo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 00:17:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rfzwJdYzMBW/I8mWiahVWKn8mWrdYwii3nmozzuIWdMgGJ5BnykFi3QUfW/XuQU1oG
         oUdeyf/4H7boTMhxnoheEdRdXawsF1S1WeTsI/6GTdqFxf2FleU5nIi0A2nogSWCLR6n
         vKWui+2+BxOpTl6RgM4k8Q0T6xXoRJ5B6LM9Y=
MIME-Version: 1.0
In-Reply-To: <1258968980.2697.9.camel@ppwaskie-mobl2>
References: <20091123064630.7385.30498.stgit@ppwaskie-hc2.jf.intel.com>
	 <2674af740911222332i65c0d066h79bf2c1ca1d5e4f0@mail.gmail.com>
	 <1258968980.2697.9.camel@ppwaskie-mobl2>
Date: Tue, 24 Nov 2009 13:17:50 +0800
Message-ID: <2674af740911232117l275e933yaca3f1b8c1207bce@mail.gmail.com>
Subject: Re: [PATCH] irq: Add node_affinity CPU masks for smarter irqbalance 
	hints
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.jf.intel.com" <arjan@linux.jf.intel.com>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[snip]
>>
>> 1) I think you should consider CONFIG_CPUMASK_OFFSTACK which will affect
>>    node_affinity.
>> 2) It seems like this patch can't work with SPARSE_IRQ.
>
> This mechanism isn't going to be used by any internal kernel mechanism
> for determining interrupt placement or operation.  It's purely something
> that either a driver can modify, or external script (through /proc),
> that irqbalance will make use of.  If irqbalance isn't running, or the
> current version of irqbalance doesn't support reading node_affinity,
> then it won't affect the system's operation.
>
> If irqbalance does support it, it'll read whatever the supplied mask is,
> and then will try and balance interrupts within that mask.  It will bail
> if the mask is invalid, or won't apply to the running system, just like
> how putting a bogus mask into smp_affinity is ignored.
>
> If there's something I'm missing beyond this with the two suggestions
> you've made (I looked into those two parameters and tried to draw
> conclusions), please let me know.

My two suggestions are both about your adding node_affinity. Before you can
use this element, you must initialise it firstly. You can refer how
irq_desc::affinity
is used in function alloc_desc_masks().
include/linux/irq.h:
static inline bool alloc_desc_masks(struct irq_desc *desc, int node,
							bool boot)
{
	gfp_t gfp = GFP_ATOMIC;

	if (boot)
		gfp = GFP_NOWAIT;

#ifdef CONFIG_CPUMASK_OFFSTACK
	if (!alloc_cpumask_var_node(&desc->affinity, gfp, node))
		return false;

#ifdef CONFIG_GENERIC_PENDING_IRQ
	if (!alloc_cpumask_var_node(&desc->pending_mask, gfp, node)) {
		free_cpumask_var(desc->affinity);
		return false;
	}
#endif
#endif
	return true;
}

Thanks,
Yong

>
> Cheers,
> -PJ Waskiewicz
>
>
