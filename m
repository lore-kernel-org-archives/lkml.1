Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbZFMEHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbZFMEHq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 00:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751044AbZFMEHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 00:07:37 -0400
Received: from mail-px0-f187.google.com ([209.85.216.187]:54886 "EHLO
	mail-px0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbZFMEHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 00:07:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sgwOWAe1TMMCDyk2sKaDRJFD93DiP1yOQGYGh/tkMKksakoRJxw8saw7R5nPAFURl9
         j7cur1hKK/yzpsgARyvWcvaY5ecC+3wI7g4MV2GVYbPJraD0O81tFtOajZ9ilq8OlQ6z
         74ETYKOCrzVK1MNNRQROS/P+J/0LWcTpMpE0M=
Date: Sat, 13 Jun 2009 12:09:58 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, Tao Ma <tao.ma@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: [Patch BUGFIX] kcore: fix its wrong size on x86_64
Message-ID: <20090613040958.GA2959@cr0>
References: <4A2A7F33.4030807@oracle.com> <4A2AEBE3.4000100@kernel.org> <20090608015242.GB2596@cr0.nay.redhat.com> <4A2CA96D.3090502@oracle.com> <2375c9f90906072341o2cded749m45bdddfdb499469@mail.gmail.com> <4A2CC52B.9010602@oracle.com> <2375c9f90906081743p77934f47n8ba1a018d333b95b@mail.gmail.com> <m1ab4i11zx.fsf@fess.ebiederm.org> <20090611050929.GA2706@cr0.nay.redhat.com> <m11vpqvozl.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11vpqvozl.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Fix wrong /proc/kcore size on x86_64.

x86_64 uses __va() macro to caculate the virtual address passed to kclist_add()
but decodes it with its own macro kc_vadd_to_offset(). This is wrong.

Also, according to Documentation/x86/x86_64/mm.txt, kc_vaddr_to_offset()
is wrong too.

So just remove them, use the generic macro.

BTW, the man page for /proc/kcore is wrong, its size can be more than
the physical memory size, because it also contains memory area of
vmalloc(), vsyscall etc...

Reported-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>

---
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
index abde308..cdbfd1d 100644
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -163,12 +163,6 @@ extern void cleanup_highmap(void);
 #define PAGE_AGP    PAGE_KERNEL_NOCACHE
 #define HAVE_PAGE_AGP 1
 
-/* fs/proc/kcore.c */
-#define	kc_vaddr_to_offset(v) ((v) & __VIRTUAL_MASK)
-#define	kc_offset_to_vaddr(o)				\
-	(((o) & (1UL << (__VIRTUAL_MASK_SHIFT - 1)))	\
-	 ? ((o) | ~__VIRTUAL_MASK)			\
-	 : (o))
 
 #define __HAVE_ARCH_PTE_SAME
 #endif /* !__ASSEMBLY__ */
