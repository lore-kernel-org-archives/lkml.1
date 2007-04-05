Return-Path: <linux-kernel-owner+w=401wt.eu-S1767392AbXDEWvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767392AbXDEWvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 18:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767399AbXDEWvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 18:51:45 -0400
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:59572 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767392AbXDEWvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 18:51:44 -0400
Date: Fri, 6 Apr 2007 00:51:41 +0200
From: Andreas Herrmann <aherrman@arcor.de>
To: Andi Kleen <ak@suse.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, andreas.herrmann3@amd.com
Subject: [PATCH RFC] x86: clear X86_FEATURE_MWAIT for AMD Fam10 CPU
Message-ID: <20070405225141.GA9112@tweety.malo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I send this as RFC because I won't manage it to test it
before end of Easter but want to have a consensus about
how the final patch should look like.

Andi,
what do you finally prefer?

(1) Something like the attached patch or
(2) a version which keeps to the MWAIT flag for Fam10 but
    introduces an X86_FEATURE_MWAIT_DOESNT_SAVE_POWER as you
    suggested.

An idle=mwait kernel parameter could (and should) be introduced
with both alternatives.

Meanwhile I think it would suffice to do (1) and issue another
cpuid if idle=mwait was used to select mwait_idle.


Regards,

Andreas

--


diff --git a/arch/i386/kernel/cpu/amd.c b/arch/i386/kernel/cpu/amd.c
index 2d47db4..4e01262 100644
--- a/arch/i386/kernel/cpu/amd.c
+++ b/arch/i386/kernel/cpu/amd.c
@@ -228,6 +228,9 @@ #define CBAR_KEY	(0X000000CB)
 	}
 
 	switch (c->x86) {
+	case 16:
+		clear_bit(X86_FEATURE_MWAIT, c->x86_capability);
+		break;
 	case 15:
 		set_bit(X86_FEATURE_K8, c->x86_capability);
 		break;
diff --git a/arch/x86_64/kernel/setup.c b/arch/x86_64/kernel/setup.c
index 3d98b69..f53ee6c 100644
--- a/arch/x86_64/kernel/setup.c
+++ b/arch/x86_64/kernel/setup.c
@@ -583,6 +583,10 @@ #endif
 	if (c->x86 == 15 && ((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58))
 		set_bit(X86_FEATURE_REP_GOOD, &c->x86_capability);
 
+	/* disable use of mwait on idle */
+	if (c->x86 == 16)
+		clear_bit(X86_FEATURE_MWAIT, c->x86_capability);
+
 	/* Enable workaround for FXSAVE leak */
 	if (c->x86 >= 6)
 		set_bit(X86_FEATURE_FXSAVE_LEAK, &c->x86_capability);

