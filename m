Return-Path: <linux-kernel-owner+w=401wt.eu-S933895AbZIDTTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933895AbZIDTTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 15:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933886AbZIDTTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 15:19:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933854AbZIDTTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 15:19:47 -0400
Date: Fri, 4 Sep 2009 09:19:34 -1000 (HST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mikael Pettersson <mikpe@it.uu.se>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14015] pty regressed again, breaking expect and gcc's
 testsuite
In-Reply-To: <alpine.LFD.2.00.0909040910140.4537@eeepc.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0909040917120.4537@eeepc.linux-foundation.org>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera> <19099.52899.620345.326521@pilspetsen.it.uu.se> <19100.31254.666066.755541@pilspetsen.it.uu.se> <200909012042.59856.rjw@sisk.pl> <alpine.LFD.2.00.0909021429360.3590@eeepc.linux-foundation.org>
 <19105.5352.28380.230615@pilspetsen.it.uu.se> <alpine.LFD.2.00.0909040729490.5232@eeepc.linux-foundation.org> <alpine.LFD.2.00.0909040739060.17375@eeepc.linux-foundation.org> <alpine.LFD.2.00.0909040753370.17375@eeepc.linux-foundation.org>
 <alpine.LFD.2.00.0909040804450.23850@eeepc.linux-foundation.org> <alpine.LFD.2.00.0909040910140.4537@eeepc.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 4 Sep 2009, Linus Torvalds wrote:
> 
> I'm sure you already figured the obvious meaning out, but here's a fixed 
> version.

And here's another patch that may also fix this, simply by virtue of 
writing the "\r\n" as a single string, rather than as two characters. That 
way, we should never get into the situation that th '\r' allocates a new 
buffer (larger than one character), and then the later '\n' writing 
decides that we've filled up.

Besides, it's a cleanup. An untested one, naturally.

			Linus

---
 drivers/char/n_tty.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index 973be2f..4e28b35 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -300,8 +300,7 @@ static int do_output_char(unsigned char c, struct tty_struct *tty, int space)
 			if (space < 2)
 				return -1;
 			tty->canon_column = tty->column = 0;
-			tty_put_char(tty, '\r');
-			tty_put_char(tty, c);
+			tty->ops->write(tty, "\r\n", 2);
 			return 2;
 		}
 		tty->canon_column = tty->column;
