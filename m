Return-Path: <linux-kernel-owner+w=401wt.eu-S935503AbZLQEEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935503AbZLQEEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763961AbZLQEEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:04:06 -0500
Received: from kroah.org ([198.145.64.141]:55411 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763956AbZLQEEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:02 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:47 2009
Message-Id: <20091217035647.738596809@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Beulich <jbeulich@novell.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [037/151] x86/mce: Set up timer unconditionally
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Beulich <jbeulich@novell.com>

commit bc09effabf0c5c6c7021e5ef9af15a23579b32a8 upstream.

mce_timer must be passed to setup_timer() in all cases, no
matter whether it is going to be actually used. Otherwise, when
the CPU gets brought down, its call to del_timer_sync() will
never return, as the timer won't have a base associated, and
hence lock_timer_base() will loop infinitely.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
LKML-Reference: <4B1DB831.2030801@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/mcheck/mce.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1374,13 +1374,14 @@ static void mce_init_timer(void)
 	struct timer_list *t = &__get_cpu_var(mce_timer);
 	int *n = &__get_cpu_var(mce_next_interval);
 
+	setup_timer(t, mcheck_timer, smp_processor_id());
+
 	if (mce_ignore_ce)
 		return;
 
 	*n = check_interval * HZ;
 	if (!*n)
 		return;
-	setup_timer(t, mcheck_timer, smp_processor_id());
 	t->expires = round_jiffies(jiffies + *n);
 	add_timer_on(t, smp_processor_id());
 }


