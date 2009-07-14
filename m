Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbZGNHlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbZGNHlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 03:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbZGNHlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 03:41:32 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:48411 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbZGNHlb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 03:41:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FdIyIRhywHwv4tHp/v5iDkQ7AjfSucd6XBAUFSthLMM41oNr5G3bxegZ+4VV0KVXpj
         yysb19LTNpgPuiHjVg3FtO5GjXiMpmDEsu/4woJhBs/Yw7iQgCyDLyNkueDqRK9lLU6m
         WIDR8jgG563ZaYALvwOq1bfS8Jo2bGGLeUGXg=
MIME-Version: 1.0
In-Reply-To: <20090710140654.32132bcb@jbarnes-g45>
References: <20090710104419.0032be7b@jbarnes-g45> <4A57A1FE.30609@kernel.org>
	 <20090710132249.1a032cfb@jbarnes-g45>
	 <20090710140654.32132bcb@jbarnes-g45>
Date: Tue, 14 Jul 2009 00:41:30 -0700
Message-ID: <4807377b0907140041y6c9da555lf3e1dba0775cfe7c@mail.gmail.com>
Subject: Re: [PATCH] x86/PCI: initialize PCI bus node numbers early
From: Jesse Brandeburg <jesse.brandeburg@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
       NetDEV list <netdev@vger.kernel.org>, ak@linux.intel.com,
       matthew@wil.cx
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 2:06 PM, Jesse Barnes<jbarnes@virtuousgeek.org> wrote:
> From 2b51fba93f7b2dabf453a74923a9a217611ebc1a Mon Sep 17 00:00:00 2001
> From: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date: Fri, 10 Jul 2009 14:04:30 -0700
> Subject: [PATCH] x86/PCI: initialize PCI bus node numbers early
>
> The current mp_bus_to_node array is initialized only by AMD specific
> code, since AMD platforms have registers that can be used for
> determining mode numbers.  On new Intel platforms it's necessary to
> initialize this array as well though, otherwise all PCI node numbers
> will be 0, when in fact they should be -1 (indicating that I/O isn't
> tied to any particular node).
>
> So move the mp_bus_to_node code into the common PCI code, and
> initialize it early with a default value of -1.  This may be overridden
> later by arch code (e.g. the AMD code).
>
> With this change, PCI consistent memory and other node specific
> allocations (e.g. skbuff allocs) should occur on the "current" node.
> If, for performance reasons, applications want to be bound to specific
> nodes, they should open their devices only after being pinned to the
> CPU where they'll run, for maximum locality.
>
> Acked-by: Yinghai Lu <yinghai@kernel.org>
> Tested-by: Jesse Brandeburg <jesse.brandeburg@gmail.com>
> Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

I can confirm this works, aside from the MSI-X interrupt migration
instability (panics) that I believe are unrelated since they happen
without this patch.

I also see a pretty nice performance boost by running with this change
on a 5520 motherboard, with an 82599 10GbE forwarding packets, esp
with interrupt affinity set correctly.

I'd like to see this applied if at all possible, I think it is really
hampering I/O traffic performance due to limiting all network (among
others) memory allocation to one of the two numa nodes.
