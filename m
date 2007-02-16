Return-Path: <linux-kernel-owner+w=401wt.eu-S1423122AbXBPEBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423122AbXBPEBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 23:01:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423123AbXBPEBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 23:01:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:37979 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423122AbXBPEBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 23:01:06 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Subject: Re: e1000_intr in request_irq faults in 2.6.20-git
Date: Thu, 15 Feb 2007 22:59:33 -0500
User-Agent: KMail/1.9.5
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       "lkml - Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <36D9DB17C6DE9E40B059440DB8D95F5201E997BA@orsmsx418.amr.corp.intel.com>
In-Reply-To: <36D9DB17C6DE9E40B059440DB8D95F5201E997BA@orsmsx418.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702152259.34162.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 February 2007 21:10, Brandeburg, Jesse wrote:
> Eric W. Biederman wrote:
> > Len Brown <lenb@kernel.org> writes:
> > 
> >> e1000 faults in 2.6.20-git, while 2.6.20 worked fine.
> >> 
> >> System is a D875PBZ with LOM.
> >> 
> >> clues?
> > 
> > I'm guessing this is an old bug found by the following bit of
> > debug coded added into since v2.6.20
> > 
> > +#ifdef CONFIG_DEBUG_SHIRQ
> > +       if (irqflags & IRQF_SHARED) {
> > +               /*
> > +                * It's a shared IRQ -- the driver ought to be
> > prepared for it +                * to happen immediately, so let's
> > make sure.... +                * We do this before actually
> > registering it, to make sure that +                * a 'real' IRQ
> > doesn't run in parallel with our fake +                */
> > +               if (irqflags & IRQF_DISABLED) {
> > +                       unsigned long flags;
> > +
> > +                       local_irq_save(flags);
> > +                       handler(irq, dev_id);
> > +                       local_irq_restore(flags);
> > +               } else
> > +                       handler(irq, dev_id);
> > +       }
> > +#endif
> > 
> > I don't have a clue why the e1000 wasn't ready though.
> > 
> 
> our code is clearly calling request_irq before we have assigned the
> function pointer adapter->clean_rx as well as adapter->alloc_rx_buf
> 
> That would be a bug, a possible patch would be (inline and attached):
> compile tested, *but* I couldn't test this patch to make sure it worked
> because I couldn't boot 2.6.20-git due to it not finding my RAID0 + lvm
> disk.
> 
> [PATCH] e1000: fix shared interrupt warning message
> 
> From: Jesse Brandeburg <jesse.brandeburg@intel.com>
> 
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
> 
>  drivers/net/e1000/e1000_main.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/e1000/e1000_main.c
> b/drivers/net/e1000/e1000_main.c
> index 619c892..b8c4d5c 100644
> --- a/drivers/net/e1000/e1000_main.c
> +++ b/drivers/net/e1000/e1000_main.c
> @@ -1417,10 +1417,6 @@ e1000_open(struct net_device *netdev)
>         if ((err = e1000_setup_all_rx_resources(adapter)))
>                 goto err_setup_rx;
> 
> -       err = e1000_request_irq(adapter);
> -       if (err)
> -               goto err_req_irq;
> -
>         e1000_power_up_phy(adapter);
> 
>         if ((err = e1000_up(adapter)))
> @@ -1431,6 +1427,10 @@ e1000_open(struct net_device *netdev)
>                 e1000_update_mng_vlan(adapter);
>         }
> 
> +       err = e1000_request_irq(adapter);
> +       if (err)
> +               goto err_req_irq;
> +
>         /* If AMT is enabled, let the firmware know that the network
>          * interface is now open */
>         if (adapter->hw.mac_type == e1000_82573 &&
> @@ -1439,10 +1439,11 @@ e1000_open(struct net_device *netdev)
> 
>         return E1000_SUCCESS;
> 
> +err_req_irq:
> +       e1000_down(adapter);
> +       e1000_free_irq(adapter);
>  err_up:
>         e1000_power_down_phy(adapter);
> -       e1000_free_irq(adapter);
> -err_req_irq:
>         e1000_free_all_rx_resources(adapter);
>  err_setup_rx:
>         e1000_free_all_tx_resources(adapter);
> 

Works for me(tm) on latest 2.6.20-git and D875PBZ.

thanks,
-Len
