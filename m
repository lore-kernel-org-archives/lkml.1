Return-Path: <linux-kernel-owner+w=401wt.eu-S1758540AbZFZPAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbZFZPAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 11:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbZFZPAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 11:00:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:33698 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbZFZPAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 11:00:25 -0400
Date: Fri, 26 Jun 2009 07:49:49 -0700
From: Greg KH <gregkh@suse.de>
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kobject_set_name_vargs memory leak
Message-ID: <20090626144949.GA24173@suse.de>
References: <20090626143652.GB6281@localdomain.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626143652.GB6281@localdomain.by>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 05:36:52PM +0300, Sergey Senozhatsky wrote:
> Hello.
> I suppose this patch fixes memory leak in kobject.c
> Correct me if I'm wrong.
> Thanks.
> -----------
> 
> Fix memory leak when kobject_set_name_vargs returns -ENOMEM.
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
> ---
> diff --git a/lib/kobject.c b/lib/kobject.c
> index b512b74..922cd8c 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -222,8 +222,10 @@ int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
>  		return 0;
>  
>  	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
> -	if (!kobj->name)
> +	if (!kobj->name) {
> +		kfree(old_name);
>  		return -ENOMEM;
> +	}

We've been through this before (search lkml archives).  If kvasprintf
fails, then we don't want to free old_name, as the caller might want to
do something with it.

Or something along those lines, I can't remember the exact reasoning
this early in the morning.

Kay, do you remember?

thanks,

greg k-h
