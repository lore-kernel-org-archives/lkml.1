Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbYIDOUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbYIDOUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 10:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbYIDOTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 10:19:54 -0400
Received: from smarthost01.mail.zen.net.uk ([212.23.3.140]:54624 "EHLO
	smarthost01.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750958AbYIDOTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 10:19:53 -0400
Date: Thu, 4 Sep 2008 15:19:46 +0100
From: Ben Hutchings <bhutchings@solarflare.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/3] pci: VPD access timeout increase
Message-ID: <20080904141944.GE7908@solarflare.com>
References: <20080827204626.4b65862f@extreme> <20080828111323.GI7908@solarflare.com> <20080903155713.7fab2e19@extreme> <20080904125219.GJ2772@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904125219.GJ2772@parisc-linux.org>
User-Agent: Mutt/1.4.1i
X-Originating-Smarthost01-IP: [82.69.137.158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Wed, Sep 03, 2008 at 03:57:13PM -0700, Stephen Hemminger wrote:
> > Accessing the VPD area can take a long time. There are comments in the
> > SysKonnect vendor driver that it can take up to 25ms.  The existing vpd
> > access code fails consistently on my hardware.
> 
> Wow, that's slow.  If you were to try to read all 32k, it'd take more
> than three minutes!  (I presume it doesn't actually have as much as 32k).
> 
> > Change the access routines to:
> >   * use a mutex rather than spinning with IRQ's disabled and lock held
> >   * have a longer timeout
> >   * call schedule while spinning to provide some responsivness
> 
> I agree with your approach, but have one minor comment:
> 
> > -	spin_lock_irq(&vpd->lock);
> > +	mutex_lock(&vpd->lock);
> 
> This should be:
> 
> +	if (mutex_lock_interruptible(&vpd->lock))
> +		return -EINTR;
[...]

This is fine for the sysfs case, but not if this is called during device
probe - we don't want signals to modprobe to break device initialisation,
do we?

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.
