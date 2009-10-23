Return-Path: <linux-kernel-owner+w=401wt.eu-S1752372AbZJWVCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbZJWVCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 17:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbZJWVCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 17:02:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37844 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbZJWVCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 17:02:41 -0400
Date: Fri, 23 Oct 2009 23:02:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Marti Raudsepp <marti@juffo.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: add compatibility with libelf 0.8 and
	autodetect
Message-ID: <20091023210231.GC8356@elte.hu>
References: <1256330234-14079-1-git-send-email-marti@juffo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256330234-14079-1-git-send-email-marti@juffo.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Marti Raudsepp <marti@juffo.org> wrote:

> The Makefile now automatically defines LIBELF_NO_MMAP when libelf 0.8 is
> detected. libelf 0.8 is still maintained and some distributions such as
> Arch Linux use it instead of elfutils.
> 
> Signed-off-by: Marti Raudsepp <marti@juffo.org>
> ---
>  tools/perf/Makefile      |    6 +++++-
>  tools/perf/util/symbol.c |   12 ++++++++++++
>  2 files changed, 17 insertions(+), 1 deletions(-)

Nice fix!

Mind doing a small change:

> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 742a32e..46e877b 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -422,7 +422,11 @@ ifeq ($(uname_S),Darwin)
>  	PTHREAD_LIBS =
>  endif
>  
> -ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
> +ifeq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
> +	ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
> +		BASIC_CFLAGS += -DLIBELF_NO_MMAP
> +	endif
> +else
>  	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel and glibc-dev[el]);
>  endif
>  
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index 47ea060..8d1df1e 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -413,7 +413,11 @@ static int dso__synthesize_plt_symbols(struct  dso *self, int v)
>  	if (fd < 0)
>  		goto out;
>  
> +#ifdef LIBELF_NO_MMAP
> +	elf = elf_begin(fd, ELF_C_READ, NULL);
> +#else
>  	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
> +#endif
>  	if (elf == NULL)
>  		goto out_close;
>  
> @@ -533,7 +537,11 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
>  	Elf *elf;
>  	int nr = 0, kernel = !strcmp("[kernel]", self->name);
>  
> +#ifdef LIBELF_NO_MMAP
> +	elf = elf_begin(fd, ELF_C_READ, NULL);
> +#else
>  	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
> +#endif
>  	if (elf == NULL) {
>  		if (v)
>  			fprintf(stderr, "%s: cannot read %s ELF file.\n",
> @@ -675,7 +683,11 @@ static char *dso__read_build_id(struct dso *self, int v)
>  	if (fd < 0)
>  		goto out;
>  
> +#ifdef LIBELF_NO_MMAP
> +	elf = elf_begin(fd, ELF_C_READ, NULL);
> +#else
>  	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
> +#endif
>  	if (elf == NULL) {
>  		if (v)
>  			fprintf(stderr, "%s: cannot read %s ELF file.\n",

I think we want a small cleanup here: a perf_elf_begin() wrapper in a 
header file to hide this #ifdef. (That's how Git wraps environmental 
libraries as well.)

Also, this would be an urgent fix for v2.6.32 too, to make perf build on 
Arch Linux, agreed?

	Ingo
