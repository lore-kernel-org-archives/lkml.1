Return-Path: <linux-kernel-owner+w=401wt.eu-S1757912AbYDTSVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbYDTSVu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 14:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbYDTSVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 14:21:43 -0400
Received: from rv-out-0708.google.com ([209.85.198.243]:2742 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753370AbYDTSVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 14:21:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=j3/83snm9b3mDnxYqwS61SZACIjB4hHiOgNiAW5HVMcBI5viLxkHN/0gVh6vs1s556vZPDxhrJyEdC3CTOjHDg0AyDu7uavSkgIQ87kVdnjbG/0Hrw3UT/hDF8QI1f/GRS9gThwbS4a2n4K9h8gOEJCmWjaU8Nm/bxfgidjfTSs=
Message-ID: <ba7d8f720804201121h6c024dcrabd301c8b4be7a4@mail.gmail.com>
Date: Sun, 20 Apr 2008 14:21:39 -0400
From: "Dan Upton" <upton.dan.linux@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: migration thread and active_load_balance
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Back again with more questions about the scheduler, as I've spent two
or three days trying to debug on my own and I'm just not getting
anywhere.

Basically, I'm trying to add a new active balancing mechanism.  I made
out a diagram of how migration_thread  calls active_load_balance and
so on, and I use a flag (set by writing to a file in sysfs) to
determine whether to use the standard iterator for the CFS runqueue or
a different iterator I wrote.  The new iterator seems to work fine, as
I've been using it (again, with a flag) to replace the regular
iterator when it's called from schedule by idle_balance.  I basically
tried adding an extra conditional in migration_thread that sets up
some state and then calls active_load_balance, but I was getting
deadlocks.  I'm not really sure why, since all I've really changed is
add a few variables to struct rq and struct cfs_rq.

I tried only doing my state setup and restore in that conditional,
without actually calling active_load_balance, which has given me an
even more frustrating result--the kernel does not deadlock, but it
does seem to crash in such a manner as to require a hard reset of the
machine.  (For instance, at one point I got an "invalid page state in
process 'init'" message from the kernel; if I try to reboot from Gnome
though it hangs.)  I don't understand this at all, since as far as I
can tell I'm using thread-local variables and really all I'm doing
right now is assignments to them.  Unless, of course the struct rq
(from rq = cpu_rq(cpu);) could be being manipulated elsewhere, leading
to some sort of race condition...

Anyway, like I said, I've spent several days trying to understand this
error by putting in printk()s galore and doing traces through the
source code to figure out the call chain, but I'm really stuck here.
Can anybody shed some light, or point me to some more thorough
documentation on the scheduler and active load balancing?

Thanks,
-dan
