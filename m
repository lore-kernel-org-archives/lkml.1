Return-Path: <linux-kernel-owner+w=401wt.eu-S1764166AbYD2QA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764166AbYD2QA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 12:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761473AbYD2QAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 12:00:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760280AbYD2QAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 12:00:42 -0400
Date: Tue, 29 Apr 2008 11:59:17 -0400
From: Alan Cox <alan@redhat.com>
To: Olivier Galibert <galibert@pobox.com>, linux-kernel@vger.kernel.org,
       alan@redhat.com
Subject: Re: [PATCH] isicom: Fix buffer allocation
Message-ID: <20080429155917.GD27202@devserv.devel.redhat.com>
References: <20080429141733.607a2306@core> <20080429152607.GA40409@dspnet.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429152607.GA40409@dspnet.fr.eu.org>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 05:26:07PM +0200, Olivier Galibert wrote:
> > @@ -813,15 +813,13 @@
> >  		return 0;
> >  	if (!port->xmit_buf) {
> >  		/* Relies on BKL */
> > +		unsigned long page  = get_zeroed_page(GFP_KERNEL);
> > +		if (page == 0)
> >  			return -ENOMEM;
> > +		if (port->xmit_buf)
> > +			free_page(page);
> > +		else
> > +			port->xmit_buf = (unsigned char *) page;
> >  	}
> 
> 
> Still looks rather strange.  An if(x) inside an if(!x) ?

The joys of parallelism. The serial drivers mostly do this because they
are using the BKL for open/close paths being a bit prehistoric (its on
the hit list ;))

CPU #1

	open
	port->xmit_buf == NULL
	get_zeroed_page [Can sleep dropping BKL]

CPU #2

	get_zeroed_page
	port->xmit_buf == NULL
		port->xmit_buf = page

CPU #1

	port->xmit_buf != NULL
		free page

A fine example of why proper locking is good ;)

