Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbYKKIQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbYKKIQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 03:16:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbYKKIPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 03:15:54 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:59827 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751717AbYKKIPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 03:15:53 -0500
Date: Tue, 11 Nov 2008 17:15:52 +0900
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: Takashi Iwai <tiwai@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix section type conflict in arch/ia64/xen/xen_pv_ops.c
Message-ID: <20081111081552.GA10955%yamahata@valinux.co.jp>
References: <s5h1vxou7gf.wl%tiwai@suse.de> <49133E11.8050607@goop.org> <20081106214848.GA3579@uranus.ravnborg.org> <s5hk5bazonk.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hk5bazonk.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 08:51:11AM +0100, Takashi Iwai wrote:
> At Thu, 6 Nov 2008 22:48:48 +0100,
> Sam Ravnborg wrote:
> > 
> > On Thu, Nov 06, 2008 at 10:57:21AM -0800, Jeremy Fitzhardinge wrote:
> > > Takashi Iwai wrote:
> > > >__initdata and const cannot be always a happy pair, as gcc-4.3.3 gives
> > > >the compile errors like:
> > > >
> > > >  arch/ia64/xen/xen_pv_ops.c:156: error: xen_init_ops causes a section 
> > > >  type conflict
> > > >  arch/ia64/xen/xen_pv_ops.c:340: error: xen_iosapic_ops causes a section 
> > > >  type conflict
> > > >
> > > >This patch simply removes const from data with __initdata.
> > > >  
> > > 
> > > Yeah, I've seen these sort of messages before, but I don't see why 
> > > there's an inherent problem with having const __initdata.
> > > 
> > > Sam?
> > 
> > The root problem here is that in some cases gcc will stuff this into
> > a section marked CONST and in other cases not.
> > So when we manually specify the section we better not mix const and
> > non-const stuff in the same section.
> > The problem is that it is very gcc dependent. I have with powerpc
> > seen that the same code was not put in CONST with a 32 bit build,
> > but with the 64 bit build it was.
> > The only cure was to remove the const and use initdata.
> > You can try to play with initconst - and it may work.
> > But you need to have pretty good build coverage to be sure.
> 
> OK, then my original patch should do right :)
> Do you guys see any problems with it?
> 
> Right now 2.6.28-rc kernel doesn't build, thus this is basically a
> regression.

I'm fine with the patch.

The above sounds x86 xen potentially has the same issue, though.

linux-2.6/arch/x86/xen $ grep __initdata *
enlighten.c:static const struct pv_info xen_info __initdata = {
enlighten.c:static const struct pv_init_ops xen_init_ops __initdata = {
enlighten.c:static const struct pv_time_ops xen_time_ops __initdata = {
enlighten.c:static const struct pv_cpu_ops xen_cpu_ops __initdata = {
enlighten.c:static const struct pv_apic_ops xen_apic_ops __initdata = {
enlighten.c:static const struct pv_mmu_ops xen_mmu_ops __initdata = {
enlighten.c:static const struct machine_ops __initdata xen_machine_ops = {
irq.c:static const struct pv_irq_ops xen_irq_ops __initdata = {
smp.c:static const struct smp_ops xen_smp_ops __initdata = {

thanks,
-- 
yamahata
