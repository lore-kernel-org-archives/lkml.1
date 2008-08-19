Return-Path: <linux-kernel-owner+w=401wt.eu-S1757771AbYHST2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771AbYHST2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbYHST2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:28:41 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38487 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088AbYHST2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:28:40 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 19 Aug 2008 21:28:18 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [patch 2/3] ieee1394: don't drop nodes during bus reset series
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, damien_benoist@yahoo.com
In-Reply-To: <tkrat.a3ef08493991acb0@s5r6.in-berlin.de>
Message-ID: <tkrat.3829f18186b21759@s5r6.in-berlin.de>
References: <994096.81924.qm@web50505.mail.re2.yahoo.com>
 <48A5A80A.90506@s5r6.in-berlin.de> <48A6BA6F.2030000@s5r6.in-berlin.de>
 <tkrat.bdb066b22ec930a0@s5r6.in-berlin.de>
 <tkrat.a3ef08493991acb0@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> nodemgr_node_probe checked for generation increments too late and
> therefore prematurely reported nodes as "suspended".
> 
> Fixes http://bugzilla.kernel.org/show_bug.cgi?id=11349 for me.

This and the accompanying sbp2 patch 3/3 allows the drivers to keep
going if they have temporary trouble with the protocol traffic due to
bus resets in a series.

I now implemented an additional patch which lets the drivers even
tolerate it if nodes vanish a few seconds from the bus --- e.g. a wonky
repeater blacks out briefly, or user plugs cables from left to right,
and so on.  As a preparation for this enhancement, I have a cleanup in
nodemgr in the pipeline. Next up:

    patch 1/2)  ieee1394: nodemgr clean up class iterators
    patch 2/2)  ieee1394: survive a few seconds connection loss

With this you can indeed unplug a disk, even a bus powered one, and plug
it back in in the next few seconds, while programs are actively
accessing the disk.  The IO of these programs will merely be blocked
during the disturbance, but sbp2 will log back in and IO will continue
without error.

Of course situations like these should rather be avoided; but they _do_
happen for example on a bus with PC--disk_A--disk_B when disk_A is
switched from self power to bus power and continues to work as repeater
when bus-powered.  The repeater function is only established after a
short disruption of the bus though.  Not nice at all if you forgot to
unmount disk_B for the time being.  From now on, unmounting it will not
be necessary because it is very very likely that sbp2 will be able to
re-login to disk_B.

The patches which I'll post will apply to 2.6.27-rc only.  Variants for
2.6.25 and .26 will be uploaded to
http://user.in-berlin.de/~s5r6/linux1394/updates/ in a few minutes.

The ieee1394 core driver actually contained stubs for this capability
for years, but the implementation wasn't fleshed out for this purpose
until now.  Therefore my patches even remove more code than they add.

The new firewire stack desperately needs a similar feature.  It monitors
the bus for PHYs vanishing even more precisely than the ieee1394 stack,
thus there is an even higher probability that firewire-sbp2
unnecessarily withdraws a disk from the SCSI stack.
-- 
Stefan Richter
-=====-==--- =--- =--==
http://arcgraph.de/sr/

