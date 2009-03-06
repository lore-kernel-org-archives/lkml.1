Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbZCFLmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbZCFLmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 06:42:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbZCFLl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 06:41:56 -0500
Received: from ping.pong.ch ([212.103.71.101]:39414 "EHLO ping.pong.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbZCFLlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 06:41:55 -0500
Date: Fri, 6 Mar 2009 12:41:49 +0100
From: Gaudenz Steinlin <gaudenz@soziologie.ch>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: commit "radeonfb: Fix resume from D3Cold on some platforms"
	breaks resume from RAM on PowerBook
Message-ID: <20090306114149.GA5371@soziologie.ch>
References: <20090304083859.GB6889@soziologie.ch> <1236219920.7260.6.camel@pasglop> <20090305125919.GA5474@soziologie.ch> <1236318629.7260.120.camel@pasglop> <20090306090906.GA5183@soziologie.ch> <1236333440.7260.136.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236333440.7260.136.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 08:57:20PM +1100, Benjamin Herrenschmidt wrote:
> 
> > So you are able to resume with my minimal config + CPU_FREQ? This would
> > be really strange if it is really the exact same model.
> 
> Yes, it appears to be :-)
> 
> > To verify if we really have the same model I included some data below. I
> > also included the gcc and binutils versions.
> > 
> > Please tell me if you have any further ideas on what to test.
> 
> In the commmit your revert, I added a function that "tests" if the chip
> appears to need to be POSTed: radeon_check_power_loss(). Try commenting
> out the content and make it always return 1.

This does not help.

> 
> Another thing you can try in radeonfb_pci_resume():
> 
>         if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
> +		pci_restore_state(pdev);

Adding this fixes the bug. Apparently the PCI core does not fully
restore the state. Before your suggestions I also tried to find out
which part of your commit breaks resume and I found out that if I
reinsert the parts to save and restore the pci configuration the bug is
fixed. It seems that somehow the PCI coniguration is not fully restored [1].  

> +		pci_enable_device(pdev);

This does not help.

> +		pci_set_master(pdev);

This does not help.

Gaudenz

[1] These are just my wild guesses. I don't really understand much of
the code involved.

-- 
Ever tried. Ever failed. No matter.
Try again. Fail again. Fail better.
~ Samuel Beckett ~
