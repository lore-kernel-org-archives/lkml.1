Return-Path: <linux-kernel-owner+w=401wt.eu-S932663AbYFGBPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663AbYFGBPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760733AbYFGBJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:10 -0400
Received: from sous-sol.org ([216.99.217.87]:42377 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759974AbYFGBJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:01 -0400
Message-Id: <20080607010637.940944913@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:03:05 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       CHIKAMA masaki <masaki.chikama@gmail.com>,
       Dave Jones <davej@codemonkey.org.uk>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [patch 50/50] cpufreq: fix null object access on Transmeta CPU
Content-Disposition: inline; filename=cpufreq-fix-null-object-access-on-transmeta-cpu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: CHIKAMA masaki <masaki.chikama@gmail.com>

upstream commit: 879000f94442860e72c934f9e568989bc7fb8ec4

If cpu specific cpufreq driver(i.e.  longrun) has "setpolicy" function,
governor object isn't set into cpufreq_policy object at "__cpufreq_set_policy"
function in driver/cpufreq/cpufreq.c .

This causes a null object access at "store_scaling_setspeed" and
"show_scaling_setspeed" function in driver/cpufreq/cpufreq.c when reading or
writing through /sys interface (ex.  cat
/sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed)

Addresses:
	http://bugzilla.kernel.org/show_bug.cgi?id=10654
	https://bugzilla.redhat.com/show_bug.cgi?id=443354

Signed-off-by: CHIKAMA Masaki <masaki.chikama@gmail.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Chuck Ebbert <cebbert@redhat.com>
Acked-by: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/cpufreq/cpufreq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -607,7 +607,7 @@ static ssize_t store_scaling_setspeed(st
 	unsigned int freq = 0;
 	unsigned int ret;
 
-	if (!policy->governor->store_setspeed)
+	if (!policy->governor || !policy->governor->store_setspeed)
 		return -EINVAL;
 
 	ret = sscanf(buf, "%u", &freq);
@@ -621,7 +621,7 @@ static ssize_t store_scaling_setspeed(st
 
 static ssize_t show_scaling_setspeed(struct cpufreq_policy *policy, char *buf)
 {
-	if (!policy->governor->show_setspeed)
+	if (!policy->governor || !policy->governor->show_setspeed)
 		return sprintf(buf, "<unsupported>\n");
 
 	return policy->governor->show_setspeed(policy, buf);

-- 
