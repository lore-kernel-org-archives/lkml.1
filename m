Return-Path: <linux-kernel-owner+w=401wt.eu-S1756378AbYC1Lds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbYC1Lds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 07:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbYC1Ldh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 07:33:37 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:33802 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbYC1Ldg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 07:33:36 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: David Miller <davem@davemloft.net>
Subject: Re: Linux 2.6.25-rc7 sparc64 loops forever on cat /proc/<pid>/pagemap
Date: Fri, 28 Mar 2008 12:33:32 +0100
User-Agent: KMail/1.9.7
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
References: <alpine.LFD.1.00.0803251856450.2775@woody.linux-foundation.org> <200803261302.46313.m.kozlowski@tuxland.pl> <20080326.173527.193701097.davem@davemloft.net>
In-Reply-To: <20080326.173527.193701097.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803281233.32917.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,

> > cat /proc/<pid>/pagemap 
> > 
> > and 
> > 
> > cat /proc/<pid>/task/<pid>/pagemap
> > 
> > eats up to 100% of CPU while looping forever somewhere. On the other
> > hand on my old x86 the same commands take well below 1s so I
> > guess that is the expected behaviour.
> 
> The patch below will speed this up for 32-bit processes but for 64-bit
> ones it's still going to take a long time.
> 
> Cat'ing this file writes a 64-bit value for every possible page in the
> task's address space, which for 64-bit is an enormous number of
> entries.
> 
> This is not how this file is supposed to be used.  Programs are
> supposed to inspect /proc/${PID}/maps, and use those ranges to lseek()
> around the pagemap file and fish out the values they need.

I see. Sorry for the noise then 8-) I've got a couple of scripts for testing
/proc and /sys and I just noticed that some of processes started by them
would run for a couple hours eating 100% CPU which doesn't happen on other
arch'es I have around - hence my report. Thanks for clarification.

> This expensive operation is quite harmless, the process can still be
> killed, it is not unstoppable.

That's true.
 
> commit c101b088ba0ed16d7109b2f3c2d16798d162a535
> Author: David S. Miller <davem@davemloft.net>
> Date:   Wed Mar 26 17:32:33 2008 -0700
> 
>     [SPARC64]: Define TASK_SIZE_OF()
>     
>     This make "cat /proc/${PID}/pagemap" more efficient for
>     32-bit tasks.

This patch certainly helps in my case. Tested here:

sparc64 # time cat /proc/1/pagemap > /dev/null
real    0m0.046s
user    0m0.000s
sys     0m0.047s

Thanks,

	Mariusz
