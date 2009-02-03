Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbZBCMcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbZBCMcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 07:32:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbZBCMbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 07:31:53 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:54150 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752853AbZBCMbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 07:31:52 -0500
Subject: Re: next-20090202: task kmemleak:763 blocked for more than 120
	seconds.
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mandeep Singh Baines <msb@google.com>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090202215740.GA26550@google.com>
References: <a4423d670902020327x61a1d9dehb1642b25ec7f82f1@mail.gmail.com>
	 <tnxiqns28mm.fsf@pc1117.cambridge.arm.com>
	 <c62985530902020715u73407d4dqe14c340de310c866@mail.gmail.com>
	 <20090202215740.GA26550@google.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 03 Feb 2009 12:31:44 +0000
Message-Id: <1233664304.1568.39.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Feb 2009 12:31:45.0832 (UTC) FILETIME=[6074C280:01C985FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 13:57 -0800, Mandeep Singh Baines wrote:
> The hung_task timeout is now 480 seconds because of sys_sync:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=fb822db465bd9fd4208eef1af4490539b236c54e
> 
> But are there are really any other tasks which call
> schedule_timeout_uninterruptibl() for with a timeout >480 seconds?
> 
> Right now kmemleak appears to be the only exception. (A quick grep didn't turn
> anything up.) And it is trivial to change kmemleak to use INTERRUPTIBLE.
> Might even be a nice feature. You could stop it faster that way.

I changed the code as below as it makes more sense:

--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1044,6 +1044,7 @@ static int kmemleak_scan_thread(void *arg)
 
 	while (!kthread_should_stop()) {
 		struct kmemleak_object *object;
+		signed long timeout = jiffies_scan_wait;
 
 		mutex_lock(&scan_mutex);
 
@@ -1069,7 +1070,8 @@ static int kmemleak_scan_thread(void *arg)
 
 		mutex_unlock(&scan_mutex);
 		/* wait before the next scan */
-		schedule_timeout_uninterruptible(jiffies_scan_wait);
+		while (timeout && !kthread_should_stop())
+			timeout = schedule_timeout_interruptible(timeout);
 	}
 
 	pr_info("kmemleak: Automatic memory scanning thread ended\n");

-- 
Catalin

