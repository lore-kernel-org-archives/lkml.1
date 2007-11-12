Return-Path: <linux-kernel-owner+w=401wt.eu-S1759203AbXKLSnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203AbXKLSnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 13:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbXKLSnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 13:43:13 -0500
Received: from ns1.suse.de ([195.135.220.2]:36159 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277AbXKLSnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 13:43:12 -0500
From: Frank Seidel <fseidel@suse.de>
Organization: SUSE LINUX Products GmbH
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [RFC 8/13] Char: nozomi, tty cleanup
Date: Mon, 12 Nov 2007 19:43:08 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <15624318902788326176.slaby@pripojeni.net>
In-Reply-To: <15624318902788326176.slaby@pripojeni.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711121943.09612.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Samstag 10 November 2007 00:48:11, you (Jiri Slaby) wrote:
> nozomi, tty cleanup
> - init and deinit tty driver at module load/unload. When the OS (user)
>   loads the driver the hardware usually is ready to driver.
> - merge (unify) MAX_PORT, NTTY_TTY_MINORS into NOZOMI_MAX_PORTS
> - remove struct nozomi_devices, it was used only as list entries

This one took a little bit longer to review and test in depth, but
i finally made it.
I really find this a really good rework, i did only a few little
very minor changes (see comments below).
Please take my comments with a big pinch of salt (as i really am very
passionate to become a kernel hacker but still lack too much knowledge
and experience in many areas).

> ...
> @@ -172,9 +172,6 @@ static int debug;
>  ...
> -#define NTTY_TTY_MINORS		MAX_PORT
> -#define NTTY_TTY_MAXMINORS	256
>  ...
> -#define MAX_PORT		4
> -#define NOZOMI_MAX_PORTS	5
> +#define NOZOMI_MAX_PORTS	4
> +#define NOZOMI_MAX_CARDS	(256 / NOZOMI_MAX_PORTS)
> +#define NOZOMI_MAX_MINORS	(NOZOMI_MAX_PORTS * NOZOMI_MAX_CARDS)

I don't see the benefit in indirectly defining the maxminors in maxcards
and count back then. Perhaps this is cleaner/better but i just don't
understand it (now). So, i just did a additional
#define NOZOMI_MAX_CARDS (NTTY_TTY_MAXMINORS / NTTY_TTY_MINORS)
which seamed more straightforward to me and didn't break anything (as the
change to NOZOMI_MAX_PORTS currently would).
But to at least merge it a bit i removed the NTTY_TTY_MINORS alias for
MAX_PORT (and of course replaced usages with MAX_PORT).

>  ...
> -		for (i = PORT_MDM; i < MAX_PORT; i++) {
> +		for (i = PORT_MDM; i < NOZOMI_MAX_PORTS; i++) {

Those changes e.g. aren't needed when just adding the one define as i
suggested above.
All other comments vanished after i studied them better :-)

I'll repost the complete patch in a few moments (in CC to Greg again).

Thanks so much for this,
Frank
