Return-Path: <linux-kernel-owner+w=401wt.eu-S1751694AbZLCF5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbZLCF5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 00:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbZLCF5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 00:57:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45574
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751073AbZLCF5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 00:57:32 -0500
Date: Wed, 02 Dec 2009 21:57:38 -0800 (PST)
Message-Id: <20091202.215738.12118816.davem@davemloft.net>
To: liml@rtr.ca
Cc: hancockrwd@gmail.com, phdm@macqel.be, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH ide] : Increase WAIT_DRQ to support slow CF cards
From: David Miller <davem@davemloft.net>
In-Reply-To: <4AEC420A.9030502@rtr.ca>
References: <20091026162011.GA3289@frolo.macqel>
	<4AE64031.5060105@gmail.com>
	<4AEC420A.9030502@rtr.ca>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Lord <liml@rtr.ca>
Date: Sat, 31 Oct 2009 09:56:26 -0400

> Robert Hancock wrote:
> ..
>> This has come up before:
>> http://marc.info/?l=linux-ide&m=123064513313466&w=2
>> I think this timeout should not even exist. libata has no such timeout
>> (only the overall command completion timeout), and I can't find any
>> reference in current ATA specs to the device being required to raise
>> DRQ in any particular amount of time.
> ..
> 
> The reason for the original (20ms, then 50ms) timeout was this text
> from the ATA1 specification, long since outdated:
> 
>   -  Upon receipt of a Class 3 command, the drive sets BSY within 400 nsec,
>      sets  up the sector buffer for a write operation, sets DRQ within 20
>      msec, and clears BSY within 400 nsec of setting DRQ.

Ok, I'd like to resolve this as follows.  We had stated "at least
500msec for SSD drives" so I doubled it.

This should be a pretty safe change.  The only major side effect is
that if the device really does hang before setting DRQ it will take
a full second before we notice it.

Any major objections?

ide: Increase WAIT_DRQ to accomodate some CF cards and SSD drives.

Based upon a patch by Philippe De Muyter, and feedback from Mark
Lord and Robert Hancock.

As noted by Mark Lord, the outdated ATA1 spec specifies a 20msec
timeout for setting DRQ but lots of common devices overshoot this.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/linux/ide.h b/include/linux/ide.h
index e4135d6..0ec6129 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -125,8 +125,8 @@ struct ide_io_ports {
  * Timeouts for various operations:
  */
 enum {
-	/* spec allows up to 20ms */
-	WAIT_DRQ	= HZ / 10,	/* 100ms */
+	/* spec allows up to 20ms, but CF cards and SSD drives need more */
+	WAIT_DRQ	= 1 * HZ,	/* 1s */
 	/* some laptops are very slow */
 	WAIT_READY	= 5 * HZ,	/* 5s */
 	/* should be less than 3ms (?), if all ATAPI CD is closed at boot */
