Return-Path: <linux-kernel-owner+w=401wt.eu-S1756453Ab0AWA3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab0AWA3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:29:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756006Ab0AWA1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:27:23 -0500
Received: from kroah.org ([198.145.64.141]:35041 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502Ab0AWASq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:18:46 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jan 22 16:11:11 2010
Message-Id: <20100123001111.257742907@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 16:09:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Cox <alan@linux.intel.com>
Subject: [08/29] nozomi: quick fix for the close/close bug
In-Reply-To: <20100123001145.GA7391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit eeec32a731631a9bad9abb21c626b9f2840bee0d upstream.

Nozomi goes wrong if you get the sequence

	open
	open
	close

	[stuff]
	close

which turns out to occur on some ppp type setups.

This is a quick patch up for the problem. It's not really fixing Nozomi
which completely fails to implement tty open/close semantics and all the
other needed stuff. Doing it right is a rather more invasive patch set and
not one that will backport.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/nozomi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -1629,10 +1629,10 @@ static void ntty_close(struct tty_struct
 
 	dc->open_ttys--;
 	port->count--;
-	tty_port_tty_set(port, NULL);
 
 	if (port->count == 0) {
 		DBG1("close: %d", nport->token_dl);
+		tty_port_tty_set(port, NULL);
 		spin_lock_irqsave(&dc->spin_mutex, flags);
 		dc->last_ier &= ~(nport->token_dl);
 		writew(dc->last_ier, dc->reg_ier);


