Return-Path: <linux-kernel-owner+w=401wt.eu-S1752502AbXIYIvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbXIYIvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 04:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbXIYIv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 04:51:29 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:50291 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbXIYIv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 04:51:27 -0400
Message-Id: <46F8CBD4.5000900@mxs.nes.nec.co.jp>
Date: Tue, 25 Sep 2007 17:50:28 +0900
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Satyam Sharma <satyam@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>,
       kexec-ml <kexec@lists.infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 6/4] [-mm patch] use the existing offsetof().
References: <46E9F6A9.8060500@mxs.nes.nec.co.jp> <46E9F942.5070007@mxs.nes.nec.co.jp> <20070914190350.011cdadb.akpm@linux-foundation.org> <46F204FD.6040303@mxs.nes.nec.co.jp> <46F205DB.70209@mxs.nes.nec.co.jp> <alpine.LFD.0.999.0709201752310.17093@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0709201752310.17093@enigma.security.iitk.ac.in>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Satyam,

Satyam Sharma wrote:
> > BTW I don't think these macros are such a big win in readability or
> > code clarity anyway. And I noticed that there are still some open
> > calls to vmcoreinfo_append_str() in kexec.c (such as for the OS_RELEASE
> > case) which you haven't macro-ized ... we end up having code that looks
> > like:
> > 
> > 	vmcoreinfo_append_str(...);
> > 	...
> > 
> > 	...
> > 	VMCOREINFO_OFFSET(...);
> > 	...
> > 
> > and it's not even obvious (unless you follow on to the definition of the
> > later macro) that the above two are *exactly* the same. So you could also
> > consider just losing the macros altogether.

I want to use these macros for calls to vmcoreinfo_append_str(), because
the strings included in each macro ("SIZE(XXX)=", "OFFSET(XXX)=", etc.)
are very important. makedumpfile command reads these strings and gets the
debugging information (structure sizes, field offsets, etc.). If losing
these macros and there is a typo like "OFESET(page.mapping)=", the command
cannot run. To prevent this mistake, these macros are very useful.

For more readability, I think it is good that all the calls are changed
to macros having a prefix "VMCOREINFO_" like the attached patch.


Thanks
Ken'ichi Ohmichi 

---
Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>

---
diff -rpuN a/include/linux/kexec.h b/include/linux/kexec.h
--- a/include/linux/kexec.h	2007-09-21 09:28:23.000000000 +0900
+++ b/include/linux/kexec.h	2007-09-21 10:26:24.000000000 +0900
@@ -127,6 +127,10 @@ void vmcoreinfo_append_str(const char *f
 	__attribute__ ((format (printf, 1, 2)));
 unsigned long paddr_vmcoreinfo_note(void);
 
+#define VMCOREINFO_OSRELEASE(name) \
+	vmcoreinfo_append_str("OSRELEASE=%s\n", #name)
+#define VMCOREINFO_PAGESIZE(value) \
+	vmcoreinfo_append_str("PAGESIZE=%ld\n", value)
 #define VMCOREINFO_SYMBOL(name) \
 	vmcoreinfo_append_str("SYMBOL(%s)=%lx\n", #name, (unsigned long)&name)
 #define VMCOREINFO_SIZE(name) \
@@ -134,8 +138,8 @@ unsigned long paddr_vmcoreinfo_note(void
 #define VMCOREINFO_STRUCT_SIZE(name) \
 	vmcoreinfo_append_str("SIZE(%s)=%zu\n", #name, sizeof(struct name))
 #define VMCOREINFO_OFFSET(name, field) \
-	vmcoreinfo_append_str("OFFSET(%s.%s)=%lu\n", #name, #field, \
-			      (unsigned long)&(((struct name *)0)->field))
+	vmcoreinfo_append_str("OFFSET(%s.%s)=%zu\n", #name, #field, \
+			      offsetof(struct name, field))
 #define VMCOREINFO_LENGTH(name, value) \
 	vmcoreinfo_append_str("LENGTH(%s)=%lu\n", #name, (unsigned long)value)
 #define VMCOREINFO_NUMBER(name) \
diff -rpuN a/kernel/kexec.c b/kernel/kexec.c
--- a/kernel/kexec.c	2007-09-21 09:28:22.000000000 +0900
+++ b/kernel/kexec.c	2007-09-21 10:17:56.000000000 +0900
@@ -1195,8 +1195,8 @@ unsigned long __attribute__ ((weak)) pad
 
 static int __init crash_save_vmcoreinfo_init(void)
 {
-	vmcoreinfo_append_str("OSRELEASE=%s\n", init_uts_ns.name.release);
-	vmcoreinfo_append_str("PAGESIZE=%ld\n", PAGE_SIZE);
+	VMCOREINFO_OSRELEASE(init_uts_ns.name.release);
+	VMCOREINFO_PAGESIZE(PAGE_SIZE);
 
 	VMCOREINFO_SYMBOL(init_uts_ns);
 	VMCOREINFO_SYMBOL(node_online_map);
_

