Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbYBPR7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbYBPR7T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 12:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756067AbYBPR7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 12:59:05 -0500
Received: from 1wt.eu ([62.212.114.60]:1993 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785AbYBPR7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 12:59:02 -0500
Date: Sat, 16 Feb 2008 18:58:49 +0100
From: Willy Tarreau <w@1wt.eu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Roel Kluin <12o3l@tiscali.nl>, geoffrey.levand@am.sony.com,
       linuxppc-dev@ozlabs.org, cbe-oss-dev@ozlabs.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Fix Unlikely(x) == y
Message-ID: <20080216175849.GA25636@1wt.eu>
References: <47B70A61.9030306@tiscali.nl> <20080216092552.325e5726@laptopd505.fenrus.org> <20080216173315.GU8953@1wt.eu> <20080216094226.1e8eede1@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080216094226.1e8eede1@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 09:42:26AM -0800, Arjan van de Ven wrote:
> On Sat, 16 Feb 2008 18:33:16 +0100
> Willy Tarreau <w@1wt.eu> wrote:
> 
> > On Sat, Feb 16, 2008 at 09:25:52AM -0800, Arjan van de Ven wrote:
> > > On Sat, 16 Feb 2008 17:08:01 +0100
> > > Roel Kluin <12o3l@tiscali.nl> wrote:
> > > 
> > > > The patch below was not yet tested. If it's correct as it is,
> > > > please comment. ---
> > > > Fix Unlikely(x) == y
> > > > 
> > > 
> > > you found a great set of bugs..
> > > but to be honest... I suspect it's just best to remove unlikely
> > > altogether for these cases; unlikely() is almost a
> > > go-faster-stripes thing, and if you don't know how to use it you
> > > shouldn't be using it... so just removing it for all wrong cases is
> > > actually the best thing to do imo.
> > 
> > Well, eventhough the author may not know how to use it, "unlikely" at
> > least indicates the intention of the author, or his knowledge of what
> > should happen here. I'd suggest leaving it where it is because the
> > authot of this code is in best position to know that this branch is
> > unlikely to happen, eventhough he does not correctly use the macro.
> >
> 
> you have more faith in the authors knowledge of how his code actually behaves than I think is warranted  :)
> Or faith in that he knows what "unlikely" means.
> I should write docs about this; but unlikely() means:
> 1) It happens less than 0.01% of the cases.
> 2) The compiler couldn't have figured this out by itself
>    (NULL pointer checks are compiler done already, same for some other conditions)
> 3) It's a hot codepath where shaving 0.5 cycles (less even on x86) matters
>    (and the author is ok with taking a 500 cycles hit if he's wrong)
> 
> If you think unlikely() means something else, we should fix what it maps to towards gcc ;)
> (to.. be empty ;)

eventhough the gcc docs say it's just a hint to help the compiler optimize
the branch it takes by default, I too have noticed that it more often does
bad than good. Code gets completely reordered and even sometimes partially
duplicated (especially when the branch is a return).

Last but not least, gcc 4 tends to emit stupid checks, to the point that I
have replaced unlikely(x) with (x) in my code when gcc >= 4 is detected. What
I observe is that the following code :

    if (unlikely(p == NULL)) ...

often gets coded like this :

    reg1 = (p == NULL)
    if (reg1 != 0) ...

... which clobbers reg1 for nothing and performs a double test.

But yes, I assumed that the author considered its use to be legitimate (I've
not looked at the code). Maybe you're right and it should be removed, but in
this case we would need a large audit of the abuses of unlikely()...

Willy

