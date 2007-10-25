Return-Path: <linux-kernel-owner+w=401wt.eu-S1761867AbXJYENm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761867AbXJYENm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 00:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbXJYENc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 00:13:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:9404 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbXJYENb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 00:13:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=RVlbnwK6dKV+kqmhEb6IdA1y2ntgAXMgua8Edr/Z6pz8OcrISbx5Qrm1VNocW6ItP+ksrP8K7RXeXq6ETgNY2xo4JUiFxRoo0zaw3elJai5pJRD6J1Hfaz9ckqck+YPNSal2E4x4l6EQ/Q7T3Sv3utlM4EpxP4k3rgg9euf1Adk=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: QUESTION: How to fix race between .suspend routine and watchdog timer
Date: Thu, 25 Oct 2007 06:12:44 +0200
User-Agent: KMail/1.9.6
Cc: linux-pm@lists.linux-foundation.org, netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710250612.44296.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Recently, trying to fix saa7134 suspend/resume problems I found that there 
is a race between IRQ handler and .suspend , and that I cant let driver access the device
while its in D3 since it can lock up some systems.

Now I am looking to fix those issues in two drivers that have my .suspend/.resume routines.
the saa7134 capture chip and dmfe, the davicom network driver.

Looking through the dmfe code, I noticed yet another possible race.
A race between the .suspend, and a timer that serves both as a watchdog, and link state detector.
Again I need to prevent it from running during the suspend/resume, but how?

I can use del_timer in .suspend, and mod_timer in .resume, but that doesn't protect against
race with already running timer.
I can use del_timer_sync, but it states that it is useless if timer re-enables itself, and I agree with that.
In dmfe case the timer does re-enable itself.

I can put checks in the timer for ->insuspend, and don't re enable it if set,
but that opens a new can of worms with memory barriers, etc...

So please tell me how properly to do that.

By the way, this problem, together with synchronize_irq it very generic, since most drivers
have and irq handler, and a timeout timer.

Best regards,
	Maxim Levitsky
