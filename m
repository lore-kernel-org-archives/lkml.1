Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbYBGMZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbYBGMZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 07:25:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbYBGMYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 07:24:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41301 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755720AbYBGMYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:24:51 -0500
Date: Thu, 7 Feb 2008 13:24:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Vivek Goyal <vgoyal@redhat.com>,
       tglx@linutronix.de, mingo@redhat.com, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH], issue EOI to APIC prior to calling crash_kexec in
	die_nmi path
Message-ID: <20080207122404.GA8195@elte.hu>
References: <20080206192555.GA24910@hmsendeavour.rdu.redhat.com> <20080206220001.GA15155@elte.hu> <20080206224805.GD11886@redhat.com> <47AA3B16.7000507@zytor.com> <20080206233657.GB12393@elte.hu> <m1r6fpd2uo.fsf@ebiederm.dsl.xmission.com> <20080207121719.GA29279@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207121719.GA29279@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Neil Horman <nhorman@tuxdriver.com> wrote:

> Ingo noted a few posts down the nmi_exit doesn't actually write to the 
> APIC EOI register, so yeah, I agree, its bogus (and I apologize, I 
> should have checked that more carefully).  Nevertheless, this patch 
> consistently allowed a hangning machine to boot through an Nmi lockup.  
> So I'm forced to wonder whats going on then that this patch helps 
> with.  perhaps its a just a very fragile timing issue, I'll need to 
> look more closely.

try a dummy iret, something like:

  asm volatile ("pushf; push $1f; iret; 1: \n");

to get the CPU out of its 'nested NMI' state. (totally untested)

the idea is to push down an iret frame to the kernel stack that will 
just jump to the next instruction and gets it out of the NMI nesting. 
Note: interrupts will/must still be disabled, despite the iret. (the 
ordering of the pushes might be wrong, we might need more than that for 
a valid iret, etc. etc.)

	Ingo
