Return-Path: <linux-kernel-owner+w=401wt.eu-S1755040AbYIYWIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbYIYWIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 18:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbYIYWIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 18:08:21 -0400
Received: from mail.suse.de ([195.135.220.2]:43247 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400AbYIYWIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 18:08:20 -0400
Date: Thu, 25 Sep 2008 15:04:54 -0700
From: Greg KH <gregkh@suse.de>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, Jeff Mahoney <jeffm@suse.de>
Subject: Re: [patch 00/04] RFC: Staging tree (drivers/staging)
Message-ID: <20080925220454.GA12116@suse.de>
References: <20080924230054.GA27730@suse.de> <f7848160809241639hbe716c9q76b0e1b83d853721@mail.gmail.com> <20080925020608.GA13869@suse.de> <f7848160809241959s3f3092b2nf05d2245a08bed03@mail.gmail.com> <20080925042108.GA3931@suse.de> <f7848160809250402l163bb177oeed30f2daa18fafd@mail.gmail.com> <20080925205328.GB11225@suse.de> <f7848160809251440jfcd60f9lb962a75ff01798c8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7848160809251440jfcd60f9lb962a75ff01798c8@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 05:40:28PM -0400, Parag Warudkar wrote:
> On Thu, Sep 25, 2008 at 4:53 PM, Greg KH <gregkh@suse.de> wrote:
> >
> > Heh, ok, so the basic premise of getting code that is not currently in
> > mergable shape into the tree earlier to get wider usage and testing is
> > something that you agree with?
> 
> I don't think I got my point across - let me try again.
> 
> My disagreement was with getting crap code in mainline, re-classifying
> it as something other than experimental when it is not, expecting
> users to use it, printing warning when it is used, tainting the kernel
> for even more harassment and then having developers not support it  as
> a bonus - all cumulative. The naming part was also something that I
> did not like but that like I said was just my preference and does not
> matter because I disagree there is no need to TAINT  in first place.

I'm sorry we disagree here.  Also note that this goes against what a
number of us decided at the kernel summit, we want this code into the
tree as easily as possible.

> I can imagine that getting crap code in mainline is helpful for some
> class of users and developers - no problem we can have it in on that
> basis - I give up my objection there.

Great.

> But my objections to the other parts remain -  i.e. we should
> definitely avoid the useless re-classification and TAINT, we should
> change little or no other kernel code in the process of integrating
> this crap, give enough deterrent for people to really think before
> loading the crap code, and do not make it an official statement that
> you will get no support on LKML if you load this driver. Because
> certainly not all developers agree and we by definition of this
> staging effort have an interest in fixing the code.
> 
> The below approach I referred few times earlier will allow us to do
> exactly that - it would be good if you can tell me if this is
> workable.

So you now agree with the idea, just the implementation of the area
around the drivers, nice that's easy to work out.

> 1) Give a staging directory for all such low quality crap

Done in the patches I sent out.

> 2) Give a KConfig group "Staging Drivers (Low Quality/High Risk)" and
> if that is selected allow users to individually select the crappy
> drivers they want to actually use - default all entries to N

Done in the patches I sent out.

> 3) Name all modules under staging  with a _stg suffix or something unique

A name doesn't really matter here, the modinfo tag is just as
sufficient like I already did.

> 4) By default do NOT load anything with a _stg suffix - deal with this
> in insmod code, not the kernel

Um, no, I'm not going to force all userspace users to upgrade their
version of module-init-tools, JUST to prevent them from automatically
loading these drivers.  That's not going to happen, sorry.

> 5) Require that -f be specified to load _stg modules - which will
> auto-taint the kernel and developers can decide on their judgment /
> situation whether or not to pursue it

So you have to load the modules by "hand"?  Ick, no, that too is not
acceptable as it means no one will ever do it.  Don't break the
wonderful infrastructure we already have around the kernel of
auto-loading the proper driver for the proper hardware just because you
want to make the user jump through an extra step please.

>  6) OOPS reports with force loaded taint and _stg in module list will
> allow developers to decide whether or not to go after it

My patch set already does this, and it does so in a way that uniquely
distinguishes from the -f option, which some of us don't want to debug
as well.

> The above approach avoids re-classification/TAINTING, touches no
> kernel code and does not load the crap code automatically and still
> allows you to do what you intended.

What's the objection for the 9 extra lines in module.c, 2 lines in
panic.c, and 9 lines on scripts/mod/modpost.c?  Is this some huge
overhead that is unmaintainable?

Heck, the insmod changes would be more than that I imagine (and it would
be in modprobe, not insmod, it has to do with alias matching and that
chunk of code is _nasty_, I sure don't want to touch that.)

> Hopefully this doesn't sound like another "let us arm wrestle on what
> to name it" - because it is clearly more than that!

No, I really think it isn't more than that.  For some reason you are
afraid of another taint flag, why?  There is no extra overhead, and no
user needs to upgrade any userspace component at all (which, if you have
any experience with, you will know it just will not happen fast, if at
all for the large majority of users/developers.)

I don't want to make the kernel require a new version of
module-init-tools, and my current proposal of infrastructure changes
requires a massive core change of:

 Documentation/sysctl/kernel.txt |    1 +
 include/linux/kernel.h          |    1 +
 kernel/module.c                 |    9 +++++++++
 kernel/panic.c                  |    6 ++++--
 scripts/mod/modpost.c           |    9 +++++++++
5 files changed, 24 insertions(+), 2 deletions(-)

How much smaller do you expect this to get?

thanks,

greg k-h
