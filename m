Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbYLLTwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbYLLTwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 14:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbYLLTv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 14:51:59 -0500
Received: from nauticaltech.com ([64.34.252.43]:50831 "EHLO nauticaltech.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbYLLTv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 14:51:59 -0500
Message-ID: <4942C0DD.50602@nauticaltech.com>
Date: Fri, 12 Dec 2008 11:51:57 -0800
From: Michael Spiegle <mike@nauticaltech.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Evgeniy Polyakov <zbr@ioremap.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [Bugme-new] [Bug 12201] New: long wait in call_usermodehelper()
 / queue_work() / wait_for_completion()
References: <bug-12201-10286@http.bugzilla.kernel.org/> <20081211143758.510b51b6.akpm@linux-foundation.org> <20081211225158.GA2169@ioremap.net> <20081211230521.GA2392@ioremap.net>
In-Reply-To: <20081211230521.GA2392@ioremap.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Btw, does this ugly hack fix the problem?
> According to your description it may be the case.
> 
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index 480184a..2b64eb5 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -434,6 +434,10 @@ static int netlink_create(struct net *net, struct socket *sock, int protocol)
>  	if (protocol < 0 || protocol >= MAX_LINKS)
>  		return -EPROTONOSUPPORT;
>  
> +#ifndef CONFIG_AUDIT
> +	if (protocol == NETLINK_AUDIT)
> +		return -EPROTONOSUPPORT;
> +#endif
>  	netlink_lock_table();
>  #ifdef CONFIG_MODULES
>  	if (!nl_table[protocol].registered) {
> 
> 

Yes, that would take care of it.  My original workaround was to disable 
CONFIG_KMOD.  I only have a few modules compiled (for servers that 
require those modules), but most of my servers don't need any modules. 
This would allow me to manually load modules myself and never have to 
worry about the kernel forking stuff in userspace.  Unfortunately, it 
appears that CONFIG_KMOD is being deprecated soon and I didn't want to 
rely on it.

What is the core reason for removing CONFIG_KMOD?  I personally would 
rather have the choice as to whether my kernel tries to find its own 
modules or not.

Michael Spiegle
mike@nauticaltech.com
