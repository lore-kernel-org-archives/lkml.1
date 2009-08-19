Return-Path: <linux-kernel-owner+w=401wt.eu-S1752721AbZHSQil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbZHSQil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbZHSQil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:38:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753212AbZHSQik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:38:40 -0400
Date: Wed, 19 Aug 2009 09:37:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, stable@kernel.org
Subject: Re: [REGRESSION] _end symbol missing from Symbol.map
Message-Id: <20090819093704.f1620baa.akpm@linux-foundation.org>
In-Reply-To: <4A83B680.5000508@suse.de>
References: <4A83B680.5000508@suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009 08:45:20 +0200 Hannes Reinecke <hare@suse.de> wrote:

> Hi all,
> 
> with 2.6.31 'crash' on x86_64 falls flat on its face as the '_end' symbol
> is missing from the System.map file.
> 
> The culprit is commit 091e52c3551d3031343df24b573b770b4c6c72b6,
> which moved the '_end' symbol into it's own section.
> Apparently this causes kallsyms to not reference it properly.
> 
> So either we'd need to revert part of the patch to not
> include _end in it's own section:
> 
> diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
> index 59f31d2..1422df5 100644
> --- a/arch/x86/kernel/vmlinux.lds.S
> +++ b/arch/x86/kernel/vmlinux.lds.S
> @@ -376,9 +376,7 @@ SECTIONS
>                 __brk_limit = .;
>         }
>  
> -       .end : AT(ADDR(.end) - LOAD_OFFSET) {
> -               _end = .;
> -       }
> +       _end = .;
>  
>         /* Sections to be discarded */
>         /DISCARD/ : {
> 
> or someone has to fixup kallsyms. But this is far beyond my comfort zone.
> 

So System.map is part of the kernel API too?  Sigh.

Your email client replaces tabs with spaces.

The patch didn't have a signed-off-by:

I queued it up, and tagged it for -stable backporting.  Unless we come
up with something better.

We might not get this into 2.6.31, in which case this fix or its
replacement will need backporting to 2.6.30.x and 2.6.31.x (IMO).

