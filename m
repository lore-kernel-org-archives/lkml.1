Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbYJVGRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbYJVGRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 02:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbYJVGRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 02:17:09 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:35950 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751446AbYJVGRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 02:17:08 -0400
Message-Id: <1224656226.15955.1280589369@webmail.messagingengine.com>
X-Sasl-Enc: YIQoXQMlB/xH30hmx5L90XHF9YiijyVHxgaOiz+iX70j 1224656226
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Richard Kennedy" <richard@rsk.demon.co.uk>, jgarzik@pobox.com
Cc: "lkml" <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1224620672.3110.59.camel@castor.localdomain>
Subject: Re: [PATCH] block: convert ata_port_for_each_link to use a while loop
 to reduce code size
In-Reply-To: <1224620672.3110.59.camel@castor.localdomain>
Date: Wed, 22 Oct 2008 08:17:06 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2008 21:24:32 +0100, "Richard Kennedy"
<richard@rsk.demon.co.uk> said:
> convert a for loop to a while loop in the ata_port_for_each_link macros
> to reduce code size.
> 
> on x86_64 size reports reduction of text size in
> 	libata.ko : -272 bytes
> 	ahci.ko   : -44 bytes
> 
> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
> 
> ----
> This patch is against 2.6.27 git head.
> 
> I've been running this patch on my AMD64 desktop machine for several
> days & have not seen any problems.
> regards
> Richard
> 
> 
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 947cf84..bbe3b9d 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -1283,12 +1283,12 @@ extern struct ata_link
> *__ata_port_next_link(struct ata_port *ap,
>  					     bool dev_only);
>  
>  #define __ata_port_for_each_link(link, ap) \
> -	for ((link) = __ata_port_next_link((ap), NULL, false); (link); \
> -	     (link) = __ata_port_next_link((ap), (link), false))
> +	(link) = NULL; \
> +	while (((link) = __ata_port_next_link((ap), (link), false)))

Hi Richard,

Please imagine how this expands...

if (some_condition)
        __ata_port_for_each_link(link, ap)
                do_something(...)

But it is probably possible to get the same size reduction by
changing the for-loop like this (safety parentheses left out):

        for (link = NULL;
                link = __ata_port_next_link(ap, link, false), link; )

Some programmers think this is abuse of the for-construct, though ;).

Greetings,
    Alexander

>  #define ata_port_for_each_link(link, ap) \
> -	for ((link) = __ata_port_next_link((ap), NULL, true); (link); \
> -	     (link) = __ata_port_next_link((ap), (link), true))
> +	(link) = NULL; \
> +	while (((link) = __ata_port_next_link((ap), (link), true)))
>  
>  #define ata_link_for_each_dev(dev, link) \
>  	for ((dev) = (link)->device; \
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - mmm... Fastmail...

