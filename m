Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbXKFHK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbXKFHK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 02:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbXKFHKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 02:10:49 -0500
Received: from quark.didntduck.org ([69.55.226.66]:36516 "EHLO
	quark.didntduck.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659AbXKFHKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 02:10:48 -0500
Message-ID: <47301363.9030303@didntduck.org>
Date: Tue, 06 Nov 2007 02:10:27 -0500
From: Brian Gerst <bgerst@didntduck.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/10] x86: arch/x86/Kconfig.cpu unification
References: <11941338801315-git-send-email-sam@ravnborg.org> <11941338804007-git-send-email-sam@ravnborg.org> <11941338801910-git-send-email-sam@ravnborg.org> <472FBB13.9070608@didntduck.org> <20071106024630.GA900@uranus.ravnborg.org> <20071106025253.GF3444@stusta.de>
In-Reply-To: <20071106025253.GF3444@stusta.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Tue, Nov 06, 2007 at 03:46:30AM +0100, Sam Ravnborg wrote:
>> On Mon, Nov 05, 2007 at 07:53:39PM -0500, Brian Gerst wrote:
>>> Sam Ravnborg wrote:
>>>> Move all CPU definitions to Kconfig.cpu
>>> This patch causes build failure on x86_64:
>>>
>>> lib/rwsem.c: In function ‘__init_rwsem’:
>>> lib/rwsem.c:24: error: ‘struct rw_semaphore’ has no member named ‘count’
>>> lib/rwsem.c:24: error: ‘RWSEM_UNLOCKED_VALUE’ undeclared (first use in
>>> this function)
>>> lib/rwsem.c:24: error: (Each undeclared identifier is reported only once
>>> lib/rwsem.c:24: error: for each function it appears in.)
>>> lib/rwsem.c: In function ‘__rwsem_do_wake’:
>>> lib/rwsem.c:64: error: implicit declaration of function
>>> ‘rwsem_atomic_update’
>>> lib/rwsem.c:64: error: ‘RWSEM_ACTIVE_BIAS’ undeclared (first use in this
>>> function)
>>> lib/rwsem.c:66: error: ‘RWSEM_ACTIVE_MASK’ undeclared (first use in this
>>> function)
>>> lib/rwsem.c:115: error: ‘RWSEM_WAITING_BIAS’ undeclared (first use in
>>> this function)
>>> lib/rwsem.c:120: error: implicit declaration of function ‘rwsem_atomic_add’
>>> lib/rwsem.c: In function ‘rwsem_down_failed_common’:
>>> lib/rwsem.c:169: error: ‘RWSEM_ACTIVE_MASK’ undeclared (first use in
>>> this function)
>>> lib/rwsem.c: In function ‘rwsem_down_read_failed’:
>>> lib/rwsem.c:197: error: ‘RWSEM_WAITING_BIAS’ undeclared (first use in
>>> this function)
>>> lib/rwsem.c:197: error: ‘RWSEM_ACTIVE_BIAS’ undeclared (first use in
>>> this function)
>>> lib/rwsem.c: In function ‘rwsem_down_write_failed’:
>>> lib/rwsem.c:210: error: ‘RWSEM_ACTIVE_BIAS’ undeclared (first use in
>>> this function)
>>>
>>> git bisect gives:
>>> 55432d383871d127685d78f94e0ad60307dcc0e9 is first bad commit
>>> commit 55432d383871d127685d78f94e0ad60307dcc0e9
>>> Author: Sam Ravnborg <sam@ravnborg.org>
>>> Date:   Thu Nov 1 21:54:39 2007 +0100
>>>
>>>     x86: arch/x86/Kconfig.cpu unification
>> Seems that a default value fail to change value when we shift
>> from 32 to 64 bit. I have it reproduced here.
>> Will look at it tonight.
> 
> The problem is that you source arch/x86/Kconfig.cpu from 
> arch/x86/Kconfig.x86_64 but didn't give RWSEM_XCHGADD_ALGORITHM 
> the required dependency on X86_32.
> 
>> 	Sam
> 
> cu
> Adrian
> 

The quick fix is to move the RWSEM_XCHGADD_ALGORITHM and
RWSEM_XCHGADD_ALGORITHM defines from Kconfig.cpu to Kconfig.i386.

Looking at this closer, the 64-bit code has been using the generic
spinlock-based implementation, while the 32-bit code uses an optimized
version on all but true 386 cpus.  The 64-bit code should be adapted to
use the optimized version at some point.
