Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbZLXJkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbZLXJkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 04:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbZLXJkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 04:40:19 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44403 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbZLXJkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 04:40:18 -0500
Subject: Re: [PATCH] futex: Fix ZERO_PAGE cause infinite loop
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <20091224182630.3DCB.A69D9226@jp.fujitsu.com>
References: <20091224182630.3DCB.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Dec 2009 10:39:25 +0100
Message-ID: <1261647565.4937.177.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added tglx and dvhart to the CC.

On Thu, 2009-12-24 at 18:29 +0900, KOSAKI Motohiro wrote:
> This patch need both futex and zero-page developer's ack.
> ==========================================================
> 
> commit a13ea5b7 (mm: reinstate ZERO_PAGE) made the unfortunate regression.
> following test program never finish and waste 100% cpu time.
> 
> At the making commit 38d47c1b7 (rely on get_user_pages() for shared
> futexes). There isn't zero page in linux kernel. then, futex developers
> thought gup retry is safe. but we reinstated zero page later...
> 
> This patch fixes it.
> 
> futex-zero.c
> ---------------------------------------------------------------------
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <sys/mman.h>
>  #include <syscall.h>
>  #include <sys/time.h>
>  #include <sys/types.h>
>  #include <sys/stat.h>
>  #include <fcntl.h>
>  #include <unistd.h>
>  #include <errno.h>
>  #include <linux/futex.h>
>  #include <pthread.h>
> 
> int main(int argc, char **argv)
> {
>         long page_size;
>         int ret;
>         void *buf;
> 
>         page_size = sysconf(_SC_PAGESIZE);
> 
>         buf = mmap(NULL, page_size, PROT_READ|PROT_WRITE,
> 			MAP_PRIVATE|MAP_ANONYMOUS, 0, 0);
>         if (buf == (void *)-1) {
>                 perror("mmap error.\n");
>                 exit(1);
>         }
> 
>         fprintf(stderr, "futex wait\n");
>         ret = syscall( SYS_futex, buf, FUTEX_WAIT, 1, NULL, NULL, NULL);
>         if (ret != 0 && errno != EWOULDBLOCK) {
>                 perror("futex error.\n");
>                 exit(1);
>         }
>         fprintf(stderr, "futex_wait: ret = %d, errno = %d\n", ret, errno);
> 
>         return 0;
> }
> ---------------------------------------------------------------------
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Nick Piggin <npiggin@suse.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/mm.h |   16 ++++++++++++++++
>  kernel/futex.c     |    3 +++
>  mm/memory.c        |   14 --------------
>  3 files changed, 19 insertions(+), 14 deletions(-)


> diff --git a/kernel/futex.c b/kernel/futex.c
> index 8e3c3ff..79b89cc 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -254,6 +254,8 @@ again:
>  
>  	page = compound_head(page);
>  	lock_page(page);
> +	if (is_zero_pfn(page_to_pfn(page)))
> +		goto anon_key;
>  	if (!page->mapping) {
>  		unlock_page(page);
>  		put_page(page);
> @@ -268,6 +270,7 @@ again:
>  	 * the object not the particular process.
>  	 */
>  	if (PageAnon(page)) {
> + anon_key:
>  		key->both.offset |= FUT_OFF_MMSHARED; /* ref taken on mm */
>  		key->private.mm = mm;
>  		key->private.address = address;

Doesn't it make more sense to simply fail the futex op?

What I mean is, all (?) futex ops assume userspace actually wrote
something to the address in question to begin with, therefore it can
never be the zero page.

So it being the zero page means someone goofed up, and we should bail,
no?

