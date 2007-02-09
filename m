Return-Path: <linux-kernel-owner+w=401wt.eu-S2992753AbXBITAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992753AbXBITAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 14:00:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992754AbXBITAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 14:00:00 -0500
Received: from ip-216-152-249-241.servata.com ([216.152.249.241]:39346 "EHLO
	servata.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992753AbXBIS77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 13:59:59 -0500
X-Greylist: delayed 1539 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Feb 2007 13:59:59 EST
Subject: oom_kill.c badness() correction for shared memory
From: Jeff Davis <linux@j-davis.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 09 Feb 2007 10:34:15 -0800
Message-Id: <1171046056.10824.71.camel@dogma.v10.wvs>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


In oom_kill.c, badness() takes into account many factors, including half
the total_vm of all the children.

The problem with this calculation is that, if the parent and children
share memory, the shared memory segment is counted many times for the
parent.

I don't think we need to count the shared memory at all when calculating
badness, because there's already a hard limit on the amount of shared
memory, so it's unlikely that process is runaway due to shared memory
consumption.

Would it be better to just use (total_vm-shared_vm) in the badness
function in each instance it currently uses total_vm? At a minimum, we
should do that for the loop that counts each child's vm against the
parent.

An example of a practical problem is with PostgreSQL. PostgreSQL
installations often have very large shared memory regions shared between
the parent and all the child processes. If the OOM killer is invoked,
it's almost guaranteed to kill the PostgreSQL parent process first, even
if the PostgreSQL processes all combined use much less memory than the
"real" bad process (because the same shared memory is counted many
times).

Regards,
	Jeff Davis

