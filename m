Return-Path: <linux-kernel-owner+w=401wt.eu-S937739AbZAPVyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937739AbZAPVyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 16:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762255AbZAPVyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 16:54:07 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:55723
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762237AbZAPVyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 16:54:06 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Valdis.Kletnieks@vt.edu,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Date: Fri, 16 Jan 2009 15:54:00 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
References: <495FEEAF.5020005@zytor.com> <200901160011.11679.rob@landley.net> <15458.1232117682@turing-police.cc.vt.edu>
In-Reply-To: <15458.1232117682@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901161554.02054.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2009 08:54:42 Valdis.Kletnieks@vt.edu wrote:
> On Fri, 16 Jan 2009 00:11:09 CST, Rob Landley said:
> > P.S.  I still hope autoconf dies off and the world wakes up and moves
> > away from that.  And from makefiles for that matter.  But in the
> > meantime, I can work around it with enough effort.
>
> What do you propose autoconf and makefiles get replaced by?

At a first guess, meaningful standards and an acknowledgement that Linux is a 
platform in its own right?  Between the two of them, that's 90% of your 
problem right there.

Not a new issue, here's a link from 2002:
http://news.cnet.com/2100-1001-950180.html

And here's a multi-vendor effort at a standards group (the 86open project to 
definite a Unix binary standard for x86 processors) dissolving itself way back 
in 1999 with a declaration that the Linux binary format already was an open 
standard and other unixes should just use things like lxrun to support that: 
http://www.telly.org/86open/

Also, it would be nice if configure steps could stop entangling 1) users 
providing preferences (command line options like --prefix or most of the --
enable and --disable flags) for which things like kconfig might make more 
sense, 2) probe for installed packages like zlib and enabling optional support 
if found, 3) questions like "does my build environment provide strlcpy()".  
Turning that into a big hairball does not help keep things simple.

> % wc pidgin/configure*
>   34287  118303 1004074 pidgin/configure
>    2499    7684   81532 pidgin/configure.ac
>
> Which you rather code, 2.5K lines of autoconf or 35K lines of configure
> script?

I consider it a false dichotomy.  I prefer "neither", and have seen it done 
successfully many times.

I've never built pidgin from source, but I've got the output of the binutils 
build in a log file.  How many of these tests are actually necessary on any 
Linux system:

checking for C compiler default output file name... a.out
checking whether the C compiler works... yes
checking for suffix of object files... o
checking whether gcc accepts -g... yes
checking for library containing strerror... none required
checking how to run the C preprocessor... gcc -E
checking whether build environment is sane... yes
checking whether gcc and cc understand -c and -o together... yes
checking for an ANSI C-conforming const... yes
checking for inline... inline

It just goes on and on and on like this.  Tests like "checking whether byte 
ordering is bigendian... no" means "Either I didn't know endian.h existed, or 
I don't trust it to be there".  How about the long stretches checking for the 
existence of header files specified by posix?  Or this gem:

checking for gawk... no
checking for mawk... no
checking for nawk... no
checking for awk... awk

(If you can use awk, when is it _not_ there?  Probable answer: there was some 
broken version on irix back in 1992 with zero remaining seats today, and they 
never went back to clean anything out of the makefile because "simplifying the 
build" and "autoconf" do not go together, and because you can't sanely 
regression test against build environments nobody has anymore.)

This argument is a can of worms, and the linux-kernel list probably isn't the 
best place for it.  However, "install mingw on windows instead of trying to 
get your thing to build under Visual Studio" is a decent support strategy.  
Tinycc and Intel's icc both implemented gcc extensions to build the kernel, 
and the kernel's been removing such extensions where c99 versions are 
available since then.  Things like uClibc implement standards and copy glibc 
extensions that are actually used.

In the era of open source, it's now a viable strategy to specify, document, 
and require a standardized build environment.  The way to make that build 
environment portable is to keep it simple and standardized, not to create a 
tower of #ifdefs testing the output of a huge environment probing shell 
script.

Rob
