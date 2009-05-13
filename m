Return-Path: <linux-kernel-owner+w=401wt.eu-S1761951AbZEMV6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761951AbZEMV6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 17:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbZEMV6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 17:58:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:46621 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZEMV6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 17:58:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=c/g9epQgD7P9AL07OSWobOlSo/MrSYrmOtvqrokGnXc0P0lF5AFi2erbAa1JyoPr9W
         2s1TVM8Y2Z8gbR37e0r9bHxd310Jhs3fH1M+YQ10t+RP8iLu2vmm4ajFjCkHhuDd8xOM
         XOdCi8b9nI1RVPnfvh5cPuVaR/FcLarMYSIA0=
Date: Thu, 14 May 2009 01:58:00 +0400
From: "Alexander Y. Fomichev" <git.user@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: jsm: two or more 4/8-port boards can not initialize ports
 properly
Message-Id: <20090514015800.5c14ecd8.git.user@gmail.com>
In-Reply-To: <20090513012431.72a9eb83@lxorguk.ukuu.org.uk>
References: <f74141980905121422p140d1649jcfb3d94aacd42f02@mail.gmail.com>
	<20090513012431.72a9eb83@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009 01:24:31 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > +struct jsm_board *jsm_boards[MAXBOARDS];
> > +
> 
> adapter_count increments each time regardless of boards present so that
> doesn't work after a few hotplugs it seems ?

it's true, i missing hotplug at all tnx.
as of hotplug it seems easier to do this allocating/deallocating
line numbers one by one storing assigned numbers in bitmap (though
it could lead to sparse ttyns belonging to a sigle board)
could you pls take a look on the patch bellow?


> >         brd->boardnum = adapter_count++;
> > +       jsm_boards[brd->boardnum] = brd;
> >         brd->pci_dev = pdev;

diff -urNp a/drivers/serial/jsm/jsm.h b/drivers/serial/jsm/jsm.h
--- a/drivers/serial/jsm/jsm.h  2009-05-12 17:29:02.117674090 +0400
+++ b/drivers/serial/jsm/jsm.h  2009-05-13 15:52:56.152889038 +0400
@@ -61,6 +61,7 @@ enum {
        if ((DBG_##nlevel & jsm_debug))                 \
        dev_printk(KERN_##klevel, pdev->dev, fmt, ## args)

+#define        MAXLINES        256
 #define MAXPORTS       8
 #define MAX_STOPS_SENT 5

diff -urNp a/drivers/serial/jsm/jsm_tty.c b/drivers/serial/jsm/jsm_tty.c
--- a/drivers/serial/jsm/jsm_tty.c      2009-05-12 17:28:51.849172254 +0400
+++ b/drivers/serial/jsm/jsm_tty.c      2009-05-14 01:15:02.542589990 +0400
@@ -33,6 +33,8 @@

 #include "jsm.h"

+static DECLARE_BITMAP(linemap,MAXLINES);
+
 static void jsm_carrier(struct jsm_channel *ch);

 static inline int jsm_get_mstat(struct jsm_channel *ch)
@@ -433,6 +435,7 @@ int __devinit jsm_tty_init(struct jsm_bo
 int __devinit jsm_uart_port_init(struct jsm_board *brd)
 {
        int i;
+       unsigned int line;
        struct jsm_channel *ch;

        if (!brd)
@@ -459,7 +462,13 @@ int __devinit jsm_uart_port_init(struct
                brd->channels[i]->uart_port.membase = brd->re_map_membase;
                brd->channels[i]->uart_port.fifosize = 16;
                brd->channels[i]->uart_port.ops = &jsm_ops;
-               brd->channels[i]->uart_port.line = brd->channels[i]->ch_portnum + brd->boardnum * 2;
+               line = find_first_zero_bit(linemap,MAXLINES);
+               if (line >= MAXLINES) {
+                       printk(KERN_INFO "linemap is full, added device failed\n");
+                       continue;
+               } else
+                       __set_bit((int)line, linemap);
+               brd->channels[i]->uart_port.line = line;
                if (uart_add_one_port (&jsm_uart_driver, &brd->channels[i]->uart_port))
                        printk(KERN_INFO "Added device failed\n");
                else
@@ -494,6 +503,7 @@ int jsm_remove_uart_port(struct jsm_boar

                ch = brd->channels[i];

+               __clear_bit((int)(ch->uart_port.line), linemap);
                uart_remove_one_port(&jsm_uart_driver, &brd->channels[i]->uart_port);
        }

-- 
Best regards
	Alexander Y. Fomichev <git.user@gmail.com>
