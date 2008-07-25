Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbYGYUGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbYGYUGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 16:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbYGYUGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 16:06:17 -0400
Received: from relay2.sgi.com ([192.48.171.30]:53556 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751270AbYGYUGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 16:06:16 -0400
Message-ID: <488A3236.5070404@sgi.com>
Date: Fri, 25 Jul 2008 13:06:14 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>	<48691556.2080208@zytor.com> <48691E8B.4040605@sgi.com>	<m14p7asl3x.fsf@frodo.ebiederm.org> <48694B3B.3010600@goop.org>	<m1skuuov4t.fsf@frodo.ebiederm.org> <486A61A7.1000902@zytor.com>	<486A68DD.80702@goop.org> <m1d4lxgwxj.fsf@frodo.ebiederm.org>	<486A9D4F.8010508@goop.org> <m1skutffn4.fsf@frodo.ebiederm.org>	<486AA72B.6010401@goop.org> <486AC9D9.9030506@zytor.com>	<486AD6BD.9080600@sgi.com> <486ADD67.1020809@sgi.com>	<486ADD9F.3000305@zytor.com> <486C062C.3090408@sgi.com>	<m1wsk3r3g6.fsf@frodo.ebiederm.org> <48724FB4.3090305@sgi.com>	<m17ibxxytj.fsf@frodo.ebiederm.org> <4873B016.8010404@sgi.com> <m1r6a4c5im.fsf@frodo.ebiederm.org> <4873FD00.1060101@goop.org>
In-Reply-To: <4873FD00.1060101@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
...
> Last time it was doing this, it was a result of a triple-fault caused by
> loading %ds with an all-zero gdt.  I modified Xen to dump the CPU state
> on triple-faults, so it was easy to pinpoint.  I can do that again if it
> helps.
> 
>    J

Hi Jeremy,

There are two question marks for my patchset.  The first is in

arch/x86/xen/smp.c:xen_cpu_up()

287 #ifdef CONFIG_X86_64
288         /* Allocate node local memory for AP pdas */
289         WARN_ON(cpu == 0);
290         if (cpu > 0) {
291                 rc = get_local_pda(cpu);
292                 if (rc)
293                         return rc;
294         }
295 #endif

and the second is at:

arch/x86/xen/enlighten.c:xen_start_kernel()

1748 #ifdef CONFIG_X86_64
1749         /* Disable until direct per-cpu data access. */
1750         have_vcpu_info_placement = 0;
1751         x86_64_init_pda();
1752 #endif

I believe with the pda folded into the percpu area, get_local_pda()
and x86_64_init_pda() have been removed, so these are no longer
required, yes?

Also, arch/x86/kernel/acpi/sleep.c:acpi_save_state_mem() sets up
the startup code address with:

102         initial_code = (unsigned long)wakeup_long64;
103         saved_magic = 0x123456789abcdef0;

Should the pda and gdt_page address also be setup as is done in
smpboot.c:do_boot_cpu():

(CONFIG_X86_64)
 801         initial_pda = (unsigned long)get_cpu_pda(cpu);
 802 #endif
 803         early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
 804         initial_code = (unsigned long)start_secondary;


Thanks!
Mike
