Return-Path: <linux-kernel-owner+w=401wt.eu-S1757004AbXITO0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbXITO0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 10:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbXITO0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 10:26:17 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:56566 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767AbXITO0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 10:26:16 -0400
Date: Thu, 20 Sep 2007 23:25:43 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Bernd Schmidt <bernds_cb1@t-online.de>
Cc: David McCullough <David_Mccullough@securecomputing.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org, bryan.wu@analog.com,
       Bernd Schmidt <bernd.schmidt@analog.com>,
       Greg Ungerer <gerg@snapgear.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ysato@users.sourceforge.jp,
       miles@lsi.nec.co.jp, linux-m32r@ml.linux-m32r.org
Subject: Re: [PATCH] binfmt_flat: minimum support for theBlackfin relocations
Message-ID: <20070920142543.GA3268@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Bernd Schmidt <bernds_cb1@t-online.de>,
	David McCullough <David_Mccullough@securecomputing.com>,
	Robin Getz <rgetz@blackfin.uclinux.org>,
	uclinux-dist-devel@blackfin.uclinux.org, bryan.wu@analog.com,
	Bernd Schmidt <bernd.schmidt@analog.com>,
	Greg Ungerer <gerg@snapgear.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	ysato@users.sourceforge.jp, miles@lsi.nec.co.jp,
	linux-m32r@ml.linux-m32r.org
References: <1190102965.4406.9.camel@roc-desktop> <200709192131.09469.rgetz@blackfin.uclinux.org> <20070920015525.GA16615@securecomputing.com> <20070920031807.GA31263@linux-sh.org> <46F261CA.50201@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F261CA.50201@t-online.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 02:04:26PM +0200, Bernd Schmidt wrote:
> Paul Mundt wrote:
> >I find it a bit disconcerting that blackfin already depends on this
> >in-tree without there being any earlier discussion on making these
> >changes.
> 
> Parts of the initial submission were picked up (the include/asm 
> directory), other's weren't.  Little we can do about that.
> 
What you can do about that is to order the patches, so one doesn't get
applied ahead of the other. People have successfully managed to submit
patches with dependencies in the past, you can look through the archives
for examples.

> >Since all the architecture is interested in is the relval that has
> >associated "persistent" data encoded in it, why don't we just have a stub
> >to give the architecture a chance to validate the relval before the
> >flat_get_relocate_addr() and move this stuff there instead? ie, blackfin
> >takes this out-of-line and manages its persistent value there.
> 
> What is flat_set_persistent other than a stub to validate the relval? 
> I'm not at all sure what you're proposing or how it would be different.
> 
My apologies for not making it clearer. I did not get a chance to hack
together a patch today. Hopefully the below will clear up whatever
confusion there was.

> >load_flat_file() is ugly enough without dumping more architecture
> >callback abuses in it.
> 
> The other maintainers who have spoken up didn't seem to think this was 
> ugly, or an abuse.  I'm surprised to hear language like that when 
> discussing a patch that adds an if statement, a local variable and one 
> parameter in a function call.
> 
Yes, well, the scope of the changes is really rather irrelevant, it's the
technical basis behind it that should be the concern. My suggestion was
to lose the local variable, get rid of this "persistent" API, and plug in
something like flat_validate_relval() or something equally silly where
each architecture has the option to grab the relval and set up whatever
sort of state it wants to out-of-line.

This is making API changes where it's convenient for your platform to use
this value, and there's no reason to change the API here at all. The
if/continue block are not an issue, it is the whole concept of persistent
data in this case that has no need to be applied uniformally across all
other architectures.

Why should all architectures have to change their APIs (not just adding
new things mind you, also changing existing definitions) to accomodate
something that can trivially be kept in the blackfin code?

I wager the other maintainers either a) don't care because it doesn't
effect them, or b) have resigned binfmt_flat to its fate. Neither option
is particularly appealing in terms of getting that code tidied. That sort
of indifference is largely why binfmt_flat is as much of a mess as it is
today. Your patch is certainly not the cause of this, the architecture
callbacks there are just a mess to begin with, I would prefer that we try
to keep new additions flexible without blindly hardcoding more usage
assumptions all over the place and having to paper over them again later.

I can hack up some patches tomorrow if you're still unsure of what I'm
proposing.
