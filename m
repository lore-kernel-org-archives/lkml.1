Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbZBTPdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbZBTPdr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 10:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbZBTPdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 10:33:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:48564 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbZBTPdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 10:33:38 -0500
Date: Fri, 20 Feb 2009 07:33:45 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: tom.leiming@gmail.com
Cc: kay.sievers@vrfy.org, greg@kroah.com, cornelia.huck@de.ibm.com,
       linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] [PATCH/RESEND] driver core: remove polling for
 driver_probe_done(v4)
Message-ID: <20090220073345.501247f7@infradead.org>
In-Reply-To: <1235139447-5829-1-git-send-email-tom.leiming@gmail.com>
References: <1235139447-5829-1-git-send-email-tom.leiming@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Feb 2009 22:17:27 +0800
tom.leiming@gmail.com wrote:

> From: Ming Lei <tom.leiming@gmail.com>
> 
> This patch adds a function : driver_wait_probe_done,
> which waits on condition of probing done to replace
> polling for driver_probe_done in fs initialization.
> 
> There is no better way to avoid polling for
> driver_probe_done _and_ existence of the root device,
> so we does not replace the driver_probe_done with
> driver_wait_probe_done in such special case.
> 
> Removing polling in fs initialization may lead to
> a faster boot.
> 
> This patch is against the latest linux-next tree.

you broke it i this revision though

> -int wait_for_device_probe(void)
> +void driver_wait_probe_done(void)
>  {
> -	/* wait for the known devices to complete their probing */
> -	while (driver_probe_done() != 0)
> -		msleep(100);
> -	async_synchronize_full();
> -	return 0;
> +	pr_debug("%s: probe_count = %d\n", __func__,
> +		 atomic_read(&probe_count));
> +	wait_event(probe_waitqueue, atomic_read(&probe_count) == 0);


You lost the async_synchronize_full()!


> -	wait_for_device_probe();
> +	driver_wait_probe_done();

I also don't understand why you rename the function..
wait_for_device_probe() is not a bad name ;)
Sounds like a gratuitous change to me.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
