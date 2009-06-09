Return-Path: <linux-kernel-owner+w=401wt.eu-S1759665AbZFIT1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759665AbZFIT1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 15:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbZFIT1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 15:27:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753883AbZFIT1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 15:27:45 -0400
Date: Tue, 9 Jun 2009 12:27:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, eibach@gdsys.de
Subject: Re: [PATCH 1/1] Char: moxa, prevent opening unavailable ports
Message-Id: <20090609122735.9a915cbf.akpm@linux-foundation.org>
In-Reply-To: <1244557981-9443-1-git-send-email-jirislaby@gmail.com>
References: <1244557981-9443-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  9 Jun 2009 16:33:01 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> From: Dirk Eibach <eibach@gdsys.de>
> 
> In moxa.c there are 32 minor numbers reserved for each device. The
> number of ports actually available per device is stored in
> moxa_board_conf->numPorts. This number is not considered in moxa_open().
> Opening a port that is not available results in a kernel oops.
> This patch adds a test to moxa_open() that prevents opening unavailable
> ports.
> 
> Signed-off-by: Dirk Eibach <eibach@gdsys.de>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> ---
>  drivers/char/moxa.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
> index 4a4cab7..65b6ff2 100644
> --- a/drivers/char/moxa.c
> +++ b/drivers/char/moxa.c
> @@ -1184,6 +1184,11 @@ static int moxa_open(struct tty_struct *tty, struct file *filp)
>  		return -ENODEV;
>  	}
>  
> +	if (port % MAX_PORTS_PER_BOARD >= brd->numPorts) {
> +		mutex_unlock(&moxa_openlock);
> +		return -ENODEV;
> +	}
> +
>  	ch = &brd->ports[port % MAX_PORTS_PER_BOARD];
>  	ch->port.count++;
>  	tty->driver_data = ch;

Looks good to me.  But please, let's avoid adding the
multiple-return-statement hand grenade?

--- a/drivers/char/moxa.c~char-moxa-prevent-opening-unavailable-ports
+++ a/drivers/char/moxa.c
@@ -1184,6 +1184,11 @@ static int moxa_open(struct tty_struct *
 		return -ENODEV;
 	}
 
+	if (port % MAX_PORTS_PER_BOARD >= brd->numPorts) {
+		retval = -ENODEV;
+		goto out_unlock;
+	}
+
 	ch = &brd->ports[port % MAX_PORTS_PER_BOARD];
 	ch->port.count++;
 	tty->driver_data = ch;
@@ -1208,8 +1213,8 @@ static int moxa_open(struct tty_struct *
 				moxa_close_port(tty);
 	} else
 		ch->port.flags |= ASYNC_NORMAL_ACTIVE;
+out_unlock:
 	mutex_unlock(&moxa_openlock);
-
 	return retval;
 }
 
_



btw, what's this code in moxa_open() doing?

	if (port == MAX_PORTS) {
		return capable(CAP_SYS_ADMIN) ? 0 : -EPERM;
	}

why does it return 0 if CAP_SYS_ADMIN?				
