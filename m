Return-Path: <linux-kernel-owner+w=401wt.eu-S932560AbZJFNKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560AbZJFNKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 09:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932265AbZJFNKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 09:10:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39794 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932542AbZJFNKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 09:10:41 -0400
Date: Tue, 6 Oct 2009 14:11:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: felipe.balbi@nokia.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>
Subject: Re: TTY loosing bytes ?
Message-ID: <20091006141115.12ad22dd@lxorguk.ukuu.org.uk>
In-Reply-To: <20091006130150.GY4452@nokia.com>
References: <20091006094845.GT4452@nokia.com>
	<20091006114528.GV4452@nokia.com>
	<20091006131230.5301f711@lxorguk.ukuu.org.uk>
	<20091006130150.GY4452@nokia.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> With the patch above I still get this messages but it still goes through
> since not receive_buf is returning the amount of bytes actually
> received. Then flush_to_ldisc() will retry those bytes on the next
> iteration. Maybe this is not the desired patch though ?
> 
> Thanks a lot for the comments Alan.

First guess try the following

n_tty: For some I/O patterns n_tty will lose bytes

From: Alan Cox <alan@linux.intel.com>

Fix the obvious disagreement between the receive path and the receive room
logic.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/n_tty.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index 2e50f4d..27b28ca 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -95,6 +95,9 @@ static void n_tty_set_room(struct tty_struct *tty)
 	/* tty->read_cnt is not read locked ? */
 	int	left = N_TTY_BUF_SIZE - tty->read_cnt - 1;
 
+	if (tty->real_raw)
+	        left = min(left, N_TTY_BUF_SIZE - tty->read_head - 1);
+
 	/*
 	 * If we are doing input canonicalization, and there are no
 	 * pending newlines, let characters through without limit, so
