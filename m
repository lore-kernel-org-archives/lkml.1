Return-Path: <linux-kernel-owner+w=401wt.eu-S968876AbXILOTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968876AbXILOTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 10:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968761AbXILOTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 10:19:14 -0400
Received: from main.gmane.org ([80.91.229.2]:39405 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968746AbXILOTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 10:19:13 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Coly Li <coyli@suse.de>
Subject: Re: hci_sock.c build failure
Date: Wed, 12 Sep 2007 16:20:28 +0200
Message-ID: <46E7F5AC.90805@suse.de>
References: <20070912092929.GA2878@ahaupt-debian-vm.localdomain>	<20070912120253.GA13003@kroah.com> <20070912.051212.112608750.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
Cc: greg@kroah.com, andre@finow14.de, torvalds@osdl.org, marcel@holtmann.org,
       linux-kernel@vger.kernel.org
X-Gmane-NNTP-Posting-Host: 85.13.87.242
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
In-Reply-To: <20070912.051212.112608750.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller 写道:
> From: Greg KH <greg@kroah.com>
> Date: Wed, 12 Sep 2007 05:02:53 -0700
> 
>> It's not even a randconfig issue, my build dies too (this is Linus's
>> current tree.)
>>
>> Time to poke through the 10 bluetooth patches that were just added...
> 
> I'll push the following fix to Linus.
> 
> From 1da97f83a843f92678b614fcaebdb3e4ebd6c9dd Mon Sep 17 00:00:00 2001
> From: David S. Miller <davem@kimchee.(none)>
> Date: Wed, 12 Sep 2007 14:10:58 +0200
> Subject: [PATCH] [BLUETOOTH]: Fix non-COMPAT build of hci_sock.c
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  net/bluetooth/hci_sock.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
> index d16ca8e..5ccea5f 100644
> --- a/net/bluetooth/hci_sock.c
> +++ b/net/bluetooth/hci_sock.c
> @@ -348,16 +348,17 @@ static inline void hci_sock_cmsg(struct sock *sk, struct msghdr *msg, struct sk_
>  
>  		skb_get_timestamp(skb, &tv);
>  
> +		data = &tv;
> +		len = sizeof(tv);
> +#ifdef CONFIG_COMPAT
>  		if (msg->msg_flags & MSG_CMSG_COMPAT) {
>  			struct compat_timeval ctv;
>  			ctv.tv_sec = tv.tv_sec;
>  			ctv.tv_usec = tv.tv_usec;
>  			data = &ctv;
>  			len = sizeof(ctv);
should we consider the condition that msg->msg_flags & MSG_CMSG_COMPAT comes to true when
CONFIG_COMPAT is not defined ?

> -		} else {
> -			data = &tv;
> -			len = sizeof(tv);
>  		}
> +#endif
>  
>  		put_cmsg(msg, SOL_HCI, HCI_CMSG_TSTAMP, len, data);
>  	}

