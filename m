Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbZCFSJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbZCFSJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 13:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750923AbZCFSJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 13:09:17 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:33157 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750728AbZCFSJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 13:09:17 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah0FALvysElMQW1W/2dsb2JhbACBTtUUhAgG
Date: Fri, 6 Mar 2009 13:09:11 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH -tip 0/4] Text edit lock and atomic text_poke()
Message-ID: <20090306180911.GB14236@Krystal>
References: <49B1428A.9050500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <49B1428A.9050500@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:07:34 up 6 days, 14:33,  1 user,  load average: 0.29, 0.45,
	0.50
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Hi,
> 
> Here is a series of patches which introduce text_mutex for protecting
> editing kernel text from each other subsystems, and make text_poke()
> atomic by using fixmap.
> 
> BTW,
> 
> > Paravirt and alternatives are always done when SMP is inactive, so there is no
> > need to use locks.
> 
> Mathieu, I'm not sure that means. alternatives will be called from module
> init code and other place where the system has already been running multi-
> -threads(and they use smp_alt mutex). So, is it possible that those functions
> will sleep or yield to another process?
> 

As I remember, module code uses text_poke_early when modifying the
module text _before_ the module is made available to the rest of the
kernel. Therefore, it behaves as if it was in a UP system, and that's
ok, because only one CPU has to touch the text. Therefore, there is no
need to use text_poke, and therefore no need to take the text mutex.

Or maybe has it changed ? But I doubt so.

Mathieu

> Anyway, I added a new patch which locks text_mutex in alternative_smp_*.
> 
> Thank you,
> 
>  arch/x86/include/asm/fixmap.h |    2 ++
>  arch/x86/kernel/alternative.c |   29 ++++++++++++++++++++---------
>  include/linux/memory.h        |    6 ++++++
>  kernel/kprobes.c              |   15 +++++++++++++--
>  mm/memory.c                   |    9 +++++++++
>  5 files changed, 50 insertions(+), 11 deletions(-)
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
