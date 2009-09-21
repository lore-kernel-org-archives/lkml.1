Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430AbZIUOl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbZIUOl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 10:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755865AbZIUOl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 10:41:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:47782 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbZIUOl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 10:41:56 -0400
Message-ID: <4AB79091.1050004@kernel.org>
Date: Mon, 21 Sep 2009 23:41:21 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix error handling in load_module()
References: <20090907141558.GA5456@linux.vnet.ibm.com> <20090910141430.a00dcc94.akpm@linux-foundation.org>
In-Reply-To: <20090910141430.a00dcc94.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 21 Sep 2009 14:41:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

Andrew Morton wrote:
> My reverse engineering of the secret, undocumented percpu_modfree()
> indicates that its mad inventor intended that percpu_modfree(NULL) be a
> valid thing to do.
> 
> It calls free_percpu(), all implementations of which appear to secretly
> support free_percpu(NULL).

Eh... unfortunately, the original percpu_modfree() implementation
didn't seem to support it.

> So why did your machine crash?
> 
> This:
> 
> void free_percpu(void *ptr)
> {
> 	void *addr = __pcpu_ptr_to_addr(ptr);
> 	struct pcpu_chunk *chunk;
> 	unsigned long flags;
> 	int off;
> 
> 	if (!ptr)
> 		return;
> 
> is dangerous.  The implementation of __pcpu_ptr_to_addr() can be
> overridden by asm/percpu.h and there's no reason why the compiler won't
> choose to pass a NULL into __pcpu_ptr_to_addr().
> 
> But there doesn't appear to be any overriding of __pcpu_ptr_to_addr()
> in 2.6.31 and the default __pcpu_ptr_to_addr() looks like it will
> handle a NULL pointer OK.
> 
> So again, why did your machine crash?
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> __pcpu_ptr_to_addr() can be overridden by the architecture and might not
> behave well if passed a NULL pointer.  So avoid calling it until we have
> verified that its arg is not NULL.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/percpu.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff -puN mm/percpu.c~percpu-avoid-calling-__pcpu_ptr_to_addrnull mm/percpu.c
> --- a/mm/percpu.c~percpu-avoid-calling-__pcpu_ptr_to_addrnull
> +++ a/mm/percpu.c
> @@ -957,7 +957,7 @@ static void pcpu_reclaim(struct work_str
>   */
>  void free_percpu(void *ptr)
>  {
> -	void *addr = __pcpu_ptr_to_addr(ptr);
> +	void *addr;
>  	struct pcpu_chunk *chunk;
>  	unsigned long flags;
>  	int off;
> @@ -965,6 +965,8 @@ void free_percpu(void *ptr)
>  	if (!ptr)
>  		return;
>  
> +	addr = __pcpu_ptr_to_addr(ptr);
> +

__pcpu_ptr_to_addr() and reverse should be simple arithmetic
transformations.  The sole reason why it's defined as overridable was
mostly because I didn't know whether all archs could be unified to use
the same macro (and different variants were used early during
development) but yeap no harm in being careful.

Thanks.

-- 
tejun
