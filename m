Return-Path: <linux-kernel-owner+w=401wt.eu-S1762712AbXGQKd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762712AbXGQKd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 06:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbXGQKdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 06:33:50 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:35412 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066AbXGQKdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 06:33:49 -0400
Date: Tue, 17 Jul 2007 14:33:43 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] isdn/sc: compile breakage re check_reset()
Message-ID: <20070717103343.GA25083@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is check_reset() -- global function in drivers/isdn/sc/
There is check_reset -- variable holding module param in aacraid driver.

On allyesconfig they clash with:

  LD      drivers/built-in.o
drivers/isdn/built-in.o: In function `check_reset':
: multiple definition of `check_reset'
drivers/scsi/built-in.o:(.data+0xe458): first defined here
ld: Warning: size of symbol `check_reset' changed from 4 in drivers/scsi/built-in.o to 219 in drivers/isdn/built-in.o
ld: Warning: type of symbol `check_reset' changed from 1 to 2 in drivers/isdn/built-in.o

Rename the former.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 drivers/isdn/sc/card.h    |    2 +-
 drivers/isdn/sc/command.c |    2 +-
 drivers/isdn/sc/timer.c   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/isdn/sc/card.h
+++ b/drivers/isdn/sc/card.h
@@ -125,7 +125,7 @@ int sendmessage(int card, unsigned int procid, unsigned int type,
 int receivemessage(int card, RspMessage *rspmsg);
 int sc_ioctl(int card, scs_ioctl *data);
 int setup_buffers(int card, int c);
-void check_reset(unsigned long data);
+void sc_check_reset(unsigned long data);
 void check_phystat(unsigned long data);
 
 #endif /* CARD_H */
--- a/drivers/isdn/sc/command.c
+++ b/drivers/isdn/sc/command.c
@@ -344,7 +344,7 @@ int reset(int card)
 
 	spin_lock_irqsave(&sc_adapter[card]->lock, flags);
 	init_timer(&sc_adapter[card]->reset_timer);
-	sc_adapter[card]->reset_timer.function = check_reset;
+	sc_adapter[card]->reset_timer.function = sc_check_reset;
 	sc_adapter[card]->reset_timer.data = card;
 	sc_adapter[card]->reset_timer.expires = jiffies + CHECKRESET_TIME;
 	add_timer(&sc_adapter[card]->reset_timer);
--- a/drivers/isdn/sc/timer.c
+++ b/drivers/isdn/sc/timer.c
@@ -43,7 +43,7 @@ static void setup_ports(int card)
  * Then, check to see if the signate has been set. Next, set the
  * signature to a known value and issue a startproc if needed.
  */
-void check_reset(unsigned long data)
+void sc_check_reset(unsigned long data)
 {
 	unsigned long flags;
 	unsigned long sig;

