Return-Path: <linux-kernel-owner+w=401wt.eu-S1753099AbZJUAHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbZJUAHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 20:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbZJUAG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 20:06:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbZJUAG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 20:06:58 -0400
Date: Wed, 21 Oct 2009 02:06:29 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Arnd Bergmann <arndbergmann@googlemail.com>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mattia Dongili <malattia@linux.it>
Subject: Re: [PATCH] sony_pi: Remove the BKL from sonypi_misc_open
In-Reply-To: <200910200008.57468.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.0910210157170.8674@localhost.localdomain>
References: <alpine.LFD.2.00.0910182353480.3405@localhost.localdomain> <alpine.LFD.2.00.0910192019420.3563@localhost.localdomain> <200910200000.24574.arnd@arndb.de> <200910200008.57468.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 20 Oct 2009, Arnd Bergmann wrote:

> On Tuesday 20 October 2009, Arnd Bergmann wrote:
> > On Monday 19 October 2009, John Kacur wrote:
> > > How does this look? (Version 2 of the patch follows)
> > 
> > Looks good now.
> > 
> 
> A bit of background:
> 
> Doing only one of the two conversions is a correct patch as well
> of course, I just want to make sure you don't have to go through all
> the same files again once someone does a blind pushdown into the ioctl
> and llseek functions, so once you prove that a specific driver doesn't
> need the BKL, please always make sure to remove it from all three places.
> 
> I fear that the llseek part will get interesting as well, just because
> we call default_llseek instead of no_ll by default currently.
> It might be a good idea to add one of .llseek=no_llseek or 
> .llseek=generic_file_llseek in any file_operations that you prove
> to not require the BKL.
> 

Good point.

@Thomas: I'm sending this as a separate patch, but I can combine it with
the one that removes the bkl in the open and ioctl functions if you 
prefer.

>From 11e6a3b690413c3926e6db1c53a53410b5214c3d Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Wed, 21 Oct 2009 01:51:41 +0200
Subject: [PATCH] sonypi: Use non-BKL version of llseek.

The default version of llseek uses the BKL.
We have removed the use of the BKL in open and the ioctl.
Now lets remove the last use of the BKL by explictly calling the
generic unlocked llseek, under the sonypi_device.lock mutex

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/char/sonypi.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
index 593cbb5..55b08cd 100644
--- a/drivers/char/sonypi.c
+++ b/drivers/char/sonypi.c
@@ -1061,6 +1061,16 @@ static long sonypi_misc_ioctl(struct file *fp,
 	return ret;
 }
 
+static loff_t sonypi_misc_llseek(struct file *fp, loff_t offset, int origin)
+{
+	loff_t loff;
+	mutex_lock(&sonypi_device.lock);
+	loff = generic_file_llseek_unlocked(fp, offset, origin);
+	mutex_unlock(&sonypi_device.lock);
+
+	return loff;
+}
+
 static const struct file_operations sonypi_misc_fops = {
 	.owner		= THIS_MODULE,
 	.read		= sonypi_misc_read,
@@ -1069,6 +1079,7 @@ static const struct file_operations sonypi_misc_fops = {
 	.release	= sonypi_misc_release,
 	.fasync		= sonypi_misc_fasync,
 	.unlocked_ioctl	= sonypi_misc_ioctl,
+	.llseek		= sonypi_misc_llseek,
 };
 
 static struct miscdevice sonypi_misc_device = {
-- 
1.6.0.6


