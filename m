Return-Path: <linux-kernel-owner+w=401wt.eu-S932270AbXIBW0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270AbXIBW0y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 18:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbXIBW0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 18:26:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57026 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbXIBW0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 18:26:43 -0400
Date: Mon, 3 Sep 2007 04:09:15 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Jeff Garzik <jeff@garzik.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Bottomley <james.bottomley@steeleye.com>, aacraid@adaptec.com,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH -mm] IPS SCSI driver: Check return of scsi_add_host()
In-Reply-To: <46DB1DCA.3050509@garzik.org>
Message-ID: <alpine.LFD.0.999.0709030407040.31154@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i
 n> <alpine.LFD.0.999.0709030142490.29617@enigma.security.iitk.ac.in>
 <46DB1DCA.3050509@garzik.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="464262402-1312230887-1188772759=:31154"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--464262402-1312230887-1188772759=:31154
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Sun, 2 Sep 2007, Jeff Garzik wrote:

> Satyam Sharma wrote:
> > drivers/scsi/ips.c: In function ‘ips_register_scsi’:
> > drivers/scsi/ips.c:6869:
> > warning: ignoring return value of ‘scsi_add_host’, declared with attribute
> > warn_unused_result
> > 
> > scsi_add_host() is __must_check, so let's check it's return and cleanup
> > appropriately on errors.
> > 
> > Signed-off-by: Satyam Sharma <satyam@infradead.org>
> > 
> > ---
> > 
> >  drivers/scsi/ips.c |    7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > --- linux-2.6.23-rc4-mm1/drivers/scsi/ips.c~fix	2007-09-02
> > 20:21:27.000000000 +0530
> > +++ linux-2.6.23-rc4-mm1/drivers/scsi/ips.c	2007-09-02 20:25:58.000000000
> > +0530
> > @@ -6866,7 +6866,12 @@ ips_register_scsi(int index)
> >  	sh->max_channel = ha->nbus - 1;
> >  	sh->can_queue = ha->max_cmds - 1;
> >  -	scsi_add_host(sh, NULL);
> > +	if (scsi_add_host(sh, NULL)) {
> > +		IPS_PRINTK(KERN_WARNING, ha->pcidev, "Unable to add SCSI
> > host\n");
> > +		free_irq(ha->irq, ha);
> > +		scsi_host_put(sh);
> > +		return -1;
> 
> ACK, as long as you add a comment to this code and the request_irq() failure
> code:  the oldha/old irq is not restored upon failure, in this function.
> 
> That is a pre-existing bug, and not your fault, but your patch "continues in
> the same buggy tradition" :)  We should at least note the FIXME at each error
> handling code branch.

True, I did notice that (as well as the coding style issue you pointed
out) when making the patch, but felt lazy to actually set it right fully.
And that (when it's done) should be a separate patch anyway.
--464262402-1312230887-1188772759=:31154--
