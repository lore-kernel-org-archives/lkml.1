Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911AbZKTFcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbZKTFcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 00:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbZKTFcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 00:32:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40561 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbZKTFca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 00:32:30 -0500
Subject: Re: [PATCH][GIT PULL][v2.6.32] tracing/x86: Add check to detect
 GCC messing with mcount prologue
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>, Andrew Haley <aph@redhat.com>,
       Richard Guenther <richard.guenther@gmail.com>, jakub@redhat.com,
       gcc <gcc@gcc.gnu.org>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <1258694593.22249.1012.camel@gandalf.stny.rr.com>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>
	 <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org>
	 <20091119072040.GA23579@elte.hu>
	 <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>
	 <1258694593.22249.1012.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 20 Nov 2009 00:32:34 -0500
Message-Id: <1258695154.22249.1014.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This touches the Makefile scripts. I forgot to CC kbuild and Sam.

-- Steve

On Fri, 2009-11-20 at 00:23 -0500, Steven Rostedt wrote:
> Ingo,
> 
> Not sure if this is too much for this late in the -rc game, but it finds
> the gcc bug at build time, and we don't need to disable function graph
> tracer for all i386 builds.
> 
> This is built on my last urgent repo pull request.
> 
> Please pull the latest tip/tracing/urgent-2 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/urgent-2
> 
> 
> Steven Rostedt (1):
>       tracing/x86: Add check to detect GCC messing with mcount prologue
> 
> ----
>  kernel/trace/Kconfig    |    1 -
>  scripts/Makefile.build  |   25 +++++++++++++++-
>  scripts/recordmcount.pl |   74 +++++++++++++++++++++++++++++++++++++++++++++--
>  3 files changed, 95 insertions(+), 5 deletions(-)
> ---------------------------
> commit c7715fb611c69ac4b7f722a891de08b206fb7686
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Thu Nov 19 23:41:02 2009 -0500
> 
>     tracing/x86: Add check to detect GCC messing with mcount prologue
>     
>     Latest versions of GCC create a funny prologue for some functions.
>     Instead of the typical:
>     
>     		push   %ebp
>     		mov    %esp,%ebp
>     		and    $0xffffffe0,%esp
>     		[...]
>     		call   mcount
>     
>     GCC may try to align the stack before setting up the frame pointer
>     register:
>     
>     		push   %edi
>     		lea    0x8(%esp),%edi
>     		and    $0xffffffe0,%esp
>     		pushl  -0x4(%edi)
>     		push   %ebp
>     		mov    %esp,%ebp
>     		[...]
>     		call   mcount
>     
>     This crazy code places a copy of the return address into the
>     frame pointer. The function graph tracer uses this pointer to
>     save and replace the return address of the calling function to jump
>     to the function graph tracer's return handler, which will put back
>     the return address. But instead instead of the typical return:
>     
>     		mov    %ebp,%esp
>     		pop    %ebp
>     		ret
>     
>     The return of the function performs:
>     
>     		lea    -0x8(%edi),%esp
>     		pop    %edi
>     		ret
>     
>     The function graph tracer return handler will not be called at the exit
>     of the function, but the parent function will call it. Because we missed
>     the return of the child function, the handler will replace the parent's
>     return address with that of the child. Obviously this will cause a crash
>     (Note, there is code to detect this case and safely panic the kernel).
>     
>     The kicker is that this happens to just a handful of functions.
>     And only with certain gcc options.
>     
>     Compiling with: 	-march=pentium-mmx
>     will cause the problem to appear. But if you were to change
>     pentium-mmx to i686 or add -mtune=generic, then the problem goes away.
>     
>     I first saw this problem when compiling with optimize for size.
>     But it seems that various other options may cause this issue to arise.
>     
>     Instead of completely disabling the function graph tracer for i386 builds
>     this patch adds a check to recordmcount.pl to make sure that all
>     functions that contain a call to mcount start with "push %ebp".
>     If not, it will fail the compile and print out the nasty warning:
>     
>       CC      kernel/time/timer_stats.o
>     
>     ********************************************************
>       Your version of GCC breaks the function graph tracer
>       Please disable CONFIG_FUNCTION_GRAPH_TRACER
>       Failed function was "timer_stats_update_stats"
>     ********************************************************
>     
>     The script recordmcount.pl is given a new parameter "do_check". If
>     this is negative, the script will only perform this check without
>     creating the mcount caller section. This will be executed for x86_32
>     when CONFIG_FUNCTION_GRAPH_TRACER is enabled and CONFIG_DYNAMIC_FTRACE
>     is not.
>     
>     If the arch is x86_32 and $do_check is greater than 1, it will perform
>     the check while processing the mcount callers. If $do_check is 0, then
>     no check will be performed. This is for non x86_32 archs and when
>     compiling without CONFIG_FUNCTION_GRAPH_TRACER enabled, even on x86_32.
>     
>     Reported-by: Thomas Gleixner <tglx@linutronix.de>
>     LKML-Reference: <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>
>     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index b416512..cd39064 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -143,7 +143,6 @@ config FUNCTION_GRAPH_TRACER
>  	bool "Kernel Function Graph Tracer"
>  	depends on HAVE_FUNCTION_GRAPH_TRACER
>  	depends on FUNCTION_TRACER
> -	depends on !X86_32 || !CC_OPTIMIZE_FOR_SIZE
>  	default y
>  	help
>  	  Enable the kernel to trace a function at both its return
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index 341b589..3b897f2 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -206,10 +206,33 @@ cmd_modversions =							\
>  endif
>  
>  ifdef CONFIG_FTRACE_MCOUNT_RECORD
> +
> + ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +  ifdef CONFIG_X86_32
> +   rm_do_check = 1
> +  else
> +   rm_do_check = 0
> +  endif
> + else
> +  rm_do_check = 0
> + endif
> +
>  cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
>  	"$(if $(CONFIG_64BIT),64,32)" \
>  	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" "$(MV)" \
> -	"$(if $(part-of-module),1,0)" "$(@)";
> +	"$(if $(part-of-module),1,0)" "$(rm_do_check)" "$(@)";
> +
> +else
> +
> + ifdef CONFIG_X86_32
> + ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +   cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
> +	"$(if $(CONFIG_64BIT),64,32)" \
> +	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" "$(MV)" \
> +	"$(if $(part-of-module),1,0)" "-1" "$(@)";
> + endif
> + endif
> +
>  endif
>  
>  define rule_cc_o_c
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index 090d300..164a9d5 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -99,14 +99,14 @@ $P =~ s@.*/@@g;
>  
>  my $V = '0.1';
>  
> -if ($#ARGV < 7) {
> -	print "usage: $P arch bits objdump objcopy cc ld nm rm mv is_module inputfile\n";
> +if ($#ARGV < 11) {
> +	print "usage: $P arch bits objdump objcopy cc ld nm rm mv is_module do_check inputfile\n";
>  	print "version: $V\n";
>  	exit(1);
>  }
>  
>  my ($arch, $bits, $objdump, $objcopy, $cc,
> -    $ld, $nm, $rm, $mv, $is_module, $inputfile) = @ARGV;
> +    $ld, $nm, $rm, $mv, $is_module, $do_check, $inputfile) = @ARGV;
>  
>  # This file refers to mcount and shouldn't be ftraced, so lets' ignore it
>  if ($inputfile eq "kernel/trace/ftrace.o") {
> @@ -129,6 +129,60 @@ $nm = "nm" if ((length $nm) == 0);
>  $rm = "rm" if ((length $rm) == 0);
>  $mv = "mv" if ((length $mv) == 0);
>  
> +# gcc can do stupid things with the stack pointer on x86_32.
> +# It may pass a copy of the return address to mcount, which will
> +# break the function graph tracer. If this happens then we need
> +# to flag it and break the build.
> +#
> +# For x86_32, the parameter do_check will be negative if we only
> +# want to perform the check, and positive if we should od the check.
> +# If function graph tracing is not enabled, do_check will be zero.
> +#
> +
> +my $check_next_line = 0;
> +my $line_failed = 0;
> +my $last_function;
> +
> +sub test_x86_32_prologue
> +{
> +    if ($check_next_line) {
> +	if (!/push\s*\%ebp/) {
> +	    $line_failed = 1;
> +	}
> +    }
> +
> +    if ($line_failed && /mcount/) {
> +	print STDERR "\n********************************************************\n";
> +	print STDERR "  Your version of GCC breaks the function graph tracer\n";
> +	print STDERR "  Please disable CONFIG_FUNCTION_GRAPH_TRACER\n";
> +	print STDERR "  Failed function was \"$last_function\"\n";
> +	print STDERR "********************************************************\n\n";
> +	exit -1;
> +    }
> +    $check_next_line = 0;
> +
> +    # check the first line after a function starts for
> +    #  push %ebp
> +    if (/^[0-9a-fA-F]+\s+<([a-zA-Z_].*)>:$/) {
> +	$last_function = $1;
> +	$check_next_line = 1;
> +	$line_failed = 0;
> +    }
> +}
> +
> +if ($do_check < 0) {
> +    # Only perform the check and quit
> +    open(IN, "$objdump -dr $inputfile|") || die "error running $objdump";
> +
> +    while (<IN>) {
> +	test_x86_32_prologue;
> +    }
> +    close (IN);
> +    exit 0;
> +}
> +
> +my $check = 0;
> +
>  #print STDERR "running: $P '$arch' '$objdump' '$objcopy' '$cc' '$ld' " .
>  #    "'$nm' '$rm' '$mv' '$inputfile'\n";
>  
> @@ -153,6 +207,12 @@ if ($arch eq "x86") {
>      }
>  }
>  
> +if ($arch eq "i386") {
> +    if ($do_check) {
> +	$check = 1;
> +    }
> +}
> +
>  #
>  # We base the defaults off of i386, the other archs may
>  # feel free to change them in the below if statements.
> @@ -381,6 +441,14 @@ my $text;
>  my $read_headers = 1;
>  
>  while (<IN>) {
> +
> +    # x86_32 may need to test the start of every function to see
> +    # if GCC did not mess up the mcount prologue. All functions must
> +    # start with push %ebp, otherwise it is broken.
> +    if ($check) {
> +	test_x86_32_prologue;
> +    }
> +
>      # is it a section?
>      if (/$section_regex/) {
>  	$read_headers = 0;
> 

