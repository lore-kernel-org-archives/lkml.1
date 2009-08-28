Return-Path: <linux-kernel-owner+w=401wt.eu-S1751617AbZH1MHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617AbZH1MHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 08:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbZH1MHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 08:07:53 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54734 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211AbZH1MHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 08:07:52 -0400
Subject: Re: modules: Fix build error in the !CONFIG_KALLSYMS case
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Helge Deller <deller@gmx.de>
In-Reply-To: <20090828084456.GB3454@elte.hu>
References: <alpine.LFD.2.01.0908271805210.3218@localhost.localdomain>
	 <20090828084456.GB3454@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Aug 2009 08:07:49 -0400
Message-Id: <1251461269.4226.6.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-28 at 10:44 +0200, Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > James Bottomley (1):
> >       module: workaround duplicate section names
> 
> -tip testing found that this patch breaks the build on x86 if 
> CONFIG_KALLSYMS is disabled:
> 
>  kernel/module.c: In function ‘load_module’:
>  kernel/module.c:2367: error: ‘struct module’ has no member named ‘sect_attrs’
>  distcc[8269] ERROR: compile kernel/module.c on ph/32 failed
>  make[1]: *** [kernel/module.o] Error 1
>  make: *** [kernel] Error 2
>  make: *** Waiting for unfinished jobs....
> 
> Commit 1b364bf misses the fact that section attributes are only 
> built and dealt with if kallsyms is enabled. The patch below fixes 
> this.

Thanks for finding the bug.

> ( note, technically speaking this should depend on CONFIG_SYSFS as
>   well but this patch is correct too and keeps the #ifdef less
>   intrusive - in the KALLSYMS && !SYSFS case the code is a NOP. )

Agree with this, but there is a way of fixing it, see below.

> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/module.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index eccb561..b4016d1 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2355,8 +2355,10 @@ static noinline struct module *load_module(void __user *umod,
>  	if (err < 0)
>  		goto unlink;
>  	add_sect_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
> +#ifdef CONFIG_KALLSYMS
>  	if (mod->sect_attrs)
>  		add_notes_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
> +#endif

Rather than adding to the #ifdef litter in the file, isn't it better to
move the test to a section of it that's already ifdef'd?

This also fixes the problem of depending on CONFIG_SYSFS you mention.

James

---

diff --git a/kernel/module.c b/kernel/module.c
index eccb561..2d53718 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1274,6 +1274,10 @@ static void add_notes_attrs(struct module *mod, unsigned int nsect,
 	struct module_notes_attrs *notes_attrs;
 	struct bin_attribute *nattr;
 
+	/* failed to create section attributes, so can't create notes */
+	if (!mod->sect_attrs)
+		return;
+
 	/* Count notes sections and allocate structures.  */
 	notes = 0;
 	for (i = 0; i < nsect; i++)
@@ -2355,8 +2359,7 @@ static noinline struct module *load_module(void __user *umod,
 	if (err < 0)
 		goto unlink;
 	add_sect_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
-	if (mod->sect_attrs)
-		add_notes_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
+	add_notes_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
 
 	/* Get rid of temporary copy */
 	vfree(hdr);


