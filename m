Return-Path: <linux-kernel-owner+w=401wt.eu-S1757974AbYLFD4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974AbYLFD4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 22:56:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbYLFD4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 22:56:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751653AbYLFD43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 22:56:29 -0500
Date: Fri, 5 Dec 2008 19:56:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "m m" <olsajiri@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: netlink - notify when the socket gets closed
Message-Id: <20081205195624.95ea1866.akpm@linux-foundation.org>
In-Reply-To: <35476bd20812050017y70c3c729v450cdc3d0c1188de@mail.gmail.com>
References: <35476bd20812050017y70c3c729v450cdc3d0c1188de@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc netdev@vger.kernel.org)

On Fri, 5 Dec 2008 09:17:51 +0100 "m m" <olsajiri@gmail.com> wrote:

> Hi,
> 
> I'm using netlink in my module. Based on the communication,
> this module dynamically creates some internal structure, which
> needs to be destroyed when the user level socket is closed (or
> the application dies).
> 
> I found I could use the netlink_register_notifier function to register
> NETLINK_URELEASE callback during the netlink_release function.
> But since my module uses the multicast netlink socket communication,
> it wont be called:
> 
> static int netlink_release(struct socket *sock)
> {
>         ...
> 
>         if (nlk->pid && !nlk->subscriptions) {
>                 struct netlink_notify n = {
>                                                 .net = sock_net(sk),
>                                                 .protocol = sk->sk_protocol,
>                                                 .pid = nlk->pid,
>                                           };
>                 atomic_notifier_call_chain(&netlink_chain,
>                                 NETLINK_URELEASE, &n);
>         }
>         ...
> 
> Whats the reason this callback is not called for multicast sockets?
> 
> To workaround it I created simple misc device which the user application
> opens before creating the netlink socket. This way I get some callbacks
> inside the module when the application dies, at least.. pretty ugly :)
> 
> Is there a netlink mechanism to be notified when the netlink socket is
> closed on the user level side? (when using multicast communication)
> 
> Or is there any other design I could use, since I think I'm not alone in
> using internal module data which needs to be removed once the application dies.

