Return-Path: <linux-kernel-owner+w=401wt.eu-S933413AbXG0NUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413AbXG0NUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 09:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759066AbXG0NUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 09:20:31 -0400
Received: from hunley.homeip.net ([69.12.222.146]:49453 "EHLO
	hunley.homeip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758630AbXG0NUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 09:20:30 -0400
X-Greylist: delayed 1483 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jul 2007 09:20:30 EDT
From: Douglas J Hunley <doug@hunley.homeip.net>
To: slocate@trakker.ca
Subject: solving(?) the updatedb problem w/ the kernel cache
Date: Fri, 27 Jul 2007 08:55:26 -0400
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707270855.26997.doug@hunley.homeip.net>
X-Greylist: Sender succeded SMTP AUTH authentication, not delayed by milter-greylist-1.6 (hunley.homeip.net [69.12.222.146]); Fri, 27 Jul 2007 08:55:33 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've been following lkml for a little while (not understanding it all, but 
following nonetheless <g>) and I've noticed that in a lot of the talks about 
schedulers, elevators, and performance, the issue of running updatedb and its 
effects on the kernel's fs cache seems to recur. I've also yet to see anyone 
present a solution that others think is worth pursuing. I'm curious why we're 
trying to solve the problem, when we can simply avoid the problem to begin 
with by making use of inotify and introducing a new user-space 
daemon, 'located'. 

This daemon would be started by the init scripts, register one or more inotify 
listeners based on /etc/updatedb.conf and then go to sleep. Whenever the fs 
is modified, an inotify event is triggered and 'located' wakes up, 
adjusts 'locate.db', and then goes back to sleep. It's about as simple as a 
daemon can get and still be of use, I think.

Add a little 'configure' foo to detect if the system has inotify support and 
if it does, build/install the new daemon. If it doesn't, then don't build it 
and use the old behavior. With the daemon up and running, you can rm the 
updatedb entry in cron.daily and the negative impact it causes on the 
kernel's fs simply goes away. 

You wouldn't need to modify 'locate' itself, as it would still read 
from 'locate.db' like it does now. As an added bonus, you'd now have 
real-time results from 'locate'. If your Sys Admin just 
installed /usr/bin/foo, then 'locate foo' would find it "immediately". No 
more waiting until the next run of 'updatedb' for accurate results.

All the major distros support inotify at this point, I believe. If I could 
code, I'd have attached the daemon here myself :)

I must admit, though, I'm a little perplexed why greater minds than mine 
haven't already implemented this. I must be missing some technical issue. Can 
anyone enlighten me on the same?
-- 
Douglas J Hunley (doug at hunley.homeip.net)
