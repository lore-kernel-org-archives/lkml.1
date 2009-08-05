Return-Path: <linux-kernel-owner+w=401wt.eu-S933801AbZHEJBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933801AbZHEJBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 05:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932688AbZHEJBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 05:01:03 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34933 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442AbZHEJBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 05:01:01 -0400
Message-ID: <4A794A4E.2060802@np.css.fujitsu.com>
Date: Wed, 05 Aug 2009 18:01:02 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: "H.Peter Anvin" <hpa@zytor.com>, LKLM <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Huang Ying <ying.huang@intel.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH] x86, mce: cleanup initcall of debugfs for mce
References: <4A77CEAB.4030909@np.css.fujitsu.com> <4A77FCCC.7040608@linux.intel.com>
In-Reply-To: <4A77FCCC.7040608@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> Sorry but I think it's better to have an own initcall per file,
> that makes everything more self contained and easier to read.
> 
> -Andi
> 
Thank you for your comment.

That's OK, but this patch is also used for resolving compile error
without CONFIG_DEBUG_FS.  Then how about this patch?

Best regards,
Jin Dongming


===

[PATCH] x86,mce: Add ifdef for severities_debugfs_init()

This patch is made based on the v5 patches of Huangying for mce.
Before using this patch, please apply the patches of Huangying.
The patches' URLs of Huangying are listed as following:
1.x86: MCE: Support specifying context for software mce injection
  URL: http://marc.info/?l=linux-kernel&m=124900459100786&w=2
2.x86: MCE: Support specifying raise mode for software MCE injection
  URL: http://marc.info/?l=linux-kernel&m=124900459100795&w=2
3.x86: MCE: Move debugfs mce dir creating to mce.c
  URL: http://marc.info/?l=linux-kernel&m=124900459100790&w=2
4.x86: MCE: Fake panic support for MCE testing
  URL: http://marc.info/?l=linux-kernel&m=124900453800724&w=2

When the kernel is compiled without CONFIG_DEBUG_FS, compiler could
not find out mce_get_debugfs_dir() which is used by
severities_debugfs_init() and output the error message.

This version is based x86-tip/mce.

Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce-internal.h |    3 +++
 arch/x86/kernel/cpu/mcheck/mce-severity.c |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
index 32996f9..58b01d4 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -22,7 +22,10 @@ struct mce_bank {
 };
 
 int mce_severity(struct mce *a, int tolerant, char **msg);
+
+#ifdef CONFIG_DEBUG_FS
 struct dentry *mce_get_debugfs_dir(void);
+#endif
 
 extern int mce_ser;
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index bc35a07..8a85dd1 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -139,6 +139,7 @@ int mce_severity(struct mce *a, int tolerant, char **msg)
 	}
 }
 
+#ifdef CONFIG_DEBUG_FS
 static void *s_start(struct seq_file *f, loff_t *pos)
 {
 	if (*pos >= ARRAY_SIZE(severities))
@@ -212,3 +213,4 @@ err_out:
 	return -ENOMEM;
 }
 late_initcall(severities_debugfs_init);
+#endif
-- 
1.6.2.2

