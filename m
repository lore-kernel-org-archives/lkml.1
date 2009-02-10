Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbZBJDP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbZBJDP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 22:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbZBJDPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 22:15:14 -0500
Received: from ozlabs.org ([203.10.76.45]:47193 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbZBJDPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 22:15:13 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Michal Hocko <mhocko@suse.cz>
Subject: Re: [RFC] Suspicious bug in module refcounting
Date: Tue, 10 Feb 2009 13:45:07 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: "David S. Miller" <davem@davemloft.net>, Karsten Keil <kkeil@suse.de>,
       linux-kernel@vger.kernel.org, richard kennedy <richard@rsk.demon.co.uk>,
       Dan Williams <dan.j.williams@intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>, dwmw2@infradead.org,
       Scott Wood <scottwood@freescale.com>, netdev@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
References: <20090203134721.GA11069@pingi.kke.suse.de> <200902041418.09630.rusty@rustcorp.com.au> <20090209151830.GC6018@dhcp35.suse.cz>
In-Reply-To: <20090209151830.GC6018@dhcp35.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902101345.08580.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 February 2009 01:48:31 Michal Hocko wrote:
> Based on this change, would it make sense to update sys_accept to change
> __module_get to try_module_get like in the following patch?

I don't think so:

>  	/*
> -	 * We don't need try_module_get here, as the listening socket (sock)
> -	 * has the protocol module (sock->ops->owner) held.
> +	 * Socket's owner cannot be in unloading path because there
> +	 * must be at least one listening reference
>  	 */
> -	__module_get(newsock->ops->owner);
> +	if (unlikely(!try_module_get(newsock->ops->owner)))
> +		BUG();

rmmod --wait can make try_module_get fail even if the reference count isn't
zero.  But in this case, we should return an error from the accept call;
presumably the admin really doesn't want us to keep using the module...

Thanks,
Rusty.
