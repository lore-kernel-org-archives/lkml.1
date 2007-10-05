Return-Path: <linux-kernel-owner+w=401wt.eu-S1760988AbXJELBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760988AbXJELBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 07:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbXJELB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 07:01:27 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:56206 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754537AbXJELB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 07:01:27 -0400
Message-ID: <391582087.27602@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 5 Oct 2007 19:01:23 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org
Subject: Re: BUG on unloading the fuse module
Message-ID: <20071005110123.GA5489@mail.ustc.edu.cn>
References: <391574553.18064@ustc.edu.cn> <E1Idjd8-0002rY-00@dorka.pomaz.szeredi.hu> <391581094.26735@ustc.edu.cn> <E1Idkor-0002v6-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Idkor-0002v6-00@dorka.pomaz.szeredi.hu>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2007 at 12:54:09PM +0200, Miklos Szeredi wrote:
> > > > In 2.6.23-rc8-mm2, the fuse module always bugs on unloading.
> > > 
> > > It's fixed in Greg's patch queue.
> > > 
> > > This patch against -mm will also fix it.
> > 
> > Oh no, it panics:
> 
> How about this one?

Yes, it did the trick.

Thank you!
Fengguang
> ---
> 
> Index: linux/lib/kobject.c
> ===================================================================
> --- linux.orig/lib/kobject.c	2007-10-02 17:20:04.000000000 +0200
> +++ linux/lib/kobject.c	2007-10-05 12:52:52.000000000 +0200
> @@ -498,18 +498,18 @@ void kobject_cleanup(struct kobject * ko
>  	struct kobj_type * t = get_ktype(kobj);
>  	struct kset * s = kobj->kset;
>  	struct kobject * parent = kobj->parent;
> -	const char *k_name = kobj->k_name;
>  
>  	pr_debug("kobject %s: cleaning up\n",kobject_name(kobj));
> -	kobj->k_name = NULL;
> -	if (t && t->release)
> +	if (t && t->release) {
> +		const char *k_name = kobj->k_name;
> +		kobj->k_name = NULL;
>  		t->release(kobj);
> -	else
> +		kfree(k_name);
> +	} else
>  		pr_debug("kobject '%s' does not have a release() function, "
>  			"if this is not a directory kobject, it is broken "
>  			"and must be fixed.\n",
> -			k_name);
> -	kfree(k_name);
> +			kobj->k_name);
>  	if (s)
>  		kset_put(s);
>  	kobject_put(parent);

