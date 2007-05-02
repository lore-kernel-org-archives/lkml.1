Return-Path: <linux-kernel-owner+w=401wt.eu-S1161000AbXEBVUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161000AbXEBVUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 17:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161789AbXEBVUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 17:20:54 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161000AbXEBVUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 17:20:53 -0400
Date: Wed, 2 May 2007 14:20:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Markus Rechberger" <markus.rechberger@amd.com>
Cc: linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH] pcmcia/pccard deadlock fix
Message-Id: <20070502142014.b1f1d77e.akpm@linux-foundation.org>
In-Reply-To: <45DB0EDB.3090803@amd.com>
References: <45DB0EDB.3090803@amd.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 20 Feb 2007 16:08:11 +0100

20 Feb was a long time ago, sorry.  I was hoping to feed the pcmcia patches
through Dominik but I think he's busy with exams or such.  So I get to
pretend to be pcmcia maintainer.

"Markus Rechberger" <markus.rechberger@amd.com> wrote:

> following patch prevents a mutex/semaphore deadlock within the pcmcia
> framework when ejecting devices multiple times using pccardctl eject.
> 
> For some more details see:
> http://lkml.org/lkml/2007/2/19/58
> 
> Signed-off-by: Markus Rechberger <markus.rechberger@amd.com>
> 
> -- 
> Markus Rechberger
> Operating System Research Center
> AMD Saxony LLC & Co. KG
> 
> 
> 
> [pcmcia-pccard-deadlock-fix.diff  text/plain (757B)]
> index ac00424..c02bf0d 100644
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
>  

This is a pretty sad-looking solution.  Does it not mean that sometimes
user-initiated actions will mysteriously fail?

Are you able to provide a more detailed description of why/how the deadlock
actually occurs so that perhaps a more robust fix can be implemented?

Thanks.
