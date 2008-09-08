Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbYIHKbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbYIHKbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 06:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbYIHKa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 06:30:58 -0400
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:37094 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752448AbYIHKa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 06:30:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=x/sBWLNmhphqaWt4tgQG1fGtvCX2/BJF1pobKDlzLUQ1tcsnXmRdY9deq3BCM41cVnth3079D1mSXR98p5yUK8GopA+Y3vWDZNExCfg7i05bju/j5APGiNaP9zyqeV5MknKUDJDlAI6cJ2JywVjfHOjfRcKLjIL/c8dMDa1T4Ik=  ;
X-YMail-OSG: WQfL4TAVM1lq.27KUy2WXDVZcEkpRJcoKT1GZrVxAYemU3f990Bu.Ze1aEhcQjKLHEZDvPm62T7Ir3_3n8t4qxdtZulYaWpBCAhv.JBXzF5r3opkpHrb3Qu_v_UXzMO.pLegqzHFLHAvRkpXG9lPbvWA
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 0/3] smp: reduce stack requirements =?iso-8859-1?q?for=09smp=5Fcall=5Ffunction=5Fmask?=
Date: Mon, 8 Sep 2008 20:30:41 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, Jes Sorensen <jes@sgi.com>,
       David Miller <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <20080905214019.821172000@polaris-admin.engr.sgi.com> <20080906132944.GC4910@elte.hu> <48C2C810.3070809@sgi.com>
In-Reply-To: <48C2C810.3070809@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809082030.41987.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 September 2008 04:12, Mike Travis wrote:
> Ingo Molnar wrote:
> > * Mike Travis <travis@sgi.com> wrote:
> >>   * Cleanup cpumask_t usages in smp_call_function_mask function chain
> >>     to prevent stack overflow problem when NR_CPUS=4096.
> >>
> >>   * Reduce the number of passed cpumask_t variables in the following
> >>     call chain for x86_64:
> >>
> >> 	smp_call_function_mask -->
> >> 	    arch_send_call_function_ipi->
> >> 		    smp_ops.send_call_func_ipi -->
> >> 			    genapic->send_IPI_mask
> >>
> >>     Since the smp_call_function_mask() is an EXPORTED function, we
> >>     cannot change it's calling interface for a patch to 2.6.27.
> >>
> >>     The smp_ops.send_call_func_ipi interface is internal only and
> >>     has two arch provided functions:
> >>
> >> 	arch/x86/kernel/smp.c:  .send_call_func_ipi = native_send_call_func_ipi
> >> 	arch/x86/xen/smp.c:     .send_call_func_ipi =
> >> xen_smp_send_call_function_ipi arch/x86/mach-voyager/voyager_smp.c:   
> >> (uses native_send_call_func_ipi)
> >>
> >>     Therefore modifying the internal interface to use a cpumask_t
> >> pointer is straight-forward.
> >>
> >>     The changes to genapic are much more extensive and are affected by
> >> the recent additions of the x2apic modes, so they will be done for
> >> 2.6.28 only.
> >>
> >> Based on 2.6.27-rc5-git6.
> >>
> >> Applies to linux-2.6.tip/master (with FUZZ).
> >
> > applied to tip/cpus4096, thanks Mike.
>
> Thanks Ingo!  Could you send me the git id for the merge?
>
> > I'm still wondering whether we should get rid of non-reference based
> > cpumask_t altogether ...
>
> I've got a whole slew of "get-ready-to-remove-cpumask_t's" coming soon.
> There are two phases, one completely within the x86 arch and the 2nd hits
> the generic smp_call_function_mask ABI (won't be doable as a back-ported
> patch to 2.6.27.)
>
> > Did you have a chance to look at the ftrace/stacktrace tracer in latest
> > tip/master, which will show the maximum stack footprint that can occur?
>
> Hmm, no.  I'm using a default config right now as I can boot that pretty
> easily.  I'll turn on the ftrace thing and check it out.
>
> > Also, i've applied the patch below as well to restore MAXSMP in a muted
> > form - with big warning signs added as well.
>
> The main thing is to allow the distros to set it manually for their QA
> testing of 2.6.27.  I'm sure I'll get back bugs because of just that.
>
> (Is there a way to have them know to assign bugzilla's to me if NR_CPUS=4k
> is the root of the problem?  This is an extremely serious issue for SGI
> and I'd like to avoid any delays in me finding out about problems.)

Considering that, unless I'm mistaken, you want to run production systems
with 4096 CPUs at some point, then I would say you should really consider
increasing NR_CPUS _further_ than that in QA efforts, so that we might be
a bit more confident of running production kernels with 4096.

Is that being tried? Setting it to 8192 or even higher during QA seems
like a good idea to me.
