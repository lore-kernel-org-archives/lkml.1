Return-Path: <linux-kernel-owner+w=401wt.eu-S1751514AbZGYOMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbZGYOMg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 10:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbZGYOMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 10:12:36 -0400
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:61539 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751291AbZGYOMf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 10:12:35 -0400
From: Frans Pop <elendil@planet.nl>
To: Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH -tip][RFC] serial8250: update to dev_pm_ops
Date: Sat, 25 Jul 2009 16:12:33 +0200
User-Agent: KMail/1.9.9
Cc: Erik Ekman <erik@kryo.se>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20090701083737.41f28c7d.erik@kryo.se> <200907081310.53579.elendil@planet.nl> <20090708144337.7006fa0a@t61.ukuu.org.uk>
In-Reply-To: <20090708144337.7006fa0a@t61.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200907251612.34140.elendil@planet.nl>
X-OriginalArrivalTime: 25 Jul 2009 14:12:34.0634 (UTC) FILETIME=[F4DFB2A0:01CA0D31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 July 2009, Alan Cox wrote:
> On Wed, 8 Jul 2009 Frans Pop <elendil@planet.nl> wrote:
> > > From dmesg:
> > > Platform driver 'serial8250' needs updating - please use dev_pm_ops
> > >
> > > Is this how it should be done?
> >
> > Alan or Rafael can probably tell.
>
> No idea. I've not looked at this so your guess is as good as mine (but
> looks quite believable. I don't plan to do anything until someone who
> needs platform 8250 support sends a tested version of the change
> however.

I have done a few of these myself now and followed all other similar
updates for other drivers. From that experience I can say that this update
is both trivial and correct. Hope you will reconsider your reluctance on
that basis.

Below Erik's patch with the commit log cleaned up, one whitespace problem
fixed and my Reviewed-by added.

Cheers,
FJP

---
From: Erik Ekman <erik@kryo.se>
Subject: serial8250: update to dev_pm_ops

>From dmesg:
Platform driver 'serial8250' needs updating - please use dev_pm_ops

Signed-off-by: Erik Ekman <erik@kryo.se>
Reviewed-by: Frans Pop <elendil@planet.nl>

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index fb867a9..496c85f 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2982,42 +2982,46 @@ static int __devexit serial8250_remove(struct platform_device *dev)
 	return 0;
 }
 
-static int serial8250_suspend(struct platform_device *dev, pm_message_t state)
+static int serial8250_suspend(struct device *dev)
 {
 	int i;
 
 	for (i = 0; i < UART_NR; i++) {
 		struct uart_8250_port *up = &serial8250_ports[i];
 
-		if (up->port.type != PORT_UNKNOWN && up->port.dev == &dev->dev)
+		if (up->port.type != PORT_UNKNOWN && up->port.dev == dev)
 			uart_suspend_port(&serial8250_reg, &up->port);
 	}
 
 	return 0;
 }
 
-static int serial8250_resume(struct platform_device *dev)
+static int serial8250_resume(struct device *dev)
 {
 	int i;
 
 	for (i = 0; i < UART_NR; i++) {
 		struct uart_8250_port *up = &serial8250_ports[i];
 
-		if (up->port.type != PORT_UNKNOWN && up->port.dev == &dev->dev)
+		if (up->port.type != PORT_UNKNOWN && up->port.dev == dev)
 			serial8250_resume_port(i);
 	}
 
 	return 0;
 }
 
+static struct dev_pm_ops serial8250_pm_ops = {
+	.suspend = serial8250_suspend,
+	.resume  = serial8250_resume,
+};
+
 static struct platform_driver serial8250_isa_driver = {
 	.probe		= serial8250_probe,
 	.remove		= __devexit_p(serial8250_remove),
-	.suspend	= serial8250_suspend,
-	.resume		= serial8250_resume,
 	.driver		= {
 		.name	= "serial8250",
 		.owner	= THIS_MODULE,
+		.pm     = &serial8250_pm_ops,
 	},
 };
 
