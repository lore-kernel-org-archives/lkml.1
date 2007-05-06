Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbXEFUWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbXEFUWR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 16:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755270AbXEFUWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 16:22:17 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:44127 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755269AbXEFUWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 16:22:17 -0400
Date: Sun, 6 May 2007 22:23:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm1
Message-ID: <20070506202310.GA10396@uranus.ravnborg.org>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org> <463D11A8.3090708@simon.arlott.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463D11A8.3090708@simon.arlott.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2007 at 12:22:16AM +0100, Simon Arlott wrote:
> On 05/05/07 09:49, Andrew Morton wrote:
> >ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/
> 
> WARNING: init/built-in.o - Section mismatch: reference to .init.text: from 
> .text between 'rest_init' (at offset 0x9) and 'run_init_process'

On i386 binutils fails to pick up reference to kernel_init
in the:
   kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
line from rest_init in init/main.c

Wy binutils throw away the info about the kernel_init symbol
is beyond me.
A workaround is to simply declare kernel_init non-static.



> WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference to 
> .init.text: from .data between 'thermal_throttle_cpu_notifier' (at offset 
> 0x21cc) and 'mce_work'
This is because:
static struct notifier_block thermal_throttle_cpu_notifier =
{
	.notifier_call = thermal_throttle_cpu_callback,
};

thermal_throttle_cpu_notifier is not marked __initdata
but thermal_throttle_cpu_callback is __cpuinit.
So this is a bug.
I do not see it with my config (a slightly modified defconfig)
so I cannot test it.
Could you try to change the line to:
static struct notifier_block __cpuinitdata thermal_throttle_cpu_notifier =
And check if this makes the warning go away.



> WARNING: kernel/built-in.o - Section mismatch: reference to .init.text: 
> from .text between 'kthreadd' (at offset 0x181d8) and 'init_waitqueue_head'

We have kthread that calls kthreadd_setup - the latter marked __init.
The only user of kthreadd is init/main.c:rest_init() but I do not know
enough about the kernel boot process to say if it is OK to mark
kthreadd __init (that would be my fist proposal).

Andrew or anyone?

	Sam
