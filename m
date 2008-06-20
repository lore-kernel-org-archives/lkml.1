Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbYFTN5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbYFTN5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 09:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbYFTN4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 09:56:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:64743 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbYFTN4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 09:56:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:from;
        b=O+FzH6CeIh7x8ec83Kh23oaWEtomDlDQCL2wGlgz2YzofFjF2MX5H7Z8BipK5l47sW
         BWv4qAk29IGFpJBIw5iL0Y+IOZ4a/wKGqcMbgUp/v4fCdGDG+Vdrn8S0rWVpk8tU4q8R
         3Bdnv599182r6Pf5X4/qX5v2WesKF4JBqPk0M=
Date: Fri, 20 Jun 2008 15:56:40 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, Zhao Yakui <yakui.zhao@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] ACPI: don't walk tables if ACPI was disabled
Message-ID: <20080620135639.GA5073@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080620095247.GA24557@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Can you see if this patch solves your problem? There might be other
functions that needs this guard as well, though. I wonder if maybe this test
should just be included at the top of every driver that uses ACPI in some
way. But I'm pretty sure that this lack of initialization is the root of your
problem in any case :-)

(By the way, I don't know why this problem popped up at this time, maybe it
was just bad timing/bad luck... How far back do your AE_BAD_PARAMETER in the
logs go?)


Vegard


From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 20 Jun 2008 15:39:09 +0200
Subject: [PATCH] ACPI: don't walk tables if ACPI was disabled

Ingo Molnar wrote:
> -tip auto-testing started triggering this spinlock corruption message
> yesterday:
>
> [    3.976213] calling  acpi_rtc_init+0x0/0xd3
> [    3.980213] ACPI Exception (utmutex-0263): AE_BAD_PARAMETER, Thread F7C50000 could not acquire Mutex [3] [20080321]
> [    3.992213] BUG: spinlock bad magic on CPU#0, swapper/1
> [    3.992213]  lock: c2508dc4, .magic: 00000000, .owner: swapper/1, .owner_cpu: 0

This is apparently because some parts of ACPI, including mutexes, are not
initialized when acpi=off is passed to the kernel.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 drivers/acpi/glue.c               |    3 +++
 drivers/acpi/namespace/nsxfeval.c |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index 2808dc6..9b227d4 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -333,6 +333,9 @@ static int __init acpi_rtc_init(void)
 {
 	struct device *dev = get_rtc_dev();
 
+	if (acpi_disabled)
+		return 0;
+
 	if (dev) {
 		rtc_wake_setup();
 		rtc_info.wake_on = rtc_wake_on;
diff --git a/drivers/acpi/namespace/nsxfeval.c b/drivers/acpi/namespace/nsxfeval.c
index a8d5491..c274d1d 100644
--- a/drivers/acpi/namespace/nsxfeval.c
+++ b/drivers/acpi/namespace/nsxfeval.c
@@ -391,6 +391,9 @@ acpi_walk_namespace(acpi_object_type type,
 
 	ACPI_FUNCTION_TRACE(acpi_walk_namespace);
 
+	if (acpi_disabled)
+		return_ACPI_STATUS(AE_NO_NAMESPACE);
+
 	/* Parameter validation */
 
 	if ((type > ACPI_TYPE_LOCAL_MAX) || (!max_depth) || (!user_function)) {
-- 
1.5.4.1

