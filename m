Return-Path: <linux-kernel-owner+w=401wt.eu-S938070AbXGUAb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938070AbXGUAb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 20:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbXGUAbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 20:31:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65496 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbXGUAbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 20:31:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
Date: Sat, 21 Jul 2007 01:55:41 +0200
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <rostedt@goodmis.org>
References: <1184970779.4012.38.camel@chaos>
In-Reply-To: <1184970779.4012.38.camel@chaos>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707210155.42814.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18x2GVpBLuNXw7Yj6CNLfAuaWY1Y8fofpsRECS
 oHgp6jELVZcU57+u38N+jkjQ4X3nLiQwOul60wyxsaClFCWW0F
 kwmKdAoTcSzqIgN6ojv9A==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 July 2007, Thomas Gleixner wrote:
> The topic of sharing more x86 code has been discussed on LKML a number 
> of times. Various approaches were discussed and we decided to advance 
> the discussion by implementing a full solution that brings the 
> transition to a shared tree to completion.

Great stuff. I've worked on doing the same for s390 and powerpc
in the past, and really think it's the right thing to do. I've
even started my own x86 merge two or three times in the past
but never got very far because of the quickly moving source.

> In this initial implementation the old arch/i386 and arch/x86_64 trees 
> are removed _immediately_, in the same commit, and all future x86 
> development goes on in the new, shared tree. So the transition right now 
> is one atomic operation.
> 
> As a next step we plan to generate a gradual, fully bisectable, fully
> working switchover from the current code to the fully populated
> arch/x86 tree. It will result in about 1000-2000 commits. We are
> releasing our current solution because it 100% represents the finally
> resulting arch/x86 source tree already, and we first wanted to make
> sure that the new architecture layout works fine and folks are happy
> before we go and do the (even more complex) fine-grained work.

I don't think it's really good to do it this way, or maybe I'm still
misunderstanding where you're going. If you really want to end
up with the exact set of files that you have your tree now, I see
absolutely zero point in making it bisectable. On the contrary,
there is nothing particularly complicated in it, so once it has
seen some amount of testing it can better get merged in one
big changeset. I'm just not convinced that it actully is what
we want to end up with.

In my experience, it's very helpful to have a single set of header
files, and merging the two versions of one header usually exposes
bugs that have been fixed in only one of the two, so you get
to fix actual bugs in the process.

In the s390 merge, I also started out in an attempt to guarantee
unchanged object files, much like what you describe. However, it
turned out that fixing it in the process is actually easier.
Either way, 'diff -D __x86_64__' is a great tool for a start, you
should try it out to see how easy it is to merge a lot of files.

To put it into perspective, I think the s390 merge was a lot easier
than the x86 merge, because there is only a very limited set of
hardware configurations for s390 compared to others. We ended up
doing the full merge with three people within less than a week
and no separate files at all.

OTOH, the powerpc merge is now going into its third year, mostly
because it was started with the intention to remove all cruft
in the process and to only allow sane code into the new architecture.

The steps that I'd suggest instead are:

* merge all exported header files of the two architectures. This
  alone is a worthy goal, because it allows us to get rid of
  the ugly code for deciding which version to use in installed
  headers and elsewhere.

* Merge the remaining header files, to end up with a single
  include/asm-x86 directory.

* Come up with a model that integrates the machine type selection
  of i386 with the way we build things on x86_64. One way would
  be to make X86_64 another platform next to X86_PC, X86_VOYAGER
  and the others.

* Create an arch/x86/Kconfig that handles the new common
  configuration

* Create an arch/x86/Makefile that descends into ../i386/* and
  ../x86_64/* instead of its subdirectories.

* Merge the arch/x86/* subdirectories, one at a time, starting with
  the low-hanging fruit like oprofile or pci, and do the hard
  ones like mm and kernel last.

Unfortunately, I don't think I'll spend much time on this, so I
don't get to decide on it, but you asked for feedback ;-)

	Arnd <><
