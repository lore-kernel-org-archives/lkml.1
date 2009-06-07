Return-Path: <linux-kernel-owner+w=401wt.eu-S1754931AbZFGTJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbZFGTJK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 15:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbZFGTIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 15:08:53 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36584 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754861AbZFGTIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 15:08:51 -0400
Subject: Re: [git pull] IDE fixes
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200906071947.19723.bzolnier@gmail.com>
References: <200906071444.33047.bzolnier@gmail.com>
	 <200906071744.23629.bzolnier@gmail.com>
	 <1244390889.8262.47.camel@mulgrave.site>
	 <200906071947.19723.bzolnier@gmail.com>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 19:08:49 +0000
Message-Id: <1244401729.8262.102.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-07 at 19:47 +0200, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 07 June 2009 18:08:09 James Bottomley wrote:
> > So I have two specific problems with the way you're trying to one up
> > libata:
> > 
> >      1. You're trying to get a jump on them by adding features as bug
> >         fixes ... this is incredibly bad release practice.
> 
> It is a bugfix.  Long overdue one.

> However you have to look beyond kernel to see it.  From the commit log:
> 
> "
> From the perspective of most users of recent systems, disabling Host
> Protected Area (HPA) can break vendor RAID formats, GPT partitions and
> risks corrupting firmware or overwriting vendor system recovery tools.
> 
> Unfortunately the original (kernels < 2.6.30) behavior (unconditionally
> disabling HPA and using full disk capacity) was introduced at the time
> when the main use of HPA was to make the drive look small enough for the
> BIOS to allow the system to boot with large capacity drives.
> 
> Thus to allow the maximum compatibility with the existing setups (using
> HPA and partitioned with HPA disabled) we automically disable HPA if
> any partitions overlapping HPA are detected.  Additionally HPA can also
> be disabled using the "nohpa" module parameter (i.e. "ide_core.nohpa=0.0"
> to disable HPA on /dev/hda).
> "
> 
> Yes, it is true that there is no rush.

So why 2.6.30-rc7 then?

> OTOH there are absolutely no valid technical reasons to slow it down!

There is incredibly valid reason not to put this in 2.6.30-rc7: You've
added a feature (HPA) which ide previously ignored, so now you need to
identify all those cases and turn it off.  The way you've done this is a
fallback heuristic in the partitions code which recognises that the
device has a partition into the host protected area and turns off the
HPA feature.  There are three areas of risk here

     1. Adding HPA at all.  We have zero outstanding bugs saying that
        ignoring HPA broke anyone's system.  Alan's concern you quote
        above is valid, but unproven at this point.  Conversely, by
        turning on HPA in IDE we may discover some legacy devices that
        don't behave well with it that haven't been picked up by libata.
        This is almost unquantifiable, but I'd guess high based on
        previous run ins with new IDE features and standards
        conformance.
     2. The modification of generic partition code for the fallback
        heuristic ... get something wrong in here and all of storage
        will suffer.  This is a medium risk which could be mitigated by
        a longer test cycle.
     3. Your actual heuristic: it sounds fine in principle, but what
        about people who use the kpartx method of partitioning or even
        just used native dm ... their disks suddenly and unexpectedly
        get shorter.  This heuristic has had insufficient testing to
        turn up any of these possible failure cases (or any others I
        haven't through of).  Again, this is high risk for an immediate
        release which could be mitigated by a longer test cycle.

All of this adds up to unacceptable risk in the last week of a release.

In the real world people get fired for this sort of thing (admittedly
only usually if the risk factor militates against them).

> >      2. this antagonism in feature evolution is likely to lead to
> >         interface incompatibility between libata and IDE ... and users
> >         will be the ultimate losers because of this.
> 
> Hmmm, did you *really* read the patches?

yes, so perhaps you'd have the courtesy to avoid newbie intimidation
tactics.

> They make libata and IDE more similar by making IDE also default to
> preserving HPA (which is what libata does).  So users get more coherent
> overall kernel behavior.
> 
> The only difference is that IDE for compatibility reasons must handle old
> installs (with HPA wrongly disabled and protected area used for filesystem
> data).

I know this, but as I said, the risk of IDE damaging a system by
ignoring HPA is theoretical at the moment ... you have to set that
against the introduced risks listed above.

> However it does it in a clean way (not a subsystem specific hack) which
> can be later used for implementing the same functionality in libata!

I agree with this too ... the problem is that doing things the right
way(tm) does increase the footprint of the changes and with it the
release risk.

> [ I also tried to encourage libata developers to look into making the needed
>   libata changes (see my initial posting of HPA patches) and I will still be
>   glad to help with libata patches if somebody would like to work on them
>   (Robert? Tejun?). ]

OK, so back off on the 2.6.30-rc7 release of this and I'll undertake to
get libata engaged for integrating this into both subsystems for
2.6.31 ... does that sound fair?

James


