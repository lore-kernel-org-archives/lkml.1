Return-Path: <linux-kernel-owner+w=401wt.eu-S1756716AbYKCRCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbYKCRCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 12:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755904AbYKCRCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 12:02:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60791 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755907AbYKCRCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 12:02:10 -0500
Date: Mon, 3 Nov 2008 15:01:15 -0200
From: Eduardo Habkost <ehabkost@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use BIOS reboot on Toshiba Portege 4000
Message-ID: <20081103170115.GC23893@blackpad>
References: <200810312118.45368.arvidjaar@mail.ru> <20081103090843.GI11730@elte.hu> <490ECC4D.9090704@redhat.com> <20081103133306.GZ23893@blackpad> <490F0DA3.4090108@redhat.com> <m1myggdbzg.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1myggdbzg.fsf@frodo.ebiederm.org>
X-Fnord: you can see the fnord
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2008 at 08:13:07AM -0800, Eric W. Biederman wrote:
> Avi Kivity <avi@redhat.com> writes:
> 
> > Eduardo Habkost wrote:
> >> We probably need to disable vmx on all CPUs, but emergency reboot skips
> >> native_smp_send_stop() (where we could hook a virt_disable call in).
> >>
> >> As relying on IPIs defeats the whole point of emergency_restart, a proper
> >> fix will need to use NMIs like the kdump code does.
> >>
> >
> > They should use the same code; they have a similar environment at entry and
> > reliability requirements for e_r are not greater than kdump's.
> 
> Just a sec.
> 
> I think we are confusing two issues here.
> 
> - Ordinary machine_restart which happens to call emergency_restart.
>   And is proceeded by machine_shutdown.
> 
> - And emergency_restart itself.
> 

I am considering only emergency_restart() itself, that simply reboots
the machine. All other cases should be calling the KVM reboot notifier,
that disables virtualization on all CPUs.


> To some extent I would be a lot happier if Alt-sysrq-r did what
> was necessary to get into a context where it can call machine_restart
> or even better kernel_restart().
> emergency_restart() is a nice idea but is broken by design.

Eliminating emergency_restart() looks good in theory, but can we
eliminate it on all cases? We need something for cases when we are on
a possibly-broken state and we want to reboot the machine as reliably
as possible.


> 
> That said.  If we can turn off vmx on that one processor.
> That should be enough for the cpu to triple fault and let
> the BIOS do what it needs to do on that cpu i.e. outb(magic, 0x92)
> and toggle a motherboard level reset?
> 
> If I read the earlier comments correctly the deep issue is
> that going through ACPI to reset systems is less reliable than
> doing it the classic way.

That's what Ingo suggested: instead of defaulting to ACPI reboot,
disable VMX before rebooting if needed and get back to a safer default.

That leads us to the NMI stuff: we need to disable VMX on all CPUs,
and we can't use IPIs if we are on a possibly-broken state.

-- 
Eduardo
