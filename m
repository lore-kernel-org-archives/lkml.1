Return-Path: <linux-kernel-owner+w=401wt.eu-S933797AbXKOWmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933797AbXKOWmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 17:42:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762693AbXKOWlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 17:41:55 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55784 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757835AbXKOWly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 17:41:54 -0500
Date: Thu, 15 Nov 2007 14:40:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] FRV: Fix the extern declaration of kallsyms_num_syms
 [try #2]
Message-Id: <20071115144007.08760570.akpm@linux-foundation.org>
In-Reply-To: <20071113165316.18700.67752.stgit@warthog.procyon.org.uk>
References: <20071113165316.18700.67752.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 16:53:16 +0000
David Howells <dhowells@redhat.com> wrote:

> From: David Howells <dhowells@redhat.com>
> 
> Fix the extern declaration of kallsyms_num_syms to indicate that the symbol
> does not reside in the small-data storage space, and so may not be accessed
> relative to the small data base register.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  kernel/kallsyms.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index 474219a..2fc2581 100644
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -32,9 +32,14 @@
>  
>  /* These will be re-linked against their real values during the second link stage */
>  extern const unsigned long kallsyms_addresses[] __attribute__((weak));
> -extern const unsigned long kallsyms_num_syms __attribute__((weak));
>  extern const u8 kallsyms_names[] __attribute__((weak));
>  
> +/* tell the compiler that the count isn't in the small data section if the arch
> + * has one (eg: FRV)
> + */
> +extern const unsigned long kallsyms_num_syms
> +__attribute__((weak, section(".rodata")));
> +
>  extern const u8 kallsyms_token_table[] __attribute__((weak));
>  extern const u16 kallsyms_token_index[] __attribute__((weak));
>  

hm, OK, so it lines up with what scripts/kallsyms.c presently does.

But it all strikes me as a bit fragile and grotty.  Perhaps longer-term it
would be better if scripts/kallsyms.c were to also emit a header file which
declares all the things which that program emits the definitions of, no?

I guess that means that we'd need to run the program twice - once at the
start of compilation in generate-the-header-file mode and once at the end
of compilation in generate-the-symbols mode.

Or something like that.

