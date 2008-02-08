Return-Path: <linux-kernel-owner+w=401wt.eu-S1764213AbYBHR30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764213AbYBHR30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 12:29:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760949AbYBHR3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 12:29:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758747AbYBHR3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 12:29:13 -0500
Date: Fri, 8 Feb 2008 12:26:58 -0500
From: Neil Horman <nhorman@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de
Subject: Re: [PATCH], issue EOI to APIC prior to calling crash_kexec in die_nmi path
Message-ID: <20080208172658.GB11878@hmsendeavour.rdu.redhat.com>
References: <20080206192555.GA24910@hmsendeavour.rdu.redhat.com> <20080206220001.GA15155@elte.hu> <20080206224805.GD11886@redhat.com> <47AA3B16.7000507@zytor.com> <20080206233657.GB12393@elte.hu> <m1r6fpd2uo.fsf@ebiederm.dsl.xmission.com> <20080207121719.GA29279@hmsreliant.think-freely.org> <20080207122404.GA8195@elte.hu> <20080208161422.GA32204@hmsreliant.think-freely.org> <20080208164544.GA23772@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208164544.GA23772@redhat.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 11:45:44AM -0500, Vivek Goyal wrote:
> On Fri, Feb 08, 2008 at 11:14:22AM -0500, Neil Horman wrote:
> > On Thu, Feb 07, 2008 at 01:24:04PM +0100, Ingo Molnar wrote:
> > > 
> > > * Neil Horman <nhorman@tuxdriver.com> wrote:
> > > 
> > > > Ingo noted a few posts down the nmi_exit doesn't actually write to the 
> > > > APIC EOI register, so yeah, I agree, its bogus (and I apologize, I 
> > > > should have checked that more carefully).  Nevertheless, this patch 
> > > > consistently allowed a hangning machine to boot through an Nmi lockup.  
> > > > So I'm forced to wonder whats going on then that this patch helps 
> > > > with.  perhaps its a just a very fragile timing issue, I'll need to 
> > > > look more closely.
> > > 
> > > try a dummy iret, something like:
> > > 
> > >   asm volatile ("pushf; push $1f; iret; 1: \n");
> > > 
> > > to get the CPU out of its 'nested NMI' state. (totally untested)
> > > 
> > > the idea is to push down an iret frame to the kernel stack that will 
> > > just jump to the next instruction and gets it out of the NMI nesting. 
> > > Note: interrupts will/must still be disabled, despite the iret. (the 
> > > ordering of the pushes might be wrong, we might need more than that for 
> > > a valid iret, etc. etc.)
> > > 
> > > 	Ingo
> > 
> > Just tried this experiment and it met with success.  Executing a dummy iret
> > instruction got us to boot the kdump kernel successfully.  
> > 
> 
> Interesting. So that means there is some operation we can't perform when
> we are in NMI handler (Or nested NMIs, I don't know if this is nested NMI
> case ).
> 
> Even if we initiated crash dump in NMI handler, next kernel should unlock
> that state as soon as we enable interrupts in next kernel (iret will be
> called).
> 
> So the only issue here will be if need to put the explicit logic to unlock
> the NMI earlier (Either in crashing kernel after clearing IDT or in
> purgatory code). Anything earlier then that, will be dangerous though, handling
> another NMI while we are already crashed and doing final preparations to jump
> to the new kernel.
> 
> Neil, is it possible to do some serial console debugging to find out
> where exactly we are hanging? Beats me, what's that operation which can
> not be executed while being in NMI handler and makes system to hang. I am
> also curious to know if it is nested NMI case.
> 
I can try, but my last attempts to do so fuond me hung in various places in
purgatory or very early in head.S.  I'll try again though, to see if I can get
some consistency.

Neil


> Thanks
> Vivek
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec

-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@redhat.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
