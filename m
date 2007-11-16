Return-Path: <linux-kernel-owner+w=401wt.eu-S935509AbXKPVrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935509AbXKPVrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935279AbXKPVr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:47:27 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58060 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935454AbXKPVrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:47:25 -0500
Date: Fri, 16 Nov 2007 13:46:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH] proc: use BUG_ON() in de_put()
Message-Id: <20071116134642.2dda1600.akpm@linux-foundation.org>
In-Reply-To: <20071115161249.GE6216@localhost.sw.ru>
References: <20071115161249.GE6216@localhost.sw.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007 19:12:49 +0300
Alexey Dobriyan <adobriyan@sw.ru> wrote:

> It's much more visible that some printk. I still has an unexplained oops
> in proc, so let's leave it for a while.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
> ---
> 
>  fs/proc/inode.c |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@ -37,12 +37,7 @@ void de_put(struct proc_dir_entry *de)
>  {
>  	if (de) {	
>  		lock_kernel();		
> -		if (!atomic_read(&de->count)) {
> -			printk("de_put: entry %s already free!\n", de->name);
> -			unlock_kernel();
> -			return;
> -		}
> -
> +		BUG_ON(atomic_read(&de->count) == 0);
>  		if (atomic_dec_and_test(&de->count)) {
>  			if (de->deleted) {
>  				printk("de_put: deferred delete of %s\n",

I don't see that an error in here _requires_ that we nuke the machine. 
Surely we can emit a warning and then recover in some fashion?

