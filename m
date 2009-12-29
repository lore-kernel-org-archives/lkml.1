Return-Path: <linux-kernel-owner+w=401wt.eu-S1751977AbZL2S2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbZL2S2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 13:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZL2S2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 13:28:47 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:50197 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751528AbZL2S2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 13:28:46 -0500
X-Greylist: delayed 932 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Dec 2009 13:28:46 EST
Date: Tue, 29 Dec 2009 13:00:05 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [Regression, bisected] Receive failure in et131x.
Message-ID: <20091229180005.GA23030@emergent.ellipticsemi.com>
Mail-Followup-To: Alan Cox <alan@linux.intel.com>,
	linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Continuing the theme from the last release cycle -- my PCI-express
et131x card (which works in 2.6.32) fails in the latest Linus git.  The
card works at first (DHCP and NFS mounts during bootup are OK) but
quickly fails once any reasonable traffic is put through it.  Transmit
seems to continue to work after a failure, but receive is mostly dead
forever -- the occasional frame appears to make it through.  The kernel
log contains many messages of the following form:

et131x 0000:02:00.0: NICRxPkts PSR Entry 1546 indicates length of 12920 and/or bad bi(614)
et131x 0000:02:00.0: NICRxPkts PSR Entry 1547 indicates length of 27745 and/or bad bi(92)
et131x 0000:02:00.0: NICRxPkts PSR Entry 1548 indicates length of 30064 and/or bad bi(116)
...

Bisection reveals the following.

99fd99f618daecae638550275cb132ab1ffe464c is the first bad commit
commit 99fd99f618daecae638550275cb132ab1ffe464c
Author: Alan Cox <alan@linux.intel.com>
Date:   Wed Nov 18 14:07:58 2009 +0000

    Staging: et131x: clean up the avail fields in the rx registers

    These have a wrap bit but again need little work to clean out. There are a
    couple of uglies left that want addressing in later clean up. Notably we should
    probably keep the local psr copy and wrap as two values.

    Signed-off-by: Alan Cox <alan@linux.intel.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

:040000 040000 8f0034c85fab183134fa19c7d58cee687991b6e7 a98b1db6fa82d8107fc5699fa2ae0851f38a14b0 M      drivers

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
