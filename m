Return-Path: <linux-kernel-owner+w=401wt.eu-S1762666AbYBAXnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762666AbYBAXnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 18:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761577AbYBAXni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 18:43:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33334 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760170AbYBAXnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 18:43:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Regression] 2.6.24-git9: RT sched mishandles artswrapper (bisected)
Date: Sat, 2 Feb 2008 00:39:58 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200802010237.59320.rjw@sisk.pl> <200802011250.18699.rjw@sisk.pl> <1201867797.32654.52.camel@lappy>
In-Reply-To: <1201867797.32654.52.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802020040.05519.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 1 of February 2008, Peter Zijlstra wrote:
> 
> On Fri, 2008-02-01 at 12:50 +0100, Rafael J. Wysocki wrote:
> > On Friday, 1 of February 2008, Peter Zijlstra wrote:
> 
> > > > It arts run as root, or does it use RLIMIT_RTPRIO to allow users to
> > > > execute realtime tasks?
> > 
> > artswrapper is setuid root and RLIMIT_RTPRIO is apparently not used.
> > Still, artswrapper is running as a regular user, so it most probably drops
> > privileges early.
> > 
> > BTW, it fails while running the artsmessage utility used for displaying arts
> > error messages, so I guess there's an error in arts that this thing tries to
> > display and deadlocks (or something like that).
> > 
> > Should I test the patch nevertheless?
> 
> Don't think that would help any in this situation. The thing to look out
> for are RT tasks running with a different uid than 0.
> 
> This patch would only stop a task from obtaining RT class scheduling
> when already in a (misconfigured) group. If the task is RT and then
> switches group another - similar - thing is needed.
> 
> Does this artsmessage thing also run with RT priority?

Well, it's in a strange state (after it's broken).  From top:

PR = -51
NI = 0
S = R
%CPU = 0.0
%MEM = 0.0

Here's the corresponding trace from sysrq+t:

artswrapper   R  running task     5128  5776      1
 ffff81007a8dbd88 0000000000000046 000000015c4321b0 ffff81006aa6e5c8
 ffffffff806daa00 ffffffff806daa00 ffffffff806daa00 ffffffff806daa00
 ffffffff806daa00 ffffffff806daa00 ffffffff806d7a60 ffffffff806daa00
Call Trace:
 [<ffffffff8022fdb7>] ? try_to_wake_up+0x77/0x200
 [<ffffffff8023573d>] __cond_resched+0x2d/0x60
 [<ffffffff804ddce1>] _cond_resched+0x31/0x40
 [<ffffffff804ddd24>] wait_for_common+0x34/0x170
 [<ffffffff8022fdb7>] ? try_to_wake_up+0x77/0x200
 [<ffffffff804ddec8>] wait_for_completion+0x18/0x20
 [<ffffffff80235aba>] sched_exec+0xba/0xf0
 [<ffffffff802b5a64>] do_execve+0x64/0x220
 [<ffffffff802097c6>] sys_execve+0x46/0x70
 [<ffffffff8020bab7>] stub_execve+0x67/0xb0
