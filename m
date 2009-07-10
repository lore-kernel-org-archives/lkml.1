Return-Path: <linux-kernel-owner+w=401wt.eu-S1757041AbZGJUSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041AbZGJUSf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 16:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756634AbZGJUS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 16:18:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:51065 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756480AbZGJUS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 16:18:26 -0400
Message-ID: <4A57A1FE.30609@kernel.org>
Date: Fri, 10 Jul 2009 13:18:06 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-kernel@vger.kernel.org,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>
Subject: Re: [PATCH] x86/PCI: initialize PCI bus node numbers early
References: <20090710104419.0032be7b@jbarnes-g45>
In-Reply-To: <20090710104419.0032be7b@jbarnes-g45>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> The current mp_bus_to_node array is initialized only by AMD specific
> code, since AMD platforms have registers that can be used for
> determining mode numbers.  On new Intel platforms it's necessary to
> initialize this array as well though, otherwise all PCI node numbers
> will be 0, when in fact they should be -1 (indicating that I/O isn't
> tied to any particular node).
> 
> So move the mp_bus_to_node code into the common PCI code, and
> initialize it early with a default value of -1.  This may be overridden
> later by arch code (e.g. the AMD code).
> 
> With this change, PCI consistent memory and other node specific
> allocations (e.g. skbuff allocs) should occur on the "current" node.
> If, for performance reasons, applications want to be bound to specific
> nodes, they should open their devices only after being pinned to the
> CPU where they'll run, for maximum locality.
> 
> Any thoughts here Yinghai or Jesse?
> 
> 
>  include/asm/pci.h |    2 +
>  kernel/setup.c    |    2 +
>  pci/amd_bus.c     |   61 +-----------------------------------------
>  pci/common.c      |   77 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 83 insertions(+), 59 deletions(-)
> 
> Thanks,

could use

static int mp_bus_to_node[BUS_NR] = {
        [0 ... BUS_NR - 1] = -1
};

so we avoid to add pci_bus_to_node_init()

YH
