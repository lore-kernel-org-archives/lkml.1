Return-Path: <linux-kernel-owner+w=401wt.eu-S1762995AbYBLRvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762995AbYBLRvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 12:51:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759197AbYBLRu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 12:50:59 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60704 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758262AbYBLRu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 12:50:58 -0500
Date: Tue, 12 Feb 2008 09:48:24 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       arjan@infradead.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080212174824.GA1919@kroah.com>
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org> <20080212044314.GA4888@kroah.com> <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 09:09:34AM -0800, Linus Torvalds wrote:
> One thing that I personally react to is that
> 
>  - I think sysfs and the device model layer has had too much churn, and 
>    I'm unhappy that people seem to expect that to continue.
> 
>    [ NOTE!! I'm picking on the device model/sysfs stuff here not because 
>      it's the only one, but because it's the obvious and good example. I 
>      do think we have other cases of the same thing. ]
> 
>    Really. I do agree that we need to fix up bad designs, but I disagree 
>    violently with the notion that this should be seen as some ongoing 
>    thing. The API churn should absolutely *not* be seen as a constant 
>    pain, and if it is (and it clearly is) then I think the people involved 
>    should start off not by asking "how can we synchronize", but looking a 
>    bit deeper and saying "what are we doing wrong?"

I may be a bit defensive here, but I hope that all of the recent
kobject/kset/driver core changes have been done with the thought of
"what are we doing wrong".

For the kset rework, we went back and looked at how people were trying
to use this code, realized that it was way too complex, and reworked it
all, making both the implementation simpler, the kernel usage model
simpler, and documented the whole thing so that everyone knows exactly
what is now going on.

To quote the original developer of that code when hearing of the
rewrite, "thank you for doing it, I have no idea what I was thinking
when I wrote that code originally."  The end result caused more code to
be removed from the kernel than was added, always a nice thing.

The rework went through many iteratations, reviews, rebases, and touched
many portions of the kernel.  In the end, there was only 1 merge issue,
in a new IB driver, and Roland and I handled that after Andrew pointed
out.  That kind of dependency was what I was trying to warn the -next
maintainers about.

>    It may well be that part of the problem is that the people causing the 
>    churn don't realize the downsides of the pain they are causing, because 
>    THEY aren't the generally ones that see it!

Oh, I see it, and so does my inbox :)

>    For example, it's easy for Greg to change his driver core, and he can 
>    obviously synchronize with himself in the other trees (because his left 
>    hand is hopefully somewhat aware of what his right hand is doing), so I 
>    suspect Greg simply doesn't see the pain that much. So Greg thinks that 
>    the solution is to just have me merge his changes early, and the pain 
>    is all gone as far as he is concerned.

No, I understand the issues here, and am working hard to resolve them.

Now that the kobject underlying layer looks very good, I'm moving a bit
higher up, into the driver core to be able to handle a long-standing
requirement by a lot of hardware vendor and driver authors.  And yes,
that is going to cause a few problems in a few places in the
bus-specific logic (the PCI core looks to be the biggest issue, as it
does some nasty things with some internal device lists), but for the
rest of the kernel, and individual driver authors, it will not be an
issue at all.

But I understand your main point here, a lot of time I might come across
as wanting to constantly change this chunk of code, but I'm only doing
it because it's necessary.  I'd much rather be off just writing new
drivers, and not having to touch this stuff at all.

If people see changes in which they think I and Kay are unnecessarily
causing churn, please call us out on it, I have no problem with that.

</defensive_posturing> :)

>  - That said, I'm also a bit unhappy about the fact you think all merging 
>    has to go through my tree and has to be visible during the two-week 
>    merge period. Quite frankly, I think that you guys could - and should - 
>    just try to sort API changes out more actively against each other, and 
>    if you can't, then that's a problem too.
> 
>    In other words, please do use the distributed nature of git to your 
>    advantage, when there are things you guys know you need to sort out.

A lot of time that already happens today, between the different
subsystem maintainers.  We routinely pass PCI and driver core changes
through the network and scsi and ata trees in order to handle merge
issues properly.  This already happened in a few places in the
2.6.25-rc1 merge cycle.

But so far we have been doing this on a per-patch level, not really on a
git-tree level.  Maybe we might want to re-think this if needed.

> So there are two separate and totally independent issues here.
> 
> One is that I suspect some people are a bit too willing to do cleanup for 
> its own sake, and do not realize that backwards compatibility does 
> actually help too, and that "better solutions" are sometimes worse than 
> "keep things stable". We should always *allow* major breakage when 
> necessary, but I think the threshold for them should be higher than I 
> think it currently is.
> 
> The other is that once somebody says "ok, I *really* need to cause this 
> breakage, because there's a major bug or we need it for fundamental reason 
> XYZ", then that person should
> 
>  (a) create a base tree with _just_ that fundamental infrastructure change,
>      and make sure that base branch is so obviously good that there is no 
>      question about merging it.
> 
>  (b) tell other people about the reason for the infrastructure change, and 
>      simply allow others to merge it. You don't have to wait for *me* to 
>      open the merge window, you need to make sure that the people that get 
>      impacted most can continue development!

I'll do this next time I do kobject/driver core changes and see how it
works out.

thanks,

greg k-h
