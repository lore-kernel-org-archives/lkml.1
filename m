Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbZFBUvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbZFBUvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 16:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbZFBUvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 16:51:40 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:35148 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbZFBUvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 16:51:39 -0400
Message-ID: <4A259155.3000909@oracle.com>
Date: Tue, 02 Jun 2009 13:53:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Reza Mostafid <m.r.mostafid@gmail.com>
CC: linux-kernel@vger.kernel.org, x86 maintainers <x86@kernel.org>
Subject: Re: kernel panic despite enabling math-emulation
References: <47a46110905302240w36d78bcbne506210dd7e9c1d2@mail.gmail.com>
In-Reply-To: <47a46110905302240w36d78bcbne506210dd7e9c1d2@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt003.oracle.com [141.146.116.12]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4A25909A.0014:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reza Mostafid wrote:
> I am trying to build a stripped down v2.6.* kernel to run on a single
> chip 386 processor.
> As I understand it, the math emulation library must be enabled (
> compiled into the kernel )
> to cater for the absence of a proper HW FPU.
> 
> I am doing the builds on a more modern x86 desktop machine running Fedora 8
> ( based on 2.6.23.1 kernel ) using the source from Fedora 8 ( i.e.
> with the F8 patches
>   applied against a 2.6.23.1 kernel )
> 
> As a first step, after building the kernel with
> 'CONFIG_MATH_EMULATION=y' I tried to test
> this feature on my build machine ( which does have an FPU ), by
> supplying the 'no387'
> boot parameter in order to simulate a non-existing FPU.
> 
> Running the math-emu enabled kernel in this way causes a kernel panic
> which happens before
> spawning 'init' and early-user space initialization.
> 
> I have observed this condition with several 2.6.* kernel versions and
> several Intel/AMD boxes.
> 
> Using the 'earlyprintk=vga' bootparameter and some printk statements
> sprinkled in the
> appropriate corners of the code ( i.e. '__init' function 'no387()' in
> bug.c ) I was able to
> observe that in all three cases the 'no387()' code snippet executes
> its stuff without hick ups
> when the 'no388' boot parameter is processed
> 
>  37 static int __init no_387(char *s)
>  38 {
>  39         boot_cpu_data.hard_math = 0;
>  40         write_cr0(0xE | read_cr0());
>  41         return 1;
>  42 }
>  43
>  44 __setup("no387", no_387);
> 
> The kernel freeze happens as a result of a panic in 'fpu_entry.c' (
> here I have reproduced code
> and line no.s from the file as it exists in v2.6.23.1 under
> 'arch/i386/math-emu' )
> 
> 179   else if ( FPU_CS == __KERNEL_CS )
> 180     {
> 181       printk("math_emulate: %04x:%08lx\n",FPU_CS,FPU_EIP);
> 182       panic("Math emulation needed in kernel");
> 183     }
> 184   else
> 
> In all cases the following lines are the last outputs to the console:
> 
>   math_emulate: <some FPU_CS value>:<some FPU_EIP value>
>   Kernel panic-not syncing: Math emulation needed in kernel
> 
> So it appears that even with math emulation enabled the logic of the
> code in 'fpu_entry.c' takes
> the kernel into the above 'else', i.e. the kernel thinks that there is
> no 'math emulation'.
> 
> Searching the web I was able to find references to this problem in
> several threads but no apparent
> solution to it.
> 
> Math-emulation albeit not a widely used feature, should have been
> around long enough for someone to
> have stumbled upon such an obvious problem.
> 
> Q1) Am I overlooking anything?
> 
>  or
> 
> Q2) Is this a problem in the code?
> 
>  and finally
> 
> Q3) Any suggestions for how I could get a 2.6 kernel to actually run
> with the math-emu?
> 
> 
> 
> Regards
> 
> 
> Reza Mostafid
> 
> 
> 
> ==========================================================================================================
> 
> Here is a reproduction of the steps I took:
> 
> 
> i)   I downloaded the source rpms for the Fedora distro I am running (
> Fedora Core 8 which runs
>      a modified version of the 2.6.23.1 kernel ).
> 
> ii)  I compiled the Fedora kernel version thus obtained ( using the
> supplied distro .config ) and
>      it boots fine
> 
> iii) I then change a single parameter of the original configuration,
> i.e. enable math-emulation and
>      I observed the problem ( kernel panics with the 'no387' param
> supplied )
> 
> iv)  I then reproduced the same problem booting a 'kernel.org' vanilla
> 2.6.23.1 kernel with the same
>      configuration and observed the same problem.
> 
> v)   Finally several different versions of the 'kernel.org' vanilla
> source were compiled with the same
>      configuration ( the FC8 distro '.config' with just the 'math-emu'
> enabled ) on three different PCs.
>      Each time the same problem: Each math-emu enabled kernel boots
> fine, until you supply the 'no387'
>      option, in which case all of them hang at the same place.
> 
> 
> Configuration used as base:    That of the Fedora 8 distro
> 
> Parameter changed:             CONFIG_MATH_EMULATION=y
> 
> Kernels tested:
> 
> 2.6.23.1 source rpm for Fedora 8
> 2.6.23.1 'vanilla' from 'kernel.org'
> 2.6.11.12 'vanilla' from 'kernel.org'
> 2.6.12.6  'vanilla' from 'kernel.org'
> 2.6.28.8  'vanilla' from 'kernel.org'
> 
> CPUs/machines problem was observed on:
> 
> Intel Celeron 331 ( Netburst type P4 )
> AMD Semperon
> AMD Athlon


I can easily reproduce this on a Pentium M running 2.6.30-rc7,
although it's a bit difficult to get a backtrace of it.

-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
