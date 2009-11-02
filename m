Return-Path: <linux-kernel-owner+w=401wt.eu-S1756402AbZKBSi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbZKBSi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 13:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932171AbZKBSi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 13:38:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39247 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190AbZKBSiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 13:38:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: Help needed, Re: [Bug #14334] pcmcia suspend regression from 2.6.31.1 to 2.6.31.2 - Dell Inspiron 600m
Date: Mon, 2 Nov 2009 19:40:25 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, Jose Marino <braket@hotmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <200911021439.28266.rjw@sisk.pl> <20091102173843.GA662@comet.dominikbrodowski.net>
In-Reply-To: <20091102173843.GA662@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911021940.25111.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 November 2009, Dominik Brodowski wrote:
> Hey,
> 
> just two minor nit-pick which we could handle post-2.6.32:
> 
> > +++ linux-2.6/drivers/pcmcia/cs.c
> > @@ -98,10 +98,13 @@ EXPORT_SYMBOL(pcmcia_socket_list_rwsem);
> >   * These functions check for the appropriate struct pcmcia_soket arrays,
> >   * and pass them to the low-level functions pcmcia_{suspend,resume}_socket
> 
> ... some documentation of the new functions, especially whether other socket
> drivers should be updated?

OK, I'll post a separate patch for that for .33.

> > -static int socket_resume(struct pcmcia_socket *skt)
> > +static void socket_start_resume(struct pcmcia_socket *skt)
> >  {
> > -	int ret;
> > -
> > -	if (!(skt->state & SOCKET_SUSPEND))
> > -		return -EBUSY;
> > -
> >  	skt->socket = dead_socket;
> >  	skt->ops->init(skt);
> >  	skt->ops->set_socket(skt, &skt->socket);
> > +	if (skt->state & SOCKET_PRESENT)
> > +		skt->resume_status = socket_setup(skt, resume_delay);
> > +}
> >  
> > +static int socket_early_resume(struct pcmcia_socket *skt)
> > +{
> > +	socket_start_resume(skt);
> > +	return 0;
> > +}
> 
> Why do we need to have two functions doing the same? Wouldn't
> 
> static int socket_early_resume(...)
> 
> suffice, with the only call to socket_start_resume() being replaced with
> socket_early_resume()?

Yes, it would.  I'll do that in the final version of the patch.

Thanks,
Rafael
