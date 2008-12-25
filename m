Return-Path: <linux-kernel-owner+w=401wt.eu-S1752551AbYLYTBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbYLYTBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 14:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbYLYTBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 14:01:40 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59643 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbYLYTBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 14:01:39 -0500
Date: Thu, 25 Dec 2008 20:01:29 +0100
From: Pavel Machek <pavel@suse.cz>
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, matthew@wil.cx,
       shaohua.li@intel.com
Subject: Re: [PATCH] ASPM: Use msleep instead of cpu_relax during link
	retraining
Message-ID: <20081225190129.GA1615@ucw.cz>
References: <20081222221156.29645.95982.stgit@bluto>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081222221156.29645.95982.stgit@bluto>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-12-22 15:11:57, Andrew Patterson wrote:
> ASPM: Use msleep instead of cpu_relax during link retraining
> 
> The cpu_relax() function can be a noop on certain architectures
> like IA-64 when CPU threads are disabled, so use msleep instead
> during link retraining busy/wait loop.

Author clearly wanted to do a busy loop... why do you think 10msec
delay here is acceptable?
  

> Introduce define LINK_RETRAIN_TIMEOUT instead of hard-coding
> timeout in pcie_aspm_configure_common_clock.
> 
> Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
> @@ -70,6 +71,8 @@ static const char *policy_str[] = {
>  	[POLICY_POWERSAVE] = "powersave"
>  };
>  
> +#define LINK_RETRAIN_TIMEOUT HZ
> +
>  static int policy_to_aspm_state(struct pci_dev *pdev)
>  {
>  	struct pcie_link_state *link_state = pdev->link_state;
> @@ -217,16 +220,18 @@ static void pcie_aspm_configure_common_clock(struct pci_dev *pdev)
>  	pci_write_config_word(pdev, pos + PCI_EXP_LNKCTL, reg16);
>  
>  	/* Wait for link training end */
> -	/* break out after waiting for 1 second */
> +	/* break out after waiting for timeout */
>  	start_jiffies = jiffies;
> -	while ((jiffies - start_jiffies) < HZ) {
> +	for (;;) {
>  		pci_read_config_word(pdev, pos + PCI_EXP_LNKSTA, &reg16);
>  		if (!(reg16 & PCI_EXP_LNKSTA_LT))
>  			break;
> -		cpu_relax();
> +		if ((jiffies - start_jiffies) >= LINK_RETRAIN_TIMEOUT)
> +			break;
> +		msleep(1);

Is this safe w.r.t. jiffie wraparounds?

>  	}
>  	/* training failed -> recover */
> -	if ((jiffies - start_jiffies) >= HZ) {
> +	if ((jiffies - start_jiffies) >= LINK_RETRAIN_TIMEOUT) {
>  		dev_printk (KERN_ERR, &pdev->dev, "ASPM: Could not configure"
>  			    " common clock\n");
>  		i = 0;

AFAICT this can trigger false positives. !reg16 test succeeds and then
jiffies tick.

...it could happen before but you make it way more probable...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
