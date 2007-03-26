Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568AbXCZKmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbXCZKmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 06:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbXCZKmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 06:42:12 -0400
Received: from smtp.osdl.org ([65.172.181.24]:52794 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbXCZKmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 06:42:11 -0400
Date: Mon, 26 Mar 2007 02:41:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: bryan.wu@analog.com
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH -mm] Revoke core code: fix nommu arch compiling error
 bug
Message-Id: <20070326024143.a226c9b2.akpm@linux-foundation.org>
In-Reply-To: <1174904637.32691.86.camel@roc-desktop>
References: <1174904637.32691.86.camel@roc-desktop>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2007 18:23:57 +0800 "Wu, Bryan" <bryan.wu@analog.com> wrote:

> Hi folks,
> 
> As struct mm_struct vm_mm is hidden in struct vm_area_struct in NOMMU
> arch, this is a fixing method when compiling failure on blackfin arch.
> 
> Signed-off-by: Bryan Wu <bryan.wu@analog.com> 
> ---
> 
>  fs/revoke.c |   22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
> 
> Index: linux-2.6/fs/revoke.c
> ===================================================================
> --- linux-2.6.orig/fs/revoke.c
> +++ linux-2.6/fs/revoke.c
> @@ -207,13 +207,21 @@
>  /*
>   *	LOCKING: spin_lock(&mapping->i_mmap_lock)
>   */
> -static int revoke_mm(struct mm_struct *mm, struct address_space *mapping,
> +static int revoke_mm(struct vm_area_struct *vma, struct address_space *mapping,
>  		     struct file *to_exclude)
>  {
> -	struct vm_area_struct *vma;
> +#ifdef CONFIG_MMU
> +	struct mm_struct *mm = vma->vm_mm;
> +#else
> +	struct mm_struct *mm = 0;
> +#endif

<looks>

Offending patch is
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/broken-out/nommu-hide-vm_mm-in-nommu-mode.patch,
which seems rather dumb.  Or at least, its changelog does a good job of
making it look dumb.

David, what on earth does "this isn't used there" mean?  Surely it is
logical to have the mm backpointer in the vma in nommu mode?  What's going
on here?

