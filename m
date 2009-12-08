Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbZLHM2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbZLHM2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 07:28:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbZLHM2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 07:28:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34885 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644AbZLHM2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 07:28:11 -0500
Date: Tue, 8 Dec 2009 22:26:12 +1100
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       dvhltc@us.ibm.com, stable@kernel.org
Subject: Re: [PATCH] futex: Take mmap_sem for get_user_pages in
	fault_in_user_writeable
Message-ID: <20091208112612.GH3511@nick>
References: <20091208121942.GA21298@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091208121942.GA21298@basil.fritz.box>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 01:19:42PM +0100, Andi Kleen wrote:
> futex: Take mmap_sem for get_user_pages in fault_in_user_writeable
> 
> gup() requires mmap_sem, so take it before running it. The
> recent fault_in_user_writeable() didn't do that.
> 
> I didn't find a good futex test case, so untested.
> 
> Likely a stable candidate.
> 
> Cc: npiggin@suse.de
> Cc: tglx@linutronix.de
> Cc: dvhltc@us.ibm.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

I agree it should go to .stable.

Acked-by: Nick Piggin <npiggin@suse.de>


> ---
>  kernel/futex.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.32-ak/kernel/futex.c
> ===================================================================
> --- linux-2.6.32-ak.orig/kernel/futex.c
> +++ linux-2.6.32-ak/kernel/futex.c
> @@ -304,8 +304,13 @@ void put_futex_key(int fshared, union fu
>   */
>  static int fault_in_user_writeable(u32 __user *uaddr)
>  {
> -	int ret = get_user_pages(current, current->mm, (unsigned long)uaddr,
> +	int ret;
> +	struct mm_struct *mm = current->mm;
> +
> +	down_read(&mm->mmap_sem);
> +	ret = get_user_pages(current, mm, (unsigned long)uaddr,
>  				 1, 1, 0, NULL, NULL);
> +	up_read(&mm->mmap_sem);
>  	return ret < 0 ? ret : 0;
>  }
>  
