Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbYADQS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbYADQS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 11:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbYADQSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 11:18:49 -0500
Received: from lixom.net ([66.141.50.11]:45504 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593AbYADQSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 11:18:49 -0500
Date: Fri, 4 Jan 2008 10:27:29 -0600
From: Olof Johansson <olof@lixom.net>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       mpm@selenic.com
Subject: Re: [patch 1/2] move WARN_ON() out of line
Message-ID: <20080104162729.GB29770@lixom.net>
References: <477D52ED.7000403@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477D52ED.7000403@linux.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jan 03, 2008 at 10:26:05PM +0100, Arjan van de Ven wrote:

> This patch build on top of Olof's patch that introduces __WARN,
> and places the slowpath out of line. It also uses Ingo's suggestion
> to not use __FUNCTION__ but to use kallsyms to do the lookup;
> this saves a ton of extra space since gcc doesn't need to store the function
> string twice now:
>
> 3936367  833603  624736 5394706  525112 vmlinux.before
> 3917508  833603  624736 5375847  520767 vmlinux-slowpath
>
> 15Kb savings...

This patch actually resulted in a slight size increase on PPC, most
likely because of the new warn_on_slowpath() that isn't used:

   text    data     bss     dec     hex filename
8059224 1820584  529064 10408872 9ed3a8 vmlinux.mainline
8058268 1820592  529064 10407924 9ecff4 vmlinux.mm
8058324 1820648  529064 10408036 9ed064 vmlinux.mm+arjanpatch

Also:

> Index: linux-2.6.24-rc6/include/asm-generic/bug.h
> ===================================================================
> --- linux-2.6.24-rc6.orig/include/asm-generic/bug.h
> +++ linux-2.6.24-rc6/include/asm-generic/bug.h
> @@ -32,11 +32,8 @@ struct bug_entry {
>  #endif
>
>  #ifndef __WARN
> -#define __WARN() do {							\
> -	printk("WARNING: at %s:%d %s()\n", __FILE__,			\
> -		__LINE__, __FUNCTION__);				\
> -	dump_stack();							\
> -} while (0)
> +extern void warn_on_slowpath(const char *file, const int line);
> +#define __WARN() warn_on_slowpath(__FILE__, __LINE__)
>  #endif
>

This caused problems on powerpc, since bug.h ends up being pulled into
some assembly files. The #defines in there have been fine, but the
external declaration threw it off. (They need them to get to some of the
include/asm-powerpc/bug.h contents, but it pulls in the generic one as
well).

Easiest is probably to encapsulate the whole file in #ifndef __ASSEMBLY__.


-Olof
