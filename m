Return-Path: <linux-kernel-owner+w=401wt.eu-S1756946AbXKMOP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946AbXKMOP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 09:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbXKMOPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 09:15:50 -0500
Received: from ns1.suse.de ([195.135.220.2]:49501 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbXKMOPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 09:15:49 -0500
To: Max Asbock <masbock@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com
Subject: Re: x86 32-bit machine check handler
From: Andi Kleen <andi@firstfloor.org>
References: <1194899975.9979.7.camel@w-amax.beaverton.ibm.com>
Date: Tue, 13 Nov 2007 15:15:47 +0100
In-Reply-To: <1194899975.9979.7.camel@w-amax.beaverton.ibm.com> (Max Asbock's message of "Mon\, 12 Nov 2007 12\:39\:35 -0800")
Message-ID: <p73abpiz0x8.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Max Asbock <masbock@us.ibm.com> writes:

> Now that the 32-bit and 64-bit x86 machine check handlers live next to
> each other a certain asymmetry in functionality is apparent. Notably,
> the 64-bit machine check handler implements a timer that periodically
> polls for silent machine check errors and makes them accessible to user
> space through /dev/mcelog. 

Actually 32bit implements that too (non-fatal.c). But it misses some
of the more advanced functionality like AMD Threshold Interrupts.

> Are there reasons the x86 32-bit machine
> check handler couldn't do the same?

The 32bit machine check code has some serious design problems. The
best would be probably to just move 32bit over to the 64bit code too.  In
fact there was a patch to do that some time ago, but it ran into some
minor problems and was unfortunately never merged. But it would be the
right thing to do.

The only missing functionality on the 64bit side would be support for
old non IA compliant old machine checks like P5 or WinChip. One option
would be to simply drop them. AFAIK these CPUs don't really have
anywhere near usable machine check capability anyways so dropping it
would not make much difference. Or alternatively keep p5.c/winchip.c
around. But if you look at them they don't do much except simple
printk with not much information and printk in a machine check handler
is always wrong because it can deadlock. I personally would prefer
dropping.

And I think one or two K7 quirks are also missing on 64bit, but these
would be very easy to add. Other than that it should just work on
32bit CPUs.

-Andi
