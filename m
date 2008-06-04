Return-Path: <linux-kernel-owner+w=401wt.eu-S1760148AbYFDRTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148AbYFDRTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 13:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYFDRTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 13:19:09 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63929 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752009AbYFDRTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 13:19:08 -0400
Date: Wed, 4 Jun 2008 18:18:28 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Stefan Assmann <sassmann@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Olaf Dabrunz <od@suse.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Boot IRQ quirks and rerouting
In-Reply-To: <alpine.LFD.1.10.0806041801260.3235@apollo.tec.linutronix.de>
Message-ID: <Pine.LNX.4.55.0806041755040.28685@cliff.in.clinika.pl>
References: <12124107071847-git-send-email-od@suse.de> <m1tzgauduu.fsf@frodo.ebiederm.org>
 <4846651F.4070802@suse.de> <m1ve0pqy06.fsf@frodo.ebiederm.org>
 <48467DA7.9030309@suse.de> <Pine.LNX.4.55.0806041555370.28685@cliff.in.clinika.pl>
 <alpine.LFD.1.10.0806041801260.3235@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008, Thomas Gleixner wrote:

> It does matter. When the interrupt is _not_ handled then it comes back
> immediately for ever and after a while the kernel decides to disable
> the legacy int, because nobody cares about the interrupt.

 Mental shortcut, sorry -- making the interrupt be discarded through the
primary rather than the secondary, etc. I/O APIC does not change anything.  
Based on the description of the problem, the interupt will just have to be
delivered somewhere, so I see little purpose in complicating the routing
and causing additional sharing just to discard the interrupt elsewhere
anyway.  If INTx messages cannot be blocked on the way anywhere, then the 
originating I/O APIC should never get its inputs masked and the handler 
should take care of the unwanted interrupts there.  This is at least my 
opinion.

 BTW, it could be possible to mask the interrupt by fiddling with the
vector used and the TPR instead -- we have a range of low-priority vectors
which are never used for APIC interrupts, so the TPR may be hardcoded to
some non-zero value for all systems and then for the problematic chipsets
handlers may change vectors to mask or unmask APIC interrupts.  This would
have to be verified on actual hardware and be conditional as it is likely
to cause troubles for systems using serial interrupt delivery over the
inter-APIC bus (the vector, delivery mode, etc. are generally not meant to
be changed with the input unmasked for these chips -- which just shows how
braindead the idea of the mask having side effects is).  Just a thought.

  Maciej
