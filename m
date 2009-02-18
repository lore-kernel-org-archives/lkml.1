Return-Path: <linux-kernel-owner+w=401wt.eu-S1762681AbZBRWwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762681AbZBRWwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762587AbZBRWwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:52:12 -0500
Received: from gw.goop.org ([64.81.55.164]:33988 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760908AbZBRWwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:52:10 -0500
Message-ID: <499C9116.7000702@goop.org>
Date: Wed, 18 Feb 2009 14:52:06 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       Alok N Kataria <akataria@vmware.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 0/9] Make lazy mmu update mode pre-empt safe
References: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com> <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Clearly some aspect of this mailbomb tool is eluding me. ]

Hi,

This series changes the paravirt-ops lazy update modes in the following 
ways:

 1. Make paravirt_get_lazy_mode() always return PARAVIRT_LAZY_NONE in
    interrupt context.  This has the effect of making all mmu and cpu
    state updates synchronous in interrupt routines, without the need
    to add explicit flushing.

 2. De-generalize lazy cpu mode to a specific context-switch operation.
    Rather than dealing with fully general enter/leave lazy cpu update
    mode, make it specifically about start/end context switch, since that
    was the only use anyway.  That means the implementations know that
    they're in the middle of a context switch.

 3. On starting a context switch, if the task is in lazy mmu update mode,
    record that fact in thread_info->flags TIF_LAZY_MMU_UPDATE, and
    disable lazy updates (flushing anything pending).  On ending a context
    switch, if the new task has TIF_LAZY_MMU_UPDATE set, then reenter
    lazy mmu update mode.

 4. Remove all the preempt_disable/enable pairs and assertion that
    preemption must be disabled for lazy mmu updates.

This has the net effect of 1) making lazy mmu updates more robust, and
2) not requiring any changes to the current rules of how init_mm can
be updated.

Thanks,
    J
