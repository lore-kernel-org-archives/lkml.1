Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbZCOP0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbZCOP0V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 11:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbZCOP0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 11:26:07 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:52703 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbZCOP0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 11:26:06 -0400
Date: Sun, 15 Mar 2009 16:25:12 +0100
From: Jan Yenya Kasprzak <kas@fi.muni.cz>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/1] Char: moxa, fix refcounting in moxa_poll_port
Message-ID: <20090315152512.GZ30997@fi.muni.cz>
References: <49BCCAE0.6010303@gmail.com> <1237109844-3866-1-git-send-email-jirislaby@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1237109844-3866-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Muni-Spam-TestIP: 147.251.48.3
X-Muni-Envelope-From: kas@fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sun, 15 Mar 2009 16:25:13 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
: Repost, sorry, scripts don't understand Reported-by.

	Looks OK, and works for me (against 2.6.29-rc8).
Thanks for the fast response :-).

-Yenya

: Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
: Reported-by: Jan 'Yenya' Kasprzak <kas@fi.muni.cz>
: Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>

Acked-by: Jan "Yenya" Kasprzak <kas@fi.muni.cz>

: ---
:  drivers/char/moxa.c |    9 +++++----
:  1 files changed, 5 insertions(+), 4 deletions(-)
: 
: diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
: index 8b0da97..4a4cab7 100644
: --- a/drivers/char/moxa.c
: +++ b/drivers/char/moxa.c
: @@ -1486,11 +1486,11 @@ static int moxa_poll_port(struct moxa_port *p, unsigned int handle,
:  	}
:  
:  	if (!handle) /* nothing else to do */
: -		return 0;
: +		goto put;
:  
:  	intr = readw(ip); /* port irq status */
:  	if (intr == 0)
: -		return 0;
: +		goto put;
:  
:  	writew(0, ip); /* ACK port */
:  	ofsAddr = p->tableAddr;
: @@ -1499,16 +1499,17 @@ static int moxa_poll_port(struct moxa_port *p, unsigned int handle,
:  				ofsAddr + HostStat);
:  
:  	if (!inited)
: -		return 0;
: +		goto put;
:  
:  	if (tty && (intr & IntrBreak) && !I_IGNBRK(tty)) { /* BREAK */
:  		tty_insert_flip_char(tty, 0, TTY_BREAK);
:  		tty_schedule_flip(tty);
:  	}
: -	tty_kref_put(tty);
:  
:  	if (intr & IntrLine)
:  		moxa_new_dcdstate(p, readb(ofsAddr + FlagStat) & DCD_state);
: +put:
: +	tty_kref_put(tty);
:  
:  	return 0;
:  }
: -- 
: 1.6.2
: 
: --
: To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
: the body of a message to majordomo@vger.kernel.org
: More majordomo info at  http://vger.kernel.org/majordomo-info.html
: Please read the FAQ at  http://www.tux.org/lkml/

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
>>  If you find yourself arguing with Alan Cox, you’re _probably_ wrong.  <<
>>     --James Morris in "How and Why You Should Become a Kernel Hacker"  <<
