Return-Path: <linux-kernel-owner+w=401wt.eu-S932199AbXFBWMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbXFBWMA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 18:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759659AbXFBWLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 18:11:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:24628 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760747AbXFBWLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 18:11:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=k1A/DyLEu5vOZU8P5zgnlfMipSKOkDcO8EwUW6P3wnfPFGnAC+ti1bknWXdHmYRF03W5WTuFGxlmZUmrPuakMAr4dHoA1D4Euw3rxLRXNe8O8Nt0ONLf4uOBrOgKlekcZVPOQfdTZemEjruj5NBS71KpgfoQppWw14PxYgDJqMU=
Message-ID: <39e6f6c70706021511i42a70099lf5415adf51215b27@mail.gmail.com>
Date: Sat, 2 Jun 2007 19:11:48 -0300
From: "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [PATCH] fix race in AF_UNIX
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1HubUt-0004Hb-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1HubUt-0004Hb-00@dorka.pomaz.szeredi.hu>
X-Google-Sender-Auth: cff317da13ecee76
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/2/07, Miklos Szeredi <miklos@szeredi.hu> wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
>
> A recv() on an AF_UNIX, SOCK_STREAM socket can race with a
> send()+close() on the peer, causing recv() to return zero, even though
> the sent data should be received.
>
> This happens if the send() and the close() is performed between
> skb_dequeue() and checking sk->sk_shutdown in unix_stream_recvmsg():
>
> process A  skb_dequeue() returns NULL, there's no data in the socket queue
> process B  new data is inserted onto the queue by unix_stream_sendmsg()
> process B  sk->sk_shutdown is set to SHUTDOWN_MASK by unix_release_sock()
> process A  sk->sk_shutdown is checked, unix_release_sock() returns zero
>
> I'm surprised nobody noticed this, it's not hard to trigger.  Maybe
> it's just (un)luck with the timing.
>
> It's possible to work around this bug in userspace, by retrying the
> recv() once in case of a zero return value.
>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>
> Index: linux-2.6.22-rc2/net/unix/af_unix.c
> ===================================================================
> --- linux-2.6.22-rc2.orig/net/unix/af_unix.c    2007-06-02 23:45:47.000000000 +0200
> +++ linux-2.6.22-rc2/net/unix/af_unix.c 2007-06-02 23:45:49.000000000 +0200
> @@ -1711,20 +1711,23 @@ static int unix_stream_recvmsg(struct ki
>                 int chunk;
>                 struct sk_buff *skb;
>
> +               unix_state_rlock(sk);

this function doesn't exist anymore, see:

http://git.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commitdiff;h=e97b6936b03dd0a62991f361c048cca38ac00198

There is also another AF_UNIX patch, also related to a race.

- Arnaldo
