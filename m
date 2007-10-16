Return-Path: <linux-kernel-owner+w=401wt.eu-S965577AbXJPXGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965577AbXJPXGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 19:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933924AbXJPXFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 19:05:53 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:45463 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933866AbXJPXFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 19:05:52 -0400
Message-ID: <471543C3.3050502@tiscali.nl>
Date: Wed, 17 Oct 2007 01:05:39 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty_ioctl: Fix the baud_table check in encode_baud_rate
References: <Pine.LNX.4.64N.0710161857280.22596@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0710161857280.22596@blysk.ds.pg.gda.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since you were sending a fix, possibly I shouldn't comment on this. If so please disregard my
suggestion for a trivial cleanup.

Roel

Maciej W. Rozycki wrote:
> +void tty_termios_encode_baud_rate(struct ktermios *termios,
> +				  speed_t ibaud, speed_t obaud)
>  {
>  	int i = 0;
>  	int ifound = -1, ofound = -1;
> @@ -251,12 +252,15 @@ void tty_termios_encode_baud_rate(struct
>  	termios->c_cflag &= ~CBAUD;
>  
>  	do {
> -		if (obaud - oclose >= baud_table[i] && obaud + oclose <= baud_table[i]) {
> +		if (obaud - oclose <= baud_table[i] &&
> +		    obaud + oclose >= baud_table[i]) {

if(a - b <= c && a + b >= c)
if(a <= c + b && a + b >= c)
if(c + b >= a && a + b >= c)
if(b >= a - c && b >= c - a)
true, if:
b >= |a - c|
so
		if (oclose >= abs(obaud - baud_table[i])) {

should work as well

>  			termios->c_cflag |= baud_bits[i];
>  			ofound = i;
>  		}
> -		if (ibaud - iclose >= baud_table[i] && ibaud + iclose <= baud_table[i]) {
> -			/* For the case input == output don't set IBAUD bits if the user didn't do so */
> +		if (ibaud - iclose <= baud_table[i] &&
> +		    ibaud + iclose >= baud_table[i]) {

similarly,
		if (iclose >= abs(ibaud - baud_table[i])) {

> +			/* For the case input == output don't set IBAUD bits
> +			   if the user didn't do so */
>  			if (ofound != i || ibinput)
>  				termios->c_cflag |= (baud_bits[i] << IBSHIFT);
>  			ifound = i;
