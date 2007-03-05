Return-Path: <linux-kernel-owner+w=401wt.eu-S932634AbXCENxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634AbXCENxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 08:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932642AbXCENxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 08:53:17 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:35238 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932634AbXCENxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 08:53:16 -0500
Message-Id: <1173102794.12256.1177759349@webmail.messagingengine.com>
X-Sasl-Enc: gppvda0QHzFLhzVdldAW+KItBRnDCdenAxKsVXSWtQiK 1173102794
From: "FN" <zzzz444@ml1.net>
To: "Oleg Verych" <olecom@flower.upol.cz>
Cc: linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1172855662.23830.1177403935@webmail.messagingengine.com>
   <E1HNyYT-00086z-27@flower>
Subject: Re: module builds need improvement / top Makefile not good enough
In-Reply-To: <E1HNyYT-00086z-27@flower>
Date: Mon, 05 Mar 2007 05:53:14 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

| > I am unhappy with the direction the 2.6 kernel builds have taken.
| > Very much like Micro$loth DDKs we (linux users) are being forced to
| > build modules by plugging into a framework that doesn't respect the
fine
| > aspects of dependency generation and analysis.
| 
| Ideas in form of patches are accepted,

I think that one of the bigger firms that support linux, like IBM,
Redhat,
Suse, ought to hire a contractor to redesign kbuild and get the linux
community involved.

 
| > Two problems I've identified
| > 1. module builds are forcing me to use a particular make program
(gnu
| > make)
| >    Well, what if someone uses a different tool to express the DAG
(dep.
| >    graph)?
| 
| with multiple stat()/clone()/exec(cc), i.e. `make' replacement, tools
| support,
| 
| > 2. gnu make is a somewhat dated program and can't do profound
dependency
| >    generation and analysis like some newer tools. All it can do is
| >    produce
| >    .d from .c with the -MM option using an idiom like this
| >      -include f1.d f2.d
| >       %.d: %.c
| >          $(CC) -MM <whatever>
| 
| AFAIK GNU make have nothing to do with any kind of decencies,

On the contrary. An attempt is made by gnu make to compute dependencies.
As I pointed out earlier, it doesn't do a very good job of it.
 
| >    But that's not good enough for 2 reasons.
| >    a) version rollback that causes timestamp rollback in time does
NOT
| >       trigger regeneration of dependencies (e.g. clearcase based
| >       builds).
| >    b) dependencies on order of things can't be expressed in gnu
make,
| >       for example -Iinc1 -Iinc2 causes different results from -Iinc2
-Iinc1
| >       if you have 2 different header files that have the same name
in
| >       both directories. Same goes for "ld -r -o mod.o f1.o f2.o" vs 
| >       "ld -r -o mod.o f2.o f1.o" if order mattered (which it doesn't
in
| >       this case).
| 
| see kbuild implementation to know how preparation done before GNU make
| is used,

How is this relevant to the point I was making about the deficiencies in
gnu
make? The most important thing to remember when designing something like
kbuild
is that "make", no matter what kind, is nothing but a way to describe a
DAG
(Directed Acyclic Graph). As soon as developers forget this all
important fact
you start seeing abominations, like Makefiles being used as a scripting
language
and top level Makefiles invoking lower level Makefiles.

| >    Bottom line - there exist free tools that are vastly superior to
gnu
| >    make, one such example is omake, and I don't want you to force me
to switch
| >    to inferior dependency analysis with gnu make.
| 
| (note: supported and well maintained free tools).

That's not for you to decide.
Just pass down all variables that may be relevant to my module builds 
and let me take it from there, for example
chdir $(M)
$(MYMAKE) CC="..." LD="..." AR="..." CFLAGS="..." MODFLAGS="..."
INCL="..."
          WHATHAVE_YOU="whatever"  modules

Currently I face the following situation -- I try to build 2 drivers
from the same Makefile
-----------
CWD := $(shell pwd)
obj-m := driver1.o driver2.o
driver1-y := d1/d2/d3/f1.o d1/d2/f2.o
driver2-y := d1/d5/file1.o d1/d6/file2.o
# ill conceived kbuild framework doesn't allow me to reduce granularity
# of EXTRA_FLAGS
$(addprefix $(CWD)/,d1/d2/d3/f1.o d1/d5/file1.o: EXTRA_CFLAGS :=
-DMASK=0x123
$(addprefix $(CWD)/,d1/d2/f2.o d1/d6/file2.o) : EXTRA_CFLAGS :=
-DMASK=0x456
# fine grained scope for EXTRA_CFLAGS (supported by gnu make) doesn't
work
----------
There are 2 problems here
1) kbuild is forcing me to declare EXTRA_CFLAGS in global scope and 
   I can't build my drivers properly because the MASKs are incompatible. 
2) assuming that modules are buildable, if I do "make clean" there is
leftover
   junk in all of these places d1/d2/d3 d1/d5 d1/d2 d1/d6.
   There is a danger associated with that junk (or state), dependency
   generation
   may be broken which it provably is in some cases (remember -Iinc_dir1
   -Iinc_dir2
   vs. -Iinc_dir2 -Iinc_dir1 example I gave earlier) and I can't rely on
   it.
   So then I need to be able to clean all, but the "clean:" target can't
   clean
   inexpensively in multiple directorie, i.e. must do recursive
   traversal to clean.

| > My suggestion how to solve this problem is the following.
| > Instead of
| > gnumake -C /lib/modules/`uname -r`/build M=`pwd` modules
| > it's better to be able to do 
| > gnumake -C /lib/modules/`uname -r`/build M=`pwd` MYMAKE=mymake
modules 
| > and then inside your gnu Makefile you'd call mymake like so
| >
| > chdir $(M)
| > mymake MODFLAGS="whatever modflags" INCFLAGS="whatever incflags"
modules
| > and pass on whatever flags are necessary.
| >
| > You can set MYMAKE to gmake if unspecified thus "MYMAKE ?= make"
| >
| > That would make the callback into the user's build environment clean
and
| > unbind it from gnu make.
| 
| I doubt this suggestion. I think, as GNU make is current good and
| supported stat()/clone()/exec(cc) tool, one must provide
| gnu-make-with-kbuild-tools independent configuration and dependency 
| building process. And having multiple-pluging for dep-build and
cc-build
| tools, it may be suitable for guys like kbuild developers, you and me.

See what happens to a person's thinking when he doesn't grasp the basics
of building software -- it gets cloudy and he can't articulate his
ideas.
No wonder kbuild users like myself face the problems that they do.
Here is a crash course in building software 101.
Start off defining the DAG (dep. graph), then choose a tool that can
express it, and extend the DAG by automatically making explicit some 
hidden (implicit) additional dependencies. The tool you pick may be 
stateless (gnu make for instance for the most part is stateless) or
capture 
select state of the build machine and incorporate it into the DAG.
A short example of a stateful build is where "make all DEBUG=false" does
nothing when repeated after a successful build but does a complete
rebuild
when invoked thus "make all DEBUG=true", because the developer chose to
include the variable $(DEBUG) in the DAG and the tool is able to express
this dependency (gnu make can't do that btw). In addition to env.
variables
it may also be possible to express dependencies on order and other
things
(but not in gnu make).

So make sure whoever discusses build issues you understand building
software 101 before jumping into discussions.
 
> > Any replies, critique -- cc me, as I am not on this list.
> 
> If you can't follow LKML yet, please find little-nice kbuild ML in the
> MAINTAINERS file. And IMHO, this (cc me) already must be in some kind of
> "how to ask questions in the smart way" or Newbie's Netiquette, as bed
> example of introduction of yourself.

No, you can't send me off to some little kbuild mailing list.
I've raised concerns that probably affects hundreds of module builders.
kbuild works well only in the simplest of build scenarios but doesn't
scale and that's a deficiency that should be urgently addressed.
The leadership of the linux kernel is going to have to make
a decision and possibly hire a competent contractor to fix these
problems.
Are you guys perfectionists or what?

Another item on my wish list is to see large chunks of the linux
kernel, including most device drivers, rewritten in a DSL (domain
specific
language). Why?
Because it's easier to reason about code correctness in a high level
language, it's also easy to reason if the translation of constructs in
this high level language to C/assembly chunks is correct.
But it's incredibly difficult to prove correctness in large gobs
of C code. I am not a prophet but I am fairly certain that in
10-15 years there would be a big push to rewrite a lot of kernel
code in a DSL. You might as well start thinking about it now.
Goodbye everyone.
-- 
  FN
  zzzz444@ml1.net

-- 
http://www.fastmail.fm - A fast, anti-spam email service.

