Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbXIMMae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbXIMMae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 08:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbXIMMa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 08:30:26 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:45191 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbXIMMa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 08:30:26 -0400
Subject: Re: hci_sock.c build failure
From: Marcel Holtmann <marcel@holtmann.org>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
In-Reply-To: <200709131211.10950.toralf.foerster@gmx.de>
References: <200709131211.10950.toralf.foerster@gmx.de>
Content-Type: text/plain
Date: Thu, 13 Sep 2007 14:29:13 +0200
Message-Id: <1189686553.12789.80.camel@aeonflux.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Toralf,

> I'm wondering why the build failure wasn't fixed by a patch like this:
> 
> 
> diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
> index 5ccea5f..85416bb 100644
> --- a/net/bluetooth/hci_sock.c
> +++ b/net/bluetooth/hci_sock.c
> @@ -348,8 +348,6 @@ static inline void hci_sock_cmsg(struct sock *sk, struct msghdr *msg, struct sk_
> 
>                 skb_get_timestamp(skb, &tv);
> 
> -               data = &tv;
> -               len = sizeof(tv);
>  #ifdef CONFIG_COMPAT
>                 if (msg->msg_flags & MSG_CMSG_COMPAT) {
>                         struct compat_timeval ctv;
> @@ -358,6 +356,9 @@ static inline void hci_sock_cmsg(struct sock *sk, struct msghdr *msg, struct sk_
>                         data = &ctv;
>                         len = sizeof(ctv);
>                 }
> +#else
> +               data = &tv;
> +               len = sizeof(tv);
>  #endif
> 
>                 put_cmsg(msg, SOL_HCI, HCI_CMSG_TSTAMP, len, data);

because that is wrong and will give you a different issue (the other way
around actually) that the change to use compat_timeval actually tried to
fix. Your patch actually will allow to return arbitrary kernel memory in
case of 64-bit applications since data and len might not be initialized.

In case of 64-bit kernels you can have 64-bit or 32-bit applications. In
case of 32-bit application you have to return compat_timeval and in cas
of 64-bit application you have to return timeval. It is checked by
MSG_CMSG_COMPAT runtime flag and not the CONFIG_COMPAT compile option.

Regards

Marcel


