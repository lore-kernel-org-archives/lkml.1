Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037Ab0BMUJX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 15:09:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:63923 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757962Ab0BMUJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 15:09:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,468,1262592000"; 
   d="scan'208";a="540552662"
Subject: Re: [PATCH] x86_64: allow sections that are recycled to set
 _PAGE_RW
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "rostedt@goodmis.org" <rostedt@goodmis.org>,
       "jeremy@goop.org" <jeremy@goop.org>
In-Reply-To: <1266030928-2126-2-git-send-email-konrad.wilk@oracle.com>
References: <1266030928-2126-1-git-send-email-konrad.wilk@oracle.com>
	 <1266030928-2126-2-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Sat, 13 Feb 2010 12:08:17 -0800
Message-Id: <1266091697.2677.64.camel@sbs-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad,

I don't think this patch is correct.

I am not sure if I understand why we see this failure in Xen. In native
case, we have two kernel mappings for 64bit kernel.

One is kernel text mapping:

ffffffff80000000 - ffffffffa0000000 (=512 MB)  kernel text mapping, from
phys 0

And another is:

ffff880000000000 - ffffc7ffffffffff (=64 TB) direct mapping of all phys.
memory

Checks in static_protections() ensure that we map the text mapping as
read-only (and don't bother about what permissions it uses for
underlying free pages that get freed in free_init_pages()). But the
kernel direct mappings for free pages will be RW and ensure that the
free pages can be read/written using the direct mapping.

The checks in static_protections() for kernel text mapping ensure that
we don't break the 2MB kernel text pages unnecessarily on 64bit kernels
(as it has performance implications). We should be fine as long as the
kernel identity mappings reflect the correct RW permissions.

But somehow this is working fine on native kernels but not on Xen pv
guest. Your patch will cause the performance issues that we are
addressing using the static protections checks. I will look at this more
detailed on tuesday.

thanks,
suresh

On Fri, 2010-02-12 at 20:15 -0700, Konrad Rzeszutek Wilk wrote:
> This fixes BUG: unable to handle kernel paging request at ffff8800013f4000
> 
>  IP: [<ffffffff8102bb0b>] free_init_pages+0xa3/0xcc
>  PGD 1611067 PUD 1615067 PMD 556b067 PTE 100000013f4025
> ...
>   [<ffffffff8102c2cb>] mark_rodata_ro+0x4a2/0x527
>   [<ffffffff810021a5>] init_post+0x2b/0x10e
> ...
> 
> On platforms where the pages to be recycled ("free") are 4KB (Xen PV guest).
> 
> In the mark_rodata_ro, we set the .text through .sdata section to RO,
> then for selective sections (.__stop___ex_table -> .__start_rodata)
> and (.__end_rodata -> ._sdata) set them to RW. The logic in
> static_protections forbids this and unsets the _PAGE_RW attribute.
> 
> This is not an issue if the sections to be recycled are in 2MB pages
> so on native platform this isn't seen.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/mm/pageattr.c |   13 +++++++++++--
>  1 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> index 1d4eb93..44ebcd7 100644
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -291,8 +291,17 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
>  	 */
>  	if (kernel_set_to_readonly &&
>  	    within(address, (unsigned long)_text,
> -		   (unsigned long)__end_rodata_hpage_align))
> -		pgprot_val(forbidden) |= _PAGE_RW;
> +		   (unsigned long)__end_rodata_hpage_align)) {
> +		/* When 'kernel_set_to_readonly', it is OK to set PAGE_RW
> +		 * on the ones that are being recycled by free_init_pages
> +		 * in mark_rodata_ro.
> +		 */
> +		if (!within(address, (unsigned long)&__stop___ex_table,
> +				(unsigned long)&__start_rodata) &&
> +		    !within(address, (unsigned long)&__end_rodata,
> +				(unsigned long)&_sdata))
> +			pgprot_val(forbidden) |= _PAGE_RW;
> +	}
>  #endif
>  
>  	prot = __pgprot(pgprot_val(prot) & ~pgprot_val(forbidden));

