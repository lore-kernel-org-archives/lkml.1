Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbZCQNpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbZCQNpD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 09:45:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbZCQNox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 09:44:53 -0400
Received: from www.tglx.de ([62.245.132.106]:58242 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbZCQNow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 09:44:52 -0400
Date: Tue, 17 Mar 2009 14:43:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: cleanup non-code changing
In-Reply-To: <1237290417.10142.4.camel@ht.satnam>
Message-ID: <alpine.LFD.2.00.0903171425250.29264@localhost.localdomain>
References: <1237290417.10142.4.camel@ht.satnam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Mar 2009, Jaswinder Singh Rajput wrote:
> --- a/arch/x86/kernel/kdebugfs.c
> +++ b/arch/x86/kernel/kdebugfs.c

>  static int __init
> @@ -84,24 +85,20 @@ create_setup_data_node(struct dentry *parent, int no,
>  {
>  	struct dentry *d, *type, *data;
>  	char buf[16];
> -	int error;
>  
>  	sprintf(buf, "%d", no);
>  	d = debugfs_create_dir(buf, parent);
> -	if (!d) {
> -		error = -ENOMEM;
> +	if (!d)
>  		goto err_return;

  Sigh. return -ENOMEM; perhaps ???? 

>  static int __init create_setup_data_nodes(struct dentry *parent)
>  {
>  	struct setup_data_node *node;
>  	struct setup_data *data;
> -	int error, no = 0;
> +	int error = 0, no = 0;
>  	struct dentry *d;
>  	struct page *pg;
>  	u64 pa_data;
>  
>  	d = debugfs_create_dir("setup_data", parent);
> -	if (!d) {
> -		error = -ENOMEM;
> +	if (!d)
>  		goto err_return;

  Yuck. This is the most stupid change I have seen so far.

  error = 0;
  goto err_return;

err_return:
  if (!error)
     error = -ENOMEM;
  return error;

  WTF can't you just initialize error with -ENOMEM ?

> @@ -175,28 +171,26 @@ static struct debugfs_blob_wrapper boot_params_blob = {
>  static int __init boot_params_kdebugfs_init(void)
>  {
>  	struct dentry *dbp, *version, *data;
> -	int error;
> +	int error = 0;
>  
>  	dbp = debugfs_create_dir("boot_params", NULL);
> -	if (!dbp) {
> -		error = -ENOMEM;
> +	if (!dbp)
>  		goto err_return;
 ...
>  err_return:
> +	if (!error)
> +		error = -ENOMEM;
>  	return error;
>  }

  At least it is conistently stupid.

>  static int
> @@ -20,8 +20,10 @@ check_addr(char *name, struct device *hwdev, dma_addr_t bus, size_t size)
>  			    "nommu_%s: overflow %Lx+%zu of device mask %Lx\n",
>  				name, (long long)bus, size,
>  				(long long)*hwdev->dma_mask);
> +
>  		return 0;
>  	}
> +
>  	return 1;
>  }

  What's the exact point of these newlines ? The code is perfectly
  readable except for the weird formatted printk which you ignored.
  
  This newlines business just has the effect that I have less code on
  one screen than before.

Can we please stop this time waste and take care of real problems ?

Thanks,

	tglx
