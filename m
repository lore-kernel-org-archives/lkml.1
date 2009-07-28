Return-Path: <linux-kernel-owner+w=401wt.eu-S1752962AbZG1DS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbZG1DS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 23:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbZG1DSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 23:18:25 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:64141 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbZG1DSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 23:18:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sKfcNGDUfp2hGLv7HgawlappGF1Jcj7XUd12Y/mPWn5i8Gs9IojLsMRGdzMqkzqM/o
         mnk3f5E36Df4mmXPFeuTgR3ilhqN8DGyrGUPc3NtVl1O90bjC76gzXOVzn/zD0fcvma0
         kppV4latANTZ4bpaBwUAqL36GqM9vzqa7sB2M=
Date: Tue, 28 Jul 2009 05:18:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 tip] perf top: Move hard coded list to
	/etc/perfconfig/symbols.skip
Message-ID: <20090728031820.GH5147@nowhere>
References: <20090728001041.GG28349@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090728001041.GG28349@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 09:10:41PM -0300, Arnaldo Carvalho de Melo wrote:
> This also paves the way to add more symbol lists to be filtered out,
> spinlock anyone?
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---



I guess it would be nice to also provide a way for non-privileged users
to tune it.

May be /etc/perfconfig/ and also ~/perfconfig/ ?




>  tools/perf/Makefile       |    6 ++++--
>  tools/perf/builtin-top.c  |   26 +++++++-------------------
>  tools/perf/util/strlist.c |   10 ++++++++--
>  3 files changed, 19 insertions(+), 23 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index a5e9b87..385a1bc 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -193,11 +193,10 @@ template_dir = share/perf-core/templates
>  htmldir = share/doc/perf-doc
>  ifeq ($(prefix),/usr)
>  sysconfdir = /etc
> -ETC_PERFCONFIG = $(sysconfdir)/perfconfig
>  else
>  sysconfdir = $(prefix)/etc
> -ETC_PERFCONFIG = etc/perfconfig
>  endif
> +ETC_PERFCONFIG = $(sysconfdir)/perfconfig
>  lib = lib
>  # DESTDIR=
>  
> @@ -596,6 +595,7 @@ PERL_PATH_SQ = $(subst ','\'',$(PERL_PATH))
>  LIBS = $(PERFLIBS) $(EXTLIBS)
>  
>  BASIC_CFLAGS += -DSHA1_HEADER='$(SHA1_HEADER_SQ)' \
> +		-DPERF_ETC_PATH='"$(ETC_PERFCONFIG)"' \
>  	$(COMPAT_CFLAGS)
>  LIB_OBJS += $(COMPAT_OBJS)
>  
> @@ -804,6 +804,8 @@ export perfexec_instdir
>  install: all
>  	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'
>  	$(INSTALL) perf$X '$(DESTDIR_SQ)$(bindir_SQ)'
> +	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(ETC_PERFCONFIG_SQ)'
> +	$(INSTALL) symbols.skip '$(DESTDIR_SQ)$(ETC_PERFCONFIG_SQ)'
>  ifdef BUILT_INS
>  	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
>  	$(INSTALL) $(BUILT_INS) '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index f139f1a..628ef29 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -20,6 +20,7 @@
>  
>  #include "perf.h"
>  
> +#include "util/strlist.h"
>  #include "util/symbol.h"
>  #include "util/color.h"
>  #include "util/util.h"
> @@ -279,24 +280,12 @@ static void *display_thread(void *arg __used)
>  }
>  
>  /* Tag samples to be skipped. */
> -static const char *skip_symbols[] = {
> -	"default_idle",
> -	"cpu_idle",
> -	"enter_idle",
> -	"exit_idle",
> -	"mwait_idle",
> -	"mwait_idle_with_hints",
> -	"ppc64_runlatch_off",
> -	"pseries_dedicated_idle_sleep",
> -	NULL
> -};
> +static struct strlist *skip_symbols;
>  
>  static int symbol_filter(struct dso *self, struct symbol *sym)
>  {
>  	static int filter_match;
> -	struct sym_entry *syme;
>  	const char *name = sym->name;
> -	int i;
>  
>  	/*
>  	 * ppc64 uses function descriptors and appends a '.' to the
> @@ -314,12 +303,9 @@ static int symbol_filter(struct dso *self, struct symbol *sym)
>  	    strstr(name, "_text_end"))
>  		return 1;
>  
> -	syme = dso__sym_priv(self, sym);
> -	for (i = 0; skip_symbols[i]; i++) {
> -		if (!strcmp(skip_symbols[i], name)) {
> -			syme->skip = 1;
> -			break;
> -		}
> +	if (strlist__has_entry(skip_symbols, name)) {
> +		struct sym_entry *syme = dso__sym_priv(self, sym);
> +		syme->skip = 1;
>  	}
>  
>  	if (filter_match == 1) {
> @@ -733,6 +719,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
>  	if (delay_secs < 1)
>  		delay_secs = 1;
>  
> +	skip_symbols = strlist__new(true, "file://" PERF_ETC_PATH "/symbols.skip");
> +
>  	parse_symbols();
>  
>  	/*
> diff --git a/tools/perf/util/strlist.c b/tools/perf/util/strlist.c
> index 7ad3817..d1d63f7 100644
> --- a/tools/perf/util/strlist.c
> +++ b/tools/perf/util/strlist.c
> @@ -104,8 +104,14 @@ void strlist__remove(struct strlist *self, struct str_node *sn)
>  
>  bool strlist__has_entry(struct strlist *self, const char *entry)
>  {
> -	struct rb_node **p = &self->entries.rb_node;
> -	struct rb_node *parent = NULL;
> +	struct rb_node **p;
> +	struct rb_node *parent;
> +
> +	if (self == NULL)
> +		return false;
> +
> +	p = &self->entries.rb_node;
> +	parent = NULL;
>  
>  	while (*p != NULL) {
>  		struct str_node *sn;
> -- 
> 1.6.2.5
> 

