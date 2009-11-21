Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbZKUPvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbZKUPvo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:51:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbZKUPvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:51:43 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57392 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366AbZKUPvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:51:42 -0500
Date: Sat, 21 Nov 2009 15:51:35 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Julia Lawall <julia@diku.dk>
Cc: walter harms <wharms@bfs.de>, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/8] drivers/pcmcia: remove unnecessary kzalloc
Message-ID: <20091121155135.GB13956@n2100.arm.linux.org.uk>
References: <Pine.LNX.4.64.0911211250090.23681@ask.diku.dk> <4B07E0CB.6000508@bfs.de> <Pine.LNX.4.64.0911211611510.26930@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0911211611510.26930@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 21, 2009 at 04:12:59PM +0100, Julia Lawall wrote:
> On Sat, 21 Nov 2009, walter harms wrote:
> 
> > 
> > 
> > Julia Lawall schrieb:
> > > From: Julia Lawall <julia@diku.dk>
> > > 
> > > The result of calling kzalloc is never used or freed.
> > > 
> > > The semantic match that finds this problem is as follows:
> > > (http://www.emn.fr/x-info/coccinelle/)
> > > 
> > > // <smpl>
> > > @r exists@
> > > local idexpression x;
> > > statement S;
> > > expression E;
> > > identifier f,f1,l;
> > > position p1,p2;
> > > expression *ptr != NULL;
> > > @@
> > > 
> > > x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
> > > ...
> > > if (x == NULL) S
> > > <... when != x
> > >      when != if (...) { <+...x...+> }
> > > (
> > > x->f1 = E
> > > |
> > >  (x->f1 == NULL || ...)
> > > |
> > >  f(...,x->f1,...)
> > > )
> > > ...>
> > > (
> > >  return \(0\|<+...x...+>\|ptr\);
> > > |
> > >  return@p2 ...;
> > > )
> > > 
> > > @script:python@
> > > p1 << r.p1;
> > > p2 << r.p2;
> > > @@
> > > 
> > > print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
> > > // </smpl>
> > > 
> > > Signed-off-by: Julia Lawall <julia@diku.dk>
> > > ---
> > >  drivers/pcmcia/sa1111_generic.c     |    4 ----
> > >  1 files changed, 0 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/pcmcia/sa1111_generic.c b/drivers/pcmcia/sa1111_generic.c
> > > index deb5036..de6bc33 100644
> > > --- a/drivers/pcmcia/sa1111_generic.c
> > > +++ b/drivers/pcmcia/sa1111_generic.c
> > > @@ -127,10 +127,6 @@ int sa1111_pcmcia_add(struct sa1111_dev *dev, struct pcmcia_low_level *ops,
> > >  	ops->socket_state = sa1111_pcmcia_socket_state;
> > >  	ops->socket_suspend = sa1111_pcmcia_socket_suspend;
> > >  
> > > -	s = kzalloc(sizeof(*s) * ops->nr, GFP_KERNEL);
> > > -	if (!s)
> > > -		return -ENODEV;
> > > -
> > >  	for (i = 0; i < ops->nr; i++) {
> > >  		s = kzalloc(sizeof(*s), GFP_KERNEL);
> > >  		if (!s)
> > 
> > 
> > 
> > mmmh, perhaps the original idea was to have an array
> > and then he moved to a linked list ?
> > 
> > I thing the array idea is better (1. it fails on low mem propperly, 2. no need free()
> > 3. less zmalloc stuff) but requieres that pcmcia_remove()
> > will release that array propperly
> > 
> > the bug is strange,
> 
> Both kzallocs were added at the same time, when the function was added in 
> commit 701a5dc05ad99a06958b3f97cb69d99b47cebee3.  I have added the author 
> to the CC list.

Thanks for the additional info which allows me to track which patch it
corresponds with.  As an aside, it's really not nice to git pull and
then edit the commits afterwards - that's much worse than rebasing.
When trees are pulled, the act of merging it conveys sufficent "sign-off".

Just remove the first kzalloc and don't convert it to an array; that's the
safest option.  I don't remember if there's a reason why I switched to a
linked list - however, what I will say is that the way all the sa11xx
and pxa stuff interact is not plainly obvious.

There may be a corner case I found with the original patches which meant
a linked list was better than an array.
