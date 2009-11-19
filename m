Return-Path: <linux-kernel-owner+w=401wt.eu-S1754999AbZKSTsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbZKSTsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 14:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbZKSTsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 14:48:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:55435 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbZKSTsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 14:48:37 -0500
Date: Thu, 19 Nov 2009 11:50:20 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: tglx@linutronix.de
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: commit b00bc0b237055b breaking perf subsystem
Message-ID: <20091119115020.7bd8896b@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit b00bc0b237055b4c45816325ee14f0bd83e6f590
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Mon Nov 2 13:01:56 2009 +0100

    uids: Prevent tear down race

has been bisected to break the perf system between -rc5 and -rc7;
and reverting this patch in rc7 also fixes the issue.

now this patch is.... fun and seemingly unrelated to perf, so I
am pretty sure something else is going on.

the symptom of the breakage is that a userland client of perf
(in my case, powertop) does not get to see new events if there
is only, say, one or two of them. The data_head pointer just does
not get updated.

Based on the patch, I have a suspicion that this pointer gets updated
from synchronize RCU context, and this patch just makes that happen
more.

If that is the case, what we really need is a new ioctl to perf that
will cause all pending buffer state to be flushed to the ring buffer,
that applications using perf can then just always call before looking
at the ring. As a concept, that sounds like a good idea to me anyway...

comments/suggestions/saying-I'm-full-of-sh*t ?



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
