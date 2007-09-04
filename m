Return-Path: <linux-kernel-owner+w=401wt.eu-S1752125AbXIDFCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbXIDFCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 01:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbXIDFCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 01:02:06 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:32916
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750980AbXIDFCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 01:02:05 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: kconfig/kbuild rewite (Re: What's up with CONFIG_BLK_DEV?)
Date: Tue, 4 Sep 2007 00:01:58 -0500
User-Agent: KMail/1.9.6
Cc: Oleg Verych <olecom@flower.upol.cz>,
       Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
References: <200708241517.28475.rob@landley.net> <E1IRcvF-0007yi-73@flower> <20070902115150.GB30207@uranus.ravnborg.org>
In-Reply-To: <20070902115150.GB30207@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709040001.59200.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 September 2007 6:51:50 am Sam Ravnborg wrote:
> As for Kconfig the low hanging fruits are not in the tools but in the
> structure of the Kconfig files. There are a lot that can be improved
> with a decent effort but nobody has stepped up doing so.
> The tools could be better too but if the root problem is the structure
> of the Kconfig files this is where we should focus and not on the tools.

On a semi-related note, I recently wrote a dumb little minimal python parser 
that converted all the menuconfig help to html:

http://kernel.org/doc/menuconfig
http://kernel.org/doc/make/menuconfig2html.py

I did this by ignoring half of the structure of the files (I was only 
interested in the help text), but it occurs to me that my current script to 
create miniconfig files by repeatedly calling "allnoconfig":
http://landley.net/hg/firmware/file/fe0e5b641cb4/sources/toys/miniconfig.sh

Could probably be replaced by a python script to read the .config, parse the 
kconfig, understand the dependencies, and spit out the miniconfig, without 
_too_ much effort.

I'll throw it on the todo heap after the other 12 projects I hope to get to 
this month...

> For Kbuild I fail to see anything that demand a rewrite from a structure
> view of the Kbuild files.
> The Kbuild internal stuff is antoehr story - here a rewrite to a saner
> language then GNU make syntax could improve hackability a lot.

I agree about getting away from make, but I arrived at the conclusion from a 
different perspective.  I believe make is starting to outlive its usefulness.

Rampant opinion follows:

Incremental builds are a developer convenience.  Users who download the source 
code to open source projects but who aren't modifying the project tend to 
do "make all", and nothing else.  Source build systems like gentoo generally 
don't have any "rebuild several variants of the same package incrementally" 
option, and for many packages changing configuration requires a "make clean" 
anyway.  (Since make doesn't handle configuration dependencies, anybody who 
_does_ make that work without an intervening make clean implemented extensive 
infrastructure of their own, on top of make.)  As far as release versions are 
concerned, all make provides is an expected user interface (./configure; 
make; make install).  The infrastructure to calculate dependencies (make's 
reason to exist) is essentially useless during deployment of release 
versions.

For 90% of the software packages out there, "make all" takes less than 10 
seconds on modern hardware.  Sometimes the ./configure step takes longer to 
run than the actual build.  (The kernel is not one of these packages, but the 
kernel is probably the largest open source software development effort in 
history, at least in terms of the number of developers involved if not 
absolute code size.)  So for all but the largest and most complicated 
software packages, make doesn't even significantly improve the lives of 
developers.  And those large software packages tend to either reimplement 
make (XFree86 had ibuild, KDE did cmake, Apache has ant...) because for 
_large_ packages, make sucks.  Kbuild can be seen as yet another such 
reimplementation, in this case built on top of gnu make rather than by 
replacing it.

The most efficient way to build software these days is to feed all the .c 
files to gcc in one go, so the optimizer can work on the entire program in 
one big tree.  This can give up about 10% smaller and faster code, assuming 
you have a few hundred megs of ram which essentially all new development 
systems do.  It's also faster to do this than to do a normal "make all" 
because you don't re-exec gcc lots of times, and can stay cache-hot more.  So 
for deployment builds, eliminating the granularity of make and batching the 
compile into larger chunks is functionally superior.  This reduces make's job 
to "call gcc once for each output binary, then do any fancy linker stuff".

Intermediate levels of granularity are available, for example the linux kernel 
source code already produces one .o file per directory (built-in.o).  It 
could compile a directory at a time rather than a file at a time, and check 
that this one .o file is newer than every other file in the directory or else 
rebuild it, improving efficiency and reducing build complexity without 
requiring full 4-minute rebuilds.  This is the same kind of "more intelligent 
batching" optimization people were doing back in the days of reel-to-reel 
tape.  Ask Maddog about it sometime, he's got great stories. :)

Using a faster non-optimizing compiler (like tcc) can build even large 
projects like the entire Linux kernel in the 10 second range.  (For example, 
http://fabrice.bellard.free.fr/tcc/tccboot.html took 15 seconds to compile 
the linux kernel on a Pentium 4.  A modern 64-bit core 2 duo is noticeably 
faster than this.)  The resulting code has some downsides (inefficient, and 
tcc isn't finished yet: I'm still working on getting tcc to build an 
unmodified current kernel which is why I haven't seriously pushed for 
adoption of this strategy yet) but it shows that there are other tools 
capable of speeding up development builds, as much or more than "make" can.

Make itself was never an elegant tool.  The significance of invisible 
whitespace (tabs vs spaces) is only a minor annoyance compared to the design 
flaw of mixing declarative and imperative flow control within the same syntax 
(fundamental problem: you can't assign to a make variable within a target), 
which leads to widespread use of recursive make to try to keep _some_ control 
over the order of events (see "Recursive make considered harmful" at 
http://aegis.sourceforge.net/auug97.pdf ), and then there's the 
incompatability between different make versions (even different releases of 
GNU Make).  Modifying makefiles thus becomes a highly non-obvious activity 
constituting its own area of expertise.  But if you aren't interested in 
dependency calculation (or only directory-level dependency calculation) and 
are willing to let all makes be "make all", then most makefiles could be 
written as a small, linear shell script.

I think that for 90% of the software packages out on freshmeat and sourceforge 
today, make is already dead weight kept in place by tradition.  I freely 
admit this is an opinion, but I doubt it'll become _less_ true in future.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
