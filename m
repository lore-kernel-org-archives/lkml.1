Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbYFDQKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbYFDQKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 12:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbYFDQKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 12:10:01 -0400
Received: from www.tglx.de ([62.245.132.106]:55555 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbYFDQJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 12:09:49 -0400
Date: Wed, 4 Jun 2008 18:08:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
cc: Stefan Assmann <sassmann@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Olaf Dabrunz <od@suse.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Boot IRQ quirks and rerouting
In-Reply-To: <Pine.LNX.4.55.0806041555370.28685@cliff.in.clinika.pl>
Message-ID: <alpine.LFD.1.10.0806041801260.3235@apollo.tec.linutronix.de>
References: <12124107071847-git-send-email-od@suse.de> <m1tzgauduu.fsf@frodo.ebiederm.org> <4846651F.4070802@suse.de> <m1ve0pqy06.fsf@frodo.ebiederm.org> <48467DA7.9030309@suse.de> <Pine.LNX.4.55.0806041555370.28685@cliff.in.clinika.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008, Maciej W. Rozycki wrote:
> On Wed, 4 Jun 2008, Stefan Assmann wrote:
>  What's the reasoning behind the option in this case?  As I understand 
> there are two cases possible:
> 
> 1. Secondary, etc. I/O APIC inputs are not masked under any circumstances.  
>    No legacy INTx redirection happens, nothing to be done.
> 
> 2. Secondary, etc. I/O APIC inputs are to be masked from time to time.  
>    That would cause legacy INTx redirection for the affected chipsets in 
>    situations where an interrupt arrives at a masked I/O APIC input.  This 
>    interrupt is delivered to an input of the primary I/O APIC which cannot 
>    be masked because of other devices wired to it.
> 
>    OK -- that means the interrupt is delivered anyway (and perhaps 
>    discarded in the handler, but that does not matter here), so why to do

It does matter. When the interrupt is _not_ handled then it comes back
immediately for ever and after a while the kernel decides to disable
the legacy int, because nobody cares about the interrupt.

What happens is:

     irq_disable(secondary);
     
     irq line of the secondary ioapic becomes active

     legacy irq happens

repeat:
     legacy irq disable
     handler runs and discards
     legacy irq enable

     legacy interrupt is still active due to rerouting
     if (count < max)
        goto repeat
     else
	disable legacy irq forever

Thanks,
	tglx
