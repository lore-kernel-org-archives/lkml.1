Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbZBDJ0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbZBDJ0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 04:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbZBDJ0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 04:26:19 -0500
Received: from ozlabs.org ([203.10.76.45]:41802 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbZBDJ0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 04:26:18 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeff Arnold <jbarnold@mit.edu>
Subject: Re: [PATCH 3/7] Ksplice: Make find_symbol return a struct kernel_symbol
Date: Wed, 4 Feb 2009 19:56:13 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Denys Vlasenko <vda.linux@googlemail.com>, Tim Abbott <tabbott@mit.edu>,
       Anders Kaseorg <andersk@mit.edu>, Waseem Daher <wdaher@mit.edu>,
       Nikanth Karthikesan <knikanth@suse.de>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu> <1228521840-3886-3-git-send-email-jbarnold@mit.edu> <1228521840-3886-4-git-send-email-jbarnold@mit.edu>
In-Reply-To: <1228521840-3886-4-git-send-email-jbarnold@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041956.13958.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 December 2008 10:33:56 Jeff Arnold wrote:
> From: Tim Abbott <tabbott@mit.edu>
> 
> Ksplice needs access to the kernel_symbol structure in order to support
> modifications to the exported symbol table.

Applied, with some fixes:

>  	preempt_disable();
> -	if (IS_ERR_VALUE(find_symbol(symbol, &owner, NULL, true, false)))
> +	if (find_symbol(symbol, &owner, NULL, true, false) == NULL)
>  		BUG();

I skipped the == NULL part; if (find_symbol... reads quite well.  Same with
three or so other places.

> -	ret = find_symbol(name, &owner, &crc,
> +	sym = find_symbol(name, &owner, &crc,
>  			  !(mod->taints & (1 << TAINT_PROPRIETARY_MODULE)), true);
> -	if (!IS_ERR_VALUE(ret)) {
> -		/* use_module can fail due to OOM,
> -		   or module initialization or unloading */
> -		if (!check_version(sechdrs, versindex, name, mod, crc) ||
> -		    !use_module(mod, owner))
> -			ret = -EINVAL;
> -	}
> -	return ret;
> +	/* use_module can fail due to OOM,
> +	   or module initialization or unloading */
> +	if (!check_version(sechdrs, versindex, name, mod, crc) ||
> +	    !use_module(mod, owner))
> +		sym = NULL;
> +	return sym;
>  }

If sym is NULL those other values aren't valid!  You can't take out the
branch....

> -	return (void *)value;
> +	return sym == NULL ? (void *)0 : (void *)sym->value;
>  }

One NULL too many, and one too few:
	return sym ? (void *)sym->value : NULL;

Here's the nett diff:

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -860,7 +860,7 @@ void __symbol_put(const char *symbol)
 	struct module *owner;
 
 	preempt_disable();
-	if (find_symbol(symbol, &owner, NULL, true, false) == NULL)
+	if (!find_symbol(symbol, &owner, NULL, true, false))
 		BUG();
 	module_put(owner);
 	preempt_enable();
@@ -1023,7 +1023,7 @@ static inline int check_modstruct_versio
 {
 	const unsigned long *crc;
 
-	if (find_symbol("struct_module", NULL, &crc, true, false) == NULL)
+	if (!find_symbol("struct_module", NULL, &crc, true, false))
 		BUG();
 	return check_version(sechdrs, versindex, "struct_module", mod, crc);
 }
@@ -1077,9 +1077,11 @@ static const struct kernel_symbol *resol
 			  !(mod->taints & (1 << TAINT_PROPRIETARY_MODULE)), true);
 	/* use_module can fail due to OOM,
 	   or module initialization or unloading */
-	if (!check_version(sechdrs, versindex, name, mod, crc) ||
-	    !use_module(mod, owner))
-		sym = NULL;
+	if (sym) {
+		if (!check_version(sechdrs, versindex, name, mod, crc) ||
+		    !use_module(mod, owner))
+			sym = NULL;
+	}
 	return sym;
 }
 
@@ -1481,11 +1483,11 @@ void *__symbol_get(const char *symbol)
 
 	preempt_disable();
 	sym = find_symbol(symbol, &owner, NULL, true, true);
-	if (sym != NULL && strong_try_module_get(owner))
+	if (sym && strong_try_module_get(owner))
 		sym = NULL;
 	preempt_enable();
 
-	return sym == NULL ? (void *)0 : (void *)sym->value;
+	return sym ? (void *)sym->value : NULL;
 }
 EXPORT_SYMBOL_GPL(__symbol_get);
 
@@ -1513,8 +1515,7 @@ static int verify_export_symbols(struct 
 
 	for (i = 0; i < ARRAY_SIZE(arr); i++) {
 		for (s = arr[i].sym; s < arr[i].sym + arr[i].num; s++) {
-			if (find_symbol(s->name, &owner, NULL, true, false)
-			    != NULL) {
+			if (find_symbol(s->name, &owner, NULL, true, false)) {
 				printk(KERN_ERR
 				       "%s: exports duplicate symbol %s"
 				       " (owned by %s)\n",
@@ -1561,7 +1562,7 @@ static int simplify_symbols(Elf_Shdr *se
 			ksym = resolve_symbol(sechdrs, versindex,
 					      strtab + sym[i].st_name, mod);
 			/* Ok if resolved.  */
-			if (ksym != NULL) {
+			if (ksym) {
 				sym[i].st_value = ksym->value;
 				break;
 			}
