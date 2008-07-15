Return-Path: <linux-kernel-owner+w=401wt.eu-S1761470AbYGOSAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761470AbYGOSAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbYGOSAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:00:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752973AbYGOSAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:00:40 -0400
Date: Tue, 15 Jul 2008 10:59:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT pull] timer updates for 2.6.27
In-Reply-To: <alpine.LFD.1.10.0807141827340.3283@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0807151046180.3017@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0807141827340.3283@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, Thomas Gleixner wrote:
> 
> Please pull the latest timers/for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers/for-linus
> ...
> Randy Dunlap (1):
>       acpi_pm clccksource: fix printk format warning

This just _adds_ a warning. I now get

drivers/clocksource/acpi_pm.c:231: warning: format ¡%04x¢ expects type ¡unsigned int¢, but argument 3 has type ¡long unsigned int¢

Why? Because it only adds the (unsigned int) cast (which is wrong anyway - 
ioports really should be long) to the ioport value, not 'base' is still 
'unsigned long', and it removed the 'lx' from the latter too.

One clean fix is probably to just make pmtmr_ioport be of type 'unsigned 
long'. It's the right thing from a portability angle anyway - even if no 
architecture that uses ACPI will likely ever have ioports that are long 
anyway.

The alternative - and probably better, but _much_ more intrusive - patch
is to make 'u32' just be 'unsigned int' on x86-32, along with making 'u64' 
be 'unsigned long long' on x86-64, which would unify more types.

Anyway, I'm not fixing it right now, since it's unclear which way to go, 
but this need to be fixed _some_ way.

		Linus
