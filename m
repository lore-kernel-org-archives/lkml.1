Return-Path: <linux-kernel-owner+w=401wt.eu-S1757781AbYHCOWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781AbYHCOWr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 10:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755591AbYHCOWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 10:22:39 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:40144 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436AbYHCOWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 10:22:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ViPMHGm/JtimwNkbSdAMXp/wLAL9JCF2kCVJ6IgRX3OeOFLQ696l2QVFdf/uycATdn
         aLPswyv5AAVge6ivYRMmuCNhf1YqVxpQhRilLEZ0fGghbJ0o2jL+4zjwpL+E5v0elp49
         E0mHvsPlwAgkdchFl5BMqznSlCIWK0/LmIJ88=
Date: Sun, 3 Aug 2008 18:22:51 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       "H. Peter Anvin" <hpa@zytor.com>, Alexander Viro <aviro@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] init: introduce boot param alias
Message-ID: <20080803142251.GA16487@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By introducing the macroses __setup_alias and early_param_alias
we are allowed to use boot param aliases.

Here is an example:

static int __init parse_func(char *arg)
{
	/* set some flag or do something */
	return 0;
}
early_param("param1", parse_func);
early_param_alias("param1-alias", parse_func);

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

I found it usefull while was looking for APIC code merging.
Please review! Any comments are _quite_welcome_!!!

I use __LINE__ macro to define salt for names. Not sure
if this is really that good way to produce unique names.
But anyway i think it's better then define different functions
with same functionallity.

I'm on really slow GPRS connection now and can't reply fast so
forgive me for that :)

Index: linux-2.6.git/include/linux/init.h
===================================================================
--- linux-2.6.git.orig/include/linux/init.h	2008-08-03 17:32:25.000000000 +0400
+++ linux-2.6.git/include/linux/init.h	2008-08-03 18:02:48.000000000 +0400
@@ -247,6 +247,25 @@ struct obs_kernel_param {
 #define early_param(str, fn)					\
 	__setup_param(str, fn, fn, 1)
 
+/*
+ * Sometimes we need to define boot parameter alias
+ * ie different boot options with the same functionality
+ * so we could use one parsing function for all of them
+ * NOTE: these macroses _MUST_ be placed on different lines
+ */
+#define __setup_param_alias(str, unique_id, salt, fn, early)		\
+	static char __setup_str_##unique_id##salt[] __initdata __aligned(1) = str; \
+	static struct obs_kernel_param __setup_##unique_id##salt	\
+		__used __section(.init.setup)				\
+		__attribute__((aligned((sizeof(long)))))		\
+		= { __setup_str_##unique_id##salt, fn, early }
+
+#define __setup_alias(str, fn)				\
+	__setup_param_alias(str, fn, __LINE__, fn, 0)
+
+#define early_param_alias(str, fn)			\
+	__setup_param_alias(str, fn, __LINE__, fn, 1)
+
 /* Relies on boot_command_line being set */
 void __init parse_early_param(void);
 #endif /* __ASSEMBLY__ */
