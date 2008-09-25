Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbYIYGRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbYIYGRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 02:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbYIYGRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 02:17:15 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:46112 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754109AbYIYGRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 02:17:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=28K4NobIjT4p/5ACZK1qgOfhYLogQ9H+frAH09cGlEzUbSrCksfwkwDt4kWNHZQBSH8TmU8WR4Qbrb3hGe28XP0D6RM3Ml2W96V+kMvGLdtP0/l/wUHbTResaTTBhegmuupY+Fl7KEtyTe8KSO2JuKlpSCLGkPEiZpClAphjdv0=  ;
X-YMail-OSG: hzsnGrIVM1mXWjdnk.Kh2LNAzwpgBrabY592f5.7izVcjIx4gbrgpXdr4m6gZn7OMu2f6gMUcWWQQ2X4VYRAr1sxgjKklkqcP0XRcLsRsr9iLKNcUX79LXHav.RpfhkZRyI-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Christian Pellegrin <chripell@gmail.com>
Subject: Re: [spi-devel-general] [PATCH RESEND] max3100 driver
Date: Wed, 24 Sep 2008 21:56:29 -0700
User-Agent: KMail/1.9.9
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Christian Pellegrin <chripell@fsfe.org>,
       alan@lxorguk.ukuu.org.uk, linux-serial@vger.kernel.org
References: <12219154581088-git-send-email-chripell@gmail.com>
In-Reply-To: <12219154581088-git-send-email-chripell@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200809242156.29505.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You got this working ... congrats!  :)

Small suggestion:  next time you resend this, make sure
that $SUBJECT mentions it's a UART driver.  Maybe even that
it's a SPI UART driver.  That should help get more comments.


On Saturday 20 September 2008, Christian Pellegrin wrote:
> +struct plat_max3100 {
> +/* force MAX3100 in loopback */
> +       int loopback;
> +/* 0 for 3.6864 Mhz, 1 for 1.8432  */
> +       int crystal;
> +/* for archs like PXA with only edge irqs */
> +       int only_edge_irq;
> +/* MAX3100 has a shutdown pin. This is a hook
> +   called on suspend and resume to activate it.*/
> +       void (*max3100_hw_suspend) (int suspend);
> +/* poll time for ctr signals in ms, 0 disables (so no hw flow
> + * ctrl is possible)  */
> +       int poll_time;
> +};

This is a bit picky, but it's the first thing I noticed when
scanning the patch ... wierd comment layout!  Either indent
those all, or (better) convert to kerneldoc style.

Potentially less picky:  probe() doesn't lock max3100s[],
neither does remove(), and in fact there seems to be no
lock for that table.  Which suggests trouble in cases like
concurrent I/O (including open) and driver remove().  You
should probably just allocate a mutex to help control that
table, like most other drivers.

And is that workqueue single threaded?


I just skimmed the rest of the driver.  Seems to be
fairly straightforward -- at least the non-TTY bits.
