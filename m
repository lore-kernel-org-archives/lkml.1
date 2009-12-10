Return-Path: <linux-kernel-owner+w=401wt.eu-S1761060AbZLJXQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761060AbZLJXQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 18:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758313AbZLJXQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 18:16:56 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:57629
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939AbZLJXQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 18:16:56 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH 1/3] Replace kernel/timeconst.pl with kernel/timeconst.sh
Date: Thu, 10 Dec 2009 17:16:59 -0600
User-Agent: KMail/1.11.2 (Linux/2.6.28-16-generic; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kbuild@vger.kernel.org
References: <200912080317.08254.rob@landley.net> <200912091740.43147.rob@landley.net> <4B20FD2C.1010804@suse.cz>
In-Reply-To: <4B20FD2C.1010804@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912101717.00049.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 December 2009 07:52:44 Michal Marek wrote:
> On 10.12.2009 00:40, Rob Landley wrote:
> > On Wednesday 09 December 2009 09:45:37 Michal Marek wrote:
> >> You're trying to avoid the build dependency on Perl. What about adding a
> >> timeconst.h_shipped with the precomputed values from timeconst.pl:
> >
> > Been there, done that.  My first patch (way back for 2.6.25) took that
> > approach:
> >
> > http://landley.net/hg/hgwebdir.cgi/firmware/file/a791ca629d9c/sources/pat
> >ches/linux-2.6.25- rc1-noperl.patch
> >
> > But it turns out various non-x86 targets (such as ARM OMAP) allow HZ to
> > be specified by an entry field in the config file, into which the user
> > can type a range of numbers.  See this post from last year for details:
> >
> > http://lists.impactlinux.com/pipermail/firmware-impactlinux.com/2008-
> > December/000022.html
> >
> > This is why reducing the perl version to just the precomputed constants
> > wouldn't work either.  (They're there so that you only need to install a
> > random cpan library when surprised by a build break on non-x86 machines.)
>
> That's why I wrote
>
> >> plus some makefile automagic to run the script iff the HZ value isn't
> >> precomputed. Then you would only need Perl for exotic HZ configurations.
>
> E.g. make it
> ...
> #elif HZ == 1200
> ...
> #else
> #include "timeconst_custom.h"
> #endif
>
> and the makefile would run timeconst.pl to generate timeconst_custom.h
> iff HZ is set to something arbitrary. I don't have a patch for that, but
> I don't see a fundamental problem with such approach.

I looked at that when I was attempting to update (rather than replace) my 
original patch.  There's a reason I didn't go there.  You're suggesting there 
be two code paths, one maintained by hand and the other just about never 
tested against bit-rot.  You want to add logic to the makefile so it knows when 
to run the perl script and when not to, meaning the makefile needs its own list 
of the cached HZ values, which needs to be kept in sync with the header of 
cached values, and thus the same information has to live in two places.

Meanwhile the shell script exists, works, and takes a fraction of a second to 
run.  Using it every build provides a single consistent code path which works 
the same for everybody.  I'm not seeing any advantage in cacheing values that 
are easy to calculate at compile time.  It's just as easy to completely 
eliminate the perl dependency as to merely mitigate it.

> Michal

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
