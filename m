Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbXJ1Sje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbXJ1Sje (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 14:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbXJ1SjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 14:39:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60042 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbXJ1SjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 14:39:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: PCMCIA insert on resume
Date: Sun, 28 Oct 2007 19:55:52 +0100
User-Agent: KMail/1.9.5
Cc: Rodolfo Giometti <giometti@enneenne.com>, linux-kernel@vger.kernel.org,
       Russell King <rmk+lkml@arm.linux.org.uk>
References: <20071024143444.GF9748@enneenne.com> <20071027074556.GC6043@ucw.cz>
In-Reply-To: <20071027074556.GC6043@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710281955.52798.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 27 October 2007 09:45, Pavel Machek wrote:
> Hi!
> 
> > I don't understand why, on resume, the function socket_resume() (in
> > drivers/pcmcia/cs.c) do:
> > 
> >        if (!(skt->state & SOCKET_PRESENT)) {
> >                skt->state &= ~SOCKET_SUSPEND;
> >                return socket_insert(skt);
> >        }
> > 
> > This cause a powered off socket before suspend to be powered on during
> > resume.
> > 
> > To avoid such (erroneous?) behaviour I propose this patch:
> > 
> > diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
> > index 729e37d..d69de74 100644
> > --- a/drivers/pcmcia/cs.c
> > +++ b/drivers/pcmcia/cs.c
> > @@ -562,10 +562,8 @@ static int socket_resume(struct pcmcia_socket *skt)
> >         skt->ops->init(skt);
> >         skt->ops->set_socket(skt, &skt->socket);
> >  
> > -       if (!(skt->state & SOCKET_PRESENT)) {
> > -               skt->state &= ~SOCKET_SUSPEND;
> > -               return socket_insert(skt);
> > -       }
> > +       if (!(skt->state & SOCKET_PRESENT))
> > +               goto resume_exit;
> >  
> >         ret = socket_setup(skt, SS_COMA, resume_delay);
> >         if (ret == CS_SUCCESS) {
> > @@ -599,6 +597,7 @@ static int socket_resume(struct pcmcia_socket *skt)
> >                 socket_shutdown(skt);
> >         }
> >  
> > +resume_exit:
> >         skt->state &= ~SOCKET_SUSPEND;
> >  
> >         return CS_SUCCESS;
> > 
> > With this patch if the socket was powered down before the suspend, at
> > resume time it's not powered on and you need a "pccardctl insert" to
> > activate the socket.
> 
> Seems okay to me, but I do not know much about pcmcia. Add
> signed-off-by, changelog at the beggining, cc me, rafael and akpm... ?

Actually, there are some objections wrt this patch from Russell King.

Greetings,
Rafael
