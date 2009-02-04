Return-Path: <linux-kernel-owner+w=401wt.eu-S1761647AbZBDS7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761647AbZBDS7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761402AbZBDStb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:49:31 -0500
Received: from kroah.org ([198.145.64.141]:32780 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761122AbZBDStW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:49:22 -0500
Date: Wed, 4 Feb 2009 10:46:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Len Brown <len.brown@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Thomas Renninger <trenn@suse.de>
Subject: [patch 22/41] cpuidle: use last_state which can reflect the actual
	state entered
Message-ID: <20090204184632.GW25246@kroah.com>
References: <20090204184029.881610776@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cpuidle-use-last_state-which-can-reflect-the-actual-state-entered.patch"
In-Reply-To: <20090204184539.GA25246@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

commit 887e301aa1105326f1412a98749024263b1031c7 upstream

cpuidle accounts the idle time for the C-state it was trying to enter and
not to the actual state that the driver eventually entered. The driver may
select a different state than the one chosen by cpuidle due to
constraints like bus-mastering, etc.

Change the time acounting code to look at the dev->last_state after
returning from target_state->enter(). Driver can modify dev->last_state
internally, inside the enter routine to reflect the actual C-state
entered.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Tested-by: Kevin Hilman <khilman@deeprootsystems.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/cpuidle/cpuidle.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -71,8 +71,11 @@ static void cpuidle_idle_call(void)
 	target_state = &dev->states[next_state];
 
 	/* enter the state and update stats */
-	dev->last_residency = target_state->enter(dev, target_state);
 	dev->last_state = target_state;
+	dev->last_residency = target_state->enter(dev, target_state);
+	if (dev->last_state)
+		target_state = dev->last_state;
+
 	target_state->time += (unsigned long long)dev->last_residency;
 	target_state->usage++;
 

