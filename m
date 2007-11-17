Return-Path: <linux-kernel-owner+w=401wt.eu-S1764926AbXKQUHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764926AbXKQUHo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 15:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758975AbXKQUHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 15:07:36 -0500
Received: from ns01.unsolicited.net ([69.10.132.115]:48570 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293AbXKQUHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 15:07:35 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=simple; s=one; d=unsolicited.net;
	h=Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:Content-Type:Content-Transfer-Encoding;
	b=HevwYirwKGeOGAYdDC7kdyIaeHvkyQtxg6lG2Mb3yd3gGi5pDY8JeB/01fsTyF0GmGzne4OYlvMAdgb9G0FWJ7HdPh+kE922PrjYQTDm1nR6+dElENkZ3IwGa7F63jFTx1HCgQ3Bdk6XTs1hn/vQNCbbquxdk8sC35820lrRpj4=;
Message-ID: <473F498D.9090703@unsolicited.net>
Date: Sat, 17 Nov 2007 20:05:33 +0000
From: David <david@unsolicited.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Javier Kohen <jkohen@users.sourceforge.net>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, stable@kernel.org
Subject: Re: [stable] Soft lockups since stable kernel upgrade to 2.6.23.8
References: <1195323695.5240.16.camel@null.tough.com.ar> <20071117191211.GA12757@kroah.com>
In-Reply-To: <20071117191211.GA12757@kroah.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sat, Nov 17, 2007 at 07:21:35PM +0100, Javier Kohen wrote:
>   
>> I upgraded today from 2.6.23 to 2.6.23.8 and started seeing a lot of
>> these in the logs:
>>     
>
> Can you see if the problem showed up in 2.6.23.2 or .3 to help narrow
> this down?
>   
This is the culprit, reverting fixes the issue.

Cheers
David

--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -80,10 +80,11 @@ void softlockup_tick(void)
        print_timestamp = per_cpu(print_timestamp, this_cpu);

        /* report at most once a second */
-       if (print_timestamp < (touch_timestamp + 1) ||
-               did_panic ||
-                       !per_cpu(watchdog_task, this_cpu))
+       if ((print_timestamp >= touch_timestamp &&
+                       print_timestamp < (touch_timestamp + 1)) ||
+                       did_panic || !per_cpu(watchdog_task, this_cpu)) {
                return;
+       }

        /* do not print during early bootup: */
        if (unlikely(system_state != SYSTEM_RUNNING)) {

