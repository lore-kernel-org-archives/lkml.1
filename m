Return-Path: <linux-kernel-owner+w=401wt.eu-S1751879AbZJWVwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbZJWVwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 17:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbZJWVwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 17:52:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57979 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbZJWVwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 17:52:44 -0400
Date: Fri, 23 Oct 2009 23:52:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Marti Raudsepp <marti@juffo.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: add compatibility with libelf 0.8 and
	autodetect
Message-ID: <20091023215239.GB29403@elte.hu>
References: <1256330234-14079-1-git-send-email-marti@juffo.org> <20091023210231.GC8356@elte.hu> <1256334501-15755-1-git-send-email-marti@juffo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256334501-15755-1-git-send-email-marti@juffo.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Marti Raudsepp <marti@juffo.org> wrote:

> On Sat, Oct 24, 2009 at 12:02 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > Mind doing a small change:
> >
> > I think we want a small cleanup here: a perf_elf_begin() wrapper in a
> > header file to hide this #ifdef. (That's how Git wraps environmental
> > libraries as well.)
> 
> Ok, does this patch do what you had in mind? I wasn't quite sure how to
> implement; changing the cmd behind someone's back might be considered
> surprising.
> 
> Another take would be to #define our own ELF_C_READ_MMAP, but that would be
> lying, too...
> 
> > Also, this would be an urgent fix for v2.6.32 too, to make perf build on
> > Arch Linux, agreed?
> 
> Hopefully :)
> 
> Regards,
> Marti
> 
> 
> [PATCH] perf tools: add compatibility with libelf 0.8 and autodetect
> 
> The Makefile now automatically defines LIBELF_NO_MMAP when libelf 0.8 is
> detected. libelf 0.8 is still maintained and some distributions such as
> Arch Linux use it instead of elfutils.
> 
> Signed-off-by: Marti Raudsepp <marti@juffo.org>
> ---
>  tools/perf/Makefile      |    6 +++++-
>  tools/perf/util/symbol.c |    9 +++++----
>  tools/perf/util/symbol.h |   11 +++++++++++
>  3 files changed, 21 insertions(+), 5 deletions(-)
> 
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
> index 47ea060..ec69c42 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -5,7 +5,6 @@
>  
>  #include "debug.h"
>  
> -#include <libelf.h>
>  #include <gelf.h>
>  #include <elf.h>
>  
> @@ -413,7 +412,8 @@ static int dso__synthesize_plt_symbols(struct  dso *self, int v)
>  	if (fd < 0)
>  		goto out;
>  
> -	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
> +	elf = perf_elf_begin(fd, ELF_C_READ, NULL);
> +
>  	if (elf == NULL)
>  		goto out_close;
>  
> @@ -533,7 +533,8 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
>  	Elf *elf;
>  	int nr = 0, kernel = !strcmp("[kernel]", self->name);
>  
> -	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
> +	elf = perf_elf_begin(fd, ELF_C_READ, NULL);
> +
>  	if (elf == NULL) {
>  		if (v)
>  			fprintf(stderr, "%s: cannot read %s ELF file.\n",
> @@ -675,7 +676,7 @@ static char *dso__read_build_id(struct dso *self, int v)
>  	if (fd < 0)
>  		goto out;
>  
> -	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
> +	elf = perf_elf_begin(fd, ELF_C_READ, NULL);
>  	if (elf == NULL) {
>  		if (v)
>  			fprintf(stderr, "%s: cannot read %s ELF file.\n",
> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
> index 6e84907..50750e9 100644
> --- a/tools/perf/util/symbol.h
> +++ b/tools/perf/util/symbol.h
> @@ -8,6 +8,8 @@
>  #include "module.h"
>  #include "event.h"
>  
> +#include <libelf.h>
> +
>  #ifdef HAVE_CPLUS_DEMANGLE
>  extern char *cplus_demangle(const char *, int);
>  
> @@ -27,6 +29,15 @@ static inline char *bfd_demangle(void __used *v, const char __used *c,
>  #endif
>  #endif
>  
> +static inline Elf *perf_elf_begin(int fd, Elf_Cmd cmd, Elf *ref)
> +{
> +#ifndef LIBELF_NO_MMAP
> +        if (cmd == ELF_C_READ)
> +          cmd = ELF_C_READ_MMAP;
> +#endif
> +        return elf_begin(fd, cmd, ref);
> +}
> +
>  #ifndef DMGL_PARAMS
>  #define DMGL_PARAMS      (1 << 0)       /* Include function args */
>  #define DMGL_ANSI        (1 << 1)       /* Include const, volatile, etc */

Looks nice!

Mind adding a comment as well to document the version dependency?

Also, there's a few probably unintended whitespaces in the patch not 
matching surrounding style (which is the kernel coding style) - please 
run the patch through scripts/checkpatch.pl.

	Ingo
