Return-Path: <linux-kernel-owner+w=401wt.eu-S1752371AbZJSL5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbZJSL5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 07:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbZJSL5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 07:57:16 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:43954 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbZJSL5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 07:57:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=b5UyfmW1s0bdZksZwoQwuwXMPgg1fvkFzc6VhTDrhqgCt4tok/B/SzNjdrea2/NVfI
         hAspgGeBTNSQFTKXfDAkxIHd0K4romf304HyrK+I0YGnwijaU/SotKLV1F9wxHZ8DVBt
         sz0FXI6roJjKEF1q95VgY1uNA/NeCmMDJgy2A=
Date: Mon, 19 Oct 2009 11:57:13 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, davem@davemloft.net,
       satoshi.oshima.fk@hitachi.com, hidehiro.kawai.ez@hitachi.com,
       hideo.aoki.tk@hitachi.com
Subject: Re: [PATCH] AF_UNIX: Fix deadlock on connecting to shutdown socket
Message-ID: <20091019115713.GB6869@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ADC010C.5070809@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19-10-2009 08:02, Tomoki Sekiyama wrote:
...
> Why this happens:
>  Error checks between unix_socket_connect() and unix_wait_for_peer() are
>  inconsistent. The former calls the latter to wait until the backlog is
>  processed. Despite the latter returns without doing anything when the
>  socket is shutdown, the former doesn't check the shutdown state and
>  just retries calling the latter forever.
> 
> Patch:
>  The patch below adds shutdown check into unix_socket_connect(), so
>  connect(2) to the shutdown socket will return -ECONREFUSED.
> 
> Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
> Signed-off-by: Masanori Yoshida <masanori.yoshida.tv@hitachi.com>
> ---
>  net/unix/af_unix.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 51ab497..fc820cd 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -1074,6 +1074,8 @@ restart:
>  	err = -ECONNREFUSED;
>  	if (other->sk_state != TCP_LISTEN)
>  		goto out_unlock;
> +	if (other->sk_shutdown & RCV_SHUTDOWN)
> +		goto out_unlock;

Isn't the shutdown call expected to change sk_state to TCP_CLOSE?

Jarek P.
