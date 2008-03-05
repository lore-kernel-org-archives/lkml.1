Return-Path: <linux-kernel-owner+w=401wt.eu-S1757229AbYCEUpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbYCEUpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 15:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbYCEUp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 15:45:28 -0500
Received: from WPIS-64-140-232-140.worldpath.net ([64.140.232.140]:37486 "EHLO
	exchange.rivulet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbYCEUp1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 15:45:27 -0500
From: Todd Tomaino <ttomaino@rivulet.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 5 Mar 2008 15:45:24 -0500
Subject: E1000:   e1000_update_stats()
Thread-Topic: E1000:   e1000_update_stats()
Thread-Index: Ach/AdXu23uAqimlRmO2CGU1uRtksA==
Message-ID: <67F3071335CB9945A6047FE06957E0240D6D94CE93@exchange.rivulet.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



I have been having trouble with interrupt latencies.  While profiling my system, I measured the e1000_update_stats() function disabling interrupts for roughly 100 usec.  For my application, this long of a delay results in data loss.  The e1000_update_stats() function is broken down into 3 main operations:

1. acquire spinlock
2. read registers & update adapter->stat counters
3. update OS adapter->net_stats statistics
4. update phy stats.
5. release spinlock.

On my system I measured 57 usec to perform operations #2 and #3, and 52 usec to perform operation #4.

Reading the comments in the code it appeared that updating adapter->net_stats and adapter->stat required interrupts to be turned off to prevent the e1000_adjust_tbi_stats() function from modifying these structures from interrupt context.  In order to reduce the amount of time spent with interrupts disabled I separated the register reads from updating adapter->stat counters.  The register reads take up the bulk of the 57 usec and shouldn't require protection (I could be wrong).  The new operation looks like this and reduces the amount of time spent with interrupts turned off by 1/2:

1. read registers
2. acquire spinlock
3. update adapter->stat counters
4. update OS adapter->net_stats statistics
5. update phy stats.
6. release spinlock.


It seemed like a bad idea to attempt to move the phy reads out of the spin locked code area.

These changes have greatly reduced my interrupt latency, but are there any negative side effects that could be caused??


Best regards,
Todd


System Info:

  Kernel:            2.6.18 (RHEL5.1)

  E1000 driver:      7.3.20-k2
