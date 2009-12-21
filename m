Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbZLUIke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbZLUIke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 03:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbZLUIkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 03:40:33 -0500
Received: from isilmar.linta.de ([213.133.102.198]:34923 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751440AbZLUIkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 03:40:32 -0500
Date: Mon, 21 Dec 2009 09:40:31 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] resources: fix call to alignf() in allocate_resource()
Message-ID: <20091221084031.GB1648@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Bjorn Helgaas <bjorn.helgaas@hp.com>,
	Yinghai Lu <yhlu.kernel@gmail.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	linux-kernel@vger.kernel.org
References: <20091220095001.GA6029@comet.dominikbrodowski.net> <alpine.LFD.2.00.0912201026570.3712@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912201026570.3712@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 20, 2009 at 10:33:05AM -0800, Linus Torvalds wrote:
> 
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

At least the PCMCIA "align" function makes excessive use of the "size"
parameter, so we'd still need this.

> We'd still need to pass in the 'struct resource', but that would be so 
> that it can figure out 'flags' (and 'size' if it really needs it) from it, 
> but now it would be for reading only. So we could mark it 'const'.

AFAICS, you can't determine the size out of "struct resource" as "start +
size" may be less than "end" (else we couldn't align anything, couldn't we?).

> But Dominik's patch is ok too - the problem is not his patch, it's our 
> longstanding horrible sh*t-for-brains calling convention (for which you 
> can probably blame me - mea culpa).

What about taking my patch for 2.6.33, and deferring the change to the
calling convention to the 2.6.34 merge window? (I'll try to cook something
up and get it into linux-next during the next few weeks).

Best,
	Dominik
