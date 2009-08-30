Return-Path: <linux-kernel-owner+w=401wt.eu-S1753035AbZH3AuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbZH3AuM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 20:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZH3AuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 20:50:12 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:19422 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbZH3AuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 20:50:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uAE5DrFrKq336LUfcdHFq1mcbiIvcQiDK94WcR/DO3TF7TT/xDxRCTrzqneXGWsOFy
         inpj+bok5L707dKtCOrrUu/WpvE1ef+tUl+VcPGbdvpE/fcOem+cmJICRRcrEyzw0Yf+
         1qSZgeSMcGo+wGkINz8V/FAiwp5ZwupLD9JU0=
Date: Sun, 30 Aug 2009 02:50:09 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH -tip tracing/kprobes 3/6] kprobes/x86: Fix to add
	__kprobes to in-kernel fault handing functions
Message-ID: <20090830005008.GA387@nowhere>
References: <20090827152539.GE6058@nowhere> <20090827172311.8246.92725.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827172311.8246.92725.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 01:23:11PM -0400, Masami Hiramatsu wrote:
> Add __kprobes to the functions which handles in-kernel fixable page faults.
> Since kprobes can cause those in-kernel page faults by accessing kprobe data
> structures, probing those fault functions will cause fault-int3-loop
> (do_page_fault has already been marked as __kprobes).
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
> 
>  arch/x86/mm/fault.c |   11 ++++++-----
>  1 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index bfae139..c322e59 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -38,7 +38,8 @@ enum x86_pf_error_code {
>   * Returns 0 if mmiotrace is disabled, or if the fault is not
>   * handled by mmiotrace:
>   */
> -static inline int kmmio_fault(struct pt_regs *regs, unsigned long addr)
> +static inline int __kprobes
> +kmmio_fault(struct pt_regs *regs, unsigned long addr)
>  {
>  	if (unlikely(is_kmmio_active()))
>  		if (kmmio_handler(regs, addr) == 1)


I guess the problem also resides in a lot of subfunctions such as kmmio_handler
and such...



> @@ -46,7 +47,7 @@ static inline int kmmio_fault(struct pt_regs *regs, unsigned long addr)
>  	return 0;
>  }
>  
> -static inline int notify_page_fault(struct pt_regs *regs)
> +static inline int __kprobes notify_page_fault(struct pt_regs *regs)
>  {
>  	int ret = 0;
>  
> @@ -239,7 +240,7 @@ void vmalloc_sync_all(void)
>   *
>   *   Handle a fault on the vmalloc or module mapping area
>   */
> -static noinline int vmalloc_fault(unsigned long address)
> +static noinline __kprobes int vmalloc_fault(unsigned long address)
>  {
>  	unsigned long pgd_paddr;
>  	pmd_t *pmd_k;
> @@ -361,7 +362,7 @@ void vmalloc_sync_all(void)
>   *
>   * This assumes no large pages in there.
>   */
> -static noinline int vmalloc_fault(unsigned long address)
> +static noinline __kprobes int vmalloc_fault(unsigned long address)
>  {
>  	pgd_t *pgd, *pgd_ref;
>  	pud_t *pud, *pud_ref;
> @@ -858,7 +859,7 @@ static int spurious_fault_check(unsigned long error_code, pte_t *pte)
>   * There are no security implications to leaving a stale TLB when
>   * increasing the permissions on a page.
>   */
> -static noinline int
> +static noinline __kprobes int
>  spurious_fault(unsigned long error_code, unsigned long address)
>  {
>  	pgd_t *pgd;
> 
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America), Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com

