Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbYJCPir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbYJCPir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbYJCPij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:38:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751759AbYJCPii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:38:38 -0400
Date: Fri, 3 Oct 2008 08:36:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [regression] Latest git has WARN_ON storm with e1000e driver
In-Reply-To: <200810031720.53923.borntraeger@de.ibm.com>
Message-ID: <alpine.LFD.2.00.0810030825190.3262@nehalem.linux-foundation.org>
References: <200810031041.49350.borntraeger@de.ibm.com> <alpine.LFD.2.00.0810030746430.3230@nehalem.linux-foundation.org> <200810031720.53923.borntraeger@de.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 3 Oct 2008, Christian Borntraeger wrote:
> 
> Very good point indeed. Seems my analysis was wrong. I made a short test and 
> preempt_count() returns 1 when the WARN_ON triggers. So its either a spinlock 
> or something else that increased my preempt_count.

Ok, I can repro it. I couldn't see it before because I usually don't have 
PREEMPT even enabled.  Enabling PREEMPT and PREEMPT_DEBUG gets me the 
messages too. Jesse?

The call trace is much better with frame pointers enabled, loke so (with
the '?' entries removed as stale):

   Call Trace:
	warn_on_slowpath+0x53/0x7a
	e1000_acquire_swflag_ich8lan+0x2d/0xe1
	e1000_read_nvm_ich8lan+0x4f/0xee
	e1000e_read_pba_num+0x4e/0x69
	e1000_probe+0xa32/0xb71
	pci_device_probe+0x4c/0x72
	driver_probe_device+0xc0/0x16e
	__driver_attach+0x4f/0x79
	bus_for_each_dev+0x4f/0x89
	driver_attach+0x1c/0x1e
	bus_add_driver+0xb7/0x1f4
	driver_register+0xa8/0x128
	__pci_register_driver+0x66/0x9d
	e1000_init_module+0x4f/0x6b
	_stext+0x47/0x13f
	kernel_init+0x127/0x17b
	child_rip+0xa/0x11

and yes, there's quite a lot of them.  I'm not seeing what disables
preemption, though.  I'll look at it some more, but I decided I should
post that cleaned-up call chain so that others can do so too..

		Linus

