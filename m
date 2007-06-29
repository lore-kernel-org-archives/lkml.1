Return-Path: <linux-kernel-owner+w=401wt.eu-S933466AbXF2PpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933466AbXF2PpJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 11:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757769AbXF2Po5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 11:44:57 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:29933 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757733AbXF2Po4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 11:44:56 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jun 2007 11:44:56 EDT
X-YMail-OSG: HoRzGMkVM1kX_.oyKm_IbQ6bhtX9LnQBlLmJ7fsg7xBtBTsvdawuva_udKvF4ztlpFPDsek5hA--
Date: Fri, 29 Jun 2007 08:38:15 -0700
From: "H. J. Lu" <hjl@lucon.org>
To: joerg.roedel@amd.com
Cc: linux kernel <linux-kernel@vger.kernel.org>
Subject: PATCH: Fix SVM MSR indexes for 32bit kernel
Message-ID: <20070629153815.GA18297@lucon.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

MSR index is 32bit not 64bit. All other MSR indexes are defined
without the ULL suffix. Otherwise, you will get

[hjl@gnu-5 tmp]$ cat foo.c
typedef unsigned long long u64;

int is_disabled(void)
{
 u64 vm_cr;

 do { unsigned long l__,h__; __asm__ __volatile__("rdmsr" : "=a" (l__),
"=d" (h__) : "c" (0xc0010114ULL)); vm_cr = l__; vm_cr |=
((u64)h__<<32); } while(0);
 if (vm_cr & (1 << 4))
  return 1;

 return 0;
}
[hjl@gnu-5 tmp]$ gcc -m32 -S foo.c
foo.c: In function â_disabledâfoo.c:7: error: impossible register
constraint in âmâoo.c:12: confused by earlier errors, bailing out
[hjl@gnu-5 tmp]$

on 32bit. This patch removes the ULL suffix in SVM MSR indexes.


H.J.
--- linux-2.6.21.i686/drivers/kvm/svm.h.msr	2007-06-28 22:42:12.000000000 -0700
+++ linux-2.6.21.i686/drivers/kvm/svm.h	2007-06-29 08:03:09.000000000 -0700
@@ -175,8 +175,8 @@ struct __attribute__ ((__packed__)) vmcb
 #define SVM_CPUID_FUNC 0x8000000a
 
 #define MSR_EFER_SVME_MASK (1ULL << 12)
-#define MSR_VM_CR       0xc0010114ULL
-#define MSR_VM_HSAVE_PA 0xc0010117ULL
+#define MSR_VM_CR       0xc0010114
+#define MSR_VM_HSAVE_PA 0xc0010117
 
 #define SVM_VM_CR_SVM_DISABLE 4
 
