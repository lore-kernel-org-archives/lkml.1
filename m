Return-Path: <linux-kernel-owner+w=401wt.eu-S1753454AbZBCMtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbZBCMtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 07:49:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbZBCMso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 07:48:44 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:55618 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751374AbZBCMsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 07:48:43 -0500
Subject: Re: next-20090202: task kmemleak:763 blocked for more than 120
	seconds.
From: Catalin Marinas <catalin.marinas@arm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mandeep Singh Baines <msb@google.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090203004141.GA22718@nowhere>
References: <a4423d670902020327x61a1d9dehb1642b25ec7f82f1@mail.gmail.com>
	 <tnxiqns28mm.fsf@pc1117.cambridge.arm.com>
	 <c62985530902020715u73407d4dqe14c340de310c866@mail.gmail.com>
	 <20090202215740.GA26550@google.com>  <20090203004141.GA22718@nowhere>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 03 Feb 2009 12:48:34 +0000
Message-Id: <1233665314.1568.46.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Feb 2009 12:48:36.0206 (UTC) FILETIME=[BAAF98E0:01C985FD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 01:41 +0100, Frederic Weisbecker wrote:
> Right. BTW, I wonder how it behaves in case of suspend to disk.
> But changing the state to TASK_INTERRUPTIBLE wouldn't change it in this case since the
> signals are only sent to userpace threads to freeze them.
> 
> Kernel threads try to freeze by themselves.
> 
> But for such very long schedule_timeout, will the hibernation wait for kmemleak
> to wake up and then try_to_freeze() before suspend to disk?

I haven't added anything to kmemleak for this. Does something like below
look feasible?

--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -88,6 +88,7 @@
 #include <linux/errno.h>
 #include <linux/uaccess.h>
 #include <linux/string.h>
+#include <linux/freezer.h>
 
 #include <asm/sections.h>
 #include <asm/processor.h>
@@ -1070,8 +1071,11 @@ static int kmemleak_scan_thread(void *arg)
 
 		mutex_unlock(&scan_mutex);
 		/* wait before the next scan */
-		while (timeout && !kthread_should_stop())
+		while (timeout && !kthread_should_stop()) {
+			if (try_to_freeze())
+				break;
 			timeout = schedule_timeout_interruptible(timeout);
+		}
 	}
 
 	pr_info("kmemleak: Automatic memory scanning thread ended\n");

Thanks.

-- 
Catalin

