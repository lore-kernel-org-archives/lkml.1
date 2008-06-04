Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbYFDQBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbYFDQBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 12:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbYFDQBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 12:01:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41482 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752984AbYFDQBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 12:01:03 -0400
Date: Wed, 4 Jun 2008 08:59:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: gyang <graf.yang@analog.com>, Bryan Wu <cooloney@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial_core: uart_set_ldisc (Was Re: Blackfin Serial
 Driver: Enable IR function when user application (irattach /dev/ttyBFx -s)
 call TIOCSETD ioctl with line discipline N_IRDA)
In-Reply-To: <20080603151854.488af929@core>
Message-ID: <alpine.LFD.1.10.0806040852500.3473@woody.linux-foundation.org>
References: <200804241929.m3OJToSE021045@hera.kernel.org> <20080424215004.34517136@the-village.bc.nu> <0F1B54C89D5F954D8535DB252AF412FA0164BC7A@chinexm1.ad.analog.com> <20080425105545.77b8c5e8@core> <386072610805040827w7a606ee2ld24e6752a6c745c7@mail.gmail.com>
 <20080504165625.083d3d22@core> <1212459526.6187.8.camel@dyang> <20080603151854.488af929@core>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Jun 2008, Alan Cox wrote:
> 
> Linus: This change plus a follow up from the Blackfin guys is needed to
> avoid blackfin losing features in this release.

Alan, I applied this as "obviously safe", since nobody sets the uart-level 
set_ldisc thing yet... BUT!

I now get an annoying compiler warning, and the compiler is definitely 
right. You have:

	static void uart_set_ldisc(struct tty_struct *tty, int ldisc)
	..
	.set_ldisc      = uart_set_ldisc,

Oops. Totally wrong function type. Because the tty-level one is

	void (*set_ldisc)(struct tty_struct *tty);

in my tree, and as a result I suspect you sent me the wrong version of a 
patch (perhaps based on -mm or -next).

I assume I should just remove the (unused) "int ldisc" argument, but would 
like to get confirmation first.

			Linus

--
 drivers/serial/serial_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 951a75e..c9b64e7 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -1165,7 +1165,7 @@ out:
 	return ret;
 }
 
-static void uart_set_ldisc(struct tty_struct *tty, int ldisc)
+static void uart_set_ldisc(struct tty_struct *tty)
 {
 	struct uart_state *state = tty->driver_data;
 	struct uart_port *port = state->port;
