Return-Path: <linux-kernel-owner+w=401wt.eu-S1030588AbXCSVlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030588AbXCSVlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030586AbXCSVlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:41:03 -0400
Received: from mx1.suse.de ([195.135.220.2]:55656 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030591AbXCSVkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:40:53 -0400
Date: Mon, 19 Mar 2007 14:38:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, tglx@linutronix.de,
       mingo@elte.hu
Subject: [patch 12/31] futex: PI state locking fix
Message-ID: <20070319213859.GN9261@kroah.com>
References: <20070319213047.710101653@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="futex-pi-state-locking-fix.patch"
In-Reply-To: <20070319213647.GB9261@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ingo Molnar <mingo@elte.hu>

Testing of -rt by IBM uncovered a locking bug in wake_futex_pi(): the PI
state needs to be locked before we access it.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/futex.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -565,6 +565,7 @@ static int wake_futex_pi(u32 __user *uad
 	if (!pi_state)
 		return -EINVAL;
 
+	spin_lock(&pi_state->pi_mutex.wait_lock);
 	new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
 
 	/*
@@ -604,6 +605,7 @@ static int wake_futex_pi(u32 __user *uad
 	pi_state->owner = new_owner;
 	spin_unlock_irq(&new_owner->pi_lock);
 
+	spin_unlock(&pi_state->pi_mutex.wait_lock);
 	rt_mutex_unlock(&pi_state->pi_mutex);
 
 	return 0;

-- 
