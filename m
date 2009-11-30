Return-Path: <linux-kernel-owner+w=401wt.eu-S1752522AbZK3IB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbZK3IB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 03:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZK3IB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 03:01:58 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:50563 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbZK3IB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 03:01:58 -0500
X-Greylist: delayed 1238 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Nov 2009 03:01:58 EST
Date: Mon, 30 Nov 2009 18:41:25 +1100
From: Simon Horman <horms@verge.net.au>
To: andrew hendry <andrew.hendry@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-x25@vger.kernel.org
Subject: Re: [PATCH 2/3] X25: Check for errors in x25_init
Message-ID: <20091130074125.GA9541@verge.net.au>
References: <d45a3acc0911241715k6882aa3el64a50b3d68d12167@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d45a3acc0911241715k6882aa3el64a50b3d68d12167@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 12:15:42PM +1100, andrew hendry wrote:
> Adds error checking to x25_init.
> 
> Signed-off-by: Andrew Hendry <andrew.hendry@gmail.com>
> 
> diff -uprN -X a/Documentation/dontdiff a/net/x25/af_x25.c b/net/x25/af_x25.c
> --- a/net/x25/af_x25.c  2009-11-25 10:21:17.000000000 +1100
> +++ b/net/x25/af_x25.c  2009-11-25 10:22:06.000000000 +1100
> @@ -1659,18 +1659,31 @@ static int __init x25_init(void)
>  	if (rc != 0)
>  		goto out;
> 
> -	sock_register(&x25_family_ops);
> +	rc = sock_register(&x25_family_ops);
> +	if (rc != 0)
> +		goto out_proto;
> 
>  	dev_add_pack(&x25_packet_type);
> 
> -	register_netdevice_notifier(&x25_dev_notifier);
> +	rc = register_netdevice_notifier(&x25_dev_notifier);
> +	if (rc != 0)
> +		goto out_sock;
> 
>  	printk(KERN_INFO "X.25 for Linux Version 0.2\n");
> 
>  	x25_register_sysctl();
> -	x25_proc_init();
> +	rc = x25_proc_init();
> +	if (rc != 0)
> +		goto out_dev;
>  out:
>  	return rc;
> +out_dev:
> +	unregister_netdevice_notifier(&x25_dev_notifier);
> +out_sock:
> +	sock_unregister(AF_X25);
> +out_proto:
> +	proto_unregister(&x25_proto);
> +	goto out;
>  }
>  module_init(x25_init);

The following seems slightly cleaner to me:

...
	rc = x25_proc_init();
	if (rc != 0)
		goto out_dev;

	return 0;  <-- or goto out;
out_dev:
	unregister_netdevice_notifier(&x25_dev_notifier);
out_sock:
	sock_unregister(AF_X25);
out_proto:
	proto_unregister(&x25_proto);
out:
	return rc;
}

