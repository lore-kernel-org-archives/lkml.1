Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbZIKRAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbZIKRAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 13:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbZIKRAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 13:00:36 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:54208 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796AbZIKRAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 13:00:35 -0400
Message-ID: <4AAA8213.8070008@nortel.com>
Date: Fri, 11 Sep 2009 11:00:03 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Linux kernel <linux-kernel@vger.kernel.org>
Subject: BUG?  possible race between tasklet_action and tasklet_kill
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Sep 2009 17:00:36.0581 (UTC) FILETIME=[6202B950:01CA3301]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think I may have discovered a race between tasklet_action and
tasklet_kill.  Given how long this code has been around, I assume that
I'm simply not understanding the purposes of tasklet_kill correctly, but
it seems like there's a mechanism whereby we could hit the BUG path in
tasklet_action().

cpu A                             cpu B
starts tasklet_kill()
does while loop until
  TASKLET_STATE_SCHED not set
                                  runs tasklet_schedule()
                                  starts tasklet_action()
tasklet_unlock_wait()
                                  if (tasklet_trylock(t)) {
clear_bit(TASKLET_STATE_SCHED)
                                  test_and_clear_bit(TASKLET_STATE_SCHED
                                  BUG


Is this a valid issue, or is this an improper usage pattern somehow?

Thanks,

Chris
