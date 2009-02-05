Return-Path: <linux-kernel-owner+w=401wt.eu-S1756952AbZBEPvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952AbZBEPvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 10:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbZBEPvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 10:51:07 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:36300 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752109AbZBEPvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 10:51:06 -0500
Date: Thu, 5 Feb 2009 10:51:04 -0500
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Missing unistd_no.h and unistd_mm.h export on m68k
Message-ID: <20090205155104.GM26064@csclub.uwaterloo.ca>
References: <20090204181453.GE26064@csclub.uwaterloo.ca> <20090204183142.GF26064@csclub.uwaterloo.ca> <20090204184659.GG26064@csclub.uwaterloo.ca> <20090205055337.GA30333@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205055337.GA30333@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 06:53:37AM +0100, Sam Ravnborg wrote:
> Indeed the *_no.h, *_mm.h is missing from Kbuild.h.
> But looking at your patch you added much more than the
> missing *_no.h, *_mm.h.
> When doing this do it in steps:
> 1) fix make headers_check
>    This is fixed by adding the *_no.h,*_mm.h for files that
>    are exported. And that is the files lited in include/asm-generic/Kbuild.asm
>    plus the single file listed in the m68k Kbuld file.
> 
> 2) then as a separate patch export the additional files needed to build
>    ulibc.
>    Do it file-by-file so you are sure you do not add a single file
>    that is not needed. We want to have a minimal set of files exported.
> 
> And when you prepare your patch please use one line per header file,
> as we do in all the ohter Kbuild files.

Well if the exported unistd.h file says:

#ifdef __uClinux__
#include "unistd_no.h"
#else
#include "unistd_mm.h"
#endif

Then I expect BOTH files to be present since I might want to compile
both glibc and uclibc against this set of headers.

Leaving out either would be broken.

I do seem to have got carried away after I encountered one after
another.  I will try to find a smaller list of what should actually be
exported.  Now perhaps some of the headers don't need this split, which
would simplify things.

So here is an updated patch that isn't carried away.  This includes the
8 pairs of files that are included by header files that are in fact
exported already.  This makes the header files consistent on m68k no
matter what you are compiling against them.

Does this look better?

I checked this way:
linux-headers/include/asm# grep _no.h *
param.h:#include "param_no.h"
ptrace.h:#include "ptrace_no.h"
setup.h:#include "setup_no.h"
sigcontext.h:#include "sigcontext_no.h"
siginfo.h:#include "siginfo_no.h"
signal.h:#include "signal_no.h"
swab.h:#include "swab_no.h"
unistd.h:#include "unistd_no.h"

linux-headers/include/asm# ls *_no.h|cat
param_no.h
ptrace_no.h
setup_no.h
sigcontext_no.h
siginfo_no.h
signal_no.h
swab_no.h
unistd_no.h

linux-headers/include/asm# ls *_mm.h|cat
param_mm.h
ptrace_mm.h
setup_mm.h
sigcontext_mm.h
siginfo_mm.h
signal_mm.h
swab_mm.h
unistd_mm.h

-- 
Len Sorensen

The header files exported on m68k are missing dependant header files
that are included by some of the epxorted files.  This includes the 8
missing pairs of files needed by normal and uclibc builds against the
headers files.

Signed-of-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>

diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
index 1a922fa..f13d614 100644
--- a/arch/m68k/include/asm/Kbuild
+++ b/arch/m68k/include/asm/Kbuild
@@ -1,2 +1,2 @@
 include include/asm-generic/Kbuild.asm
-header-y += cachectl.h
+header-y += cachectl.h param_mm.h param_no.h ptrace_mm.h ptrace_no.h setup_mm.h setup_no.h sigcontext_mm.h sigcontext_no.h siginfo_mm.h siginfo_no.h signal_mm.h signal_no.h swab_mm.h swab_no.h unistd_mm.h unistd_no.h
