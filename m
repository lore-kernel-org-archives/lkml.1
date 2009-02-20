Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbZBTSud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbZBTSud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 13:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbZBTSuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 13:50:24 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:25021 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbZBTSuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 13:50:23 -0500
Message-ID: <499EFB1A.7070801@caviumnetworks.com>
Date: Fri, 20 Feb 2009 10:48:58 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Syscall wrappers breaks things.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Feb 2009 18:48:58.0770 (UTC) FILETIME=[E3C2C720:01C9938B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit ee6a093222549ac0c72cfd296c69fa5e7d6daa34 the syscall wrappers 
infrastructure was introduced.

A typical definition is something like this (from Ralf's patch):

SYSCALL_DEFINE6(32_ipc, u32, call, long, first, long, second, long, third,
	unsigned long, ptr, unsigned long, fifth)
{
.
.
.

This creates a symbol sys_32_ipc.  The old name of the symbol is 
sys32_ipc (note the change in the number of '_').

For the mips64 kernel the syscall table for o32 ABI executable contains:

.
.
.
	PTR	sys32_ipc
.
.
.

This is now linked to the sys32_ipc function in kernel/sys_ni.c which 
kindly returns ENOSYS.

The long and short of the problem is that the is now a kernel wide 
mismatch in function names between the names created by SYSCALL_DEFINE*, 
the syscall tables and kernel/sys_ni.c.

I am not sure what the best solution is, but something should probably 
be done to un-break things.

Thanks,
David Daney
