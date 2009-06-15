Return-Path: <linux-kernel-owner+w=401wt.eu-S935598AbZFOVys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935598AbZFOVys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 17:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbZFOVyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 17:54:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:41029 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035AbZFOVyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 17:54:39 -0400
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       yinghai@kernel.org
In-Reply-To: <20090615113848.GA23377@wotan.suse.de>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>
	 <20090615081831.GA5411@osiris.boeblingen.de.ibm.com>
	 <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com>
	 <20090615094148.GC1314@wotan.suse.de> <1245059476.12400.7.camel@pasglop>
	 <20090615101254.GB10294@wotan.suse.de> <1245062388.12400.17.camel@pasglop>
	 <20090615112205.GA6012@wotan.suse.de> <20090615112827.GC6012@wotan.suse.de>
	 <20090615113848.GA23377@wotan.suse.de>
Content-Type: text/plain
Date: Tue, 16 Jun 2009 07:37:22 +1000
Message-Id: <1245101842.12400.43.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 13:38 +0200, Nick Piggin wrote:
> On Mon, Jun 15, 2009 at 01:28:28PM +0200, Nick Piggin wrote:
> > On Mon, Jun 15, 2009 at 01:22:05PM +0200, Nick Piggin wrote:
> > > On Mon, Jun 15, 2009 at 08:39:48PM +1000, Benjamin Herrenschmidt wrote:
> > > But I won't live with having it shit in our nice core code...
> > > Well, at least I won't throw up my hands and give up this
> > > early.
> > 
> > Just the principle, btw.
> 
> I have the same opinion for suspend/resume too, although
> in that case I know less about the issues and if we
> found that it indeed does make a random driver writers
> life easier[*] then it might be a reason to do this. But
> I still don't think that would give boot code a license to
> just revert back to "I don't know or care, GFP_KERNEL pelase"
> 
> [*] and note that being unaware of your context I don't
> think is making life easier automatically.

The suspend/resume case is even worse ... because drivers don't know,
and don't have to.

IE. We are talking here about pretty much -any- kmalloc in the kernel,
you don't seem to understand that.

The problem here is that driver A has suspended and happen to be on the
swapout path. driver B hasn't been suspended yet, and potentially
doesn't even know there's a suspend/resume cycle in progress.

Now, driver B, while holding for example one of its internal mutexes,
calls something that calls something that does a kmalloc(GFP_KERNEL) ...
The later will potentially block forever (or at least until resume)
because the allocator may try to swap something out to devices driven by
driver A while it's suspended.

Now, driver B suspend() is called, which tries to take the above
mutex... kaboom.

Yes, we -could- probably try to invent some scheme for block devices to
"teach" upper layers that they are being suspended. That would cover
some of the cases and would probably not be done properly for 10 kernel
versions to come... Or we can make all kmalloc() degrade automatically
to GFP_NOIO when suspend is started.

Which one is more likely to actually work ? :-)

Cheers,
Ben.

