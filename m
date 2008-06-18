Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbYFRQv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbYFRQv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 12:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbYFRQvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 12:51:18 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:44589 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbYFRQvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 12:51:18 -0400
Date: Wed, 18 Jun 2008 12:49:42 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Renzo Davoli <renzo@cs.unibo.it>
Cc: LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 0/1] ptrace_vm: let us simplify the code for ptrace and
	add useful features for VM
Message-ID: <20080618164942.GC8225@c2.user-mode-linux.org>
References: <20080616075804.GA6950@cs.unibo.it> <20080617162511.GA7223@c2.user-mode-linux.org> <20080617190831.GC32418@cs.unibo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080617190831.GC32418@cs.unibo.it>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2008 at 09:08:31PM +0200, Renzo Davoli wrote:
> 0 -> do the syscall and notify after it

To be more precise - 
	do the call notification, do the syscall, and do the return notification
> PTRACE_VM_SKIPEXIT -> do the syscall and do not notify after it
	don't do the return notification
> PTRACE_VM_SKIPCALL -> skip everything.
	don't do the syscall or return notification

Looking at things this way, it seems like you might want three flags,
since the asymmetry is caused by two things being bundled into
SKIPCALL.

If you have
	PTRACE_VM_SKIPEXIT - skip the return notification
	PTRACE_VM_SKIPCALL - skip the syscall
	PTRACE_VM_SKIPSTART - skip the call notification
this makes the meaning make more sense to me.

The downside of this is that you end up at least one combination that
doesn't make too much sense, like PTRACE_VM_SKIPCALL (do both
notifications even though nothing could have changed in between).

> umview (and now kmview using a kernel module based on utrace) decides if
> a syscall must be virtualized or not depending on the value of its
> arguments, not on the syscall number. With "system call" I mean "call of
> a system call", a "system call call";-)

OK, if you're looking at the arguments in order to decide what to do,
then you can't just mask out the notifications.

     	       	    Jeff

-- 
Work email - jdike at linux dot intel dot com
