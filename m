Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575AbYCaBdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbYCaBdY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 21:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755335AbYCaBdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 21:33:07 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:2648 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbYCaBdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 21:33:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=M7iQ/R8684FJHOLMHwKF9H2Gjtj18jmmjuIxyyyDWkD4MO4nK8JPRqAhxjcxXfIRKLcjuV8HIUorAJEAE2Zk7gnG+4OBkINYqjTLAH8Otc5h2GVxAlnuN7TicFTruFNuF1O3UDlOHV/9JWaPV5fSKxujntqV4M0aXc6KHxlGS50=
Message-ID: <86802c440803301833r2229900cw99129515822dc373@mail.gmail.com>
Date: Sun, 30 Mar 2008 18:33:04 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jack Steiner" <steiner@sgi.com>, "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH 8/8] x86_64: Support for new UV apic
Cc: mingo@elte.hu, tglx@linutronix.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <86802c440803301622j2874ca56t51b52a54920a233b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080328191216.GA16455@sgi.com>
	 <86802c440803301622j2874ca56t51b52a54920a233b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2008 at 4:22 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
> On Fri, Mar 28, 2008 at 12:12 PM, Jack Steiner <steiner@sgi.com> wrote:
>  >
>  >  UV supports really big systems. So big, in fact, that the APICID register
>  >  does not contain enough bits to contain an APICID that is unique across all
>  >  cpus.
>  >
>  >  The UV BIOS supports 3 APICID modes:
>  >
>  >         - legacy mode. This mode uses the old APIC mode where
>  >           APICID is in bits [31:24] of the APICID register.
>  >
>  >         - x2apic mode. This mode is whitebox-compatible. APICIDs
>  >           are unique across all cpus. Standard x2apic APIC operations
>  >           (Intel-defined) can be used for IPIs. The node identifier
>  >           fits within the Intel-defined portion of the APICID register.
>  >
>  >         - x2apic-uv mode. In this mode, the APICIDs on each node have
>  >           unique IDs, but IDs on different node are not unique. For example,
>  >           if each mode has 32 cpus, the APICIDs on each node might be
>  >           0 - 31. Every node has the same set of IDs.
>  >           The UV hub is used to route IPIs/interrupts to the correct node.
>  >           Traditional APIC operations WILL NOT WORK.
>  >
>  >  In x2apic-uv mode, the ACPI tables all contain a full unique ID (note:
>  >  exact bit layout still changing but the following is close):
>  >
>  >         nnnnnnnnnnlc0cch
>  >                 n = unique node number
>  >                 l = socket number on board
>  >                 c = core
>  >                 h = hyperthread
>  >
>  >  Only the "lc0cch" bits are written to the APICID register. The remaining bits are
>  >  supplied by having the get_apic_id() function "OR" the extra bits into the value
>  >  read from the APICID register. (Hmmm.. why not keep the ENTIRE APICID register
>  >  in per-cpu data....)
>  >
>  >  The x2apic-uv mode is recognized by the MADT table containing:
>  >           oem_id = "SGI"
>  >           oem_table_id = "UV-X"
>  >
>  >  Based on:
>  >         git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
>  >
>  >  Signed-off-by: Jack Steiner <steiner@sgi.com>
>  >
>  >  ---
>  >   arch/x86/kernel/Makefile         |    2
>  >   arch/x86/kernel/apic_64.c        |    2
>  >   arch/x86/kernel/genapic_64.c     |   18 ++
>  >   arch/x86/kernel/genx2apic_uv_x.c |  245 +++++++++++++++++++++++++++++++++++++++
>  >   arch/x86/kernel/setup64.c        |    4
>  >   arch/x86/kernel/smpboot.c        |    5
>  >   include/asm-x86/genapic_64.h     |    5
>  >   include/asm-x86/smp.h            |    5
>  >   8 files changed, 285 insertions(+), 1 deletion(-)
>  >
>  >  Index: linux/arch/x86/kernel/genapic_64.c
>  >  ===================================================================
>  >  --- linux.orig/arch/x86/kernel/genapic_64.c     2008-03-28 13:06:07.000000000 -0500
>  >  +++ linux/arch/x86/kernel/genapic_64.c  2008-03-28 13:06:12.000000000 -0500
>  >  @@ -15,6 +15,7 @@
>  >   #include <linux/kernel.h>
>  >   #include <linux/ctype.h>
>  >   #include <linux/init.h>
>  >  +#include <linux/hardirq.h>
>  >
>  >   #include <asm/smp.h>
>  >   #include <asm/ipi.h>
>  >  @@ -32,6 +33,7 @@ void *x86_cpu_to_apicid_early_ptr;
>  >   #endif
>  >   DEFINE_PER_CPU(u16, x86_cpu_to_apicid) = BAD_APICID;
>  >   EXPORT_PER_CPU_SYMBOL(x86_cpu_to_apicid);
>  >  +DEFINE_PER_CPU(int, x2apic_extra_bits);
>  >
>  >   struct genapic __read_mostly *genapic = &apic_flat;
>  >
>  >  @@ -42,6 +44,9 @@ static enum uv_system_type uv_system_typ
>  >   */
>  >   void __init setup_apic_routing(void)
>  >   {
>  >  +       if (uv_system_type == UV_NON_UNIQUE_APIC)
>  >  +               genapic = &apic_x2apic_uv_x;
>  >  +       else
>  >   #ifdef CONFIG_ACPI
>  >         /*
>  >          * Quirk: some x86_64 machines can only use physical APIC mode
>  >  @@ -82,6 +87,19 @@ int __init acpi_madt_oem_check(char *oem
>  >         return 0;
>  >   }
>  >
>  >  +unsigned int read_apic_id(void)
>  >  +{
>  >  +       unsigned int id;
>  >  +
>  >  +       WARN_ON(preemptible());
>  >  +       id = apic_read(APIC_ID);
>  >  +       if (uv_system_type >= UV_X2APIC)
>  >  +               id  |= __get_cpu_var(x2apic_extra_bits);
>  >  +       else
>  >  +               id = (id >> 24) & 0xFFu;;
>  >  +       return id;
>  >  +}
>
>  so this is "the new one of Friday"?
>
>  it still wrong. you can not shit id here. ot broke all x86_64 smp.
>
>  Did you test it on non UV_X2APIC box?

anyway the read_apic_id is totally wrong, even for your UV_X2APIC box.
because id=apic_read(APIC_ID) will have apic_id at bits [31,24], and
id |= __get_cpu_var(x2apic_extra_bits) is assuming that is on bits [5,0]

so you even didn't test in your UV_X2APIC box!

YH
