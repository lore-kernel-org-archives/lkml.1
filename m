Return-Path: <linux-kernel-owner+w=401wt.eu-S1762670AbYASABc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762670AbYASABc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 19:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757204AbYASABZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 19:01:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756738AbYASABY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 19:01:24 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: x86: kdump failure
In-Reply-To: Ingo Molnar's message of  Friday, 18 January 2008 10:02:05 +0100 <20080118090205.GA24337@elte.hu>
References: <478BB226.6090105@ct.jp.nec.com>
	<20080114190904.GA2288@elte.hu>
	<4790145C.9060102@ct.jp.nec.com>
	<20080118090205.GA24337@elte.hu>
X-Zippy-Says: I'm having a BIG BANG THEORY!!
Message-Id: <20080119000119.3524B26F9FD@magilla.localdomain>
Date: Fri, 18 Jan 2008 16:01:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, I overlooked the use of elf_core_copy_regs in kernel/kexec.c.  It
is certainly safe and fine to reintroduce the old macro.  Everything
removed in the "x86 user_regset cleanup" patch is purely removing code
and it doesn't hurt to have it back (it's just all unused except for this
kexec nit).

Unfortunately it really doesn't fit to have kexec call into the new
user_regset code that replaced this macro for user core dump purposes.
Those new interfaces are really purely for user-mode state, derived only
from task_struct (i.e. uses task_pt_regs), not from a struct pt_regs
pointer passed in.  (There is the minority case where it really is using
user-mode state.  That part could be done via the user_regset interface,
if that saved any trouble.)

Things like crash_fixup_ss_esp point to the poor fit of the code intended
for user core dumps with what kexec needs.  IMHO it would be cleaner for
kexec's arch interfaces to fill in elf_gregset_t directly, replacing some
of the places a struct pt_regs is passed around now.
crash_setup_regs already has to know the name of every register anyway.
A particular arch's definition can share code with its core dump or
user_regset code when that fits.


Thanks,
Roland
