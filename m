Return-Path: <linux-kernel-owner+w=401wt.eu-S964821AbXBYMwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964821AbXBYMwp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 07:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964872AbXBYMwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 07:52:45 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35417 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964821AbXBYMwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 07:52:44 -0500
Date: Sun, 25 Feb 2007 04:52:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Markus Rechberger" <markus.rechberger@amd.com>
Cc: linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH] pcmcia/pccard deadlock fix
Message-Id: <20070225045231.81682e06.akpm@linux-foundation.org>
In-Reply-To: <45DB0EDB.3090803@amd.com>
References: <45DB0EDB.3090803@amd.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 20 Feb 2007 16:08:11 +0100 "Markus Rechberger" <markus.rechberger@amd.com> wrote:
> following patch prevents a mutex/semaphore deadlock within the pcmcia
> framework when ejecting devices multiple times using pccardctl eject.
> 
> For some more details see:
> http://lkml.org/lkml/2007/2/19/58
> 
> --- a/drivers/pcmcia/cs.c
> +++ b/drivers/pcmcia/cs.c
> @@ -856,7 +856,8 @@ int pcmcia_eject_card(struct pcmcia_socket *skt)
>      
>  	cs_dbg(skt, 1, "user eject request\n");
>  
> -	mutex_lock(&skt->skt_mutex);
> +	if (!mutex_trylock(&skt->skt_mutex)) 
> +		return -EAGAIN;
>  	do {
>  		if (!(skt->state & SOCKET_PRESENT)) {
>  			ret = -ENODEV;
> index 18e111e..b9d3440 100644
> --- a/drivers/pcmcia/ds.c
> +++ b/drivers/pcmcia/ds.c
> @@ -1100,7 +1100,9 @@ static ssize_t pcmcia_store_allow_func_id_match(struct device *dev,
>  	if (!count)
>  		return -EINVAL;
>  
> -	mutex_lock(&p_dev->socket->skt_mutex);
> +	if (!mutex_trylock(&p_dev->socket->skt_mutex)) 
> +		return -EAGAIN;
> +
>  	p_dev->allow_func_id_match = 1;
>  	mutex_unlock(&p_dev->socket->skt_mutex);

That looks rather hacky.  I'll queue it up to bug Dominik with, but
hopeully we'll come up with some fix which avoids the trylocks.
