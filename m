Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbZLTSdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbZLTSdQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 13:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbZLTSdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 13:33:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752484AbZLTSdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 13:33:15 -0500
Date: Sun, 20 Dec 2009 10:33:05 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dominik Brodowski <linux@dominikbrodowski.net>
cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] resources: fix call to alignf() in allocate_resource()
In-Reply-To: <20091220095001.GA6029@comet.dominikbrodowski.net>
Message-ID: <alpine.LFD.2.00.0912201026570.3712@localhost.localdomain>
References: <20091220095001.GA6029@comet.dominikbrodowski.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 20 Dec 2009, Dominik Brodowski wrote:
>
> The second parameter to alignf() in allocate_resource() must
> reflect what new resource is attempted to be allocated, else
> functions like pcibios_align_resource() (at least on x86) or
> pcmcia_align() can't work correctly.
> 
> Commit 1e5ad9679016275d422e36b12a98b0927d76f556 broke this by
> setting the "new" resource until we're about to return success.
> To keep the resource untouched when allocate_resource() fails,
> a "tmp" resource is introduced.

Ack. That was subtle. 

That said, maybe a nicer fix to this would be to actually return 'start' 
from the 'alignf' macro. That "modify the resource inside the alignment 
function" thing was always pretty ugly.

And then we'd pass in 'start' instead of 'size' (I have _no_ idea why we 
pass in 'size' to the alignment function, but whatever).

We'd still need to pass in the 'struct resource', but that would be so 
that it can figure out 'flags' (and 'size' if it really needs it) from it, 
but now it would be for reading only. So we could mark it 'const'.

Comments?

But Dominik's patch is ok too - the problem is not his patch, it's our 
longstanding horrible sh*t-for-brains calling convention (for which you 
can probably blame me - mea culpa).

		Linus
