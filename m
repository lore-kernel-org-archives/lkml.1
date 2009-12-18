Return-Path: <linux-kernel-owner+w=401wt.eu-S933094AbZLRVoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094AbZLRVoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 16:44:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932804AbZLRVoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 16:44:00 -0500
Received: from outbound-mail-29.bluehost.com ([69.89.17.211]:44776 "HELO
	outbound-mail-29.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932712AbZLRVn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 16:43:59 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=IhJ50brxctEdBU1uNSqkW8mEwyW9sw0if186pNtLFcSeHk0tefnIh+i9JQrEqn9yWa+VVJUHO0Rv09BO99zRQI+lvaz1XTtVEqcvRSk+Tm9D0HzluROOwbGZ3QeKPBBX;
Date: Fri, 18 Dec 2009 13:43:19 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 2/12] pci: add pci_bridge_release_unused_res and
 pci_bus_release_unused_bridge_res -v2
Message-ID: <20091218134319.05b1de65@jbarnes-piketon>
In-Reply-To: <alpine.LFD.2.00.0912181316190.3712@localhost.localdomain>
References: <4B2BE9DD.3040504@kernel.org>
	<4B2BEC1B.9090104@kernel.org>
	<alpine.LFD.2.00.0912181316190.3712@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Dec 2009 13:24:41 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:
> And once you do that, then using "release_resrouce()" is the wrong
> thing, since it turns into just "__release_resource()" and you notice
> that that walks the chain looking for them - which makes it pointless
> to have _another_ outer loop that walks the chain to release them!
> 
> So you'd need to
> 
>  - move this to kernel/resource.c
> 
>  - do it all under 'write_lock(&resource_lock);'
> 
>  - stop the silly double list loop, and just do it as a single loop
> that does
> 
> 	p = old->parent->child;
> 	old->parent = NULL;
> 	while (p) {
> 		struct resource *tmp = p;
> 		p = p->sibling;
> 
> 		.. do whatever you do to free tmp ..
> 	}
> 
>    and it's much simpler, more efficient, has the rigth locking, and
> is in the right place.
> 
> That said, it's still unclear if you can ever do this! Why would the
> PCI layer be allowed to release ACPI resources int he tree, for
> example?
> 
> So I can see fixing the _implementation_ issues I have like above,
> but I'd still be nervous about the whole concept of the patch..

Yeah, if we roll all the way back up through some system resources we
could definitely get into trouble.  Stopping the recursion when we hit
a bridge or host bridge may be a good enough heuristic?

Really I guess this is just a half measure.  There are a whole set a
fixed resources that are children of the root address space, and we
shouldn't try to free or move them around at all (e.g. ACPI _CRS type
resources).  Beyond that though it should be safe to free all the
moveable resources in a tree and try again if a leaf device can't get
its preferred allocation (the whole purpose of this series afaict).

-- 
Jesse Barnes, Intel Open Source Technology Center
