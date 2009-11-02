Return-Path: <linux-kernel-owner+w=401wt.eu-S932110AbZKBRjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbZKBRjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756210AbZKBRjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:39:18 -0500
Received: from isilmar.linta.de ([213.133.102.198]:58609 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755990AbZKBRjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:39:16 -0500
Date: Mon, 2 Nov 2009 18:38:43 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Jose Marino <braket@hotmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: Help needed, Re: [Bug #14334] pcmcia suspend regression from
	2.6.31.1 to 2.6.31.2 - Dell Inspiron 600m
Message-ID: <20091102173843.GA662@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Jose Marino <braket@hotmail.com>,
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
	Linux PCI <linux-pci@vger.kernel.org>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <200911010936.10409.rjw@sisk.pl> <alpine.LFD.2.01.0911010914100.31845@localhost.localdomain> <200911021439.28266.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911021439.28266.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

just two minor nit-pick which we could handle post-2.6.32:

> +++ linux-2.6/drivers/pcmcia/cs.c
> @@ -98,10 +98,13 @@ EXPORT_SYMBOL(pcmcia_socket_list_rwsem);
>   * These functions check for the appropriate struct pcmcia_soket arrays,
>   * and pass them to the low-level functions pcmcia_{suspend,resume}_socket

... some documentation of the new functions, especially whether other socket
drivers should be updated?

> -static int socket_resume(struct pcmcia_socket *skt)
> +static void socket_start_resume(struct pcmcia_socket *skt)
>  {
> -	int ret;
> -
> -	if (!(skt->state & SOCKET_SUSPEND))
> -		return -EBUSY;
> -
>  	skt->socket = dead_socket;
>  	skt->ops->init(skt);
>  	skt->ops->set_socket(skt, &skt->socket);
> +	if (skt->state & SOCKET_PRESENT)
> +		skt->resume_status = socket_setup(skt, resume_delay);
> +}
>  
> +static int socket_early_resume(struct pcmcia_socket *skt)
> +{
> +	socket_start_resume(skt);
> +	return 0;
> +}

Why do we need to have two functions doing the same? Wouldn't

static int socket_early_resume(...)

suffice, with the only call to socket_start_resume() being replaced with
socket_early_resume()?

Best,
	Dominik
