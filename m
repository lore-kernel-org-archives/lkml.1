Return-Path: <linux-kernel-owner+w=401wt.eu-S1753758AbYBPKqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbYBPKqt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 05:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbYBPKql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 05:46:41 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:54621 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbYBPKqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 05:46:40 -0500
Date: Sat, 16 Feb 2008 11:46:47 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] h8300 CONFIG_KALLSYMS fix
Message-ID: <20080216104647.GA11043@uranus.ravnborg.org>
References: <87abm1o2ck.wl%ysato@users.sourceforge.jp> <20080215223201.c0d08ce6.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080215223201.c0d08ce6.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 10:32:01PM -0800, Andrew Morton wrote:
> On Sat, 16 Feb 2008 01:13:47 -0500 Yoshinori Sato <ysato@users.sourceforge.jp> wrote:
> 
> > Please comment "C_SYMBOL_PREFIX".
> > 
> >  Makefile           |    3 ++-
> >  arch/h8300/Kconfig |    4 ++++
> >  2 files changed, 6 insertions(+), 1 deletions(-)
> > 
> > diff --git a/Makefile b/Makefile
> > index c162370..745e31f 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -751,7 +751,8 @@ endef
> >  # Generate .S file with all kernel symbols
> >  quiet_cmd_kallsyms = KSYM    $@
> >        cmd_kallsyms = $(NM) -n $< | $(KALLSYMS) \
> > -                     $(if $(CONFIG_KALLSYMS_ALL),--all-symbols) > $@
> > +                     $(if $(CONFIG_KALLSYMS_ALL),--all-symbols) \
> > +                     $(if $(CONFIG_C_SYMBOL_PREFIX),--symbol-prefix='_') > $@
> >  
> >  .tmp_kallsyms1.o .tmp_kallsyms2.o .tmp_kallsyms3.o: %.o: %.S scripts FORCE
> >  	$(call if_changed_dep,as_o_S)
> > diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
> > index 085dc6e..2804edd 100644
> > --- a/arch/h8300/Kconfig
> > +++ b/arch/h8300/Kconfig
> > @@ -87,6 +87,10 @@ config HZ
> >  	int
> >  	default 100
> >  
> > +config C_SYMBOL_PREFIX
> > +	bool
> > +	default y
> > +
> >  source "init/Kconfig"
> >  
> >  source "arch/h8300/Kconfig.cpu"
> > -- 

The intent with this patch is fine but we should go for
another implementation.

In arch/Kconfig we should put the general config symbol
that says if we use '_' or not - where the default is to
not use underscore.

Something like this:
diff --git a/arch/Kconfig b/arch/Kconfig
index 3d72dc3..f2928c5 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -29,3 +29,8 @@ config KPROBES

 config HAVE_KPROBES
        def_bool n
+
+# Architectures where binutils prefix C symbols with
+# underscore '_' shall select this symbol.
+config SYMBOL_C_PREFIX
+       bool


Then in the relevant architectures we should do a

 config H8300
+	select SYMBOL_C_PREFIX	# We prefix C symbols with '_'

And we should do this for all the relevant architectures:
blackfin, v850 springs to my mind.
For the other archs as separate patches via the respective
maintainers.

	Sam
