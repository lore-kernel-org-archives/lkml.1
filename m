Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303AbYKRV5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbYKRV5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 16:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbYKRV51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 16:57:27 -0500
Received: from smooth.piipiip.net ([194.100.76.170]:36220 "EHLO
	smooth.piipiip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbYKRV51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 16:57:27 -0500
Date: Tue, 18 Nov 2008 23:57:23 +0200
From: Jarkko Lavinen <jlavi@iki.fi>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Doug Thompson <dougthompson@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: i82875p_edac: BAR 0 collision
Message-ID: <20081118215723.GA3121@piipiip.net>
References: <20081107114355.GA31730@piipiip.net> <20081111000152.271d9706.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111000152.271d9706.akpm@linux-foundation.org>
X-Operating-System: Linux smooth.piipiip.net 2.6.18-5-k7
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: jlavi@piipiip.net
X-SA-Exim-Scanned: No (on smooth.piipiip.net); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 12:01:52AM -0800, Andrew Morton wrote:
> On Fri, 7 Nov 2008 13:43:55 +0200 Jarkko Lavinen <jlavi@iki.fi> wrote:
> > When I try load i82875p_edac module on 2.6.27 I get
> > 
> >   # modprobe i82875p_edac
> >   FATAL: Error inserting i82875p_edac
> >   (/lib/modules/2.6.27.4/kernel/drivers/edac/i82875p_edac.ko): No such device

> Might be an EDAC driver regression.  It might also be a consequence of
> PCI address space management fiddlings, but I think most of the changes
> there post-date 2.6.26?

I can get around the modprobe problem by adding the missing resource after 
the hidden overflow device is revealed. The diff below is against 2.6.27.

	--- a/drivers/edac/i82875p_edac.c
	+++ b/drivers/edac/i82875p_edac.c
	@@ -295,6 +295,7 @@ static int i82875p_setup_overfl_dev(struct pci_dev *pdev,
	                                "%s(): pci_bus_add_device() Failed\n",
	                                __func__);
	                }
	+               pci_bus_assign_resources(dev->bus);
	        }
	 
	        *ovrfl_pdev = dev;

The access violation when doing "rmmod i82875p_edac" occurs
because the module exit function i82875p_exit() runs
pci_unregister_driver() while the edac_mc_workq_function() is
scheduled to be run.  When the work queue runs, it accesses
something not available anymore.

	static void __exit i82875p_exit(void)
	{
		debugf3("%s()\n", __func__);

	+	mci_saved->op_state = OP_OFFLINE;

		pci_unregister_driver(&i82875p_driver);

		if (!i82875p_registered) {
			i82875p_remove_one(mci_pdev);
			pci_dev_put(mci_pdev);
		}
	}
		

I tried to stop the workqueue by saving mci pointer at the time
of its allocation and just set its state to OFFLINE just before
calling pci_unregister_driver.

This isn't the right way to remove the module and edac_dore has 
refcount 2 after i82875p_edac has been removed. The refcount 
should be 0.

Cheers
Jarkko Lavinen
