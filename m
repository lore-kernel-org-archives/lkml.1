Return-Path: <linux-kernel-owner+w=401wt.eu-S1754994AbYJVIEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbYJVIEB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 04:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbYJVIC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 04:02:56 -0400
Received: from anchor-post-32.mail.demon.net ([194.217.242.90]:3780 "EHLO
	anchor-post-32.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754347AbYJVICy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 04:02:54 -0400
Subject: Re: [PATCH] block: convert ata_port_for_each_link to use a while
	loop to reduce code size
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: jgarzik@pobox.com, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1224656226.15955.1280589369@webmail.messagingengine.com>
References: <1224620672.3110.59.camel@castor.localdomain>
	 <1224656226.15955.1280589369@webmail.messagingengine.com>
Content-Type: text/plain
Date: Wed, 22 Oct 2008 09:02:51 +0100
Message-Id: <1224662571.3176.5.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-22 at 08:17 +0200, Alexander van Heukelum wrote:
> On Tue, 21 Oct 2008 21:24:32 +0100, "Richard Kennedy"
> <richard@rsk.demon.co.uk> said:
> > convert a for loop to a while loop in the ata_port_for_each_link macros
> > to reduce code size.
> > 
> > on x86_64 size reports reduction of text size in
> > 	libata.ko : -272 bytes
> > 	ahci.ko   : -44 bytes
> > 
> > Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
> > 
> > ----
> > This patch is against 2.6.27 git head.
> > 
> > I've been running this patch on my AMD64 desktop machine for several
> > days & have not seen any problems.
> > regards
> > Richard
> > 
> > 
> > diff --git a/include/linux/libata.h b/include/linux/libata.h
> > index 947cf84..bbe3b9d 100644
> > --- a/include/linux/libata.h
> > +++ b/include/linux/libata.h
> > @@ -1283,12 +1283,12 @@ extern struct ata_link
> > *__ata_port_next_link(struct ata_port *ap,
> >  					     bool dev_only);
> >  
> >  #define __ata_port_for_each_link(link, ap) \
> > -	for ((link) = __ata_port_next_link((ap), NULL, false); (link); \
> > -	     (link) = __ata_port_next_link((ap), (link), false))
> > +	(link) = NULL; \
> > +	while (((link) = __ata_port_next_link((ap), (link), false)))
> 
> Hi Richard,
> 
> Please imagine how this expands...
> 
> if (some_condition)
>         __ata_port_for_each_link(link, ap)
>                 do_something(...)
> 
> But it is probably possible to get the same size reduction by
> changing the for-loop like this (safety parentheses left out):
> 
>         for (link = NULL;
>                 link = __ata_port_next_link(ap, link, false), link; )
> 
> Some programmers think this is abuse of the for-construct, though ;).
> 
> Greetings,
>     Alexander
> 
> >  #define ata_port_for_each_link(link, ap) \
> > -	for ((link) = __ata_port_next_link((ap), NULL, true); (link); \
> > -	     (link) = __ata_port_next_link((ap), (link), true))
> > +	(link) = NULL; \
> > +	while (((link) = __ata_port_next_link((ap), (link), true)))
> >  
> >  #define ata_link_for_each_dev(dev, link) \
> >  	for ((dev) = (link)->device; \
> -- 
>   Alexander van Heukelum
>   heukelum@fastmail.fm

yes of course, that is the problem with this kind of macro :(

IMHO, this particular macro doesn't improve the overall code readability
so would be better being removed altogether. Whenever possible I much
prefer being able to see a for or while loop in the code rather than
hidden in a macro somewhere, but maybe that's just me ;)
regards
Richard


