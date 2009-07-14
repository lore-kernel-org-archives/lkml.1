Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbZGNPrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbZGNPrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 11:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbZGNPrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 11:47:35 -0400
Received: from outbound-mail-40.bluehost.com ([69.89.20.194]:53332 "HELO
	outbound-mail-40.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753501AbZGNPrf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 11:47:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=kZkj3+79Q59DeMDakXS9REoOiWXumVylr4B6l9GMyFvaIqHwimQ07saXnqruawTNRifYQsgtPZuJpyKU+5gaB9zyxk5ka1OEvp5W224Q/7Uy19CYM602zfS0WGmVtyeh;
Date: Tue, 14 Jul 2009 08:47:31 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jesse Brandeburg <jesse.brandeburg@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
       NetDEV list <netdev@vger.kernel.org>, ak@linux.intel.com,
       matthew@wil.cx
Subject: Re: [PATCH] x86/PCI: initialize PCI bus node numbers early
Message-ID: <20090714084731.61d5d39d@jbarnes-g45>
In-Reply-To: <4807377b0907140041y6c9da555lf3e1dba0775cfe7c@mail.gmail.com>
References: <20090710104419.0032be7b@jbarnes-g45>
	<4A57A1FE.30609@kernel.org>
	<20090710132249.1a032cfb@jbarnes-g45>
	<20090710140654.32132bcb@jbarnes-g45>
	<4807377b0907140041y6c9da555lf3e1dba0775cfe7c@mail.gmail.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jul 2009 00:41:30 -0700
Jesse Brandeburg <jesse.brandeburg@gmail.com> wrote:

> On Fri, Jul 10, 2009 at 2:06 PM, Jesse
> Barnes<jbarnes@virtuousgeek.org> wrote:
> > From 2b51fba93f7b2dabf453a74923a9a217611ebc1a Mon Sep 17 00:00:00
> > 2001 From: Jesse Barnes <jbarnes@virtuousgeek.org>
> > Date: Fri, 10 Jul 2009 14:04:30 -0700
> > Subject: [PATCH] x86/PCI: initialize PCI bus node numbers early
> >
> > The current mp_bus_to_node array is initialized only by AMD specific
> > code, since AMD platforms have registers that can be used for
> > determining mode numbers.  On new Intel platforms it's necessary to
> > initialize this array as well though, otherwise all PCI node numbers
> > will be 0, when in fact they should be -1 (indicating that I/O isn't
> > tied to any particular node).
> >
> > So move the mp_bus_to_node code into the common PCI code, and
> > initialize it early with a default value of -1.  This may be
> > overridden later by arch code (e.g. the AMD code).
> >
> > With this change, PCI consistent memory and other node specific
> > allocations (e.g. skbuff allocs) should occur on the "current" node.
> > If, for performance reasons, applications want to be bound to
> > specific nodes, they should open their devices only after being
> > pinned to the CPU where they'll run, for maximum locality.
> >
> > Acked-by: Yinghai Lu <yinghai@kernel.org>
> > Tested-by: Jesse Brandeburg <jesse.brandeburg@gmail.com>
> > Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> 
> I can confirm this works, aside from the MSI-X interrupt migration
> instability (panics) that I believe are unrelated since they happen
> without this patch.
> 
> I also see a pretty nice performance boost by running with this change
> on a 5520 motherboard, with an 82599 10GbE forwarding packets, esp
> with interrupt affinity set correctly.
> 
> I'd like to see this applied if at all possible, I think it is really
> hampering I/O traffic performance due to limiting all network (among
> others) memory allocation to one of the two numa nodes.

Ok, thanks for testing.  I've pushed it to my linux-next branch.

-- 
Jesse Barnes, Intel Open Source Technology Center
