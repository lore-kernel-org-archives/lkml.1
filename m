Return-Path: <linux-kernel-owner+w=401wt.eu-S1757743AbZCPKuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757743AbZCPKuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 06:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbZCPKun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 06:50:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51756 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753363AbZCPKum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 06:50:42 -0400
Date: Mon, 16 Mar 2009 10:50:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/2] Char: isicom, prolong tty reference holding
Message-ID: <20090316105026.610a0b9a@lxorguk.ukuu.org.uk>
In-Reply-To: <1237199665-10675-1-git-send-email-jirislaby@gmail.com>
References: <1237199665-10675-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Mar 2009 11:34:24 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> Hold the tty reference a bit longer in isicom_shutdown_port, because
> we use it later in the function, so that it won't disappear in the
> meantime.

NAK - we do have a bug there but I don't think that is it.

The tty_kref_get takes an additional reference so the tty_port_tty_set is
fine, but we don't then drop the kref we took temporarily. I think we
need this:

isicom: isicom kref leak fix

From: Alan Cox <alan@lxorguk.ukuu.org.uk>

The isicom driver leaks a kref on the shutdown path. Drop the additional
kref we took

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/char/isicom.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 24aa6e8..a59eac5 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -925,6 +925,7 @@ static void isicom_shutdown_port(struct isi_port *port)
 		if (!card->count)
 			isicom_shutdown_board(card);
 	}
+	tty_kref_put(tty);
 }
 
 static void isicom_flush_buffer(struct tty_struct *tty)
