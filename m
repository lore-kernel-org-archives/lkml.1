Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbZGJUW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbZGJUW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 16:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbZGJUWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 16:22:52 -0400
Received: from outbound-mail-128.bluehost.com ([67.222.38.28]:48515 "HELO
	outbound-mail-128.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752302AbZGJUWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 16:22:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ob72lFbXPk1g+u4N9+g1KyfVKFP8D81qqAgqlMbYx4TuQTMWUyqUFWwfWwrqXik6ZFMnE5dOGZPCSMumjuiVhFGOe9XmFR05Ox1M4Az6hHmHMUzuCW0FolX1hs1nMoAG;
Date: Fri, 10 Jul 2009 13:22:49 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>
Subject: Re: [PATCH] x86/PCI: initialize PCI bus node numbers early
Message-ID: <20090710132249.1a032cfb@jbarnes-g45>
In-Reply-To: <4A57A1FE.30609@kernel.org>
References: <20090710104419.0032be7b@jbarnes-g45>
	<4A57A1FE.30609@kernel.org>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009 13:18:06 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> Jesse Barnes wrote:
> > The current mp_bus_to_node array is initialized only by AMD specific
> > code, since AMD platforms have registers that can be used for
> > determining mode numbers.  On new Intel platforms it's necessary to
> > initialize this array as well though, otherwise all PCI node numbers
> > will be 0, when in fact they should be -1 (indicating that I/O isn't
> > tied to any particular node).
> > 
> > So move the mp_bus_to_node code into the common PCI code, and
> > initialize it early with a default value of -1.  This may be
> > overridden later by arch code (e.g. the AMD code).
> > 
> > With this change, PCI consistent memory and other node specific
> > allocations (e.g. skbuff allocs) should occur on the "current" node.
> > If, for performance reasons, applications want to be bound to
> > specific nodes, they should open their devices only after being
> > pinned to the CPU where they'll run, for maximum locality.
> > 
> > Any thoughts here Yinghai or Jesse?
> > 
> > 
> >  include/asm/pci.h |    2 +
> >  kernel/setup.c    |    2 +
> >  pci/amd_bus.c     |   61 +-----------------------------------------
> >  pci/common.c      |   77
> > ++++++++++++++++++++++++++++++++++++++++++++++++++++++ 4 files
> > changed, 83 insertions(+), 59 deletions(-)
> > 
> > Thanks,
> 
> could use
> 
> static int mp_bus_to_node[BUS_NR] = {
>         [0 ... BUS_NR - 1] = -1
> };
> 
> so we avoid to add pci_bus_to_node_init()

Ah yeah that would clean things up a bit...  Thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
