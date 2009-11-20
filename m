Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbZKTRAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbZKTRAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbZKTRAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:00:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46503 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbZKTRAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:00:53 -0500
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
       gcc <gcc@gcc.gnu.org>, Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1258694593.22249.1012.camel@gandalf.stny.rr.com>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>
	 <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org>
	 <20091119072040.GA23579@elte.hu>
	 <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>
	 <1258694593.22249.1012.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 20 Nov 2009 12:00:56 -0500
Message-Id: <1258736456.22249.1032.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Thomas and Linus,

I know Thomas did a patch to force the -mtune=generic, but just in case
gcc decides to do something crazy again, this patch will catch it.

Should we try to get this in now?

-- Steve

On Fri, 2009-11-20 at 00:23 -0500, Steven Rostedt wrote:
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


