Return-Path: <linux-kernel-owner+w=401wt.eu-S1760689AbYDCAoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760689AbYDCAoc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 20:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757783AbYDCAoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 20:44:21 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:18976 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757726AbYDCAoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 20:44:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KkuvD5jMJ4+jz9x5RabIov6C6r6V38qqdid/HxSYL92uhvQ9EUQ6ltfLiqmvOsBdTLtCSjvd3m1sLiccSgVW8GERkfiM1QEIvnpu6mFFu0bH3L5G0ccQFw9fdhYB6xgUgF5mcudTOBH8kdm0FoBjhik7U2qCOaZrx74VPHtOkqA=
Message-ID: <86802c440804021744m7c6e3d94vcb6af3ebcaa71b5b@mail.gmail.com>
Date: Wed, 2 Apr 2008 17:44:19 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: allocate usemap at first instead of mem_map in sparse_init
Cc: "Yinghai Lu" <yhlu.kernel.send@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Badari Pulavarty" <pbadari@us.ibm.com>, michael@ellerman.id.au,
       "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>,
       linuxppc-dev@ozlabs.org, "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080402155247.5e746be7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804021525.48799.yhlu.kernel@gmail.com>
	 <20080402155247.5e746be7.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2008 at 3:52 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Wed, 2 Apr 2008 15:25:48 -0700 Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:
>
>  > [PATCH] mm: allocate usemap at first instead of mem_map in sparse_init
>  >
>  > on powerpc,
>  >
>  > On Wed, Apr 2, 2008 at 12:22 PM, Badari Pulavarty <pbadari@us.ibm.com> wrote:
>  > >
>  > > On Wed, 2008-04-02 at 18:17 +1100, Michael Ellerman wrote:
>  > >  > On Wed, 2008-04-02 at 12:38 +0530, Kamalesh Babulal wrote:
>  > >  > > Andrew Morton wrote:
>  > >  > > > On Wed, 02 Apr 2008 11:55:36 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>  > >  > > >
>  > >  > > >> Hi Andrew,
>  > >  > > >>
>  > >  > > >> The 2.6.25-rc8-mm1 kernel panic's while bootup on the power machine(s).
>  > >  > > >>
>  > >  > > >> [    0.000000] ------------[ cut here ]------------
>  > >  > > >> [    0.000000] kernel BUG at arch/powerpc/mm/init_64.c:240!
>  > >  > > >> [    0.000000] Oops: Exception in kernel mode, sig: 5 [#1]
>  > >  > > >> [    0.000000] SMP NR_CPUS=32 NUMA PowerMac
>  > >  > > >> [    0.000000] Modules linked in:
>  > >  > > >> [    0.000000] NIP: c0000000003d1dcc LR: c0000000003d1dc4 CTR: c00000000002b6ac
>  > >  > > >> [    0.000000] REGS: c00000000049b960 TRAP: 0700   Not tainted  (2.6.25-rc8-mm1-autokern1)
>  > >  > > >> [    0.000000] MSR: 9000000000021032 <ME,IR,DR>  CR: 44000088  XER: 20000000
>  > >  > > >> [    0.000000] TASK = c0000000003f9c90[0] 'swapper' THREAD: c000000000498000 CPU: 0
>  > >  > > >> [    0.000000] GPR00: c0000000003d1dc4 c00000000049bbe0 c0000000004989d0 0000000000000001
>  > >  > > >> [    0.000000] GPR04: d59aca40f0000000 000000000b000000 0000000000000010 0000000000000000
>  > >  > > >> [    0.000000] GPR08: 0000000000000004 0000000000000001 c00000027e520800 c0000000004bf0f0
>  > >  > > >> [    0.000000] GPR12: c0000000004bf020 c0000000003fa900 0000000000000000 0000000000000000
>  > >  > > >> [    0.000000] GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
>  > >  > > >> [    0.000000] GPR20: 0000000000000000 0000000000000000 0000000000000000 4000000001400000
>  > >  > > >> [    0.000000] GPR24: 00000000017d64b0 c0000000003d6250 0000000000000000 c000000000504000
>  > >  > > >> [    0.000000] GPR28: 0000000000000000 cf000000001f8000 0000000001000000 cf00000000000000
>  > >  > > >> [    0.000000] NIP [c0000000003d1dcc] .vmemmap_populate+0xb8/0xf4
>  > >  > > >> [    0.000000] LR [c0000000003d1dc4] .vmemmap_populate+0xb0/0xf4
>  > >  > > >> [    0.000000] Call Trace:
>  > >  > > >> [    0.000000] [c00000000049bbe0] [c0000000003d1dc4] .vmemmap_populate+0xb0/0xf4 (unreliable)
>  > >  > > >> [    0.000000] [c00000000049bc70] [c0000000003d2ee8] .sparse_mem_map_populate+0x38/0x60
>  > >  > > >> [    0.000000] [c00000000049bd00] [c0000000003c242c] .sparse_early_mem_map_alloc+0x54/0x94
>  > >  > > >> [    0.000000] [c00000000049bd90] [c0000000003c250c] .sparse_init+0xa0/0x20c
>  > >  > > >> [    0.000000] [c00000000049be50] [c0000000003ab7d0] .setup_arch+0x1ac/0x218
>  > >  > > >> [    0.000000] [c00000000049bee0] [c0000000003a36ac] .start_kernel+0xe0/0x3fc
>  > >  > > >> [    0.000000] [c00000000049bf90] [c000000000008594] .start_here_common+0x54/0xc0
>  > >  > > >> [    0.000000] Instruction dump:
>  > >  > > >> [    0.000000] 7fe3fb78 7ca02a14 4082000c 3860fff4 4800003c e92289c8 e96289c0 e9090002
>  > >  > > >> [    0.000000] e8eb0002 4bc575cd 60000000 78630fe0 <0b030000> 7ffff214 7fbfe840 7fe3fb78
>  > >  > > >> [    0.000000] ---[ end trace 31fd0ba7d8756001 ]---
>  > >  > > >> [    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
>  > >
>  > >  mm-make-mem_map-allocation-continuous.patch
>  > >  and its friends in -mm.
>  > >
>  > >  You have to call sparse_init_one_section() on each pmap and usemap
>  > >  as we allocate - since valid_section() depends on it (which is needed
>  > >  by vmemmap_populate() to check if the section is populated or not).
>  > >  On ppc, we need to call htab_bolted_mapping() on each section and
>  > >  we need to skip existing sections.
>  > >
>  > >  These patches tried to group all allocations together and then later
>  > >  calls sparse_init_one_section() - which is not good :(
>  >
>  > so try to allocate usemap at first altogether.
>
>  I have to turn all the above crud into a proper changelog.  I'd prefer that
>  you do it.
>
>  Unless this patch should be folded into another one, in which case it
>  doesn't matter.
>
>
>  > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>  >
>  > diff --git a/mm/sparse.c b/mm/sparse.c
>  > index d3cb085..782ebe5 100644
>  > --- a/mm/sparse.c
>  > +++ b/mm/sparse.c
>
>  We shouldn't merge this patch on its own because then that will leave a
>  non-bisectable region in the powerpc history.
>
>  So which patch is this patch fixing?  Lexically it applies to
>  mm-allocate-section_map-for-sparse_init.patch (and its updates).  But is
>  that where it logically lies?

yes. we should fold

mm-make-mem_map-allocation-continuous.patch
mm-allocate-section_map-for-sparse_init.patch
and this one

to big one (not big really).

YH
