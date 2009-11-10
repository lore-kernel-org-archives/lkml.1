Return-Path: <linux-kernel-owner+w=401wt.eu-S1757424AbZKJRmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424AbZKJRmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757158AbZKJRmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:42:24 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:65023 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbZKJRmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:42:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=EU3l7F4E/d2nRsFPrQ6FFfuOWY/CwSeu8fRCGST3mrfEKjWV9R2Yv8h04JEwBbCT1Y
         S/MYhM9dScZapGMlrEYi/OQjg7mFcR1GC1VTdPW4IHdTeUAiYpHmfJvDzeG0CLHhtwFO
         DKT6p2Ke5dX/qbHB4PBpZ6TrMTvYEHsrSBUfk=
MIME-Version: 1.0
In-Reply-To: <4AF7D0DD.5030604@gmail.com>
References: <b9df5fa10911022029q197a0c5dkbbda609f4e41287@mail.gmail.com>
	 <b9df5fa10911062108l2334be64ka0777e89c6dbc17f@mail.gmail.com>
	 <4AF54B77.2000605@gmail.com>
	 <b9df5fa10911081806m7564f778k35e0308fc5ddfba4@mail.gmail.com>
	 <4AF7D0DD.5030604@gmail.com>
Date: Tue, 10 Nov 2009 23:42:28 +0600
Message-ID: <b9df5fa10911100942o4768484euae363173adcfab0f@mail.gmail.com>
Subject: Re: [PATCH -mm] char, moxa: Make isabrds variable global.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/9/09, Jiri Slaby <jirislaby@gmail.com> wrote:
> Actually I'm idiot. I forgot, that today people can just pass "module
>  parameters" on the kernel cmdline even on !MODULE in the
>  KBUILD_MODNAME.param manner. So no, a better fix is to remove !MODULE
>  ifdefs completely.
>
>  Sorry for the confusion.

Okay, hope this will be right. Checkout the following patch.

 moxa: Remove #ifdef MODULE completely.

 We can pass "module parameters" on the kernel command
line even when !MODULE. So, #ifdef MODULE becomes
obsolete. Also move the declaration moxa_board_conf at the
start of the function, since we were hit by the following warning.

drivers/char/moxa.c: In function `moxa_init':
drivers/char/moxa.c:1040: warning: ISO C90 forbids mixed declarations and code

Signed-off-by: Rakib Mullick<rakib.mullick@gmail.com>
---

--- linus/drivers/char/moxa.c	2009-11-10 23:30:13.000000000 +0600
+++ rakib/drivers/char/moxa.c	2009-11-11 00:37:55.000000000 +0600
@@ -165,24 +165,22 @@ static struct mon_str moxaLog;
 static unsigned int moxaFuncTout = HZ / 2;
 static unsigned int moxaLowWaterChk;
 static DEFINE_MUTEX(moxa_openlock);
-/* Variables for insmod */
-#ifdef MODULE
+
 static unsigned long baseaddr[MAX_BOARDS];
 static unsigned int type[MAX_BOARDS];
 static unsigned int numports[MAX_BOARDS];
-#endif

 MODULE_AUTHOR("William Chen");
 MODULE_DESCRIPTION("MOXA Intellio Family Multiport Board Device Driver");
 MODULE_LICENSE("GPL");
-#ifdef MODULE
+
 module_param_array(type, uint, NULL, 0);
 MODULE_PARM_DESC(type, "card type: C218=2, C320=4");
 module_param_array(baseaddr, ulong, NULL, 0);
 MODULE_PARM_DESC(baseaddr, "base address");
 module_param_array(numports, uint, NULL, 0);
 MODULE_PARM_DESC(numports, "numports (ignored for C218)");
-#endif
+
 module_param(ttymajor, int, 0);

 /*
@@ -1011,6 +1009,8 @@ static int __init moxa_init(void)
 {
 	unsigned int isabrds = 0;
 	int retval = 0;
+	struct moxa_board_conf *brd = moxa_boards;
+	unsigned int i;

 	printk(KERN_INFO "MOXA Intellio family driver version %s\n",
 			MOXA_VERSION);
@@ -1038,10 +1038,7 @@ static int __init moxa_init(void)
 	}

 	/* Find the boards defined from module args. */
-#ifdef MODULE
-	{
-	struct moxa_board_conf *brd = moxa_boards;
-	unsigned int i;
+
 	for (i = 0; i < MAX_BOARDS; i++) {
 		if (!baseaddr[i])
 			break;
@@ -1074,8 +1071,6 @@ static int __init moxa_init(void)
 			isabrds++;
 		}
 	}
-	}
-#endif

 #ifdef CONFIG_PCI
 	retval = pci_register_driver(&moxa_pci_driver);
