Return-Path: <linux-kernel-owner+w=401wt.eu-S1759000AbZBMT3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000AbZBMT3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 14:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbZBMT3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 14:29:13 -0500
Received: from outbound-mail-29.bluehost.com ([69.89.17.211]:43979 "HELO
	outbound-mail-29.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752608AbZBMT3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 14:29:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=Jz7FHlo1LeeFFQL58Gq9V4ZwEmFNR+eSzqRApLqE7bpaQJiqN9oWlHgxM+3McJOO4Aw5yMOYr7rB4knfoOCy610eHV6gyV0cvOKvLjYmE2y9CLQEs9TzRS+UEr17WVBE;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: [PATCH] pciehp:  Handle interrupts that happen during initialization.
Date: Fri, 13 Feb 2009 11:29:08 -0800
User-Agent: KMail/1.9.10
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <m1pri623g9.fsf@fess.ebiederm.org> <49815BF6.7060402@jp.fujitsu.com>
In-Reply-To: <49815BF6.7060402@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902131129.09523.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any update here, Eric?  Sounds like you're using hotplug in real environments 
with complex topologies (based on your earlier messages), so we're interested 
in what you're seeing here...

Thanks,
Jesse

On Wednesday, January 28, 2009 11:34 pm Kenji Kaneshige wrote:
> Hi,
>
> I don't understand what this patch is trying to fix. Could you
> please tell me more about the problem?
>
> And I have a worry. With this patch, the hotplug operation files
> under /sys/bus/pci/slots/*/ directory will be created before the
> interrupt is initialized. If hotplug operation is initiated (power
> on/off, change attention indicator and so on) by user before
> interrupt is initialized (though I think it's rare), command
> completion event could not be handled.
>
> Thanks,
> Kenji Kaneshige
>
> Eric W. Biederman wrote:
> > Move the enabling of interrupts after all of the data structures
> > are setup so that we can safely run the interrupt handler as
> > soon as it is registered.
> >
> > Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
> > ---
> >  drivers/pci/hotplug/pciehp.h      |    2 ++
> >  drivers/pci/hotplug/pciehp_core.c |    7 +++++++
> >  drivers/pci/hotplug/pciehp_hpc.c  |   15 +++++++--------
> >  3 files changed, 16 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
> > index db85284..39ae375 100644
> > --- a/drivers/pci/hotplug/pciehp.h
> > +++ b/drivers/pci/hotplug/pciehp.h
> > @@ -111,6 +111,7 @@ struct controller {
> >  	int cmd_busy;
> >  	unsigned int no_cmd_complete:1;
> >  	unsigned int link_active_reporting:1;
> > +	unsigned int notification_enabled:1;
> >  };
> >
> >  #define INT_BUTTON_IGNORE		0
> > @@ -170,6 +171,7 @@ extern int pciehp_configure_device(struct slot
> > *p_slot); extern int pciehp_unconfigure_device(struct slot *p_slot);
> >  extern void pciehp_queue_pushbutton_work(struct work_struct *work);
> >  struct controller *pcie_init(struct pcie_device *dev);
> > +int pcie_init_notification(struct controller *ctrl);
> >  int pciehp_enable_slot(struct slot *p_slot);
> >  int pciehp_disable_slot(struct slot *p_slot);
> >  int pcie_enable_notification(struct controller *ctrl);
> > diff --git a/drivers/pci/hotplug/pciehp_core.c
> > b/drivers/pci/hotplug/pciehp_core.c index c248554..681e391 100644
> > --- a/drivers/pci/hotplug/pciehp_core.c
> > +++ b/drivers/pci/hotplug/pciehp_core.c
> > @@ -434,6 +434,13 @@ static int pciehp_probe(struct pcie_device *dev,
> > const struct pcie_port_service_ goto err_out_release_ctlr;
> >  	}
> >
> > +	/* Enable events after we have setup the data structures */
> > +	rc = pcie_init_notification(ctrl);
> > +	if (rc) {
> > +		ctrl_err(ctrl, "Notification initialization failed\n");
> > +		goto err_out_release_ctlr;
> > +	}
> > +
> >  	/* Check if slot is occupied */
> >  	t_slot = pciehp_find_slot(ctrl, ctrl->slot_device_offset);
> >  	t_slot->hpc_ops->get_adapter_status(t_slot, &value);
> > diff --git a/drivers/pci/hotplug/pciehp_hpc.c
> > b/drivers/pci/hotplug/pciehp_hpc.c index 71a8012..7a16c68 100644
> > --- a/drivers/pci/hotplug/pciehp_hpc.c
> > +++ b/drivers/pci/hotplug/pciehp_hpc.c
> > @@ -934,7 +934,7 @@ static void pcie_disable_notification(struct
> > controller *ctrl) ctrl_warn(ctrl, "Cannot disable software
> > notification\n");
> >  }
> >
> > -static int pcie_init_notification(struct controller *ctrl)
> > +int pcie_init_notification(struct controller *ctrl)
> >  {
> >  	if (pciehp_request_irq(ctrl))
> >  		return -1;
> > @@ -942,13 +942,17 @@ static int pcie_init_notification(struct controller
> > *ctrl) pciehp_free_irq(ctrl);
> >  		return -1;
> >  	}
> > +	ctrl->notification_enabled = 1;
> >  	return 0;
> >  }
> >
> >  static void pcie_shutdown_notification(struct controller *ctrl)
> >  {
> > -	pcie_disable_notification(ctrl);
> > -	pciehp_free_irq(ctrl);
> > +	if (ctrl->notification_enabled) {
> > +		pcie_disable_notification(ctrl);
> > +		pciehp_free_irq(ctrl);
> > +		ctrl->notification_enabled = 0;
> > +	}
> >  }
> >
> >  static int pcie_init_slot(struct controller *ctrl)
> > @@ -1110,13 +1114,8 @@ struct controller *pcie_init(struct pcie_device
> > *dev) if (pcie_init_slot(ctrl))
> >  		goto abort_ctrl;
> >
> > -	if (pcie_init_notification(ctrl))
> > -		goto abort_slot;
> > -
> >  	return ctrl;
> >
> > -abort_slot:
> > -	pcie_cleanup_slot(ctrl);
> >  abort_ctrl:
> >  	kfree(ctrl);
> >  abort:



-- 
Jesse Barnes, Intel Open Source Technology Center
