Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbZBIOKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbZBIOKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 09:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbZBIOKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 09:10:35 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:65346 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbZBIOKe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 09:10:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pc85v/TCwnzCS/rTKWXKMAhviXGure67cXn7dW294xeDswKxa5QDlO+unR8L9G+stM
         tbPlbyYyhcpF7fREhb8enAmi5983gvYUf4khA3royt/4tWocaYs2yUn+7W/GOwSJ1nYO
         +FZDXyQMvrvNliQ+WsQiugVBIPydCmZ/IR9JQ=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0902090853360.20576@wrl-59.cs.helsinki.fi>
References: <20090206054541.GA4954@gondor.apana.org.au>
	 <b6a2187b0902060335h646e8d86pf00773035f577665@mail.gmail.com>
	 <20090209055848.GA3889@gondor.apana.org.au>
	 <20090208.220357.261414983.davem@davemloft.net>
	 <20090209061151.GA3982@gondor.apana.org.au>
	 <Pine.LNX.4.64.0902090853360.20576@wrl-59.cs.helsinki.fi>
Date: Mon, 9 Feb 2009 22:10:32 +0800
Message-ID: <b6a2187b0902090610v56cc0789m1bbb144994078474@mail.gmail.com>
Subject: Re: commit 64ff3b938ec6782e6585a83d5459b98b0c3f6eb8 breaks rlogin
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       David Miller <davem@davemloft.net>, rjw@sisk.pl,
       torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 9, 2009 at 3:13 PM, Ilpo Järvinen <ilpo.jarvinen@helsinki.fi> wrote:
>  net/ipv4/tcp_output.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 557fe16..c808d73 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -667,7 +667,8 @@ static int tcp_transmit_skb(struct sock *sk, struct sk_buff *skb, int clone_it,
>                if (between(tp->snd_up, tcb->seq + 1, tcb->seq + 0xFFFF)) {
>                        th->urg_ptr = htons(tp->snd_up - tcb->seq);
>                        th->urg = 1;
> -               } else if (after(tcb->seq + 0xFFFF, tp->snd_nxt)) {
> +               } else if (after(tcb->seq + 0xFFFF, tp->snd_nxt) &&
> +                          before(tcb->seq, tcp->snd_up)) {
>                        th->urg_ptr = 0xFFFF;
>                        th->urg = 1;
>                }
> --
> 1.5.6.5
>

Ilpo,

Got this error ...

  CC      net/ipv4/tcp_output.o
net/ipv4/tcp_output.c: In function 'tcp_transmit_skb':
net/ipv4/tcp_output.c:671: error: 'tcp' undeclared (first use in this function)
net/ipv4/tcp_output.c:671: error: (Each undeclared identifier is
reported only once
net/ipv4/tcp_output.c:671: error: for each function it appears in.)

> +                          before(tcb->seq, tcp->snd_up)) {

That should be "tp->snd_up" instead of "tcp->snd_up". Other than that,
the good news is I've tested your patch on top of Herbert's patch, and
it works! No more rlogin hangs!

Thanks,
Jeff.
