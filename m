Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbYJ2TOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbYJ2TOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 15:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbYJ2TOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 15:14:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63139 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbYJ2TOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 15:14:32 -0400
Date: Wed, 29 Oct 2008 15:14:28 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Sam Ravnborg <sam@ravnborg.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 01/11] ftrace: handle generic arch calls
In-Reply-To: <20081029190045.GC22105@uranus.ravnborg.org>
Message-ID: <alpine.DEB.1.10.0810291511340.13214@gandalf.stny.rr.com>
References: <20081022184313.179487464@goodmis.org> <20081022185135.618026303@goodmis.org> <alpine.DEB.1.10.0810271337370.8006@gandalf.stny.rr.com> <20081029190045.GC22105@uranus.ravnborg.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 29 Oct 2008, Sam Ravnborg wrote:

> On Mon, Oct 27, 2008 at 01:41:41PM -0400, Steven Rostedt wrote:
> > 
> > [
> >   Resending patch.
> > 
> >   Sam, can you Ack this?
> > 
> >   -- Steve
> > ]
> > 
> > From: Steven Rostedt <srostedt@redhat.com>
> > Subject: ftrace: handle generic arch calls
> > 
> > The recordmcount script requires that the actual arch is passed in.
> > This works well when ARCH=i386 or ARCH=x86_64 but does not handle the
> > case of ARCH=x86.
> > 
> > This patch adds a parameter to the function to pass in the number of
> > bits of the architecture. So that it can determine if x86 should be
> > run for x86_64 or i386 archs.
> > 
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> > ---
> >  scripts/Makefile.build  |   10 ++++++++--
> >  scripts/recordmcount.pl |   11 ++++++++++-
> >  2 files changed, 18 insertions(+), 3 deletions(-)
> > 
> > Index: linux-compile.git/scripts/Makefile.build
> > ===================================================================
> > --- linux-compile.git.orig/scripts/Makefile.build	2008-10-22 15:09:04.000000000 -0400
> > +++ linux-compile.git/scripts/Makefile.build	2008-10-22 15:09:07.000000000 -0400
> > @@ -198,10 +198,16 @@ cmd_modversions =							\
> >  	fi;
> >  endif
> >  
> > +ifdef CONFIG_64BIT
> > +arch_bits = 64
> > +else
> > +arch_bits = 32
> > +endif
> > +
> >  ifdef CONFIG_FTRACE_MCOUNT_RECORD
> >  cmd_record_mcount = perl $(srctree)/scripts/recordmcount.pl \
> > -	"$(ARCH)" "$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" \
> > -	"$(MV)" "$(@)";
> > +	"$(ARCH)" "$(arch_bits)" "$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" \
> > +	"$(NM)" "$(RM)" "$(MV)" "$(@)";
> >  endif
> 
> A simple $(if $(CONFIG_64BIT),64,32) in the command would be more dense.

OK, will fix.

> 
> >  
> >  define rule_cc_o_c
> > Index: linux-compile.git/scripts/recordmcount.pl
> > ===================================================================
> > --- linux-compile.git.orig/scripts/recordmcount.pl	2008-10-22 15:09:04.000000000 -0400
> > +++ linux-compile.git/scripts/recordmcount.pl	2008-10-22 15:09:45.000000000 -0400
> > @@ -106,7 +106,8 @@ if ($#ARGV < 6) {
> >  	exit(1);
> >  }
> >  
> > -my ($arch, $objdump, $objcopy, $cc, $ld, $nm, $rm, $mv, $inputfile) = @ARGV;
> > +my ($arch, $bits, $objdump, $objcopy, $cc,
> > +    $ld, $nm, $rm, $mv, $inputfile) = @ARGV;
> >  
> >  $objdump = "objdump" if ((length $objdump) == 0);
> >  $objcopy = "objcopy" if ((length $objcopy) == 0);
> > @@ -129,6 +130,14 @@ my $function_regex;	# Find the name of a
> >  			#    (return offset and func name)
> >  my $mcount_regex;	# Find the call site to mcount (return offset)
> >  
> > +if ($arch eq "x86") {
> > +    if ($bits == 64) {
> > +	$arch = "x86_64";
> > +    } else {
> > +	$arch = "i386";
> > +    }
> > +}
> > +
> >  if ($arch eq "x86_64") {
> >      $section_regex = "Disassembly of section";
> >      $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
> > 
> 
> This looks strange to my eyes.
> Why not do the more obvious:
> if ($arch eq "x86" && $bits == 64) {
> 
> The change above is like trying to stick to the old i386/x86_64
> notation.

Heh, you're right. This is from writing an update without wanting to 
modify the original code too much. But it makes the end result ugly.

I'll create another patch to go on top of this one. We needed this one in 
because without it, it broke "make ARCH=x86"

Thanks,

-- Steve
