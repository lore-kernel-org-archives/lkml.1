Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab0BXIzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 03:55:51 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:50018 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755884Ab0BXIzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 03:55:49 -0500
X-Sasl-enc: qpIzwIH+FUACKgklIxXHiUktpxv7tJ27sMXTHLBbg4iI 1267001748
Message-ID: <4B84E993.5080903@imap.cc>
Date: Wed, 24 Feb 2010 09:55:47 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; de; rv:1.9.1.8) Gecko/20100205 SeaMonkey/2.0.3
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: linux-kernel@vger.kernel.org, Hansjoerg Lipp <hjlipp@web.de>
Subject: Re: [PATCHv2 1/2] drivers: isdn: get rid of custom strtoul()
References: <47f90389321e1cb7d5adb222cef8c21c7d715bc8.1266952616.git.andy.shevchenko@gmail.com>
In-Reply-To: <47f90389321e1cb7d5adb222cef8c21c7d715bc8.1266952616.git.andy.shevchenko@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Am 2010-02-23 20:21 schrieb Andy Shevchenko:
> --- a/drivers/isdn/gigaset/ev-layer.c
> +++ b/drivers/isdn/gigaset/ev-layer.c
> @@ -420,64 +420,18 @@ static const struct zsau_resp_t {
>  	{NULL,				ZSAU_UNKNOWN}
>  };
>  
> -/*
> - * Get integer from char-pointer
> - */
> -static int isdn_getnum(char *p)
> -{
> -	int v = -1;
> -
> -	gig_dbg(DEBUG_TRANSCMD, "string: %s", p);

This conflicts (trivially) with:
[PATCH 3/4] gigaset: reduce syslog clutter
which I submitted the day before yesterday and which has not yet been
merged into *-next.

> -/*
> - * Get integer from char-pointer
> - */
> -static int isdn_gethex(char *p)
> -{
> -	int v = 0;
> -	int c;
> -
> -	gig_dbg(DEBUG_TRANSCMD, "string: %s", p);

Idem.

>  /* retrieve CID from parsed response
>   * returns 0 if no CID, -1 if invalid CID, or CID value 1..65535
>   */
>  static int cid_of_response(char *s)
>  {
>  	int cid;
> +	int rc;
>  
>  	if (s[-1] != ';')
>  		return 0;	/* no CID separator */
> -	cid = isdn_getnum(s);
> -	if (cid < 0)
> +	rc = strict_strtoul(s, 10, &cid);

strict_strtoul() expects unsigned long* as its third argument, but cid
is an int. Consequently, this generates sparse warnings:

drivers/isdn/gigaset/ev-layer.c:433:30: warning: incorrect type in
argument 3 (different type sizes)
drivers/isdn/gigaset/ev-layer.c:433:30:    expected unsigned long *<noident>
drivers/isdn/gigaset/ev-layer.c:433:30:    got int *<noident>

and compiler warnings:

drivers/isdn/gigaset/ev-layer.c: In function ‘cid_of_response’:
drivers/isdn/gigaset/ev-layer.c:433: warning: passing argument 3 of
‘strict_strtoul’ from incompatible pointer type
include/linux/kernel.h:176: note: expected ‘long unsigned int *’ but
argument is of type ‘int *’

> @@ -648,9 +602,11 @@ void gigaset_handle_modem_response(struct cardstate *cs)
>  		case RT_ZCAU:
>  			event->parameter = -1;
>  			if (curarg + 1 < params) {
> -				i = isdn_gethex(argv[curarg]);
> -				j = isdn_gethex(argv[curarg + 1]);
> -				if (i >= 0 && i < 256 && j >= 0 && j < 256)
> +				int ri = strict_strtoul(argv[curarg], 16, &i);
> +				int rj = strict_strtoul(argv[curarg+1], 16, &j);

Idem.

> @@ -660,12 +616,14 @@ void gigaset_handle_modem_response(struct cardstate *cs)
>  		case RT_NUMBER:
>  		case RT_HEX:
>  			if (curarg < params) {
> -				if (param_type == RT_HEX)
> -					event->parameter =
> -						isdn_gethex(argv[curarg]);
> -				else
> -					event->parameter =
> -						isdn_getnum(argv[curarg]);
> +				int base = (param_type == RT_HEX) ? 16 : 10;
> +				unsigned long res;
> +				int rc;
> +
> +				rc = strict_strtoul(argv[curarg], base, &res);

Idem.

Thanks,
Tilman

- -- 
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Ungeöffnet mindestens haltbar bis: (siehe Rückseite)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkuE6ZMACgkQQ3+did9BuFtLUQCfcPv6XMsFCmSJ+BfU4W42F1k4
tI0AnjsOK0rGkIF3Gnx4S4z3bzMriCw3
=xfZT
-----END PGP SIGNATURE-----
