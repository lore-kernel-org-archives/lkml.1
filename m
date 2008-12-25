Return-Path: <linux-kernel-owner+w=401wt.eu-S1752576AbYLYXYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbYLYXYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 18:24:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbYLYXYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 18:24:44 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:49248 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbYLYXYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 18:24:44 -0500
Date: Thu, 25 Dec 2008 16:24:27 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Pavel Machek <pavel@suse.cz>
Cc: Andrew Patterson <andrew.patterson@hp.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, shaohua.li@intel.com
Subject: Re: [PATCH] ASPM: Use msleep instead of cpu_relax during link retraining
Message-ID: <20081225232427.GJ19967@parisc-linux.org>
References: <20081222221156.29645.95982.stgit@bluto> <20081225190129.GA1615@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081225190129.GA1615@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2008 at 08:01:29PM +0100, Pavel Machek wrote:
> On Mon 2008-12-22 15:11:57, Andrew Patterson wrote:
> > ASPM: Use msleep instead of cpu_relax during link retraining
> > 
> > The cpu_relax() function can be a noop on certain architectures
> > like IA-64 when CPU threads are disabled, so use msleep instead
> > during link retraining busy/wait loop.
> 
> Author clearly wanted to do a busy loop... why do you think 10msec
> delay here is acceptable?

10ms?  I see a 1ms sleep.

> > @@ -217,16 +220,18 @@ static void pcie_aspm_configure_common_clock(struct pci_dev *pdev)
> >  	pci_write_config_word(pdev, pos + PCI_EXP_LNKCTL, reg16);
> >  
> >  	/* Wait for link training end */
> > -	/* break out after waiting for 1 second */
> > +	/* break out after waiting for timeout */
> >  	start_jiffies = jiffies;
> > -	while ((jiffies - start_jiffies) < HZ) {
> > +	for (;;) {
> >  		pci_read_config_word(pdev, pos + PCI_EXP_LNKSTA, &reg16);
> >  		if (!(reg16 & PCI_EXP_LNKSTA_LT))
> >  			break;
> > -		cpu_relax();
> > +		if ((jiffies - start_jiffies) >= LINK_RETRAIN_TIMEOUT)
> > +			break;
> > +		msleep(1);
> 
> Is this safe w.r.t. jiffie wraparounds?

Definitely needs to be time_before/time_after.

> >  	}
> >  	/* training failed -> recover */
> > -	if ((jiffies - start_jiffies) >= HZ) {
> > +	if ((jiffies - start_jiffies) >= LINK_RETRAIN_TIMEOUT) {
> >  		dev_printk (KERN_ERR, &pdev->dev, "ASPM: Could not configure"
> >  			    " common clock\n");
> >  		i = 0;
> 
> AFAICT this can trigger false positives. !reg16 test succeeds and then
> jiffies tick.
> 
> ...it could happen before but you make it way more probable...

No, because the test moved.

I came up with this loop (off the top of my head):

<willy>         for (;;) {
<willy>                 pci_read_config_word(pdev, pos + PCI_EXP_LNKSTA, &reg16);
<willy>                 if (!(reg16 & PCI_EXP_LNKSTA_LT))
<willy>                         break;
<willy>                 if ((jiffies - start_jiffies) >= HZ)
<willy>                         break;
<willy>                 msleep(1);
<willy>         }

Andrew has mostly followed that ... improving it to LINK_RETRAIN_TIMEOUT
instead of HZ.

Yes, the subsequent test should be of reg16 instead of jiffies.

And we should be using time_before/after instead of the explicit
comparison.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
