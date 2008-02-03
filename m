Return-Path: <linux-kernel-owner+w=401wt.eu-S1753781AbYBCUaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbYBCUaM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 15:30:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbYBCU37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 15:29:59 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:45037 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbYBCU36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 15:29:58 -0500
Date: Sun, 3 Feb 2008 21:30:02 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: section breakage on ppc64 (aka __devinitconst is broken by design)
Message-ID: <20080203203002.GD2648@uranus.ravnborg.org>
References: <20080203130844.GS27894@ZenIV.linux.org.uk> <20080203172635.GA2275@uranus.ravnborg.org> <20080203180234.GT27894@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203180234.GT27894@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2008 at 06:02:34PM +0000, Al Viro wrote:
> On Sun, Feb 03, 2008 at 06:26:35PM +0100, Sam Ravnborg wrote:
> > On Sun, Feb 03, 2008 at 01:08:44PM +0000, Al Viro wrote:
> > > ; cat >a.c <<'EOF'
> > > const char foo[] __attribute__ ((__section__(".blah"))) = "";
> > > const char * const bar __attribute__((__section__(".blah"))) = "";
> > > EOF
> > > ; gcc -m32 -S a.c
> > > ; gcc -m64 -S a.c
> > > a.c:2: error: bar causes a section type conflict
> > > ;
> > > 
> > > That's 4.1.2 on ppc.  What happens is that the second declaration
> > > wants to make .blah writable.  We actually trigger that in ppc64
> > > builds on drivers/net/natsemi.c.
> > > 
> > > Note that on ppc64 without explicit sections you have the second one land in
> > > .data.rel.ro.local, which is "aw",progbits.
> > > 
> > > The reason why it didn't visibly bite us before is that usually __devinit...
> > > just expanded to nothing (unless you disable HOTPLUG, which requires
> > > EMBEDDED, which wasn't apparently common enough for ppc64 builds).
> > > 
> > > Suggestions?
> > 
> > Hi Al.
> > 
> > __devinitconst were invented to cover this issue.
> > So use __devinitconst for const data and 
> > __devinitdata for non-const data.
> 
> As the example above shows, what is and what is not const data is
> irrelevant.  The data _is_ const.  On ppc32 gcc is happy to put
> it into read-only section.  On ppc64 the same version of gcc insists
> on making the section this data object is going to *writable*.
> 
> > We recently had breakage in mainline with x86 64 bit
> > (sis190) for the exact same case.
> 
> No, this is not exact same case.  Unfortunately.
> 
> > Does this work in your ppc example or do we need
> > to find another solution?
> 
> Please, read the posted example.  s/.blah/.devinit.rodata/ if you wish - it's
> not magical.  What happens is that
> 	* gcc choice of r/o vs. r/w section is not determined by object
> being const
> 	* that choice is actually platform-dependent, even between related
> platforms (see ppc32 and ppc64 in the example above).

Got it now - sorry.

And I'm suprised to see that gcc thinks bar is writeable.
If I try to assign it gcc error out as expected.

To get your example building I had to kill the const in front of foo:
char foo[] __attribute__ ((__section__(".blah"))) = "";
const char * const bar __attribute__((__section__(".blah"))) = "";

This is not an acceptable situation but for now I do not see a solution.

It is as such not the __devinitconst thing that causes us problems here.
It is the total concept of controlling the section of variables from
our C-code base.

We could invent a __initstr annotation but I dunno if that would suffice.
Do you see any pattern when gcc do the r/w choice compared to the
r/o choise. Maybe it is only const char[] that happens to be considered
r/o and the rest is r/w?

Should a gcc-bug be filed for this btw?

	Sam
