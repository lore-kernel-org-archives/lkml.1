Return-Path: <linux-kernel-owner+w=401wt.eu-S1758095AbYLPUG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbYLPUG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbYLPUGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:06:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45407 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbYLPUGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:06:47 -0500
Date: Tue, 16 Dec 2008 15:06:45 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Sam Ravnborg <sam@ravnborg.org>
cc: linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       zippel@linux-m68k.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Better way to force a rebuild
In-Reply-To: <alpine.DEB.1.10.0812141204480.20467@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0812161502530.25356@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0812101443550.11805@gandalf.stny.rr.com> <20081210200242.GA15692@uranus.ravnborg.org> <20081210212821.GA18348@uranus.ravnborg.org> <20081213231654.GA32446@uranus.ravnborg.org>
 <alpine.DEB.1.10.0812141204480.20467@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 14 Dec 2008, Steven Rostedt wrote:
> 
> On Sun, 14 Dec 2008, Sam Ravnborg wrote:
> 
> > On Wed, Dec 10, 2008 at 10:28:21PM +0100, Sam Ravnborg wrote:
> > > 
> > > I made the following quick hack.
> > > I think it should do the trick.
> > > 
> > > 	Sam
> > > 
> > > diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> > > index 468fbc9..8b5bf43 100644
> > > --- a/scripts/Makefile.build
> > > +++ b/scripts/Makefile.build
> > > @@ -215,7 +215,8 @@ define rule_cc_o_c
> > >  	$(call echo-cmd,cc_o_c) $(cmd_cc_o_c);				  \
> > >  	$(cmd_modversions)						  \
> > >  	$(cmd_record_mcount)						  \
> > > -	scripts/basic/fixdep $(depfile) $@ '$(call make-cmd,cc_o_c)' >    \
> > > +	scripts/basic/fixdep $(depfile) $@                                \
> > > +	'$(call make-cmd,cc_o_c) $(call make-cmd,record_mcount)' >        \
> > >  	                                              $(dot-target).tmp;  \
> > >  	rm -f $(depfile);						  \
> > >  	mv -f $(dot-target).tmp $(dot-target).cmd
> > 
> > Hi Steven.
> > 
> > Did you try the above?
> > If it works I will add it to kbuild-next.git
> 
> I started to but got distracted :-/   I'll retry it on Monday.

Hi Sam,

Sorry for taking so long to get back to you, but my hard drive for my 
laptop is on the fritz, and I'm busy making sure everything is backed up.

I tried this patch and it does not seem to do what I want :-(

You can test it too, just compile the kernel with CONFIG_FUNCTION_TRACER
and CONFIG_DYNAMIC_FTRACE enabled, and then compile again with just 
disabling CONFIG_DYNAMIC_FTRACE (keep CONFIG_FUNCTION_TRACER enabled). If 
the entire kernel does not compile again, then it did not work.

-- Steve

Oh, you need to add this patch first:

---
 include/linux/kernel.h |    5 -----
 1 file changed, 5 deletions(-)

Index: linux-trace.git/include/linux/kernel.h
===================================================================
--- linux-trace.git.orig/include/linux/kernel.h	2008-11-20 14:36:55.000000000 -0500
+++ linux-trace.git/include/linux/kernel.h	2008-12-10 16:54:16.000000000 -0500
@@ -535,9 +535,4 @@ struct sysinfo {
 #define NUMA_BUILD 0
 #endif
 
-/* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
-#ifdef CONFIG_FTRACE_MCOUNT_RECORD
-# define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
-#endif
-
 #endif
