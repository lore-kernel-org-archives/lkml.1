Return-Path: <linux-kernel-owner+w=401wt.eu-S1754376AbYJ2TEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbYJ2TEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 15:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbYJ2TD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 15:03:56 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:46444 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbYJ2TDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 15:03:55 -0400
Date: Wed, 29 Oct 2008 20:00:45 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 01/11] ftrace: handle generic arch calls
Message-ID: <20081029190045.GC22105@uranus.ravnborg.org>
References: <20081022184313.179487464@goodmis.org> <20081022185135.618026303@goodmis.org> <alpine.DEB.1.10.0810271337370.8006@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810271337370.8006@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 01:41:41PM -0400, Steven Rostedt wrote:
> 
> [
>   Resending patch.
> 
>   Sam, can you Ack this?
> 
>   -- Steve
> ]
> 
> From: Steven Rostedt <srostedt@redhat.com>
> Subject: ftrace: handle generic arch calls
> 
> The recordmcount script requires that the actual arch is passed in.
> This works well when ARCH=i386 or ARCH=x86_64 but does not handle the
> case of ARCH=x86.
> 
> This patch adds a parameter to the function to pass in the number of
> bits of the architecture. So that it can determine if x86 should be
> run for x86_64 or i386 archs.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  scripts/Makefile.build  |   10 ++++++++--
>  scripts/recordmcount.pl |   11 ++++++++++-
>  2 files changed, 18 insertions(+), 3 deletions(-)
> 
> Index: linux-compile.git/scripts/Makefile.build
> ===================================================================
> --- linux-compile.git.orig/scripts/Makefile.build	2008-10-22 15:09:04.000000000 -0400
> +++ linux-compile.git/scripts/Makefile.build	2008-10-22 15:09:07.000000000 -0400
> @@ -198,10 +198,16 @@ cmd_modversions =							\
>  	fi;
>  endif
>  
> +ifdef CONFIG_64BIT
> +arch_bits = 64
> +else
> +arch_bits = 32
> +endif
> +
>  ifdef CONFIG_FTRACE_MCOUNT_RECORD
>  cmd_record_mcount = perl $(srctree)/scripts/recordmcount.pl \
> -	"$(ARCH)" "$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" \
> -	"$(MV)" "$(@)";
> +	"$(ARCH)" "$(arch_bits)" "$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" \
> +	"$(NM)" "$(RM)" "$(MV)" "$(@)";
>  endif

A simple $(if $(CONFIG_64BIT),64,32) in the command would be more dense.

>  
>  define rule_cc_o_c
> Index: linux-compile.git/scripts/recordmcount.pl
> ===================================================================
> --- linux-compile.git.orig/scripts/recordmcount.pl	2008-10-22 15:09:04.000000000 -0400
> +++ linux-compile.git/scripts/recordmcount.pl	2008-10-22 15:09:45.000000000 -0400
> @@ -106,7 +106,8 @@ if ($#ARGV < 6) {
>  	exit(1);
>  }
>  
> -my ($arch, $objdump, $objcopy, $cc, $ld, $nm, $rm, $mv, $inputfile) = @ARGV;
> +my ($arch, $bits, $objdump, $objcopy, $cc,
> +    $ld, $nm, $rm, $mv, $inputfile) = @ARGV;
>  
>  $objdump = "objdump" if ((length $objdump) == 0);
>  $objcopy = "objcopy" if ((length $objcopy) == 0);
> @@ -129,6 +130,14 @@ my $function_regex;	# Find the name of a
>  			#    (return offset and func name)
>  my $mcount_regex;	# Find the call site to mcount (return offset)
>  
> +if ($arch eq "x86") {
> +    if ($bits == 64) {
> +	$arch = "x86_64";
> +    } else {
> +	$arch = "i386";
> +    }
> +}
> +
>  if ($arch eq "x86_64") {
>      $section_regex = "Disassembly of section";
>      $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
> 

This looks strange to my eyes.
Why not do the more obvious:
if ($arch eq "x86" && $bits == 64) {

The change above is like trying to stick to the old i386/x86_64
notation.

	Sam

