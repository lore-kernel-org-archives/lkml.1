Return-Path: <linux-kernel-owner+w=401wt.eu-S1760288AbZKFW0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760288AbZKFW0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760104AbZKFW0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:26:47 -0500
Received: from kroah.org ([198.145.64.141]:57184 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932688AbZKFWXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:40 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:51 2009
Message-Id: <20091106221551.250413089@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:15:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Huang Ying <ying.huang@intel.com>, Andi Kleen <ak@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [89/99] x86: mce: Fix thermal throttling message storm
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=x86-mce-fix-thermal-throttling-message-storm.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ingo Molnar <mingo@elte.hu>

commit b417c9fd8690637f0c91479435ab3e2bf450c038 upstream.

If a system switches back and forth between hot and cold mode,
the MCE code will print a stream of critical kernel messages.

Extend the throttling code to properly notice this, by
only printing the first hot + cold transition and omitting
the rest up to CHECK_INTERVAL (5 minutes).

This way we'll only get a single incident of:

 [  102.356584] CPU0: Temperature above threshold, cpu clock throttled (total events = 1)
 [  102.357000] Disabling lock debugging due to kernel taint
 [  102.369223] CPU0: Temperature/speed normal

Every 5 minutes. The 'total events' count tells the number of cold/hot
transitions detected, should overheating occur after 5 minutes again:

[  402.357580] CPU0: Temperature above threshold, cpu clock throttled (total events = 24891)
[  402.358001] CPU0: Temperature/speed normal
[  450.704142] Machine check events logged

Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -42,6 +42,7 @@ struct thermal_state {
 
 	u64			next_check;
 	unsigned long		throttle_count;
+	unsigned long		last_throttle_count;
 };
 
 static DEFINE_PER_CPU(struct thermal_state, thermal_state);
@@ -120,11 +121,12 @@ static int therm_throt_process(bool is_t
 	if (is_throttled)
 		state->throttle_count++;
 
-	if (!(was_throttled ^ is_throttled) &&
-			time_before64(now, state->next_check))
+	if (time_before64(now, state->next_check) &&
+			state->throttle_count != state->last_throttle_count)
 		return 0;
 
 	state->next_check = now + CHECK_INTERVAL;
+	state->last_throttle_count = state->throttle_count;
 
 	/* if we just entered the thermal event */
 	if (is_throttled) {


