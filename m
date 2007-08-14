Return-Path: <linux-kernel-owner+w=401wt.eu-S933549AbXHNTsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549AbXHNTsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 15:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486AbXHNTsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 15:48:00 -0400
Received: from ns.suse.de ([195.135.220.2]:56146 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbXHNTr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 15:47:59 -0400
To: cra@WPI.EDU
Cc: wdc@mit.edu, linux-kernel@vger.kernel.org
Subject: Re: vm86.c audit_syscall_exit() call trashes registers
References: <20070814183119.GC17694@angus.ind.WPI.EDU>
From: Andi Kleen <andi@firstfloor.org>
Date: 14 Aug 2007 22:42:02 +0200
In-Reply-To: <20070814183119.GC17694@angus.ind.WPI.EDU>
Message-ID: <p73r6m5n90l.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Anderson <cra@WPI.EDU> writes:
> 
> If I'm reading correctly, it appears that the code above trashes the 
> %fs and %gs registers, or otherwise doesn't leave them at zero before 
> returning from the system call as the old code did.  Is this a correct 
> analysis? 

The kernel runs with defined fs -- saved and set at system call entry/exit --
and shouldn't touch gs (except on a context switch, but then it should
be set back when you get scheduled again)

It's in theory possible that something went wrong with the gs saving
for the vm86 path, but this changed long 2.6.16. But I assume
when you just remove the call in 2.6.16 it already works? If yes
it cannot be that (2.6.16 didn't use either fs or gs in the kernel)

> How should this be fixed?

The problem first needs to be fully understood. Do you have more 
details on the corruption?

One suspicious thing is that the audit code does mutex_lock(&tty_mutex)
and could sleep there. It's a long shot, but does the problem go
away when you comment that out? [such a patch is incorrect in theory,
but should be unlikely enough to crash for a quick test]

But actually sleeping should be ok here and a preemptible kernel could do
it anyways.

-Andi
