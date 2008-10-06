Return-Path: <linux-kernel-owner+w=401wt.eu-S1756715AbYJFXY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbYJFXY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756412AbYJFXWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:22:03 -0400
Received: from ns.suse.de ([195.135.220.2]:40860 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756641AbYJFXWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:22:01 -0400
Date: Mon, 6 Oct 2008 16:17:19 -0700
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
       alan@lxorguk.ukuu.org.uk, epprecht@solnet.ch,
       Zhao Yakui <yakui.zhao@intel.com>, Zhang Rui <rui.zhang@intel.com>,
       Andi Kleen <ak@linux.intel.com>
Subject: [patch 10/28] ACPI: Avoid bogus EC timeout when EC is in Polling
	mode
Message-ID: <20081006231719.GK20567@suse.de>
References: <20081006225949.357365087@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-avoid-bogus-ec-timeout-when-ec-is-in-polling-mode.patch"
In-Reply-To: <20081006231639.GA20567@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Zhao Yakui <yakui.zhao@intel.com>

commit 9d699ed92a459cb408e2577e8bbeabc8ec3989e1 upstream

When EC is in Polling mode, OS will check the EC status continually by using
the following source code:
       clear_bit(EC_FLAGS_WAIT_GPE, &ec->flags);
       while (time_before(jiffies, delay)) {
               if (acpi_ec_check_status(ec, event))
       	            return 0;
               msleep(1);
       }
But msleep is realized by the function of schedule_timeout. At the same time
although one process is already waken up by some events, it won't be scheduled
immediately. So maybe there exists the following phenomena:
     a. The current jiffies is already after the predefined jiffies.
	But before timeout happens, OS has no chance to check the EC
	status again.
     b. If preemptible schedule is enabled, maybe preempt schedule will happen
	before checking loop. When the process is resumed again, maybe
	timeout already happens, which means that OS has no chance to check
	the EC status.

In such case maybe EC status is already what OS expects when timeout happens.
But OS has no chance to check the EC status and regards it as AE_TIME.

So it will be more appropriate that OS will try to check the EC status again
when timeout happens. If the EC status is what we expect, it won't be regarded
as timeout. Only when the EC status is not what we expect, it will be regarded
as timeout, which means that EC controller can't give a response in time.

http://bugzilla.kernel.org/show_bug.cgi?id=9823
http://bugzilla.kernel.org/show_bug.cgi?id=11141

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Zhang Rui  <rui.zhang@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/acpi/ec.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -228,6 +228,8 @@ static int acpi_ec_wait(struct acpi_ec *
 			if (acpi_ec_check_status(ec, event))
 				goto end;
 		}
+		if (acpi_ec_check_status(ec,event))
+			return 0;
 	}
 	pr_err(PREFIX "acpi_ec_wait timeout,"
 			       " status = %d, expect_event = %d\n",

-- 
