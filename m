Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbZAZVTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbZAZVTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 16:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbZAZVTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 16:19:43 -0500
Received: from isrv.corpit.ru ([81.13.33.159]:45579 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbZAZVTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 16:19:42 -0500
Message-ID: <497E28EA.8060504@msgid.tls.msk.ru>
Date: Tue, 27 Jan 2009 00:19:38 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: linux-kernel@vger.kernel.org, sgrubb@redhat.com, esandeen@redhat.com,
       sukadev@us.ibm.com, alan@lxorguk.ukuu.org.uk
Subject: Re: tty: tty_open can return to userspace holding tty_mutex
References: <1233003761.9850.14.camel@localhost.localdomain>
In-Reply-To: <1233003761.9850.14.camel@localhost.localdomain>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote:
> __tty_open could return (to userspace) holding the tty_mutex thanks to a
> regression introduced by 4a2b5fddd53b80efcb3266ee36e23b8de28e761a.  This was
> found by bisecting an fsfuzzer problem.  Admittedly I have no idea how it
> managed to tickle this 100% reliably, but it is clearly a regression and
> when hit leaves the box in a completely unusable state.  This patch lets
> the fsfuzzer test complete every time.

This should go to -stable too, right?
It's present in 2.6.28 (but not 2.6.27).

/mjt

> Signed-off-by: Eric Paris <eparis@redhat.com>
> 
> ---
>  drivers/char/tty_io.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
> index d33e5ab..bc84e12 100644
> --- a/drivers/char/tty_io.c
> +++ b/drivers/char/tty_io.c
> @@ -1817,8 +1817,10 @@ got_driver:
>  		/* check whether we're reopening an existing tty */
>  		tty = tty_driver_lookup_tty(driver, inode, index);
>  
> -		if (IS_ERR(tty))
> +		if (IS_ERR(tty)) {
> +			mutex_unlock(&tty_mutex);
>  			return PTR_ERR(tty);
> +		}
>  	}
>  
>  	if (tty) {

