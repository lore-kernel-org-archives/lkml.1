Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbYCHTMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbYCHTMB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 14:12:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754430AbYCHTLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 14:11:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:32855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625AbYCHTLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 14:11:52 -0500
To: Olivier Galibert <galibert@pobox.com>
Cc: David Daney <ddaney@avtrex.com>, Michael Matz <matz@suse.de>,
       Joe Buck <Joe.Buck@synopsys.COM>, Jan Hubicka <hubicka@ucw.cz>,
       Aurelien Jarno <aurelien@aurel32.net>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction   flag
References: <20080305195834.GA17267@synopsys.com>
	<20080305202319.GA17053@volta.aurel32.net>
	<Pine.LNX.4.64.0803052133400.20583@wotan.suse.de>
	<20080305204234.GB17267@synopsys.com>
	<20080305204945.GB14011@atrey.karlin.mff.cuni.cz>
	<Pine.LNX.4.64.0803052158270.20583@wotan.suse.de>
	<20080305212005.GC17267@synopsys.com>
	<Pine.LNX.4.64.0803052241170.20583@wotan.suse.de>
	<20080305231712.GC2649@dspnet.fr.eu.org> <47CF2B07.2050503@avtrex.com>
	<20080306140620.GB5236@dspnet.fr.eu.org>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Sat, 08 Mar 2008 16:10:10 -0300
In-Reply-To: <20080306140620.GB5236@dspnet.fr.eu.org> (Olivier Galibert's message of "Thu\, 6 Mar 2008 15\:06\:20 +0100")
Message-ID: <orzlt9rq0d.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar  6, 2008, Olivier Galibert <galibert@pobox.com> wrote:

> It's extremely rare, no doubt about it.  It's just that it *yells*
> security issue in the making.  It's not a source bug, i.e. not easily
> reviewable.  It's related to signal handlers which are the mark of a
> server and/or more failure-conscious program than usual.  It's obscure
> (breaking a stringop, probably memset, or a not-paranoid-enough inline
> asm in a signal handler through a running memmove in the main program,
> oh my) but reasonably predictable for someone looking for an
> exploitable flaw.

> It's gcc's job to adapt to the realities of its running environment,
> not the other way around.

I smell a false dilemma here.

The problem doesn't have to be fixed/worked-around in either the
kernel or GCC.  Per your argument, one might claim it's the userland
library's, or even the application's job to adapt to the realities of
its running environment.

GCC doesn't know what functions are signal handlers to insert cld in
them.  How could it fix the problem, then?  How could it possibly fix
custom assembly?  How could it possibly fix object code containing
signal handlers, compiled by other compilers?

A userland system library, in theory, knows what functions are signal
handlers.  It could wrap function pointers passed as arguments to
signal() such that they get cld.  But then, applications that couldn't
care less about this would take a hit.

Applications, on the other hand, know when they might need cld.  So,
per your argument, they should adapt to the realities of their running
environment, and add asm("cld"); to signal handlers that might need
it.  At times, it may be hard for them to know whether they need it,
because too many factors may affect this need.  E.g.:

- if the kernel does cld for them, then they don't need it.  But
that's a run-time property, so it can't be tested at build time: the
code may run on a different kernel that doesn't do it.

- if none of the libraries they use mess with this flag, or none of
the libraries they use from signal handlers depend on this flag, then
they don't need it.  But then, again, libraries may vary over time,
and you can't assume the (dynamic) library that's available at build
time will behave the same way at run time.

So an application would have to do it conservatively, adding cld to
their signal handlers just in case.

But then, it would be more convenient if the library did it.

And then, by the same argument, it would be more convenient if the
kernel did it.

(Compiler can't do it, since it doesn't know what's a signal handler
in the general case.)

And that's an argument to support the ABI specs as they are.

It would be just silly to try to work around this deviation from the
specs, at a performance penalty, in every affected compiler, library
*and* application.  And anything less than fixing all of them would be
an incomplete work around.

Which is not an argument against providing work arounds where
possible, just an argument in favor of fixing the problem where it can
be fixed for good.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
