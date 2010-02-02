Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab0BBHLB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:11:01 -0500
Received: from smtp-out.google.com ([216.239.33.17]:18749 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab0BBHLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:11:00 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Dnj2TAe6m3WdPRkSsACE1AV1svaVsMjD1YPPurB1Dw6ya/vH1D5UbrwsuLtLM5M4Z
	+OaxWD4THLfMr4MaOZOBw==
Date: Mon, 1 Feb 2010 23:10:51 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andreas Mohr <andi@lisas.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Improve usability in case of init binary failure
In-Reply-To: <20091227150329.GA25711@rhlx01.hs-esslingen.de>
Message-ID: <alpine.DEB.2.00.1002012308480.22003@chino.kir.corp.google.com>
References: <20091116194015.GA13820@rhlx01.hs-esslingen.de> <20091116203545.GA2028@emergent.ellipticsemi.com> <20091117204015.GB5746@rhlx01.hs-esslingen.de> <20091227150329.GA25711@rhlx01.hs-esslingen.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Dec 2009, Andreas Mohr wrote:

> Well, took quite a while longer, partly due to broken Broadcom USB host
> (OpenWrt fix to be submitted) and non-working USB-audio on nicer platforms.
> 
> Took most of the comments into account (thanks!), improved some wording.
> 
> Patch against current git, compile- and runtime-tested,
> checkpatch.pl'd (with a single nice hierarchy warning resulting from mixing
> git diff output and manual /dev/null diffing).
> 
> Thanks!
> 

It looks like this patch got mangled when added to mmotm-2010-02-01-16-25 
in init-mainc-improve-usability-in-case-of-init-binary-failure.patch since 
it added init.txt to the root directory instead of Documentation, even 
though the patch below is correct.

> Signed-off-by: Andreas Mohr <andi@lisas.de>
> 
> diff --git a/init/main.c b/init/main.c
> index dac44a9..33748c6 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -836,7 +836,8 @@ static noinline int init_post(void)
>  	run_init_process("/bin/init");
>  	run_init_process("/bin/sh");
>  
> -	panic("No init found.  Try passing init= option to kernel.");
> +	panic("No init found.  Try passing init= option to kernel. "
> +	      "See Linux Documentation/init.txt for guidance.");
>  }
>  
>  static int __init kernel_init(void * unused)
> --- /dev/null	2009-12-27 16:25:29.521258205 +0100
> +++ Documentation/init.txt	2009-12-27 15:47:46.000000000 +0100
> @@ -0,0 +1,49 @@
> +Explaining the dreaded "No init found." boot hang message
> +=========================================================
> +
> +OK, so you've got this pretty unintuitive message (currently located
> +in init/main.c) and are wondering what the H*** went wrong.
> +Some high-level reasons for failure (listed roughly in order of execution)
> +to load the init binary are:
> +A) Unable to mount root FS
> +B) init binary doesn't exist on rootfs
> +C) broken console device
> +D) binary exists but dependencies not available
> +E) binary cannot be loaded
> +
> +Detailed explanations:
> +0) Set "debug" kernel parameter (in bootloader config file or CONFIG_CMDLINE)
> +   to get more detailed kernel messages.
> +A) make sure you have the correct root FS type
> +   (and root= kernel parameter points to the correct partition),
> +   required drivers such as storage hardware (such as SCSI or USB!)
> +   and filesystem (ext3, jffs2 etc.) are builtin (alternatively as modules,
> +   to be pre-loaded by an initrd)
> +C) Possibly a conflict in console= setup --> initial console unavailable.
> +   E.g. some serial consoles are unreliable due to serial IRQ issues (e.g.
> +   missing interrupt-based configuration).
> +   Try using a different console= device or e.g. netconsole= .
> +D) e.g. required library dependencies of the init binary such as
> +   /lib/ld-linux.so.2 missing or broken. Use readelf -d <INIT>|grep NEEDED
> +   to find out which libraries are required.
> +E) make sure the binary's architecture matches your hardware.
> +   E.g. i386 vs. x86_64 mismatch, or trying to load x86 on ARM hardware.
> +   In case you tried loading a non-binary file here (shell script?),
> +   you should make sure that the script specifies an interpreter in its shebang
> +   header line (#!/...) that is fully working (including its library
> +   dependencies). And before tackling scripts, better first test a simple
> +   non-script binary such as /bin/sh and confirm its successful execution.
> +   To find out more, add code to init/main.c to display kernel_execve()s
> +   return values.
> +
> +Please extend this explanation whenever you find new failure causes
> +(after all loading the init binary is a CRITICAL and hard transition step
> +which needs to be made as painless as possible), then submit patch to LKML.
> +Further TODOs:
> +- Implement the various run_init_process() invocations via a struct array
> +  which can then store the kernel_execve() result value and on failure
> +  log it all by iterating over _all_ results (very important usability fix).
> +- try to make the implementation itself more helpful in general,
> +  e.g. by providing additional error messages at affected places.
> +
> +Andreas Mohr <andi at lisas period de>
