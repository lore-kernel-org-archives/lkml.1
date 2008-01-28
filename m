Return-Path: <linux-kernel-owner+w=401wt.eu-S1754277AbYA1Fet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbYA1Fet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 00:34:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbYA1Fd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 00:33:27 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60112 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755163AbYA1Fd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 00:33:26 -0500
Date: Sun, 27 Jan 2008 21:33:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       auke-jan.h.kok@intel.com, jesse.brandeburg@intel.com,
       jeffrey.t.kirsher@intel.com, john.ronciak@intel.com,
       e1000-devel@lists.sourceforge.net, venkatesh.pallipadi@intel.com
Subject: Re: [PATCH 1/1] Net: e100, fix iomap mem accesses
Message-Id: <20080127213330.148989f1.akpm@linux-foundation.org>
In-Reply-To: <4791004B.50408@garzik.org>
References: <1200608900-3507-1-git-send-email-jirislaby@gmail.com>
	<4791004B.50408@garzik.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008 14:38:51 -0500 Jeff Garzik <jeff@garzik.org> wrote:

> Jiri Slaby wrote:
> > readX functions are not permitted on iomap-ped space change to ioreadX,
> > also pci_unmap pci_map-ped space on exit (instead of iounmap).
> > 
> > Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> > ---
> >  drivers/net/e100.c |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/net/e100.c b/drivers/net/e100.c
> > index 51cf577..47548ef 100644
> > --- a/drivers/net/e100.c
> > +++ b/drivers/net/e100.c
> > @@ -1836,7 +1836,7 @@ static int e100_rx_indicate(struct nic *nic, struct rx *rx,
> >  		if ((le16_to_cpu(rfd->command) & cb_el) &&
> >  		    (RU_RUNNING == nic->ru_running))
> >  
> > -			if (readb(&nic->csr->scb.status) & rus_no_res)
> > +			if (ioread8(&nic->csr->scb.status) & rus_no_res)
> >  				nic->ru_running = RU_SUSPENDED;
> >  		return -ENODATA;
> >  	}
> > @@ -1859,7 +1859,7 @@ static int e100_rx_indicate(struct nic *nic, struct rx *rx,
> >  	if ((le16_to_cpu(rfd->command) & cb_el) &&
> >  	    (RU_RUNNING == nic->ru_running)) {
> >  
> > -	    if (readb(&nic->csr->scb.status) & rus_no_res)
> > +	    if (ioread8(&nic->csr->scb.status) & rus_no_res)
> >  		nic->ru_running = RU_SUSPENDED;
> >  	}
> >  
> > @@ -1958,7 +1958,7 @@ static void e100_rx_clean(struct nic *nic, unsigned int *work_done,
> >  
> >  	if(restart_required) {
> >  		// ack the rnr?
> > -		writeb(stat_ack_rnr, &nic->csr->scb.stat_ack);
> > +		iowrite8(stat_ack_rnr, &nic->csr->scb.stat_ack);
> >  		e100_start_receiver(nic, nic->rx_to_clean);
> >  		if(work_done)
> >  			(*work_done)++;
> > @@ -2774,7 +2774,7 @@ static void __devexit e100_remove(struct pci_dev *pdev)
> >  		struct nic *nic = netdev_priv(netdev);
> >  		unregister_netdev(netdev);
> >  		e100_free(nic);
> > -		iounmap(nic->csr);
> > +		pci_iounmap(pdev, nic->csr);
> >  		free_netdev(netdev);
> >  		pci_release_regions(pdev);
> 
> ACK, but patch doesn't seem to apply...

It's been a week, nothing seems to have happened and the e100 maintainers
are asleep.

Please resend when convenient.  Maybe more luodly or something, I dunno.
