Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbZA2OFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbZA2OFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 09:05:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbZA2OFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 09:05:40 -0500
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:54472 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758248AbZA2OFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 09:05:39 -0500
X-DKIM: Sendmail DKIM Filter v2.6.0 mail-in-17.arcor-online.net 82CF03B261E
Subject: Re: [Bugme-new] [Bug 12562] New: High overhead while switching or
 synchronizing threads on different cores
From: Thomas Pilarski <thomas.pi@arcor.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Galbraith <efault@gmx.de>,
       Gregory Haskins <ghaskins@novell.com>, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1233229028.4495.34.camel@laptop>
References: <bug-12562-10286@http.bugzilla.kernel.org/>
	 <20090128125604.94ed3fe0.akpm@linux-foundation.org>
	 <1233181507.6988.14.camel@bugs-laptop>  <1233220048.7835.19.camel@twins>
	 <1233223979.5294.41.camel@bugs-laptop>
	 <1233224644.5294.52.camel@bugs-laptop>  <1233229028.4495.34.camel@laptop>
Content-Type: text/plain
Date: Thu, 29 Jan 2009 15:05:34 +0100
Message-Id: <1233237934.11129.183.camel@bugs-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> In short this program is carefully crafted to defeat all our affinity
> tests - and I'm not sure what to do.

I am sorry, although it is not carefully crafted. The function random()
is causing my problem. I currently have no real data, so I tried to make
some random utilization and data.

Without the random() function it works even with 80MB of data and I get
great results.

./ThreadSchedulingIssue 1 10485760 8 312
All threads finished: 309 messages in 29.369 seconds / 10.521 msg/s

schedtool -a 1 -e ./ThreadSchedulingIssue 1 10485760 8 312
All threads finished: 312 messages in 44.284 seconds / 7.045 msg/s

It does not even regress with more then two threads. 

./ThreadSchedulingIssue 2 10485760 8 312
All threads finished: 311 messages in 28.040 seconds / 11.091 msg/s

./ThreadSchedulingIssue 4 10485760 8 312
All threads finished: 309 messages in 28.021 seconds / 11.027 msg/s

With small amounts of data the speed on two core is even doubled. 

schedtool -a 1 -e ./ThreadSchedulingIssue 1 1048 8 312000
All threads finished: 311992 messages in 19.437 seconds / 16051.247
msg/s

./ThreadSchedulingIssue 3 1048 8 312000
All threads finished: 311998 messages in 9.652 seconds / 32324.411 msg/s

./ThreadSchedulingIssue 8 1048 8 312000
All threads finished: 311997 messages in 9.339 seconds / 33406.370 msg/s

--------------
Perhaps it is as it should be, but when I run the test (without
random()) with 2*8 threads, it uses ~186 of the cpu, while an instance
of "bzip2 -9 -c /dev/urandom >/dev/null" gets only 12%.

