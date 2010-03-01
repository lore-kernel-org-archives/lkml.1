Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab0CAG1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 01:27:33 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:56795 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751139Ab0CAG1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 01:27:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=fsg25MB6HlO2ic+NExN4oIjD8tUOJ1sVv/QUwiEFJw4Ib/u0vESeIUePSs1m5619jcnrD3XQ4Up/u5McHa8k3rylKi3nckNHv39kCW273ef/1/O+OYmsV3F/DGlKYeie;
Date: Sun, 28 Feb 2010 22:28:22 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] PCI changes for 2.6.34  - pci rom rom fail list
Message-ID: <20100228222822.34889f1a@jbarnes-piketon>
In-Reply-To: <4B8B0113.1020103@kernel.org>
References: <20100226093957.7b99d09c@jbarnes-piketon>
	<alpine.LFD.2.00.1002281227300.3851@localhost.localdomain>
	<alpine.LFD.2.00.1002281246120.3637@localhost.localdomain>
	<33223F6C-10BD-4671-937D-6D5E4956DD3F@kernel.org>
	<alpine.LFD.2.00.1002281314110.3637@localhost.localdomain>
	<4B8AF121.2060106@kernel.org>
	<4B8B0113.1020103@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Feb 2010 15:49:39 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> please check
> 
> [PATCH] pci: don't reassign to ROM res if it is not going to be
> enabled
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/pci/setup-bus.c |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/drivers/pci/setup-bus.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/setup-bus.c
> +++ linux-2.6/drivers/pci/setup-bus.c
> @@ -101,9 +101,17 @@ static void __assign_resources_sorted(st
>  	for (list = head->next; list;) {
>  		res = list->res;
>  		idx = res - &list->dev->resource[0];
> +
>  		if (pci_assign_resource(list->dev, idx)) {
> -			if (fail_head
> && !pci_is_root_bus(list->dev->bus))
> -				add_to_failed_list(fail_head,
> list->dev, res);
> +			if (fail_head
> && !pci_is_root_bus(list->dev->bus)) {
> +				/*
> +				 * if the failed res is for ROM BAR,
> and it will
> +				 * be enabled later, don't add it to
> the list
> +				 */
> +				if (!((idx == PCI_ROM_RESOURCE) &&
> +				      (!(res->flags &
> IORESOURCE_ROM_ENABLE))))
> +
> add_to_failed_list(fail_head, list->dev, res);
> +			}
>  			res->start = 0;
>  			res->end = 0;
>  			res->flags = 0;
> 
> 

I think this is on the right track; a failed ROM allocation shouldn't
cause us to try to reassign resources.  Generally the ROM isn't needed
anyway, and even when it is we have to handle it specially anyway.

Linus, does this patch fix your problem?

-- 
Jesse Barnes, Intel Open Source Technology Center
