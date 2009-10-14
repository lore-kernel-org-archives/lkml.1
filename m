Return-Path: <linux-kernel-owner+w=401wt.eu-S1758628AbZJNLK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628AbZJNLK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 07:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756259AbZJNLK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 07:10:29 -0400
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:40834 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755526AbZJNLK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 07:10:28 -0400
Subject: bdi_threshold slow to reach steady state
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Wu Fengguang <fengguang.wu@intel.com>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 14 Oct 2009 12:09:45 +0100
Message-Id: <1255518586.2360.78.camel@castor>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

I've been running simple tests that uses fio to write 2Gb & reading the
bdi dirty threshold once a second from debugfs. 

The graph of bdi dirty threshold is nice and smooth but takes a long
time to reach a steady state, 60 seconds or more. (run on 2.6.32-rc4)

By eye it seems as though a first-order control system is a good model
for its behavior, so it approximates to 1-e^(-t/T). It just seems too
heavily damped ( at least on my machine).

For fun, I changed calc_period_shift to
	return ilog2(dirty_total - 1) - 2;

and it now reaches a steady state much quicker, around 4-5 seconds.

Tests that write to 2 disks at the same time show no significant
performance differences but are much more consistent, i.e. the standard
deviation is lower across multiple runs.

I have noticed that the first test run on a freshly booted machine is
always the slowest of any sequence of tests, but this change to
calc_period_shift greatly reduces this effect. 

So I wondered how you chose these values? and are there any other tests
that are useful to explore this?

I know that my machine is getting a bit old now, it's AMDX2 & only has
sata 150 drives, so I'm not suggesting that this change is going to be
correct for all machines but maybe we can set a better default? or take
more factors in to account other than just memory size. 

BTW why is it ilog2(dirty_total -1) -- what does the -1 do?

regards
Richard


