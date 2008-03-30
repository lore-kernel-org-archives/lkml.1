Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbYC3UmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbYC3UmE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 16:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbYC3Ulx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 16:41:53 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:33369 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbYC3Ulx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 16:41:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=icssPFBXiwIZ8lbwadX/zT3jFOxv6FAWqEDR6v+sneHVOTOyNmXssf0wojYsmSxe2qZ3/3C8YvbfI5909l3CSO7uGSN9ugKxrjgC9XxilMSY4SBUiHw+5muL4ctFFFEdw32hvPWSIPEuCkNP5lb/xTDXFCTjZUS7aGGh4hsDyRI=
Message-ID: <86802c440803301341i5d116b0en362a51f6d8550482@mail.gmail.com>
Date: Sun, 30 Mar 2008 13:41:52 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jack Steiner" <steiner@sgi.com>
Subject: Re: [RFC 8/8] x86_64: Support for new UV apic
Cc: mingo@elte.hu, tglx@linutronix.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080324182122.GA28327@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080324182122.GA28327@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2008 at 11:21 AM, Jack Steiner <steiner@sgi.com> wrote:
>
>  UV supports really big systems. So big, in fact, that the APICID register
>  does not contain enough bits to contain an APICID that is unique across all
>  cpus.
>
>  The UV BIOS supports 3 APICID modes:
>
>         - legacy mode. This mode uses the old APIC mode where
>           APICID is in bits [31:24] of the APICID register.
>
>         - x2apic mode. This mode is whitebox-compatible. APICIDs
>           are unique across all cpus. Standard x2apic APIC operations
>           (Intel-defined) can be used for IPIs. The node identifier
>           fits within the Intel-defined portion of the APICID register.
>
>         - x2apic-uv mode. In this mode, the APICIDs on each node have
>           unique IDs, but IDs on different node are not unique. For example,
>           if each mode has 32 cpus, the APICIDs on each node might be
>           0 - 31. Every node has the same set of IDs.
>           The UV hub is used to route IPIs/interrupts to the correct node.
>           Traditional APIC operations WILL NOT WORK.
>
>  In x2apic-uv mode, the ACPI tables all contain a full unique ID (note:
>  exact bit layout still changing but the following is close):
>
>         nnnnnnnnnnlc0cch
>                 n = unique node number
>                 l = socket number on board
>                 c = core
>                 h = hyperthread
>
>  Only the "lc0cch" bits are written to the APICID register. The remaining bits are
>  supplied by having the get_apic_id() function "OR" the extra bits into the value
>  read from the APICID register. (Hmmm.. why not keep the ENTIRE APICID register
>  in per-cpu data....)
>
>  The x2apic-uv mode is recognized by the MADT table containing:
>           oem_id = "SGI"
>           oem_table_id = "UV-X"
>
>
>  (NOTE: a work-in-progress. Pieces missing....)
>
>
>         Signed-off-by: Jack Steiner <steiner@sgi.com>
>
>  ---
>   arch/x86/kernel/Makefile         |    2
>   arch/x86/kernel/genapic_64.c     |   15 +
>   arch/x86/kernel/genx2apic_uv_x.c |  305 +++++++++++++++++++++++++++++++++++++++
>   arch/x86/kernel/setup64.c        |    4
>   arch/x86/kernel/smpboot_64.c     |    7
>   include/asm-x86/genapic_64.h     |    5
>   6 files changed, 335 insertions(+), 3 deletions(-)
>
>  Index: linux/arch/x86/kernel/genapic_64.c
>  ===================================================================
>  --- linux.orig/arch/x86/kernel/genapic_64.c     2008-03-21 15:37:05.000000000 -0500
>  +++ linux/arch/x86/kernel/genapic_64.c  2008-03-21 15:49:38.000000000 -0500
>  @@ -30,6 +30,7 @@ u16 x86_cpu_to_apicid_init[NR_CPUS] __in
>   void *x86_cpu_to_apicid_early_ptr;
>   DEFINE_PER_CPU(u16, x86_cpu_to_apicid) = BAD_APICID;
>   EXPORT_PER_CPU_SYMBOL(x86_cpu_to_apicid);
>  +DEFINE_PER_CPU(int, x2apic_extra_bits);
>
>   struct genapic __read_mostly *genapic = &apic_flat;
>
>  @@ -40,6 +41,9 @@ static enum uv_system_type uv_system_typ
>   */
>   void __init setup_apic_routing(void)
>   {
>  +       if (uv_system_type == UV_NON_UNIQUE_APIC)
>  +               genapic = &apic_x2apic_uv_x;
>  +       else
>   #ifdef CONFIG_ACPI
>         /*
>          * Quirk: some x86_64 machines can only use physical APIC mode
>  @@ -69,7 +73,16 @@ void send_IPI_self(int vector)
>
>   unsigned int get_apic_id(void)
>   {
>  -       return (apic_read(APIC_ID) >> 24) & 0xFFu;
>  +       unsigned int id;
>  +
>  +       preempt_disable();
>  +       id = apic_read(APIC_ID);
>  +       if (uv_system_type >= UV_X2APIC)
>  +               id  |= __get_cpu_var(x2apic_extra_bits);
>  +       else
>  +               id = (id >> 24) & 0xFFu;;
>  +       preempt_enable();
>  +       return id;
>

you can not shift id here.

GET_APIC_ID will shift that again.

you apic id will be 0 for all cpu

YH
