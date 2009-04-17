Return-Path: <linux-kernel-owner+w=401wt.eu-S1753583AbZDQTWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbZDQTWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 15:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbZDQTWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 15:22:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:63908 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbZDQTWI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 15:22:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iLfdOQw02HI4M0Qio+nIupVLIIGuR6P/DNHs8ArXd6BkA5goUeuSq9hx62yh/F1naK
         78XYrRYarXIPjjao6vxviUGXhJwqi8TAKAsWWnzATrrVr7MwzP1gAC4KL2ufr3oVH49s
         oWMUVza0cdPvfqNDc9enq9RbhVW5Dp64AlivM=
MIME-Version: 1.0
In-Reply-To: <tip-9b94b3a19b13e094c10f65f24bc358f6ffe4eacd@git.kernel.org>
References: <20090417100746.GG16198@alberich.amd.com>
	 <tip-9b94b3a19b13e094c10f65f24bc358f6ffe4eacd@git.kernel.org>
Date: Fri, 17 Apr 2009 12:22:06 -0700
Message-ID: <86802c440904171222q428fe106l4ad2d89a35057b@mail.gmail.com>
Subject: Re: [tip:x86/cpu] x86: fixup numa_node information for AMD CPU 
	northbridge functions
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 9:27 AM, tip-bot for Andreas Herrmann
<andreas.herrmann3@amd.com> wrote:
> Commit-ID:  9b94b3a19b13e094c10f65f24bc358f6ffe4eacd
> Gitweb:     http://git.kernel.org/tip/9b94b3a19b13e094c10f65f24bc358f6ffe4eacd
> Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
> AuthorDate: Fri, 17 Apr 2009 12:07:46 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 17 Apr 2009 18:12:36 +0200
>
> x86: fixup numa_node information for AMD CPU northbridge functions
>
> Currently the numa_node attribute for these PCI devices is 0 (it
> corresponds to the numa_node for PCI bus 0). This is not a big issue
> but incorrect.
>
> This inconsistency can be fixed by reading the node number from CPU
> NB function 0.
>
> [ Impact: fill in dev->numa_node information, to optimize DMA allocations ]
>
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> Cc: jbarnes@virtuousgeek.org
> LKML-Reference: <20090417100746.GG16198@alberich.amd.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>
>
> ---
>  arch/x86/kernel/quirks.c |   37 +++++++++++++++++++++++++++++++++++++
>  1 files changed, 37 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
> index e95022e..94ad0c0 100644
> --- a/arch/x86/kernel/quirks.c
> +++ b/arch/x86/kernel/quirks.c
> @@ -493,5 +493,42 @@ void force_hpet_resume(void)
>                break;
>        }
>  }
> +#endif
> +
> +#if defined(CONFIG_PCI) && defined(CONFIG_NUMA)
> +/* Set correct numa_node information for AMD NB functions */
> +static void __init quirk_amd_nb_node(struct pci_dev *dev)
> +{
> +       struct pci_dev *nb_ht;
> +       unsigned int devfn;
> +       u32 val;
> +
> +       devfn = PCI_DEVFN(PCI_SLOT(dev->devfn), 0);
> +       nb_ht = pci_get_slot(dev->bus, devfn);
> +       if (!nb_ht)
> +               return;
> +
> +       pci_read_config_dword(nb_ht, 0x60, &val);
> +       set_dev_node(&dev->dev, val & 7);
> +       pci_dev_put(dev);
> +}
>
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB,
> +                       quirk_amd_nb_node);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_ADDRMAP,
> +                       quirk_amd_nb_node);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MEMCTL,
> +                       quirk_amd_nb_node);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC,
> +                       quirk_amd_nb_node);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_HT,
> +                       quirk_amd_nb_node);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MAP,
> +                       quirk_amd_nb_node);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_DRAM,
> +                       quirk_amd_nb_node);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC,
> +                       quirk_amd_nb_node);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_LINK,
> +                       quirk_amd_nb_node);
>  #endif
> --

wonder if need to check if the node is online aka there is memory on
that node...

looks like if that node is not online, should use -1 instead for 64bit.

YH
