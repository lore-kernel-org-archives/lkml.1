Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab0BABHf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 20:07:35 -0500
Received: from senator.holtmann.net ([87.106.208.187]:53859 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab0BABHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 20:07:33 -0500
Subject: Re: [Bug #15127] Bluetooth: sleeping function called from invalid
 context
From: Marcel Holtmann <marcel@holtmann.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       David John <davidjon@xenontk.org>,
       Luiz Augusto von Dentz <luiz.dentz@gmail.com>
In-Reply-To: <de962C6zBxL.A.lME.FFiZLB@chimera>
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
	 <de962C6zBxL.A.lME.FFiZLB@chimera>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 31 Jan 2010 17:06:46 -0800
Message-ID: <1264986406.31341.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15127
> Subject		: Bluetooth: sleeping function called from invalid context
> Submitter	: David John <davidjon@xenontk.org>
> Date		: 2010-01-12 9:19 (20 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9e726b17422bade75fba94e625cd35fd1353e682
> References	: http://marc.info/?l=linux-kernel&m=126328727021949&w=4

you have an outdated email from Luiz and I change it to the right one
now.

I looked with him at the patch and I think this will fix it:

diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index fc5ee32..2b50637 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -252,7 +252,6 @@ static void rfcomm_session_timeout(unsigned long
arg)
 	BT_DBG("session %p state %ld", s, s->state);
 
 	set_bit(RFCOMM_TIMED_OUT, &s->flags);
-	rfcomm_session_put(s);
 	rfcomm_schedule(RFCOMM_SCHED_TIMEO);
 }
 
@@ -1920,6 +1919,7 @@ static inline void rfcomm_process_sessions(void)
 		if (test_and_clear_bit(RFCOMM_TIMED_OUT, &s->flags)) {
 			s->state = BT_DISCONN;
 			rfcomm_send_disc(s, 0);
+			rfcomm_session_put(s);
 			continue;
 		}
 
We need some extra testing on this with the actual hardware we did the
patch for. So this will take at least a few days before we get our hands
on it.

Regards

Marcel


