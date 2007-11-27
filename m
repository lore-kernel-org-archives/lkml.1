Return-Path: <linux-kernel-owner+w=401wt.eu-S1757141AbXK0BFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbXK0BFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 20:05:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbXK0BFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 20:05:04 -0500
Received: from namei.org ([69.55.235.186]:51785 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752493AbXK0BFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 20:05:02 -0500
Date: Tue, 27 Nov 2007 12:04:18 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
       selinux@tycho.nsa.gov, alan@redhat.com, chrisw@redhat.com,
       hpa@zytor.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/3] mmap: protect from stack expantion into low vm
 addresses
In-Reply-To: <1196120846.16779.12.camel@localhost.localdomain>
Message-ID: <Xine.LNX.4.64.0711271201240.17892@us.intercode.com.au>
References: <1196120846.16779.12.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007, Eric Paris wrote:

> Add security checks to make sure we are not attempting to expand the
> stack into memory protected by mmap_min_addr
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

Please include the LSMs list in the CC line (added again) for posts 
relating to security.

Applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git#for-akpm

> ---
> 
> ** Be very careful applying/rediffing this patch.  Standard 3 lines of
> context from git diff will misapply the first hunk to expand_upwards
> instead of properly in expand_downwards.  This patch was generated using
> -U 4 to make sure it applies in the correct place.  **

Seems to have applied correctly for me.


> 
>  mm/mmap.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> --- kernel-1/mm/mmap.c
> +++ kernel-2/mm/mmap.c
> @@ -1614,17 +1614,21 @@ static inline int expand_downwards(struc
>  	 * so that the anon_vma locking is not a noop.
>  	 */
>  	if (unlikely(anon_vma_prepare(vma)))
>  		return -ENOMEM;
> +
> +	address &= PAGE_MASK;
> +	error = security_file_mmap(0, 0, 0, 0, address, 1);
> +	if (error)
> +		return error;
> +
>  	anon_vma_lock(vma);
>  
>  	/*
>  	 * vma->vm_start/vm_end cannot change under us because the caller
>  	 * is required to hold the mmap_sem in read mode.  We need the
>  	 * anon_vma lock to serialize against concurrent expand_stacks.
>  	 */
> -	address &= PAGE_MASK;
> -	error = 0;
>  
>  	/* Somebody else might have raced and expanded it already */
>  	if (address < vma->vm_start) {
>  		unsigned long size, grow;
> 
> 

-- 
James Morris
<jmorris@namei.org>
