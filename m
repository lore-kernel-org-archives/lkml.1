Return-Path: <linux-kernel-owner+w=401wt.eu-S933014AbYD2PdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014AbYD2PdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757526AbYD2Pc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:32:57 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:3839 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756978AbYD2Pc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:32:56 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Apr 2008 11:32:56 EDT
Date: Tue, 29 Apr 2008 17:26:07 +0200
From: Olivier Galibert <galibert@pobox.com>
To: linux-kernel@vger.kernel.org
Cc: alan@redhat.com
Subject: Re: [PATCH] isicom: Fix buffer allocation
Message-ID: <20080429152607.GA40409@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	linux-kernel@vger.kernel.org, alan@redhat.com
References: <20080429141733.607a2306@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429141733.607a2306@core>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 02:17:33PM +0100, Alan Cox wrote:
> Fix the rather strange buffer management on open that turned up while
> auditing for BKL dependancies
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/drivers/char/isicom.c linux-2.6.25-mm1/drivers/char/isicom.c
> --- linux.vanilla-2.6.25-mm1/drivers/char/isicom.c	2008-04-28 11:36:48.000000000 +0100
> +++ linux-2.6.25-mm1/drivers/char/isicom.c	2008-04-14 10:56:25.000000000 +0100
> @@ -813,15 +813,13 @@
>  		return 0;
>  	if (!port->xmit_buf) {
>  		/* Relies on BKL */
> +		unsigned long page  = get_zeroed_page(GFP_KERNEL);
> +		if (page == 0)
>  			return -ENOMEM;
> +		if (port->xmit_buf)
> +			free_page(page);
> +		else
> +			port->xmit_buf = (unsigned char *) page;
>  	}


Still looks rather strange.  An if(x) inside an if(!x) ?

  OG.
