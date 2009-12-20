Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbZLTWSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbZLTWSM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 17:18:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbZLTWSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 17:18:11 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:46736 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbZLTWSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 17:18:10 -0500
Subject: Re: [PATCH] resources: fix call to alignf() in allocate_resource()
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0912201026570.3712@localhost.localdomain>
References: <20091220095001.GA6029@comet.dominikbrodowski.net>
	 <alpine.LFD.2.00.0912201026570.3712@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 20 Dec 2009 15:12:16 -0700
Message-Id: <1261347136.26429.3.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-20 at 10:33 -0800, Linus Torvalds wrote:
> 
> On Sun, 20 Dec 2009, Dominik Brodowski wrote:
> >
> > The second parameter to alignf() in allocate_resource() must
> > reflect what new resource is attempted to be allocated, else
> > functions like pcibios_align_resource() (at least on x86) or
> > pcmcia_align() can't work correctly.
> > 
> > Commit 1e5ad9679016275d422e36b12a98b0927d76f556 broke this by
> > setting the "new" resource until we're about to return success.
> > To keep the resource untouched when allocate_resource() fails,
> > a "tmp" resource is introduced.
> 
> Ack. That was subtle. 
> 
> That said, maybe a nicer fix to this would be to actually return 'start' 
> from the 'alignf' macro. That "modify the resource inside the alignment 
> function" thing was always pretty ugly.
> 
> And then we'd pass in 'start' instead of 'size' (I have _no_ idea why we 
> pass in 'size' to the alignment function, but whatever).
> 
> We'd still need to pass in the 'struct resource', but that would be so 
> that it can figure out 'flags' (and 'size' if it really needs it) from it, 
> but now it would be for reading only. So we could mark it 'const'.

Ouch, sorry about that, I should have noticed that alignf() can modify
'new' before we know whether we're going to succeed.

Linus' proposal requires more code change, but has the advantage that
future similar mistakes would be less likely.

Bjorn


