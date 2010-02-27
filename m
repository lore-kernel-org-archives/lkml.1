Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968127Ab0B0JwP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 04:52:15 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:34763 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968098Ab0B0JwL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 04:52:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=pD6nxtCHlWgFFS65s3A08U7KMM90HFilOo43bNW5rnm05ai+ltnuUtYCWUnkSsi9E4
         E4fCPCXrRa2cr6hJGb4lg20eQPSJ8gJ5QM9cJc+zHU//djvCPWvWzHk+y4yFjzTsrBrT
         GYMbqrbue0WU+xJwCltL6Mz6JqMi6SIvsZAC4=
MIME-Version: 1.0
Date: Sat, 27 Feb 2010 10:52:09 +0100
Message-ID: <b170af451002270152u228a46abr3b316da75b2fa3f0@mail.gmail.com>
Subject: schedule (wait_event) vs. while
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In radeon engine reclocking code I need to do some calculations and
then wait for VBLANK interrupt. Right after VBLANK interrupt will
happen I need to reclock ASAP.

Interrupts are received by another context and I need some quite fast
synchronization.

1) Schedule solution:
reclocking() {
  calculations();
  radeon->vblank_sync = 0;
  wait_event_timeout(radeon->wq, radeon->vblank_sync, timeout);
  reclock();
}
i-handler() { radeon->vblank_sync = 1; }

2) While solution:
reclocking() {
  calculations();
  del_timer(radeon->fake_vblank);
  radeon->vblank_sync = 0;
  mod_timer(radeon->fake_vblank, 10ms);
  while(!radeon->vblank_sync);
  reclock();
}
i-handler() { radeon->vblank_sync = 1; }
fake-handler() { radeon->vblank_sync = 1; }

Of course first one is much cleaner but internally wait_event_timeout
uses schedule_timeout(). Now according to LDD3:
> Once a process releases the processor with schedule, there are no guarantees that the process will get the processor back anytime soon. Therefore, calling schedule in this manner is not a safe solution to the driver’s needs, in addition to being bad for the computing system as a whole. If you test jitsched while running load50, you can see that the delay associated to each line is extended by a few seconds, because other processes are using the CPU when the timeout expires.

I can not afford any delays because VBLANK is so short timeframe. Is
there any better solution?

-- 
Rafał
