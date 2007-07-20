Return-Path: <linux-kernel-owner+w=401wt.eu-S934894AbXGTQyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934894AbXGTQyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938607AbXGTQs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:48:58 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:43562 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932397AbXGTQsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:48:54 -0400
Date: Fri, 20 Jul 2007 10:48:50 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Andi Kleen <ak@novell.com>,
       Arthur Jones <arthur.jones@qlogic.com>,
       Vasily Tarasov <vtaras@openvz.org>, linux-kernel@vger.kernel.org,
       Jan Kara <jack@ucw.cz>, linux-arch@vger.kernel.org
Subject: Re: build fix for x86_64...
Message-ID: <20070720164850.GE14791@parisc-linux.org>
References: <20070720085501.82715036.randy.dunlap@oracle.com> <617E1C2C70743745A92448908E030B2A01FA46A9@scsmsx411.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <617E1C2C70743745A92448908E030B2A01FA46A9@scsmsx411.amr.corp.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 09:20:15AM -0700, Luck, Tony wrote:
> Which is better.  But if we unconditionally set this CONFIG variable, then the
> code in fs/quota.c will have to read:
> 
> #if defined(CONFIG_COMPAT) && defined(CONFIG_COMPAT_FOR_U64_ALIGNMENT)
> 
> We can keep it simpler if the Kconfig file does the conditional for us:
> 
> config COMPAT_FOR_U64_ALIGNMENT
> 	def_bool y
> 	depends on COMPAT

Ah, but you can do better:

config COMPAT_FOR_U64_ALIGNMENT
	def_bool COMPAT

I hand-edited your patch:

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 36c7b96..36c1582 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -425,6 +425,9 @@ config COMPAT
 	depends on IA32_SUPPORT
 	default y
 
+config COMPAT_FOR_U64_ALIGNMENT
+	def_bool COMPAT
+
 config IA64_MCA_RECOVERY
 	tristate "MCA recovery from errors other than TLB."
 
diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
index 14bf8ce..c77510b 100644
--- a/arch/x86_64/Kconfig
+++ b/arch/x86_64/Kconfig
@@ -753,6 +753,9 @@ config COMPAT
 	depends on IA32_EMULATION
 	default y
 
+config COMPAT_FOR_U64_ALIGNMENT
+	def_bool COMPAT
+
 config SYSVIPC_COMPAT
 	bool
 	depends on COMPAT && SYSVIPC
diff --git a/fs/quota.c b/fs/quota.c
index e6577ac..99b24b5 100644
--- a/fs/quota.c
+++ b/fs/quota.c
@@ -387,7 +387,7 @@ asmlinkage long sys_quotactl(unsigned int cmd, const char __user *special, qid_t
 	return ret;
 }
 
-#if defined(CONFIG_X86_64) || defined(CONFIG_IA64)
+#if defined(CONFIG_COMPAT_FOR_U64_ALIGNMENT)
 /*
  * This code works only for 32 bit quota tools over 64 bit OS (x86_64, ia64)
  * and is necessary due to alignment problems.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
