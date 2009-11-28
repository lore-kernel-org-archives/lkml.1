Return-Path: <linux-kernel-owner+w=401wt.eu-S1753501AbZK1AUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbZK1AUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 19:20:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbZK1AUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 19:20:30 -0500
Received: from gate.crashing.org ([63.228.1.57]:60315 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbZK1AUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 19:20:30 -0500
Subject: Re: [PATCH v3 16/27] PPC: use helpers for rlimits
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jirislaby@gmail.com, mingo@elte.hu, nhorman@tuxdriver.com,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, marcin.slusarz@gmail.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, torvalds@linux-foundation.org,
       oleg@redhat.com, James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
In-Reply-To: <1259363167-9347-16-git-send-email-jslaby@suse.cz>
References: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
	 <1259363167-9347-16-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 28 Nov 2009 11:19:17 +1100
Message-ID: <1259367557.2076.11.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-11-28 at 00:05 +0100, Jiri Slaby wrote:
> Make sure compiler won't do weird things with limits. E.g. fetching
> them twice may return 2 different values after writable limits are
> implemented.
> 
> I.e. either use newly added rlimit helpers or ACCESS_ONCE if not
> applicable.

Thanks. I have that already queued up.

Cheers,
Ben.

> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: James Morris <jmorris@namei.org>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: linuxppc-dev@ozlabs.org
> ---
>  arch/powerpc/mm/mmap_64.c                    |    4 ++--
>  arch/powerpc/platforms/cell/spufs/coredump.c |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/mm/mmap_64.c b/arch/powerpc/mm/mmap_64.c
> index 0d957a4..8df1299 100644
> --- a/arch/powerpc/mm/mmap_64.c
> +++ b/arch/powerpc/mm/mmap_64.c
> @@ -47,7 +47,7 @@ static inline int mmap_is_legacy(void)
>  	if (current->personality & ADDR_COMPAT_LAYOUT)
>  		return 1;
>  
> -	if (current->signal->rlim[RLIMIT_STACK].rlim_cur == RLIM_INFINITY)
> +	if (rlim_get_cur(RLIMIT_STACK) == RLIM_INFINITY)
>  		return 1;
>  
>  	return sysctl_legacy_va_layout;
> @@ -77,7 +77,7 @@ static unsigned long mmap_rnd(void)
>  
>  static inline unsigned long mmap_base(void)
>  {
> -	unsigned long gap = current->signal->rlim[RLIMIT_STACK].rlim_cur;
> +	unsigned long gap = rlim_get_cur(RLIMIT_STACK);
>  
>  	if (gap < MIN_GAP)
>  		gap = MIN_GAP;
> diff --git a/arch/powerpc/platforms/cell/spufs/coredump.c b/arch/powerpc/platforms/cell/spufs/coredump.c
> index c4d4a19..4ef1c92 100644
> --- a/arch/powerpc/platforms/cell/spufs/coredump.c
> +++ b/arch/powerpc/platforms/cell/spufs/coredump.c
> @@ -54,7 +54,7 @@ static ssize_t do_coredump_read(int num, struct spu_context *ctx, void *buffer,
>   */
>  static int spufs_dump_write(struct file *file, const void *addr, int nr, loff_t *foffset)
>  {
> -	unsigned long limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
> +	unsigned long limit = rlim_get_cur(RLIMIT_CORE);
>  	ssize_t written;
>  
>  	if (*foffset + nr > limit)


