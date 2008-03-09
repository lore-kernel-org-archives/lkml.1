Return-Path: <linux-kernel-owner+w=401wt.eu-S1754438AbYCIVDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbYCIVDy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 17:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYCIVDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 17:03:45 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:4189 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbYCIVDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 17:03:44 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, heukelum@fastmail.fm
Subject: Re: [PATCH] x86: Change x86 to use generic find_next_bit
References: <20080309200103.GA895@mailshack.com>
	<20080309201016.GA28454@elte.hu>
From: Andi Kleen <andi@firstfloor.org>
Date: 09 Mar 2008 22:03:42 +0100
In-Reply-To: <20080309201016.GA28454@elte.hu>
Message-ID: <87ve3vzk29.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Mar 2008 20:57:11.0470 (UTC) FILETIME=[2536A4E0:01C88228]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
> 
> the generic version in lib/find_next_bit.c is open-coded C which gcc can 
> optimize pretty nicely.
> 
> the hand-coded assembly versions in arch/x86/lib/bitops_32.c mostly use 
> the special x86 'bit search forward' (BSF) instruction - which i know 
> from the days when the scheduler relied on it has some non-trivial setup 

~14 cycles on K8 for memory, but if you stay in a register it is 8 cycles

> costs. So especially when there's _small_ bitmasks involved, it's more 
> expensive.

I had a patchkit some time ago to special case the max_bit <= 63 case
and always use directly inlined stream lined single instruction
assembler for that. There was still some issue and I dropped it then,
but doing something like that makes still sense. Even if the BSF 
is slightly slower than the open coded version just getting rid
of the CALL will make it a win and it could be also kept in a register
so you get the 8 cycle variant (for which I doubt you can do 
it faster open coded) 

The result would be that a standard for_each_cpu () in a NR_CPUS <= 64
kernel wouldn't have any unnecessary calls.

In general the problem of walking cpu masks is quite different
from seaching ext2 bitmaps, so they likely should be special cased
and optimized for each.

-Andi

