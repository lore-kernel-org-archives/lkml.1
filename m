Return-Path: <linux-kernel-owner+w=401wt.eu-S1161152AbXD1SGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161152AbXD1SGT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163398AbXD1SGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:06:09 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:57800 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161071AbXD1SF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 14:05:57 -0400
X-Originating-Ip: 74.109.98.66
Date: Sat, 28 Apr 2007 14:05:44 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: random thoughts on DEPRECATED and OBSOLETE
In-Reply-To: <46337BD2.7000701@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0704281320560.27098@localhost.localdomain>
References: <Pine.LNX.4.64.0704280925270.24691@localhost.localdomain>
 <46337BD2.7000701@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


stefan makes a number of points, all of which i'll add to the wiki
page shortly (if i get ambitious enough), but i'll answer them here as
well.

On Sat, 28 Apr 2007, Stefan Richter wrote:

> Robert P. J. Day wrote:
> > http://fsdev.net/wiki/index.php?title=Maturity_levels
> >
> > rday
> >
>
> A few comments:
>
>   - Your argument should include what the benefits of exposing
>     DEPRECATED and OBSOLETE as machine-parsable tags are.

assuming i understand you correctly, the advantage of adding these
attributes is to be able to (de)select, in one operation, anything of
that attribute type from your build (in the same way that you can
deselect anything EXPERIMENTAL in one mouse click).

i think there's a real benefit in being able to say that you can
configure and build a kernel that incorporates nothing that people
have labelled as obsolete or deprecated (or broken, etc.).

(hypothetically, you could do "make allyesconfig", then "make
menuconfig" and switch off anything tagged as OBSOLETE, then do your
build.  that *that* configuration should build would be, IMHO, more
important than whether a full build *including* obsolete stuff
builds.  all that's doing is prioritizing how much you care whether
various parts of the kernel actually compile even though, yes, you
probably want to eventually fix it up, anyway. but at least you can
compile-test the more important features first.)

>   - "...it's not really experimental but nonetheless claims to be. Bad
>     craziness all around."

>     Won't adding more maturity levels increase craziness?

not at all.  in fact, what it *will* do is prevent those mismatches
between some kernel feature visually *advertising* itself as being,
say, DEPRECATED, while, in reality, it's *not* tagged that way.  or
vice versa.  there's a lot of that going on in the current Kconfig
files as we speak (with EXPERIMENTAL, of course).

> All of the levels except BROKEN are highly subjective.

i don't think so.  we've had this discussion before, and most people
seem to agree on what it means for something to be "deprecated" and
what it means to be "obsolete."  it's not really *that* subjective.

> And such tags can and will become outdated.

how is that different from what's happening now?  there's stuff marked
"EXPERIMENTAL" that appears to have been in the kernel for years.
and, obviously, the only way a scheme like this is going to work is if
developers keep their own subsystems up to date and tag them
appropriately.

(note also that the beauty of this scheme is that you can start off
slowly and, a bit at a time, start tagging stuff with those new
attributes.  you don't need to do it all at once but, the more you use
it, the more rigorous and selective you can make your builds.)

>   - How is the proposed "maturity" keyword to be used?  Will
>         maturity EXPERIMENTAL
>     replace
>         config EXPERIMENTAL
>     or
>         depends on EXPERIMENTAL
>     ?  One of your examples for the usage of the keyword, "maturity
>     OBSOLETE && BROKEN", indicates it is the latter.

whoops, good point.  it would be used thusly:

config FUBAR
	bool "Grobnit the fubar"
	maturity DEPRECATED
	...

in addition, "maturity EXPERIMENTAL" would replace "depends on
EXPERIMENTAL", while you would lose the whole "config EXPERIMENTAL"
part completely, since EXPERIMENTAL would no longer be a regular
"config" option, but a maturity attribute.

>   - In case it is the latter, didn't you mean by this example "maturity
>     OBSOLETE | BROKEN" rather than "maturity OBSOLETE && BROKEN"?

no, it would make no sense to tag something as

	maturity OBSOLETE | BROKEN

as if there was a choice.  any kernel feature would be explicitly
tagged as one or more maturity attributes, as in one of, possibly:

	maturity OBSOLETE
	maturity BROKEN
	maturity BROKEN && OBSOLETE && PIECEOFCRAP

then, depending on your config selection, you would display *only*
those features whose attributes are a *subset* of what you selected:

	[*] OBSOLETE
	[ ] BROKEN

would display stuff that (in addition to the normal stuff with no
maturity tag at all) was OBSOLETE, but *not* OBSOLETE *and* BROKEN,
since you clearly did not select BROKEN.

> I sometimes voiced my opinion that the Kconfig language and files
> should stick to reflect the mere dependencies, while presentation
> should be left to the UIs.  The "maturity" directive is basically a
> variant of "config" or "depends on" with added presentational
> information.

in a way, yes, it's a variant, but it's a variant that differs enough
from a regular "config" and "depends on" that i think trying to mix
the two would be a horribly bad idea.

i like your suggestion of calling it an "attribute".  it's sort of
like assigning a type.  but the point to note is that this whole idea
has a precedent -- EXPERIMENTAL.  once you've allowed kernel features
to be tagged as EXPERIMENTAL, you're really opened the door to other
types of maturity levels that would be just as useful.  personally, i
don't know how anyone can accept the notion of EXPERIMENTAL, yet
resist adding more maturity levels, but that's just me.

> Of course everybody is entitled to have a different opinion and ask
> for more presentational markup in Kconfig.

fair enough, but it's not just presentational markup, in the same way
that EXPERIMENTAL isn't *just* presentational markup -- it means more
than that.

> Something /can/ sensibly be DEPRECATED and OBSOLETE at the same
> time.

i disagree.  in previous exchanges, most people seemed satisfied that
those two terms were mutually exclusive.  i think the difference in
their definitions is self-evident.

> (This also means the correct term is not maturity /levels/, but
> maturity attributes or the like.)

sure, i can go with that, but it's not like it's a critical
distinction since only the word "maturity" need appear in the Kconfig
file, anyway.

rday

p.s.  a couple more observations.  first, rather than mess with
EXPERIMENTAL or BROKEN, those can be left entirely alone and a new
structure can be added to the parser to support *just* maturity levels
of DEPRECATED and OBSOLETE.  once that seems to work well,
EXPERIMENTAL and BROKEN can be moved over some time in the future but,
even without that move, a restricted maturity attribute would still be
useful and informative.

also, once a few things get tagged, then, as i mentioned before, a
full tree build can be done in stages.  i recall andrew grumbling that
he was still trying to get a full configuration to build.  but why try
to do it all at once?

i'd start with an "allyesconfig" but leaving out all the DEPRECATED,
OBSOLETE and BROKEN stuff and beat on that until it worked.  then i'd
add in the DEPRECATED stuff and do it again.  finally, add the
OBSOLETE stuff.  at each stage, the build might fail but, the further
you get into it, the less a build failure should concern you.

it's just a thought.

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
