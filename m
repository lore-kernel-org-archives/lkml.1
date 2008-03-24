Return-Path: <linux-kernel-owner+w=401wt.eu-S1756222AbYCXCJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbYCXCJX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 22:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbYCXCJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 22:09:14 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:35215 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751562AbYCXCJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 22:09:12 -0400
Date: Mon, 24 Mar 2008 11:08:32 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>,
       J??rn Engel <joern@logfs.org>
Cc: dwmw2 <dwmw2@infradead.org>, Andrew Morton <akpm@osdl.org>,
       linux-sh <linux-sh@vger.kernel.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH] 2/3 mtd: add support for flash on the SEGA Dreamcast Visual Memory Unit
Message-ID: <20080324020832.GA13935@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	J??rn Engel <joern@logfs.org>, dwmw2 <dwmw2@infradead.org>,
	Andrew Morton <akpm@osdl.org>, linux-sh <linux-sh@vger.kernel.org>,
	Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
	MTD <linux-mtd@lists.infradead.org>
References: <1206207805.6324.13.camel@localhost.localdomain> <1206209035.6324.29.camel@localhost.localdomain> <20080322183200.GD19347@logfs.org> <1206211147.6324.48.camel@localhost.localdomain> <20080322185600.GE19347@logfs.org> <1206207805.6324.13.camel@localhost.localdomain> <1206209035.6324.29.camel@localhost.localdomain> <20080322183200.GD19347@logfs.org> <1206211147.6324.48.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080322185600.GE19347@logfs.org> <1206211147.6324.48.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2008 at 06:39:07PM +0000, Adrian McMenamin wrote:
> On Sat, 2008-03-22 at 19:32 +0100, J??rn Engel wrote:
> > Without a doubt, buffering is useful.  However I question how useful it
> > is to implement this in individual device drivers instead of once in
> > mtd_core.c.
> 
> Well, it's obviously useful to this device. Are you making best the
> enemy of better?
> 
Adrian, relax. These are helpful comments, and you should be taking them
under consideration even if you have no immediate plans to implement them
in the current driver.

Buffering is useful for this device, but the suggestion is that it's a
useful capability to have for other parts also, and so it should be done
in the generic layer. Doing this requires a bit more work on your part,
but it's in no way removing the ability to do buffering in the VMU MTD
driver (the logic is just moved up a level). You seem to be implying
that the options are having buffering in the driver as it is today, or
not at all, which is a position that doesn't even factor in the initial
comment. This is not helpful.

While it's certainly possible to do all of your work off in your own
corner, it tends to be detrimental to the subsystem if you have stuff
that can and should be done generically. Likewise, it's a give and take,
if you can't be bothered trying to do this incrementally in the subsystem
itself now, there's not much motivation for you to do so once the driver
has been merged either.

> > Given that you have ignored most of my previous comments, NAK. 
> 
> Not good enough, frankly. What comments have I ignored? I didn't
> implement your suggestion that a void* memory type become be32* because
> it was totally inappropriate for a type that is passed in both be32 and
> le32 and as u8.
> 
While I haven't seen the previous comments, the implication seems to be
that there are more than one outstanding.

> >  I don't mind merging code that isn't up to our standards yet.  But I
> >  have a bad feeling about a maintainer that does not understand
> >  review comments.  Since you had similar problems understanding
> >  Andrew, part of the blame may sit on your side.
> 
> I'm sorry that you feel that way, but as you took the hump when I said
> that this:
> 
> "Possibly the big-endian annotations need to trickly though the layers
> here as well."
> 
> Isn't good english (and it's not) and asked you - twice - to explain
> what you meant. I cannot accept your summary.
> 
Just as there's no motivation for others to accept merging your code. You
really need to work on handling feedback in a less oppositional way if
you ever want to have your changes merged.

As far as "good" english goes, this is l-k, hang your degree at the
door and get off your high horse. Even the native speakers perform
horrendous atrocities against the english language, that's life, deal
with it. In technical discussions this doesn't tend to matter at all, as
long as the meaning is obvious -- which in this case it certainly seems
to be. If you're speaking a different language, perhaps it's a
miscommunication or misinterpretation of technical terms rather than
anything else. Do not automatically assume the blame lies with people who
are trying to help you.

On Sat, Mar 22, 2008 at 07:56:01PM +0100, J??rn Engel wrote:
> Your argument would make sense if referring to a transport layer where
> some structure is just passed along as payload data.  But you are
> dereferencing a structure.  And instead of declaring a structure, you
> still do this:
> 	((unsigned long *)sendbuf)[0] = cpu_to_be32(MAPLE_FUNC_MEMCARD);
> 	((unsigned long *)sendbuf)[1] = cpu_to_be32(partition << 24 | num);
> 
> If that is a valid description of "appropriate" in your dictionary then
> we clearly don't speak the same language.  Even your own suggestion to
> change the cast to (u32*) would have been an improvement.
> 
Agreed, this stuff is very much a mess, and making the structure more
explicit would help quite a bit in terms of readability. This is legacy
stuff that's been hanging around for close to a decade now, it would be
nice to see this cleaned up and looking more like code.

> I tried to help you by a) reviewing the code and b) even converting the
> function myself after deciding that you don't understand what I meant.  
> Clearly this didn't work.  And maybe the problem is me, either because
> my English is insufficient or I am a d***head.  Quite possible.
> 
> But even if I am the problem, you should be able to understand
> somebody's review comments and act accordingly.  If not, I have a really
> bad feeling about this.  And I hope someone else has more patience than
> me, because this code still needs work.
> 
I've hit the same issues with Adrian's patches in the past, but I've
weighed this against a couple of factors:

	- Is it reasonably isolated.
	- Does it break anything else.
	- Is it more likely to get pointed at and fixed in-tree or out.

The merging of less-than-desirable code is certainly a factor here, but
it's incredibly unlikely that any of this code would get cleaned up if it
hadn't been merged. This has certainly been the case for maple, and the
related peripherals. It still has a long way to go, but it's in much
better shape these days. Adrian has done some good work in this area,
even if his bizarre oppositional development model flies in the face of
all conventional wisdom. It's slow progress, but I wouldn't have merged
the maple stuff at all if it didn't seem liks the pros outweighed the
cons. Most of the rest of us that were working in this area 7-8 years ago
have neither the time or inclination to do anything with it today, so
without these bits getting merged, it's unlikely they ever will. The fact
there's still someone hacking on this stuff today is a good indicator
that he'll be around in the future to keep it running also, hopefully
figuring out how to work with subsystem maintainers and folks doing
thankless code review in the process.

With that said, the current code obviously needs quite a bit of work
before it can be merged. I'm obviously coming in to this thread late, so
it would be helpful to have a pointer to the initial review comments. The
comments made by Andrew and myself on the maple bits I assume are being
worked on and will be respun at some point. I'll attempt to work with
Adrian on getting the rest of these issues addressed.
