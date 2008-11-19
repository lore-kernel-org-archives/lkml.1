Return-Path: <linux-kernel-owner+w=401wt.eu-S1752165AbYKSGU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbYKSGU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 01:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750990AbYKSGUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 01:20:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750834AbYKSGUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 01:20:15 -0500
Date: Tue, 18 Nov 2008 22:19:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rakib Mullick" <rakib.mullick@gmail.com>
Cc: "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] kernel/profile.c: Fix section mismatch warning.
Message-Id: <20081118221942.384ebefd.akpm@linux-foundation.org>
In-Reply-To: <b9df5fa10811172015w3dfb955bq115180d9d0808d82@mail.gmail.com>
References: <b9df5fa10811172015w3dfb955bq115180d9d0808d82@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2008 10:15:24 +0600 "Rakib Mullick" <rakib.mullick@gmail.com> wrote:

> Impact: Fix section mismatch warning in kernel/profile.c
> 
> Here, profile_nop function has been called from a non-init function
> create_hash_tables(void). Which generetes a section mismatch warning.
> Previously, create_hash_tables(void) was a init function. So, removing
> __init from create_hash_tables(void) requires profile_nop to be
> non-init. This patch makes profile_nop function inline and fixes the
> following warning:
> 
> WARNING: vmlinux.o(.text+0x6ebb6): Section mismatch in reference from
> the function create_hash_tables() to the function
> .init.text:profile_nop()
> The function create_hash_tables() references
> the function __init profile_nop().
> This is often because create_hash_tables lacks a __init
> annotation or the annotation of profile_nop is wrong.
> 
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> 
> --- linux-2.6-orig/kernel/profile.c	2008-11-17 20:30:42.000000000 +0600
> +++ linux-2.6/kernel/profile.c	2008-11-18 09:39:58.000000000 +0600
> @@ -544,7 +544,7 @@ static const struct file_operations proc
>  };
> 
>  #ifdef CONFIG_SMP
> -static void __init profile_nop(void *unused)
> +static inline void profile_nop(void *unused)
>  {
>  }

Thanks.

There's no point in declaring this as inline, since it is always called
indirectly, via on_each_cpu().

There would be a teeny point in inlining an on_each_cpu() function in
uniprocessor code, because in that case it _would_ be inlined.  But a)
that's a bit dopey and b) this code you're patching is SMP-only.

So...

--- a/kernel/profile.c~kernel-profilec-fix-section-mismatch-warning-fix
+++ a/kernel/profile.c
@@ -544,7 +544,7 @@ static const struct file_operations proc
 };
 
 #ifdef CONFIG_SMP
-static inline void profile_nop(void *unused)
+static void profile_nop(void *unused)
 {
 }
 
_

