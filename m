Return-Path: <linux-kernel-owner+w=401wt.eu-S1758113AbYB1O0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbYB1O0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 09:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbYB1O0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 09:26:41 -0500
Received: from el-out-1112.google.com ([209.85.162.182]:46995 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbYB1O0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 09:26:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=pa9Y1bbQn/mMISdnMwS7HKgl4EiGh+npjgNqwUv1uT3ooYJBBk9sfiVDaUh3LfpmK+Sx1oZOuo2IMPQ5Ri2oJuzG3SrpatMAON368HS66PrjTG1vIEPJrCwo73OLU86cP1Obad7zOiOMexeaoZM2/noghpqGRe0ohH3n1mNguhY=
Message-ID: <f19298770802280626g5ee17328ldedf7658a9f26f56@mail.gmail.com>
Date: Thu, 28 Feb 2008 17:26:38 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
Subject: printk timestamps jumping back and forth in 2.6.25-rc.
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Long story short, this is what I see in my dmesg:

http://romomatic.osuosl.org/share/xl0/dmesg-2.6.25-rc3
http://romomatic.osuosl.org/share/xl0/dmesg-2.6.25-rc3-clocksource-acpi_pm
http://romomatic.osuosl.org/share/xl0/dmesg-2.6.25-rc3-clocksource-hpet

Specifying clocksource=acpi_pm and hpet changes nothing.

Apart from the jumpy timestamps, I think the
scheduler is not working well, because the mouse
looses smoothness from time to time during
compilations. Not that noticeble, but definetely
worse than it was in 2.6.23. Probably might be related,
I don't know.

I tried to bisect the problem, but it first lead me to

commit 326e96b92306b7af24a3608ec01156cba17a3fc1
Author: Ingo Molnar <mingo@elte.hu>
Date:   Sun Jan 27 08:03:54 2008 +0100

    printk: revert ktime_get() timestamps

    revert 19ef9309273d26cb005cb23e6a370353dca91099.

    Kevin Winchester reported a lockup during X startup an bisected
    it to this commit.

Reverting this revert kind of worked:
http://romomatic.osuosl.org/share/xl0/dmesg-2.6.25-rc3-reverted
but clearly this was not the right thing. ;)

and after bisecting 2.6.24 - commit before
19ef9309273d26cb005cb23e6a370353dca91099
I got to

commit d713f519332e029d43eca8462629314eee1ded86
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Jan 25 21:07:58 2008 +0100

    sched: fix CONFIG_PRINT_TIME's reliance on sched_clock()

    Stefano Brivio reported weird printk timestamp behavior during
    CPU frequency changes:

      http://bugzilla.kernel.org/show_bug.cgi?id=9475

    fix CONFIG_PRINT_TIME's reliance on sched_clock() and use cpu_clock()
    instead.

    Reported-and-bisected-by: Stefano Brivio <stefano.brivio@polimi.it>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>


which sound like "happy debugging, losers" to me. ;)

Anything else I can do?
