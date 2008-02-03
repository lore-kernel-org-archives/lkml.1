Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbYBCVCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbYBCVCV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 16:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750890AbYBCVCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 16:02:10 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46578 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbYBCVCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 16:02:09 -0500
Date: Sun, 3 Feb 2008 21:02:08 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: section breakage on ppc64 (aka __devinitconst is broken by design)
Message-ID: <20080203210208.GU27894@ZenIV.linux.org.uk>
References: <20080203130844.GS27894@ZenIV.linux.org.uk> <20080203172635.GA2275@uranus.ravnborg.org> <20080203180234.GT27894@ZenIV.linux.org.uk> <20080203203002.GD2648@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203203002.GD2648@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2008 at 09:30:02PM +0100, Sam Ravnborg wrote:
> And I'm suprised to see that gcc thinks bar is writeable.
> If I try to assign it gcc error out as expected.

That's because "not modifiable" and "goes into r/o section" are not the
same thing.  The former belongs to C and is target-independent, of course.
The latter is up to implementation, except that modifiable objects
obviously *can not* go into r/o.  You are not guaranteed the reverse.

> We could invent a __initstr annotation but I dunno if that would suffice.
> Do you see any pattern when gcc do the r/w choice compared to the
> r/o choise. Maybe it is only const char[] that happens to be considered
> r/o and the rest is r/w?

On ppc64 relocs => r/w, AFAICS.  On other targets we might have any number
of other rules.
 
> Should a gcc-bug be filed for this btw?

Why?  gcc is entirely within its rights - it's not even a matter of ABI,
it's way below that.  Note that you are meddling with section assignment
rules and those are target-dependent, so target-independent overrides
are nowhere near being promised to work.

Frankly, "do not ever make __initdata et.al. const" is probably the best
we can do - adding __initconst, __initconst_but_has_relocs,
__initconst_but_has_something_that_puts_it_into_writable_on_this_weird_target,
__initconst_but_has_something_that_puts_it_into_writable_on_that_weird_target,
etc. is not feasible - we'll keep getting portability bugs all the time since
nobody will remember all rules (or care about ones that do not apply on
amd64).

Suppose we have an array of ad-hoc structs with a bunch of ints
in those.  Used only in ->probe(), so __devinitdata.  Constant, so
__devinitconst (and no special per-target rules trigger on the current
struct contents).  Fast forward half a year; somebody adds a string field
to those.  Oops - suddenly it's __devinitconst_but_has_relocs, but author
of that patch has never heard of ppc64 oddities; on all targets he knows
__devinitconst still works fine.
