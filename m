Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118AbXISASL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbXISASL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 20:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbXISAR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 20:17:58 -0400
Received: from node3.inaccessnetworks.com ([212.205.200.118]:43425 "EHLO
	inaccessnetworks.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751361AbXISAR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 20:17:57 -0400
X-Greylist: delayed 1256 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Sep 2007 20:17:56 EDT
Date: Wed, 19 Sep 2007 02:56:48 +0300
To: linux-kernel@vger.kernel.org
Subject: Bogus high interrupt load?
Message-ID: <20070918235648.GA29746@inaccessnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: amanous@inaccessnetworks.com (Aggelos Manousarides)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am using kernel 2.6.13 on a PXA. The system has a DSP driver which
triggers an interrupt every 5ms with a free running clock, unrelated to
the PXA clock.

During the debugging of the DSP driver a strange load peak was detected with
a very precise period. Normally the total load figure was about 1%-2%,
but every 4:40 minutes, the interrupt load was almost 30% of the system
for about 10 seconds. All tools which are based on the /proc/stat
numbers reported this (top, a custom top build on /proc/stat, snmp
agent).  This system supports multiple slots on a custom bus and another
DSP card was used (which obviously had a different crystal).  The same
phenomenon was repeated but with a different period.

The symptoms suggest that this a clock drift related problem. Various
debugging methods where used (including the oprofile facility) and the
possibility of a bug in the DSP driver has been eliminated. Also, the
logic analyzer did not reveal any prolonged hardware cycles during this
period in which there was load.

Then, we came across a bug in 2.6.21, related to the load average and
the calc_load function. The load I am referring is not based on the load
average figures but the ones reported in /proc/stat, so this is probably
not the same issue.  But this gave us the idea that the load might not
actually be real! So the following experiment was performed.

A silly C program (about 5 lines long) sets a counter to zero and
increases the counter in a busy loop until it reaches a certain bit
boundary. The boundary was set to a number which made the loop last
about 3.4 seconds. The following script was executed:

while true; do time ./test; done

Obviously this produces a 100% load on the system. When no interrupt
load is present, time reported 3,4 seconds real, 3,4 seconds user. When
actual interrupt load was introduced (high ethernet traffic) time
reported 3,4 seconds user and a bigger number for real. Everything looks
normal.

However, during the supposed load produced by the DSP driver, the following
amazing thing happened. Time reported that the real time was again 3,4
seconds (and it was, there was no delay) and that 1,7 seconds was user
load and 1,7 was system load!

How can a process that does "i = 0; while (i++) ;" produce system load?

There is obviously something happening to the load reporting facility of
the kernel when a periodic interrupt source is present. Has anyone seen
something like this? I am not using any real time patches, this is a
vanilla kernel patched only to support the platform at hand.

--
Angelos Manousaridis
