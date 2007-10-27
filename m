Return-Path: <linux-kernel-owner+w=401wt.eu-S1752650AbXJ1SM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbXJ1SM7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 14:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754626AbXJ1SL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 14:11:59 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4534 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752538AbXJ1SL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 14:11:58 -0400
Date: Sat, 27 Oct 2007 07:45:56 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PCMCIA insert on resume
Message-ID: <20071027074556.GC6043@ucw.cz>
References: <20071024143444.GF9748@enneenne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024143444.GF9748@enneenne.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I don't understand why, on resume, the function socket_resume() (in
> drivers/pcmcia/cs.c) do:
> 
>        if (!(skt->state & SOCKET_PRESENT)) {
>                skt->state &= ~SOCKET_SUSPEND;
>                return socket_insert(skt);
>        }
> 
> This cause a powered off socket before suspend to be powered on during
> resume.
> 
> To avoid such (erroneous?) behaviour I propose this patch:
> 
> diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
> index 729e37d..d69de74 100644
> --- a/drivers/pcmcia/cs.c
> +++ b/drivers/pcmcia/cs.c
> @@ -562,10 +562,8 @@ static int socket_resume(struct pcmcia_socket *skt)
>         skt->ops->init(skt);
>         skt->ops->set_socket(skt, &skt->socket);
>  
> -       if (!(skt->state & SOCKET_PRESENT)) {
> -               skt->state &= ~SOCKET_SUSPEND;
> -               return socket_insert(skt);
> -       }
> +       if (!(skt->state & SOCKET_PRESENT))
> +               goto resume_exit;
>  
>         ret = socket_setup(skt, SS_COMA, resume_delay);
>         if (ret == CS_SUCCESS) {
> @@ -599,6 +597,7 @@ static int socket_resume(struct pcmcia_socket *skt)
>                 socket_shutdown(skt);
>         }
>  
> +resume_exit:
>         skt->state &= ~SOCKET_SUSPEND;
>  
>         return CS_SUCCESS;
> 
> With this patch if the socket was powered down before the suspend, at
> resume time it's not powered on and you need a "pccardctl insert" to
> activate the socket.

Seems okay to me, but I do not know much about pcmcia. Add
signed-off-by, changelog at the beggining, cc me, rafael and akpm... ?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
