Return-Path: <linux-kernel-owner+w=401wt.eu-S1758590AbXJCOcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590AbXJCOcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 10:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbXJCOcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 10:32:09 -0400
Received: from sacred.ru ([62.205.161.221]:38791 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777AbXJCOcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 10:32:08 -0400
Message-ID: <4703A44F.9020402@openvz.org>
Date: Wed, 03 Oct 2007 18:16:47 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Matt Mackall <mpm@selenic.com>
Subject: [PATCH 0/3] Make tasks always have non-zero pids
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 03 Oct 2007 18:19:12 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some time ago Sukadev noticed that the vmlinux size has
grown 5Kb due to merged pid namespaces. One of the big
problems with it was fat inline functions. The other thing
was noticed by Matt - the checks for task's pid to be not
NULL take place and make the kernel grow due to inlining,
but these checks are not always needed.

In this series I introduce a static pid (dummy), according
to Matt's proposal, which is assigned to tasks during the 
detach_pid and transfer_pid instead of NULL. This pid lives 
in the init pid namespace and has the id = 0, so all the 
task_xid_xnr() calls will still return 0 on a dead task.

Places that get the struct pid from task either get it from
the current (in this case they will never get this dummy),
or use it to compare with some other value (so they will 
work the same for both NULL and dummy pids).

This saves up to 340 bytes for i386 kernel with minimal 
config  and probably more with more users of pids.

Tested on i386 and x86_64 boxes. Tasks still live and die,
namespaces and proc still work.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
