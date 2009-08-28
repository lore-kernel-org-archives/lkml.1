Return-Path: <linux-kernel-owner+w=401wt.eu-S1751532AbZH1JWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbZH1JWH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 05:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbZH1JWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 05:22:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:14274 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbZH1JWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 05:22:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Wapag0VjvCK/TOYXrZBVmzhsQXRvfP1maJNT/Z3qdaYQ4YOFFSWf90BeNE9nqotcvt
         LqLIRhGo6VrgTKwakgJaabooJxIez6RylRN5RaGuwhvjARZYGOK28JxX3ne/7pruXBC4
         52XALPM1yAIgrl1P1NUuuip5nlwXWwkoeAk9s=
Date: Fri, 28 Aug 2009 17:24:26 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Helge Deller <deller@gmx.de>
Subject: Re: modules: Fix build error in the !CONFIG_KALLSYMS case
Message-ID: <20090828092426.GC4849@cr0.nay.redhat.com>
References: <alpine.LFD.2.01.0908271805210.3218@localhost.localdomain> <20090828084456.GB3454@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090828084456.GB3454@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 28, 2009 at 10:44:56AM +0200, Ingo Molnar wrote:
>
>* Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> James Bottomley (1):
>>       module: workaround duplicate section names
>
>-tip testing found that this patch breaks the build on x86 if 
>CONFIG_KALLSYMS is disabled:
>
> kernel/module.c: In function ‘load_module’:
> kernel/module.c:2367: error: ‘struct module’ has no member named ‘sect_attrs’
> distcc[8269] ERROR: compile kernel/module.c on ph/32 failed
> make[1]: *** [kernel/module.o] Error 1
> make: *** [kernel] Error 2
> make: *** Waiting for unfinished jobs....
>


Ouch..

>Commit 1b364bf misses the fact that section attributes are only 
>built and dealt with if kallsyms is enabled. The patch below fixes 
>this.
>
>( note, technically speaking this should depend on CONFIG_SYSFS as
>  well but this patch is correct too and keeps the #ifdef less
>  intrusive - in the KALLSYMS && !SYSFS case the code is a NOP. )
>
>Signed-off-by: Ingo Molnar <mingo@elte.hu>


I reviewed that patch. This one looks fine.

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>


Thanks!



>---
> kernel/module.c |    2 ++
> 1 files changed, 2 insertions(+), 0 deletions(-)
>
>diff --git a/kernel/module.c b/kernel/module.c
>index eccb561..b4016d1 100644
>--- a/kernel/module.c
>+++ b/kernel/module.c
>@@ -2355,8 +2355,10 @@ static noinline struct module *load_module(void __user *umod,
> 	if (err < 0)
> 		goto unlink;
> 	add_sect_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
>+#ifdef CONFIG_KALLSYMS
> 	if (mod->sect_attrs)
> 		add_notes_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
>+#endif
> 
> 	/* Get rid of temporary copy */
> 	vfree(hdr);
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
