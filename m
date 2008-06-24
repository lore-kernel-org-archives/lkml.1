Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbYFXKY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbYFXKY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 06:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYFXKYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 06:24:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47771 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbYFXKYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 06:24:20 -0400
Date: Tue, 24 Jun 2008 12:24:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
Subject: [bug] Re: [PATCH] - Fix stack overflow for large values of
	MAX_APICS
Message-ID: <20080624102401.GA27614@elte.hu>
References: <20080620025104.GA25571@sgi.com> <20080620103921.GC32500@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080620103921.GC32500@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Jack Steiner <steiner@sgi.com> wrote:
> 
> > physid_mask_of_physid() causes a huge stack (12k) to be created if 
> > the number of APICS is large. Replace physid_mask_of_physid() with a 
> > new function that does not create large stacks. This is a problem 
> > only on large x86_64 systems.
> 
> this indeed fixes the crash i reported here:
> 
>    http://lkml.org/lkml/2008/6/19/98
> 
> so i've added both this and the MAXAPICS patch to tip/x86/uv, and will 
> test it some more. Lets hope it goes all well this time :-)

-tip auto-testing found a new boot failure on x86 which happens if 
NR_CPUS is changed from 8 to 4096. The hang goes like this:

 Linux version 2.6.26-rc7-tip (mingo@dione) (gcc version 4.2.3) #10233 SMP
 Tue Jun 24 12:13:46 CEST 2008
 [...]
 initcall init_mnt_writers+0x0/0x8c returned 0 after 0 msecs
 calling  eventpoll_init+0x0/0x9a
 initcall eventpoll_init+0x0/0x9a returned 0 after 0 msecs
 calling  anon_inode_init+0x0/0x11a
 initcall anon_inode_init+0x0/0x11a returned 0 after 0 msecs
 calling  pcie_aspm_init+0x0/0x27
 initcall pcie_aspm_init+0x0/0x27 returned 0 after 0 msecs
 calling  acpi_event_init+0x0/0x57
 [... hard hang ...]

on a good bootup, it would continue like this:

 initcall acpi_event_init+0x0/0x57 returned 0 after 38 msecs
 calling  pnp_system_init+0x0/0x17
 [...]

the config, full bootlog and reproducer bzImage is at:

  http://redhat.com/~mingo/misc/config-Tue_Jun_24_07_44_17_CEST_2008.bad
  http://redhat.com/~mingo/misc/log-Tue_Jun_24_07_44_17_CEST_2008.bad
  http://redhat.com/~mingo/misc/bzImage-Tue_Jun_24_07_44_17_CEST_2008.bad

changing CONFIG_NR_CPUS from 4096 to 8 causes the system to boot up 
fine.

	Ingo
