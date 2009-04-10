Return-Path: <linux-kernel-owner+w=401wt.eu-S939427AbZDJS3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939427AbZDJS3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 14:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937293AbZDJS3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 14:29:42 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:52186 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932520AbZDJS3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 14:29:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sYg4Echa0vwr10RhoRCSbiJoSkNmXjUzDGNYBGAjTRQkEXVEoycFU5ic/5XhjW9+uU
         yBQxNRQTiUcLgaab9ofWbctYBPsWqTJ46JjM659FKyHiONHn1NQcbrUC2c/JY9UMUwBT
         R+yb59SbQ66k6Inq721P+cWs4dUN/mb+wyjfs=
Date: Fri, 10 Apr 2009 20:29:37 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: Ingo Molnar <mingo@elte.hu>, Jonathan Corbet <corbet@lwn.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] remove the BKL: remove "BKL auto-drop" assumption from
	nfs3_rpc_wrapper()
Message-ID: <20090410182936.GA6018@nowhere>
References: <1239381281-11282-1-git-send-email-abogani@texware.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239381281-11282-1-git-send-email-abogani@texware.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 06:34:41PM +0200, Alessio Igor Bogani wrote:
> Fix nfs3_rpc_wrapper()'s "schedule() drops the BKL automatically" assumption,
> when schedule_timeout_killable() does not do that it can lock up.
> 
> Signed-off-by: Alessio Igor Bogani <abogani@texware.it>


Hi Alessio,

Btw, does it fix the lockdep message you've seen while mounting
an nfs point?

Thanks,
Frederic.


> ---
>  fs/nfs/nfs3proc.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
> index d0cc5ce..d91047c 100644
> --- a/fs/nfs/nfs3proc.c
> +++ b/fs/nfs/nfs3proc.c
> @@ -17,6 +17,7 @@
>  #include <linux/nfs_page.h>
>  #include <linux/lockd/bind.h>
>  #include <linux/nfs_mount.h>
> +#include <linux/smp_lock.h>
>  
>  #include "iostat.h"
>  #include "internal.h"
> @@ -28,11 +29,17 @@ static int
>  nfs3_rpc_wrapper(struct rpc_clnt *clnt, struct rpc_message *msg, int flags)
>  {
>  	int res;
> +	int bkl = kernel_locked();
> +
>  	do {
>  		res = rpc_call_sync(clnt, msg, flags);
>  		if (res != -EJUKEBOX)
>  			break;
> +		if (bkl)
> +			unlock_kernel();
>  		schedule_timeout_killable(NFS_JUKEBOX_RETRY_TIME);
> +		if (bkl)
> +			lock_kernel();
>  		res = -ERESTARTSYS;
>  	} while (!fatal_signal_pending(current));
>  	return res;
> -- 
> 1.6.0.4
> 

