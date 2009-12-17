Return-Path: <linux-kernel-owner+w=401wt.eu-S936662AbZLQEkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936662AbZLQEkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:40:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965099AbZLQEi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:38:57 -0500
Received: from kroah.org ([198.145.64.141]:55399 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763909AbZLQEEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:01 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:47 2009
Message-Id: <20091217035647.605378154@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Jan Beulich <jbeulich@novell.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [036/151] x86, mce: dont restart timer if disabled
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

commit fe5ed91ddce85a0ed0e4f92c10b099873ef62167 upstream.

Even it is in error path unlikely taken, add_timer_on() at
CPU_DOWN_FAILED* needs to be skipped if mce_timer is disabled.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Jan Beulich <jbeulich@novell.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/mcheck/mce.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1991,9 +1991,11 @@ mce_cpu_callback(struct notifier_block *
 		break;
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
-		t->expires = round_jiffies(jiffies +
+		if (!mce_ignore_ce && check_interval) {
+			t->expires = round_jiffies(jiffies +
 					   __get_cpu_var(mce_next_interval));
-		add_timer_on(t, cpu);
+			add_timer_on(t, cpu);
+		}
 		smp_call_function_single(cpu, mce_reenable_cpu, &action, 1);
 		break;
 	case CPU_POST_DEAD:


