Return-Path: <linux-kernel-owner+w=401wt.eu-S1764128AbYBFXwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764128AbYBFXwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759716AbYBFXwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:52:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760120AbYBFXwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:52:04 -0500
Date: Wed, 6 Feb 2008 18:50:47 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Neil Horman <nhorman@tuxdriver.com>,
       tglx@linutronix.de, mingo@redhat.com, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH], issue EOI to APIC prior to calling crash_kexec in
	die_nmi path
Message-ID: <20080206235047.GE11886@redhat.com>
References: <20080206192555.GA24910@hmsendeavour.rdu.redhat.com> <20080206220001.GA15155@elte.hu> <20080206224805.GD11886@redhat.com> <47AA3B16.7000507@zytor.com> <20080206233657.GB12393@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206233657.GB12393@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 12:36:57AM +0100, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> >> I am wondering if interrupts are disabled on crashing cpu or if 
> >> crashing cpu is inside die_nmi(), how would it stop/prevent delivery 
> >> of NMI IPI to other cpus.
> >
> > I don't see how it would.
> 
> cross-CPU IPIs are a bit fragile on some PC platforms. So if the kexec 
> code relies on getting IPIs to all other CPUs, it might not be able to 
> do it reliably. There might be limitations on how many APIC irqs there 
> can be queued at a time, and if those slots are used up and the CPU is 
> not servicing irqs then stuff gets retried. This might even affect NMIs 
> sent via APIC messages - not sure about that.

- Kexec code does not wait infinitely for destination cpu to respond to
  NMI. If destination cpu does not reposond in certain amount of time,
  execution continues. So even if NMI was not delivered to destination
  cpu kexec code should have continued. (Dangerous though, as we don't
  know what other cpu will be doing in the mean time.)

- Even if there is a limitation on how many interrupts can be queued up
  (including NMI), I am not sure how this patch will help that situation.
  This patch is not doing anything on destination cpu (assuming destination
  cpu is also not executing die_nmi() at the same time)

  In fact, even if other cpus are servicing die_nmi() they will end up
  spinning on kexec_lock inside crash_kexec().

I think there is more to this problem then just EOI stuff.

Thanks
Vivek
