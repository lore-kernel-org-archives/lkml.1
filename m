Return-Path: <linux-kernel-owner+w=401wt.eu-S1752616AbYGVHMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbYGVHMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 03:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbYGVHMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 03:12:25 -0400
Received: from main.gmane.org ([80.91.229.2]:47257 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbYGVHMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 03:12:25 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Kari Hurtta <hurtta+gmane@siilo.fmi.fi>
Subject: Re: [PATCH 02/79] kobject: replace '/' with '!' in name
Date: 22 Jul 2008 10:12:11 +0300
Message-ID: <5dfxq21jg4.fsf@Hurtta06k.keh.iki.fi>
References: <20080722051805.GA17373@suse.de> <1216703983-21448-2-git-send-email-gregkh@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cs168115.pp.htv.fi
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh@suse.de> writes in gmane.linux.kernel:

> From: Kay Sievers <kay.sievers@vrfy.org>
> 
> Some (block) devices have a '/' in the name, and need special
> handling. Let's have that rule to the core, so we can remove it
> from the block class.
> 
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  lib/kobject.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/kobject.c b/lib/kobject.c
> index dcade05..7444015 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -216,13 +216,19 @@ static int kobject_add_internal(struct kobject *kobj)
>  static int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
>  				  va_list vargs)
>  {
> -	/* Free the old name, if necessary. */
> -	kfree(kobj->name);
> +	const char *old_name = kobj->name;
> +	char *s;
>  
>  	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
>  	if (!kobj->name)
>  		return -ENOMEM;

Is this leaking old_name if kvasprintf returns NULL ?

kobj->name is that point to set NULL  and old value
of kobj->name (old_name) is not free'ed
  
> +	/* ewww... some of these buggers have '/' in the name ... */
> +	s = strchr(kobj->name, '/');
> +	if (s)
> +		s[0] = '!';
> +
> +	kfree(old_name);
>  	return 0;
>  }
>  
> -- 
> 1.5.6.3

/ Kari Hurtta

