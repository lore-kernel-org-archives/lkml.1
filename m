Return-Path: <linux-kernel-owner+w=401wt.eu-S1756459AbXLUHKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459AbXLUHKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 02:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbXLUHKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 02:10:06 -0500
Received: from ams-iport-1.cisco.com ([144.254.224.140]:11519 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbXLUHKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 02:10:05 -0500
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2007 02:10:04 EST
X-IronPort-AV: E=Sophos;i="4.24,192,1196636400"; 
   d="scan'208";a="1479047"
Message-ID: <476B6448.7090805@hotmail.com>
Date: Thu, 20 Dec 2007 22:59:20 -0800
From: Srinivas Kommu <kommu@hotmail.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Srinivas Kommu <kommu@hotmail.com>
Subject: driver spin lock and files_lock deadlock question
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Dec 2007 07:00:06.0588 (UTC) FILETIME=[1E3797C0:01C8439F]
Authentication-Results: ams-dkim-2; header.From=kommu@hotmail.com; dkim=neutral
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a driver that needs to be SMP-safe. It also has some code hooking 
into the net_rx_action softirq. So it takes a spinlock and disables the 
local bottom-half around its critical sections: 
spin_lock_bh(&driver_lock). Now, I'm facing a deadlock under a 
particular sequence involving the files_lock:

1. CPU 0 takes driver_lock and then calls remove_proc_entry() which is 
hanging at spin_lock(&files_lock).

2. CPU 1 was in fput() which took files_lock; the softirq comes in at 
this point and attempts to take driver_lock and hangs forever.

It seems this kind of a deadlock can happen with any kernel lock, not 
just files_lock. What's the driver's mistake here? Is it wrong to call 
remove_proc_entry() while holding another lock? What is the right thing 
to do?

This is with the 2.4 kernel, BTW.


thanks
srini
