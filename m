Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724AbYHRO7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbYHRO7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 10:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYHRO7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 10:59:31 -0400
Received: from mail.fieldses.org ([66.93.2.214]:36707 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbYHRO7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 10:59:30 -0400
Date: Mon, 18 Aug 2008 10:59:25 -0400
To: Takashi Iwai <tiwai@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH] Fix allocation sizes of knfsd raparm hash
Message-ID: <20080818145925.GB23127@fieldses.org>
References: <20080815184032.3acd8032.sfr@canb.auug.org.au> <s5hr68q5rm8.wl%tiwai@suse.de> <20080815190221.GB26563@fieldses.org> <s5hvdy1ny9n.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hvdy1ny9n.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2008 at 10:45:56AM +0200, Takashi Iwai wrote:
> At Fri, 15 Aug 2008 15:02:21 -0400,
> J. Bruce Fields wrote:
> > 
> > On Fri, Aug 15, 2008 at 03:34:39PM +0200, Takashi Iwai wrote:
> > > The raparm was allocated in a wrong size in the commit
> > > 
> > >    ca80290ebda9009aedc4bd93ede5d397cb1853dc
> > >    nfsd: permit unauthenticated stat of export root
> > > 
> > > and thus it resulted in memory corruption, eventually Oopsing.
> > > This patch fixes the allocation size.
> > 
> > Whoops, my fault, now fixed; thanks!
> > 
> > (Out of curiosity--how did you find this?)
> 
> Actually I hit the related Oops with the latest linux-next tree.
> Since this bug appears first on that tree and didn't occur on the
> previous tree, it was apparently a regression.  So, I looked through
> changes over knfsd since the previous tree, found a suspicious one,
> and tried to fix.
> 
> The linux-next tree is pretty helpful to catch a regression if one
> eats own dog foods everyday.

OK, now I see my problem: my test systems deliver the rest of their
results by email, but if I want to check the logs for oops messages I
still need to remember to log in and look after each test run.  So I got
lazy and missed the slab errors on nfsd shutdown.

I wonder what the easiest way would be to automate collection of oops
messages from the logs?  I suppose I should look at what the code that
submits to kerneloops.org does.

--b.

> 
> BTW, I've been building linux-next SUSE kernel packages at every
> linux-next release.  The packages are found in the following URL:
> 
>     http://ftp.suse.com/pub/people/tiwai/kernel-next/
> 
> If anyone has a SUSE system and would like to try linux-next kernel,
> just installs the package in addition.  It won't conflict with
> existing standard kernel packages.
> 
> 
> thanks,
> 
> Takashi
> 
> > 
> > --b.
> > 
> > > 
> > > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > > 
> > > ---
> > > diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> > > index bfa5453..30d606f 100644
> > > --- a/fs/nfsd/vfs.c
> > > +++ b/fs/nfsd/vfs.c
> > > @@ -2093,7 +2093,7 @@ nfsd_racache_init(int cache_size)
> > >  
> > >  		raparm = &raparm_hash[i].pb_head;
> > >  		for (j = 0; j < nperbucket; j++) {
> > > -			*raparm = kzalloc(sizeof(*raparm), GFP_KERNEL);
> > > +			*raparm = kzalloc(sizeof(**raparm), GFP_KERNEL);
> > >  			if (!*raparm)
> > >  				goto out_nomem;
> > >  			raparm = &(*raparm)->p_next;
> > 
