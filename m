Return-Path: <linux-kernel-owner+w=401wt.eu-S1762839AbYAYHqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762839AbYAYHqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761410AbYAYHc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:32:28 -0500
Received: from gw.goop.org ([64.81.55.164]:59091 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761401AbYAYHc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:32:27 -0500
Message-ID: <47999089.5080609@goop.org>
Date: Thu, 24 Jan 2008 23:32:25 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] x86: fix NX bit handling in change_page_attr
References: <1201240493.15972.43.camel@caritas-dev.intel.com>
In-Reply-To: <1201240493.15972.43.camel@caritas-dev.intel.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> This patch fixes a bug of change_page_attr/change_page_attr_addr on
> Intel i386/x86_64 CPUs.  After changing page attribute to be
> executable with these functions, the page remains un-executable on
> Intel i386/x86_64 CPU.  Because on Intel i386/x86_64 CPU, only if the
> "NX" bits of all three level page tables are cleared (PAE is enabled),
> the corresponding page is executable (refer to section 4.13.2 of Intel
> 64 and IA-32 Architectures Software Developer's Manual).  So, the bug
> is fixed through clearing the "NX" bit of PMD when splitting the huge
> PMD.
>
> Signed-off-by: Huang Ying <ying.huang@intel.com>
>
> ---
>  arch/x86/mm/pageattr.c |    1 +
>  1 file changed, 1 insertion(+)
>
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -124,6 +124,7 @@ static int split_large_page(pte_t *kpte,
>  	/*
>  	 * Install the new, split up pagetable:
>  	 */
> +	pgprot_val(ref_prot) &= ~_PAGE_NX;
>   

I don't think its a good idea to treat pgprot_val() as an lvalue - it 
precludes it from being turned into an inline function.  I know there 
are numerous other places which do, but we should avoid making it worse.

    J
