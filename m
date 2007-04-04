Return-Path: <linux-kernel-owner+w=401wt.eu-S1946040AbXDDAJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946040AbXDDAJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 20:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946043AbXDDAJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 20:09:16 -0400
Received: from smtp.osdl.org ([65.172.181.24]:49635 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946040AbXDDAJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 20:09:15 -0400
Date: Tue, 3 Apr 2007 17:08:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: rusty@rustcorp.com.au, pmarques@grupopie.com, linux-kernel@vger.kernel.org,
       devel@openvz.org
Subject: Re: [PATCH 5/5] Fix race between cat /proc/slab_allocators and
 rmmod
Message-Id: <20070403170827.a32f97f1.akpm@linux-foundation.org>
In-Reply-To: <20070402150316.GE6735@localhost.sw.ru>
References: <20070402150316.GE6735@localhost.sw.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2007 19:03:16 +0400
Alexey Dobriyan <adobriyan@sw.ru> wrote:

> +int lookup_module_symbol_attrs(unsigned long addr, unsigned long *size,
> +			unsigned long *offset, char *modname, char *name)
> +{
> +	struct module *mod;
> +
> +	mutex_lock(&module_mutex);
> +	list_for_each_entry(mod, &modules, list) {
> +		if (within(addr, mod->module_init, mod->init_size) ||
> +		    within(addr, mod->module_core, mod->core_size)) {
> +			const char *sym;
> +
> +			sym = get_ksymbol(mod, addr, size, offset);
> +			if (!sym)
> +				goto out;
> +			if (modname)
> +				strlcpy(modname, mod->name, MODULE_NAME_LEN + 1);
> +			if (name)
> +				strlcpy(name, sym, KSYM_NAME_LEN + 1);
> +			mutex_unlock(&module_mutex);
> +			return 0;
> +		}
> +	}
> +out:
> +	mutex_unlock(&module_mutex);
> +	return -ERANGE;
> +}
> +

The functions lookup_symbol_name() and lookup_symbol_attrs() are quite
general and are likely to be used for other applications in the future.

Could we please pick better names for them?  The names you've chosen are
far too general-sounding - we have a lot of different types of "symbol" in
the kernel!  Perhaps module_lookup_symbol_attrs() and
kallsyms_lookup_symbol() and kallsyms_lookup_attrs() or something.  But
something prefixed with kallsyms_ and module_.

Also, as these general-use functions are exported to all of vmlinux, a little
bit of documentation for them would be good.

