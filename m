Return-Path: <linux-kernel-owner+w=401wt.eu-S1758881AbYFZSCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881AbYFZSCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884AbYFZSBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:01:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:29981 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbYFZSBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:01:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UQcJ+JjHTsDQJAJIXKMEmMTDKqYbCPNSeMzXJqTI5l5sUsbSJ0FovDuOtb84mGbOn9
         dN2b53u6PRVrO/qUSIOviPZAbo0zaFAyzuUGTC9JNU80CGS47gF4v/OmqJfpoheMApqm
         8x2mKNFYq+5nPDnGj3+RJa2mR6xJI5col6u0w=
Message-ID: <86802c440806261101k78c5057id8ca0649188bd132@mail.gmail.com>
Date: Thu, 26 Jun 2008 11:01:12 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: akataria@vmware.com
Subject: Re: [PATCH 1/2] cleanup e820_setup_gap v2
Cc: "Ingo Molnar" <mingo@elte.hu>, "lenb@kernel.org" <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "the arch/x86 maintainers" <x86@kernel.org>
In-Reply-To: <1214416962.27577.74.camel@promb-2n-dhcp368.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214333310.27577.26.camel@promb-2n-dhcp368.eng.vmware.com>
	 <20080625160817.GC24967@elte.hu>
	 <1214416962.27577.74.camel@promb-2n-dhcp368.eng.vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 11:02 AM, Alok Kataria <akataria@vmware.com> wrote:
> On Wed, 2008-06-25 at 09:08 -0700, Ingo Molnar wrote:
>> * Alok Kataria <akataria@vmware.com> wrote:
>>
>> > This is a preparatory patch for the next patch in series.
>> > Moves some code from e820_setup_gap to a new function e820_search_gap.
>> > This patch is a part of a bug fix where we walk the ACPI table to calculate
>> > a gap for PCI optional devices.
>> >
>> > v1->v2: Patch on top of tip/master.
>> >       Fixes a bug introduced in the last patch about the typeof "last".
>> >       Also the new function e820_search_gap now returns if we found a gap in
>> >       e820_map.
>>
>> applied to tip/x86/setup-memory - thanks Alok.
>
> Hi Ingo,
>
> As mentioned in this mail,
> http://marc.info/?l=linux-kernel&m=121441312409978&w=2
>
> I have also added a end_addr parameter to e820_search_gap to search only
> till the CRS objects end_addr instead of 2^32. In the normal case via
> e820_setup_gap we search till 2^32.
>
> Please apply this too.
> Patch on top of tip/master
> --
>
> e820_search_gap also take a end_addr parameter to limit search from
> start_addr to end_addr.
>
> Signed-off-by: AloK N Kataria <akataria@vmware.com>

Acked-by: Yinghai Lu <yhlu.kernel@gmail.com>

>
> Index: linux-x86-tree.git/arch/x86/kernel/e820.c
> ===================================================================
> --- linux-x86-tree.git.orig/arch/x86/kernel/e820.c      2008-06-25 10:05:21.000000000 -0700
> +++ linux-x86-tree.git/arch/x86/kernel/e820.c   2008-06-25 10:07:30.000000000 -0700
> @@ -486,17 +486,19 @@
>        printk(KERN_INFO "modified physical RAM map:\n");
>        e820_print_map("modified");
>  }
> -
> +#define MAX_GAP_END 0x100000000ull
>  /*
> - * Search for a gap in the e820 memory space from start_addr to 2^32.
> + * Search for a gap in the e820 memory space from start_addr to end_addr.
>  */
>  __init int e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
> -               unsigned long start_addr)
> +               unsigned long start_addr, unsigned long long end_addr)
>  {
> -       unsigned long long last = 0x100000000ull;
> +       unsigned long long last;
>        int i = e820.nr_map;
>        int found = 0;
>
> +       last = (end_addr && end_addr < MAX_GAP_END) ? end_addr : MAX_GAP_END;
> +
>        while (--i >= 0) {
>                unsigned long long start = e820.map[i].addr;
>                unsigned long long end = start + e820.map[i].size;
> @@ -536,7 +538,7 @@
>
>        gapstart = 0x10000000;
>        gapsize = 0x400000;
> -       found  = e820_search_gap(&gapstart, &gapsize, 0);
> +       found  = e820_search_gap(&gapstart, &gapsize, 0, MAX_GAP_END);
>
>  #ifdef CONFIG_X86_64
>        if (!found) {
> Index: linux-x86-tree.git/include/asm-x86/e820.h
> ===================================================================
> --- linux-x86-tree.git.orig/include/asm-x86/e820.h      2008-06-25 10:05:21.000000000 -0700
> +++ linux-x86-tree.git/include/asm-x86/e820.h   2008-06-25 10:06:17.000000000 -0700
> @@ -72,7 +72,7 @@
>  extern void update_e820(void);
>  extern void e820_setup_gap(void);
>  extern int e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
> -                               unsigned long start_addr);
> +                       unsigned long start_addr, unsigned long long end_addr);
>  struct setup_data;
>  extern void parse_e820_ext(struct setup_data *data, unsigned long pa_data);
>
>
>
>
>
