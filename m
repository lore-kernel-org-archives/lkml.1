Return-Path: <linux-kernel-owner+w=401wt.eu-S965570AbXC1R4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965570AbXC1R4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 13:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965574AbXC1R4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 13:56:49 -0400
Received: from smtp.osdl.org ([65.172.181.24]:51800 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965570AbXC1R4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 13:56:48 -0400
Date: Wed, 28 Mar 2007 10:56:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: Linux 2.6.21-rc5
In-Reply-To: <200703281630.59191.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0703281051180.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
 <46096834.5050508@googlemail.com> <200703281630.59191.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 28 Mar 2007, Andi Kleen wrote:
> 
> Can you test this patch please? 

This patch is totally broken.

> i386/x86-64: Convert nmi reservation to be global
> 
> It doesn't make much sense to have this per CPU, because all
> the services using NMIs run on all CPUs. So make it global.

NO!

If you do this, then you must make all *callers* be global too. But they 
aren't. Right now all callers do per-CPU setup!

See for example enable_lapic_nmi_watchdog():

	on_each_cpu(setup_apic_nmi_watchdog, NULL, 0, 1);

where "setup_apic_nmi_watchdog()" will call "setup_k7_watchdog()", which 
in turn will do a per-CPU reservation of the perfctl for the watchdog.

So I agree in that it probably doesn't make sense to have NMI/perfctl 
reservation per-CPU, but you can't just change the reservation and ignore 
all the *users* of that reservation that assumed that it was per-CPU.

Is that code insane? Probably. But it probably also works. After your 
patch, one CPU will be able to reserve the NMI/perfctl thing (fine so far) 
but then all the other CPU's that try to do it will fail.

			Linus
