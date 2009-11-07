Return-Path: <linux-kernel-owner+w=401wt.eu-S1750893AbZKGFIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750893AbZKGFIc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 00:08:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750781AbZKGFIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 00:08:31 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:45948 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbZKGFIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 00:08:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FuZljrBFrQ7Rj29a70+IYe1aRaPMmXO893bR/FtJ0qxLSVnAAmxfm39pj+9vJloT8f
         faUcWt4WaMTDC1m7d49rEIE0VR2Pp4eqc61LNFIghxFwk9tF6B3k7DGjQx6BsMuIucYT
         BbOTmcmzd1OxdUVs1cMncgwzXNotS5lYc0TXQ=
MIME-Version: 1.0
In-Reply-To: <b9df5fa10911022029q197a0c5dkbbda609f4e41287@mail.gmail.com>
References: <b9df5fa10911022029q197a0c5dkbbda609f4e41287@mail.gmail.com>
Date: Sat, 7 Nov 2009 11:08:35 +0600
Message-ID: <b9df5fa10911062108l2334be64ka0777e89c6dbc17f@mail.gmail.com>
Subject: Re: [PATCH -mm] char, moxa: Make isabrds variable global.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jirislaby@gmail.com, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/3/09, Rakib Mullick <rakib.mullick@gmail.com> wrote:
>  When CONFIG_MODULE=n and CONFIG_PCI=n, then variable
>  isabrds becomes unused variable. So place it outside
>  moxa_init solves this problem.
>
>   We were warned by the following warning:
>
>  drivers/char/moxa.c: In function `moxa_init':
>  drivers/char/moxa.c:1012: warning: unused variable `isabrds'

Hi Andrew, after applying this one, it introduce a new warning:

drivers/char/moxa.c:1010: warning: 'isabrds' defined but not used

And while compiling moxa.c we are also warned by the following warnings:

drivers/char/moxa.c:81: warning: 'moxa_brdname' defined but not used
drivers/char/moxa.c:818: warning: 'moxa_init_board' defined but not used

To fix this warnings we need to properly #ifdef above functions.
So after applying the following patch - moxa.c compiles cleanly.

Would you mind check this out, Andrew?

  Fix compilation warning when CONFIG_PCI=n.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
----

--- linus/drivers/char/moxa.c	2009-11-06 17:12:13.000000000 +0600
+++ rakib/drivers/char/moxa.c	2009-11-06 17:47:18.000000000 +0600
@@ -78,6 +78,7 @@ enum {
 	MOXA_BOARD_CP204J,
 };

+#if defined MODULE || defined CONFIG_PCI
 static char *moxa_brdname[] =
 {
 	"C218 Turbo PCI series",
@@ -87,6 +88,9 @@ static char *moxa_brdname[] =
 	"CP-204J series",
 };

+static unsigned int __initdata isabrds;
+#endif
+
 #ifdef CONFIG_PCI
 static struct pci_device_id moxa_pcibrds[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_C218),
@@ -419,6 +423,7 @@ static DEFINE_SPINLOCK(moxa_lock);
  * HW init
  */

+#if defined MODULE || defined CONFIG_PCI
 static int moxa_check_fw_model(struct moxa_board_conf *brd, u8 model)
 {
 	switch (brd->boardType) {
@@ -878,6 +883,7 @@ err_free:
 err:
 	return ret;
 }
+#endif

 static void moxa_board_deinit(struct moxa_board_conf *brd)
 {
@@ -1009,7 +1015,6 @@ static struct pci_driver moxa_pci_driver

 static int __init moxa_init(void)
 {
-	unsigned int isabrds = 0;
 	int retval = 0;

 	printk(KERN_INFO "MOXA Intellio family driver version %s\n",
