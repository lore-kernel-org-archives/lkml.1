Return-Path: <linux-kernel-owner+w=401wt.eu-S1757126AbYBIRPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbYBIRPc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 12:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756232AbYBIRPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 12:15:06 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60520 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073AbYBIRPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 12:15:04 -0500
Date: Sat, 9 Feb 2008 12:15:03 -0500
From: Christoph Hellwig <hch@infradead.org>
To: jason.wessel@windriver.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/8] kgdb, modules: Always allow module sect info for
	KGDB
Message-ID: <20080209171503.GB15568@infradead.org>
References: <1202564114-18587-1-git-send-email-jason.wessel@windriver.com> <1202564114-18587-2-git-send-email-jason.wessel@windriver.com> <1202564114-18587-3-git-send-email-jason.wessel@windriver.com> <1202564114-18587-4-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202564114-18587-4-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 07:35:09AM -0600, jason.wessel@windriver.com wrote:
> From: Jason Wessel <jason.wessel@windriver.com>
> 
> With more information in the kernel, gdb can be modified in such a way
> as to automatically read the kernel module section information and
> allow for easy kernel module debugging.
> 
> In gdb the solib-search-path must contain the location of any module
> to be debugged.  When a module is loaded GDB acts like a shared
> library has been loaded and will collect the information about the
> memory location so the kernel module can be debugged or inspected.
> 
> Even when not using kgdb+gdb, it is quite useful for a
> debugger+ICE/jtag to have the module section information.

This patches doesn't match the description and seems quite odd in
various ways:

> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -342,13 +342,16 @@ struct module
>  	unsigned long num_symtab;
>  	char *strtab;
>  
> -	/* Section attributes */
> -	struct module_sect_attrs *sect_attrs;
> -
>  	/* Notes attributes */
>  	struct module_notes_attrs *notes_attrs;
>  #endif
>  
> +#if defined(CONFIG_KALLSYMS) || defined(CONFIG_KGDB)
> +	/* Section attributes */
> +	struct module_sect_attrs *sect_attrs;
> +#endif

So here we make a member of struct module conditional.  Fine if
that saves memory for non-debug configs, but that's not
what the description mentions.  Also is there any reason why
you'd want to build KGDB without KALLSYMS?

> diff --git a/kernel/module.c b/kernel/module.c
> index 4202da9..4a94d1a 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -602,6 +602,9 @@ static void module_unload_free(struct module *mod)
>  			}
>  		}
>  	}
> +	blocking_notifier_call_chain(&module_notify_list,
> +				MODULE_STATE_GOING,
> +				mod);

this adds a notifier for a module beeing unloaded.  This could vaguely
be related to what's in the description at least..

> +#if defined(CONFIG_KALLSYMS) || defined(CONFIG_KGDB)
>  #ifdef CONFIG_KALLSYMS
>  static ssize_t module_sect_show(struct module_attribute *mattr,
>  				struct module *mod, char *buf)
> @@ -1000,6 +1004,7 @@ static ssize_t module_sect_show(struct module_attribute *mattr,
>  		container_of(mattr, struct module_sect_attr, mattr);
>  	return sprintf(buf, "0x%lx\n", sattr->address);
>  }
> +#endif /* CONFIG_KALLSYMS */

Now you add a CONFIG_KALLSYMS || KGDB ifdef around an CONFIG_KALLSYMS
block that you shorten at the same time.  If you really want to allow
kgdb without kallsyms the KALLSYMS should be left for this function and
the KALLSYMS || KGDB move below it.  But with this ifdef mess I can
only repeat that you should simply make kallsysm mandatory for kgdb.

