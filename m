Return-Path: <linux-kernel-owner+w=401wt.eu-S1757602AbZCMDZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602AbZCMDZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 23:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbZCMDZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 23:25:11 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:38881
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbZCMDZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 23:25:09 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: make headers_install broken for ARCH=m68k in 2.6.29-rc7.
Date: Thu, 12 Mar 2009 22:25:03 -0500
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, Greg Ungerer <gerg@snapgear.com>,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       linux-next@vger.kernel.org
References: <200903120437.03837.rob@landley.net> <20090312210216.GB14205@uranus.ravnborg.org> <10f740e80903121540i30fdaddr600ce21f4159530a@mail.gmail.com>
In-Reply-To: <10f740e80903121540i30fdaddr600ce21f4159530a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903122225.04560.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009 17:40:02 Geert Uytterhoeven wrote:
> On Thu, Mar 12, 2009 at 22:02, Sam Ravnborg <sam@ravnborg.org> wrote:
> >> And, yes, I can confirm the m68k include/asm/unistd.h from linux-next
> >> actually has contents, thanks to commit
> >> 646652bded41f4c3bd375b4e03a25b42da93f40b
> >>
> >> Anyway, here's hoping the fix makes it into 2.6.29.
> >
> > Why not telling the m68k maintainer that you think it should go into
> > 2.6.29?

I contacted the headers_install maintainer about a headers_install problem, 
and was pointed to an existing fix upstream.  This seemed to imply awareness 
of the problem?

Happy to follow up more, wasn't aware it was required...

> There are a few more:
>
> param.h:#include "param_no.h"
> param.h:#include "param_mm.h"
> ptrace.h:#include "ptrace_no.h"
> ptrace.h:#include "ptrace_mm.h"
> setup.h:#include "setup_no.h"
> setup.h:#include "setup_mm.h"
> sigcontext.h:#include "sigcontext_no.h"
> sigcontext.h:#include "sigcontext_mm.h"
> siginfo.h:#include "siginfo_no.h"
> siginfo.h:#include "siginfo_mm.h"
> signal.h:#include "signal_no.h"
> signal.h:#include "signal_mm.h"
> swab.h:#include "swab_no.h"
> swab.h:#include "swab_mm.h"
>
> Rob, do these also causes problems?
> Some (not all) of them are fixed in linux-next.

I'm trying to build uClibc against the new headers.  I just got around to 
extracting the patch to fix that one file and testing it in my build system, 
and this time it broke with:

  build/cross-compiler-m68k/include/asm/param.h:4:22: error: param_mm.h: No
  such file or directory

So yeah, it's still unhappy.  Dunno how many of these are still needed to 
build the cross compiler, and then who knows what other packages need to 
build.  Presumably all of it.

Keep in mind I still haven't found an emulator for m68k that actually boots a 
linux kernel, so my m68k support is purely theoretical.  (I poked at mess and 
uae a bit today, but they don't do the "qemu -kernel" thing I'm using for the 
other targets, and qemu itself only seems to support coldfire and not a full-
blown m68k.)  I'm following up on this because it's a regression.  Under 
2.6.28 the m68k target was building a kernel and root filesystem, but I don't 
have hardware to run it and have never been able to test it, so isn't really 
very useful for me.  It's really just there so that if qemu grows the rest of 
m68k support (patches have been submitted but not merged), I'll be ready.

P.S.  If you're bored and want to try my test build for yourself:

  wget http://impactlinux.com/hg/firmware/archive/tip.tar.bz2
  tar xvjf tip.tar.bz2
  cd firmware-*
  USE_UNSTABLE=linux ./build.sh m68k

Without the USE_UNSTABLE=linux it uses 2.6.28 and builds to completion, with 
it the build uses 2.6.29-rc7 (or whatever URL's listed as the UNSTABLE= value 
for linux in download.sh) and it breaks trying to add uClibc to the cross 
compiler.

But then anything that actually _uses_ the "make headers_install" output to 
build stuff against should notice pretty quickly whether or not it #includes 
missing files.

Rob
