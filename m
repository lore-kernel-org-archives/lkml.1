Return-Path: <linux-kernel-owner+w=401wt.eu-S1758874AbZA2Tma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874AbZA2Tma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 14:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755167AbZA2TmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 14:42:20 -0500
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:60067 "EHLO
	QMTA08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755653AbZA2TmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 14:42:19 -0500
Subject: Re: vm: shmat() address for 32 vs 64 bit kernel
From: Nicholas Miell <nmiell@comcast.net>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4981FEBF.5050603@msgid.tls.msk.ru>
References: <4981FEBF.5050603@msgid.tls.msk.ru>
Content-Type: text/plain
Date: Thu, 29 Jan 2009 11:41:46 -0800
Message-Id: <1233258106.12514.6.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-29 at 22:08 +0300, Michael Tokarev wrote:
> I were needed to run a legacy application which uses
> Oracle 8 database.  Tried to run it on a 64bit kernel,
> which is running on my machine for a long time, together
> with 32bits userland.  Everything worked but not oracle,
> which segfaults at startup on 64bits kernel, but works
> just fine when running the same but 32bits kernel
> (userspace is the same).
> 
> After much debugging I found this difference which may
> be relevant.  It's the address returned by shmat() routine.
> 
> Here are the relevant stuff for 32bits:
> 
> shmget(0x4d21f3bc, 579067904, IPC_CREAT|IPC_EXCL|0640) = 174358532
> shmat(174358532, 0, 0)            = 0x9569f000
> 
> Here, the segment ends at (0x9569f000+579067904)/1024/1024 = 2942Mb.
> 
> And here's what happens with 64bits kernel:
> 
> shmget(0xc9a7c840, 579067904, IPC_CREAT|IPC_EXCL|0640) = 294912
> shmat(294912, 0, 0)               = 0xd5548000
> 
> Here, the segment ends at 3965Mb.
> 
> And right after that shmat, oracle process terminates with SIGSEGV
> (on 64bits kernel, but continues just fine on 32bits).
> 
> I understand full well many bad points here: proprietary software,
> old legacy code, not supported, buggy.

Fortunately, compatibility is compatibility, and none of these are
relevant. :)

> But the question really is: why the difference in the first place,
> for 32bits userland, between 32 and 64bits kernels?  Can this diff
> be "fixed" somehow?  For example, I remember kernel/user memory
> split kconfig option - is there similar thing for 32bits userspace
> on 64bits kernel?
> 

On 32-bit systems, the kernel is mapped into the last gigabyte of the 4
GB address space for every process. On 64-bit systems, the kernel is
mapped in the negative half of the 64-bit address space for all
processes, which leaves the top gigabyte of the 4 GB address space free
for userspace use.

Most of the time this just means more memory for the processes that need
it, but (as you have discovered) sometimes it can cause problems, which
is why the setarch command has the --3gb flag.

> (And for the record, in case others will encounter the same issue:
> the process started it all sees this:
> 
> SQL> startup
> ORA-24323: value not allowed
> ORA-03113: end-of-file on communication channel
> 
> and in the alert file we see this:
> 
> Errors in file /usr/oracle/8.1/rdbms/log/ora_3365.trc:
> ORA-00445: background process "PMON" did not start after 120 seconds
> )
> 
> Thanks!
> 
> /mjt

-- 
Nicholas Miell <nmiell@comcast.net>

