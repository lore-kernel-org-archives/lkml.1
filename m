Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbZHPUOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbZHPUOM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 16:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755882AbZHPUOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 16:14:11 -0400
Received: from cyrus.watson.org ([65.122.17.42]:60941 "EHLO cyrus.watson.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755790AbZHPUOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 16:14:10 -0400
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Aug 2009 16:14:10 EDT
Date: Sun, 16 Aug 2009 21:06:41 +0100 (BST)
From: Robert Watson <rwatson@FreeBSD.org>
X-X-Sender: robert@fledge.watson.org
To: Oliver Pinter <oliver.pntr@gmail.com>
cc: David Wagner <daw@cs.berkeley.edu>, freebsd-hackers@FreeBSD.org,
       linux-kernel@vger.kernel.org
Subject: Re: Security: information leaks in /proc enable keystroke recovery
In-Reply-To: <6101e8c40908151625s52ad9b83ue061de3fab97fbf8@mail.gmail.com>
Message-ID: <alpine.BSF.2.00.0908162014030.1901@fledge.watson.org>
References: <200908152221.n7FMLRuw005799@taverner.cs.berkeley.edu> <6101e8c40908151625s52ad9b83ue061de3fab97fbf8@mail.gmail.com>
User-Agent: Alpine 2.00 (BSF 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="621616949-1749418058-1250453201=:1901"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--621616949-1749418058-1250453201=:1901
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT


On Sun, 16 Aug 2009, Oliver Pinter wrote:

> FreeBSD manages its process ﬁles more cautiously than Linux12 : it puts all 
> register values into the ﬁle /proc/pid/regs that can only be read by the 
> owner of a process, which blocks the information used by

This is inaccurate, but largely in an academic sense.  The FreeBSD kernels 
computes debug permissions between two processes from a number of factors, 
including:

- Comparison of uids (effective, real, saved)
- Comparison of gids (effective, real, saved)
- Subset check on the additional group set
- Jail information
- Mandatory access control policies

There are some other checks that fit the pattern of credential comparison less 
well:

- We deny debugger activity during execve(2) as a robustness protection
   against possible race conditions.

- We have global policy controls, security.bsd.see_other_gids and
   security.bsd.see_other_uids, which allow administrators to scope not just
   debugging facilities, but also monitoring facilities.

- We have a global policy control, security.bsd.unprivileged_proc_debug, to
   disable debugging facilities for unprivileged users, on the grounds that (a)
   this is sometimes a desirable system policy, and (b) all UNIX systems have
   historically suffered from significant debugger security vulnerabilities and
   this provides an easy work-around to use if that happens in the future.

Which is to say: the UNIX file system permissions appearing in procfs are 
purely decorative -- they roughly summarize, but do not implement, the above 
checks.

procfs is also deprecated in FreeBSD, and has not been mounted by default for 
several major releases.  Instead, the system call interfaces ktrace(2), 
ptrace(2), and sysctl(2) provide access to trace data, process debugging, and 
process state (such as address space layout and file descriptor information). 
Some legacy setgid kvm tools exist that use libkvm and /dev/kmem, but we are 
eliminating these as quickly as we can; they may not follow the same policies 
as those implemented in the kernel.

The see_other_uids and see_other_gids policy sysctls narrow the policy on 
inter-process visibility via monitoring controls -- however, 
additional hardening is required to enforce this policy universally.  For 
example, administrators will also need to limit access to logs, accounting 
data, and so on, for this to be fully effective.

Beyond this, and assuming the correct implementation of the above, we're into 
the grounds of classic trusted OS covert channel analysis, against which no 
COTS UNIX OSes I'm aware of are hardened.  This isn't to dismiss these attacks 
as purely hypothetical -- we've seen some rather compelling examples of covert 
channels being exploited in unexpected and remarkably practical ways in the 
last few years (Steven Murdoch's "Hot or Not" paper takes the cake in that 
regard, I think).

However, this next step up from "the kernel doesn't reveal information on 
processes from other users" involves scheduler hardening, consideration of 
inter-CPU/core/thread cache interactions, and so on -- things that we don't 
have a good research, let alone production, OS understanding of.  There are 
tools in FreeBSD that can help with some of these issues -- for example, you 
can use login classes to pin different users to different CPU threads, cores, 
or packages.  However, this leaves the implementation of policy up to the 
administrator, rather than simply allowing the administator to specify the 
policy that mutually untrusting processes can't share CPUs with each other in 
some window.

Robert N M Watson
Computer Laboratory
University of Cambridge
--621616949-1749418058-1250453201=:1901--
