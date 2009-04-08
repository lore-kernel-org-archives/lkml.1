Return-Path: <linux-kernel-owner+w=401wt.eu-S1761358AbZDHINm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761358AbZDHINm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756969AbZDHINX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:13:23 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:23774 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064AbZDHINU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:13:20 -0400
Date: Wed, 8 Apr 2009 10:13:03 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: [GIT PULL] i2c updates for 2.6.30
Message-ID: <20090408101303.71399654@hyperion.delvare>
In-Reply-To: <10f740e80904071320t2fdd073bs51f3a8abf0f60e36@mail.gmail.com>
References: <20090328213950.1c788471@hyperion.delvare>
	<10f740e80904071320t2fdd073bs51f3a8abf0f60e36@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Tue, 7 Apr 2009 22:20:29 +0200, Geert Uytterhoeven wrote:
> On Sat, Mar 28, 2009 at 22:39, Jean Delvare <khali@linux-fr.org> wrote:
> > Please pull the i2c subsystem updates for Linux 2.6.30 from:
> 
> > Wolfram Sang (4):
> >      i2c-algo-pca: Rework waiting for a free bus
> 
> This one introduced:
> 
> drivers/i2c/algos/i2c-algo-pca.c:197: warning: 'state' is used
> uninitialized in this function
> 
> Probably
> 
>         while (pca_status(adap) != 0xf8) {
> 
> should become
> 
>         while ((state = pca_status(adap)) != 0xf8) {
> 
> again.

You're perfectly right, I must have missed it because I didn't build
any kernel with CONFIG_I2C_DEBUG_ALGO=y for a long time. Here's the fix
I will push to Linus soon:

From: Jean Delvare <khali@linux-fr.org>
Subject: i2c-algo-pca: Fix use of uninitialized variable in debug message

A recent change broke debugging of pca_xfer(), fix it.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/i2c/algos/i2c-algo-pca.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.30-rc1.orig/drivers/i2c/algos/i2c-algo-pca.c	2009-04-08 08:52:48.000000000 +0200
+++ linux-2.6.30-rc1/drivers/i2c/algos/i2c-algo-pca.c	2009-04-08 10:06:36.000000000 +0200
@@ -190,7 +190,7 @@ static int pca_xfer(struct i2c_adapter *
 	int completed = 1;
 	unsigned long timeout = jiffies + i2c_adap->timeout;
 
-	while (pca_status(adap) != 0xf8) {
+	while ((state = pca_status(adap)) != 0xf8) {
 		if (time_before(jiffies, timeout)) {
 			msleep(10);
 		} else {


-- 
Jean Delvare
