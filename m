Return-Path: <linux-kernel-owner+w=401wt.eu-S934198AbZKXVkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934198AbZKXVkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:40:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933995AbZKXVkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:40:05 -0500
Received: from outbound-mail-117.bluehost.com ([69.89.22.17]:35560 "HELO
	outbound-mail-117.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933736AbZKXVkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:40:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=inOM7QeJFD2sgXu2y5JL6txBqMV5X0PAukEtt+Jxa4K2ADkCzqB4YcpXQqE8ru9ofmns1J2yQcacnMAe1AP2TP7zlENJyW/eBFT0LxEPaGpEEF4g5eQpdVjq4vA9lDSV;
Date: Tue, 24 Nov 2009 13:40:08 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Yu Zhao <yu.zhao@intel.com>, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] x86/pci: claim SR-IOV bar in pcibios_allocate_resource
Message-ID: <20091124134008.0050a339@jbarnes-piketon>
In-Reply-To: <4B0C4E69.4090402@kernel.org>
References: <4AFFB1E6.9040300@kernel.org>
	<20091124131912.2aabb852@jbarnes-piketon>
	<4B0C4E69.4090402@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009 13:21:45 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> Jesse Barnes wrote:
> > On Sat, 14 Nov 2009 23:46:46 -0800
> > Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> >> so use correct allocation from BIOS, instead of later assign
> >> another one.
> >>
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >>
> >> ---
> >>  arch/x86/pci/i386.c |    4 +++-
> >>  1 file changed, 3 insertions(+), 1 deletion(-)
> >>
> >> Index: linux-2.6/arch/x86/pci/i386.c
> >> ===================================================================
> >> --- linux-2.6.orig/arch/x86/pci/i386.c
> >> +++ linux-2.6/arch/x86/pci/i386.c
> >> @@ -155,7 +155,9 @@ static void __init pcibios_allocate_reso
> >>  
> >>  	for_each_pci_dev(dev) {
> >>  		pci_read_config_word(dev, PCI_COMMAND, &command);
> >> -		for (idx = 0; idx < PCI_ROM_RESOURCE; idx++) {
> >> +		for (idx = 0; idx < PCI_BRIDGE_RESOURCES; idx++) {
> >> +			if (idx == PCI_ROM_RESOURCE)
> >> +				continue;
> >>  			r = &dev->resource[idx];
> >>  			if (r->parent)		/* Already
> >> allocated */ continue;
> > 
> > I'm worried this might have side effects beyond just allocating
> > SR-IOV BARs, since it looks like we'll walk through all the bridge
> > resources all the time?
> 
> /*
>  *  For PCI devices, the region numbers are assigned this way:
>  */
> enum {
>         /* #0-5: standard PCI resources */
>         PCI_STD_RESOURCES,
>         PCI_STD_RESOURCE_END = 5,
> 
>         /* #6: expansion ROM resource */
>         PCI_ROM_RESOURCE,
> 
>         /* device specific resources */
> #ifdef CONFIG_PCI_IOV
>         PCI_IOV_RESOURCES,
>         PCI_IOV_RESOURCE_END = PCI_IOV_RESOURCES + PCI_SRIOV_NUM_BARS
> - 1, #endif
> 
>         /* resources assigned to buses behind the bridge */
> #define PCI_BRIDGE_RESOURCE_NUM 4
> 
>         PCI_BRIDGE_RESOURCES,
> 
> so will only add IOV BAR related.

Oh right, *up to* bridge resources...  Still we should probably add a
comment about that.  SR-IOV is still somewhat new.

-- 
Jesse Barnes, Intel Open Source Technology Center
