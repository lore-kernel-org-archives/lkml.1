Return-Path: <linux-kernel-owner+w=401wt.eu-S1757640AbZBCA6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640AbZBCA6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 19:58:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbZBCA6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 19:58:47 -0500
Received: from gate.crashing.org ([63.228.1.57]:50189 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933AbZBCA6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 19:58:46 -0500
Subject: Re: PCI PM: Restore standard config registers of all devices early
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.0902021508340.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>
	 <200902022239.02453.rjw@sisk.pl>
	 <alpine.LFD.2.00.0902021343280.3247@localhost.localdomain>
	 <200902022331.49131.rjw@sisk.pl>
	 <alpine.LFD.2.00.0902021508340.3247@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 11:58:05 +1100
Message-Id: <1233622685.18767.142.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> (background: pci_restore_standard_config() will have done 
> pci_raw_set_power_state(PCI_D0) with the device clocks off, which wouldn't 
> actualyl have _done_ anythign to the device, but then it does

Actually, we are lucky we don't even crash with a machine check when
hitting an unclocked device ...

I found a problem with radeonfb (patch sent separately) that explains
the breakage on one of my recent machines, but I wouldn't be surprised
if some other models of powerbooks/ibooks have also problem with USB
as you mentioned. IE. I have to check whether the ones doing PCI D state
can also use the Apple specific clock stuff. We might be lucky and they
are exclusive from each other.

Also, the nice thing with turning clocks off on these Apple ASICs is
that it doesn't lose the config space content. So we may just get lucky
here.

> Ben, does this trivial patch make any difference for those powermacs?

On my test setup, the problem is radeonfb and I just made a patch to fix
it. But it's using some standard PCI USB, not the older fancy Apple
stuff. I'll check on an older machine tongight when I get back home, I
don't have one here.

Cheers,
Ben.

> 		Linus
> ---
>  drivers/pci/pci.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 17bd932..97e1c38 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1419,7 +1419,7 @@ int pci_restore_standard_config(struct pci_dev *dev)
>  		}
>  	}
>  
> -	dev->current_state = PCI_D0;
> +	pci_update_current_state(dev, PCI_D0);
>  
>  	return 0;
>  }

