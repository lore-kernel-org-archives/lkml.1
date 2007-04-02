Return-Path: <linux-kernel-owner+w=401wt.eu-S965695AbXDBTBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965695AbXDBTBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 15:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965692AbXDBTBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 15:01:12 -0400
Received: from rwcrmhc12.comcast.net ([216.148.227.152]:40006 "EHLO
	rwcrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965698AbXDBTBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 15:01:11 -0400
Subject: hrtimer_start problem?
From: Jim Houston <jim.houston@comcast.net>
Reply-To: jim.houston@comcast.net
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 02 Apr 2007 15:01:09 -0400
Message-Id: <1175540469.6299.84.camel@x2.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

The logic in hrtimer_start() which controls the reprogram argument
to enqueue_hrtimer() looks broken to me.  I assume that intent is
to set the hardware timer only if the hrtimer is being enqueued on
a local base.

The existing test "base == new_base" will skip programming the timer
if it was moved from another cpu.  Normally switch_hrtimer_base() will
find that the timer is already on the local base or will move the timer
to the local base.  In both of these cases it seems necessary to
program the timer.  The case where the timer should not be programmed
is if switch_hrtimer_base() failed to move the timer and it is
still associated with a non-local base.

There are two failure mechanisms.  The common case fails to
set the hardware timer even though the timer has been moved 
to the local base.  This would cause the hrtimer's expiry to
be delayed until the time when the hardware timer was currently
programmed to expire.  In the case where timer could not be moved,
we program the local timer using a mishmash of information from
the local and remote bases.

I ran into this with a Concurrent kernel based on your
patch-2.6.18-hrt-dyntick2.  I have checked that the logic is
still the same in kernel.org.


Jim Houston - Concurrent Computer Corp.

