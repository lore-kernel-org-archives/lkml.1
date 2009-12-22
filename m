Return-Path: <linux-kernel-owner+w=401wt.eu-S1755098AbZLVVMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbZLVVMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 16:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZLVVMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 16:12:18 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47309 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbZLVVMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 16:12:17 -0500
Subject: Please revert xtime_cache removal
From: john stultz <johnstul@us.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Petr =?UTF-8?Q?Tit=C4=9Bra?= <P.Titera@century.cz>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 13:12:11 -0800
Message-ID: <1261516331.3508.32.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

	Please revert commit 7bc7d637452383d56ba4368d4336b0dde1bb476d - "Time:
Remove xtime_cache".

Petr Titěra reported an issue where he saw odd atime regressions with
2.6.33 where there were a full second worth of nanoseconds in the
nanoseconds field. 

He also reviewed the time code and narrowed down the problem: unhandled
overflow of the nanosecond field caused by rounding up the
sub-nanosecond accumulated time.


Details:

* At the end of update_wall_time(), we currently round up the
sub-nanosecond portion of accumulated time when storing it into xtime.
This was added to avoid time inconsistencies caused when the
sub-nanosecond portion was truncated when storing into xtime.
Unfortunately we don't handle the possible second overflow caused by
that rounding.

* Previously the xtime_cache code hid this overflow by normalizing the
xtime value when storing into the xtime_cache. 

* We could try to handle the second overflow after the rounding up, but
since this affects the timekeeping's internal state, this would further
complicate the next accumulation cycle, causing small errors in ntp
steering. As much as I'd like to get rid of it, the xtime_cache code is
known to work.

* The correct fix is really to include the sub-nanosecond portion in the
timekeeping accessor function, so we don't need to round up at during
accumulation. This would greatly simplify the accumulation code.
Unfortunately, we can't do this safely until the last three
non-GENERIC_TIME arches (sparc32, arm, cris) are converted  (those
patches are in -mm) and we kill off the spots where arches set xtime
directly. This is all 2.6.34 material, so I think reverting the
xtime_cache change is the best approach for now.


Many thanks to Petr for both reporting and finding the issue! 

thanks again,
-john

