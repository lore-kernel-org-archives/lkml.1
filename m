Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbZBFVGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbZBFVGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 16:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbZBFVGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 16:06:37 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:48641 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbZBFVGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 16:06:37 -0500
Date: Fri, 6 Feb 2009 14:05:50 -0700
From: Alex Chiang <achiang@hp.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
       "stable@kernel.org" <stable@kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ia64: prevent irq migration race in __cpu_disable path
Message-ID: <20090206210550.GF2445@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	"Luck, Tony" <tony.luck@intel.com>,
	"paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
	"stable@kernel.org" <stable@kernel.org>,
	"linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20090206162213.GD8208@ldl.fc.hp.com> <57C9024A16AD2D4C97DC78E552063EA36121A469@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA36121A469@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Luck, Tony <tony.luck@intel.com>:
> > This is wrong because fixup_irqs calls migrate_irqs, and in
> > migrate_irqs, we use the cpu_online_map to:
> >
> >       1. look for interrupts on current CPU
> >       2. if we find one, move it to the first available CPU in
> >       the cpu_online_map
> >
> > This means we can potentially migrate an interrupt off ourself
> > back to... ourself. Uh oh.
> 
> Should we make migrate_irqs smarter then ... does any caller really
> expect that it would "migrate" the irq to the same cpu?

The only thing migrate_irqs does is locate irqs that have their
CPU affinity set to the current CPU, and if so, changes the
affinity.

We still have possible pending timer interrupts that we need to
handle, so I'm not seeing how changing the migrate_irqs
implementation (to avoid migrating to ourself) will handle that.

On one hand, I think the only irq handler that can be called at
this point is our timer_interrupt, which doesn't seem to be using
any RCU APIs.

On the other hand, if we really want to make sure that we're not
calling interrupt handlers with our CPU marked as 'offline', then
we need to fix ia64_process_pending_intr() so that we're not
firing our timer_interrupt with a NULL pt_regs.

Add in to the mix that x86 seems to have the same assumption that
we do (that it's ok to call our timer interrupt handler even if
we're already marked as 'offline').

I'm leaning towards reverting Paul's previous commit entirely
because

	- migrate_platform_irqs() doesn't cause any interrupt
	  handlers to be fired by itself

	- it also uses cpu_online)map to find a new CPU to assign
	  CPEI to

Thoughts?

/ac

