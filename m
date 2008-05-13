Return-Path: <linux-kernel-owner+w=401wt.eu-S1759699AbYEMUNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759699AbYEMUNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760916AbYEMUMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:12:31 -0400
Received: from ns1.suse.de ([195.135.220.2]:37181 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760652AbYEMUM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:12:29 -0400
Date: Tue, 13 May 2008 13:11:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [patch 03/37] serial: access after NULL check in
	uart_flush_buffer()
Message-ID: <20080513201127.GD31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="serial-access-after-null-check-in-uart_flush_buffer.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

commit 55d7b68996a5064f011d681bca412b6281d2f711 upstream

I noticed that

  static void uart_flush_buffer(struct tty_struct *tty)
  {
  	struct uart_state *state = tty->driver_data;
  	struct uart_port *port = state->port;
  	unsigned long flags;

  	/*
  	 * This means you called this function _after_ the port was
  	 * closed.  No cookie for you.
  	 */
  	if (!state || !state->info) {
  		WARN_ON(1);
  		return;
  	}

is too late for checking state != NULL.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/serial_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -535,7 +535,7 @@ static int uart_chars_in_buffer(struct t
 static void uart_flush_buffer(struct tty_struct *tty)
 {
 	struct uart_state *state = tty->driver_data;
-	struct uart_port *port = state->port;
+	struct uart_port *port;
 	unsigned long flags;
 
 	/*
@@ -547,6 +547,7 @@ static void uart_flush_buffer(struct tty
 		return;
 	}
 
+	port = state->port;
 	pr_debug("uart_flush_buffer(%d) called\n", tty->index);
 
 	spin_lock_irqsave(&port->lock, flags);

-- 
