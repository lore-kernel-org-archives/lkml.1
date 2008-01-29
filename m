Return-Path: <linux-kernel-owner+w=401wt.eu-S1761071AbYA2DsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761071AbYA2DsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 22:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbYA2DsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 22:48:10 -0500
Received: from ns2.suse.de ([195.135.220.15]:46554 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbYA2DsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 22:48:09 -0500
To: "Joachim Deguara" <joachim.deguara@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, yinghai.lu@sun.com,
       "Dean Roe" <roe@cray.com>
Subject: Re: [PATCH] x86: add PCI IDs to k8topology_64.c
From: Andi Kleen <andi@firstfloor.org>
References: <200801281211.28214.joachim.deguara@amd.com>
Date: Tue, 29 Jan 2008 04:48:06 +0100
In-Reply-To: <200801281211.28214.joachim.deguara@amd.com> (Joachim Deguara's message of "Mon\, 28 Jan 2008 12\:11\:27 -0800")
Message-ID: <p73y7a970nd.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Joachim Deguara" <joachim.deguara@amd.com> writes:

> Quick history, this is a harmless patch that got dropped by Andi as a mixup to 

It's not harmless.

> dropping another patch of mine that was made obsolete by Yinghai.
> http://thread.gmane.org/gmane.linux.kernel/559581

No that's not the correct history. The correct history is that 
I intentionally rejected this patch because the old k8topology
hack should really not be used anymore on modern machines (especially
not on Quad Cores). SRAT is the far better way to handle this problem
because it has a proper abstraction.

The problem with k8topology.c is that it needs to know very low level
information (like HT node numbers etc.) the kernel should not really
need to know and which are difficult to handle generally without
motherboard specific knowledge. 

k8topology.c mostly guesses, which was never a good way to handle this. 
Also in in the various "node has no memory" cases it needs quite
hackish fallback heuristics which will be always fragile. Then there
are some ugly interactions with quad cores. And some other issues

I still think the patch a bad idea because adapting this file all
the time is a long term maintenance issue. I can say that as 
the original author :-) It was just a quick hack long ago
to get NUMA going early. But now it far outlived its usefulness
and adapting it to modern machines is the wrong direction. 

Best is to phase k8topology out.

-Andi



>
> -Joachim
>
> --
>
>     x86: add PCI IDs to k8topology_64.c
>     
>     This just adds the PCI IDs of AMD's family 10h and 11h CPU's northbridges 
> to
>     k8topology discovery.
>     
>     Signed-off-by: Joachim Deguara <joachim.deguara@amd.com>
>     Signed-off-by: Andi Kleen <ak@suse.de>
>     Acked-by: Yinghai Lu <yinghai.lu@sun.com>
>
> diff --git a/arch/x86/mm/k8topology_64.c b/arch/x86/mm/k8topology_64.c
> index a96006f..b123ea3 100644
> --- a/arch/x86/mm/k8topology_64.c
> +++ b/arch/x86/mm/k8topology_64.c
> @@ -28,11 +28,15 @@ static __init int find_northbridge(void)
>  		u32 header;
>  		
>  		header = read_pci_config(0, num, 0, 0x00);  
> -		if (header != (PCI_VENDOR_ID_AMD | (0x1100<<16)))
> +		if (header != (PCI_VENDOR_ID_AMD | (0x1100<<16)) &&
> +			header != (PCI_VENDOR_ID_AMD | (0x1200<<16)) &&
> +			header != (PCI_VENDOR_ID_AMD | (0x1300<<16)))
>  			continue; 	
>  
>  		header = read_pci_config(0, num, 1, 0x00); 
> -		if (header != (PCI_VENDOR_ID_AMD | (0x1101<<16)))
> +		if (header != (PCI_VENDOR_ID_AMD | (0x1101<<16)) &&
> +			header != (PCI_VENDOR_ID_AMD | (0x1201<<16)) &&
> +			header != (PCI_VENDOR_ID_AMD | (0x1301<<16)))
>  			continue;	
>  		return num; 
>  	} 
