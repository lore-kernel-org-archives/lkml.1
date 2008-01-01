Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbYAANLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbYAANLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 08:11:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbYAANK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 08:10:56 -0500
Received: from po-out-1718.google.com ([72.14.252.154]:41874 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbYAANKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 08:10:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=udN6VnSNWLOlWiBlzo0kJU86GL+gZ/ZtpS9j6RQoirtijOzmMueqfLwsnDwEZe6dZIyxvYgUPZXgi/naEmPxIz1MquDQQISiNT3zCnQffu651uxAiFT6/1W/DyyJqbYKNOyTRriNaupCAJRnC7n2JkZFd6ghsw69q0+cs96Z1RQ=
Date: Tue, 1 Jan 2008 21:11:02 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-mips@linux-mips.org
Subject: (Try #2) [Patch 2/8] MIPS: Remove 'TOPDIR' from Makefiles
Message-ID: <20080101131102.GB2499@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080101071311.GA2496@hacking> <20080101072238.GC2496@hacking> <20080101101540.GB28913@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101101540.GB28913@uranus.ravnborg.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> -KERNEL_IMAGE = $(TOPDIR)/vmlinux
>> +KERNEL_IMAGE = $(objtree)/vmlinux
>
>Current directory when building is $(objtree) so here we should
>just skip the use of TOPDIR like this:
>> +KERNEL_IMAGE = vmlinux
>
>
>>  KERNEL_START = $(shell $(NM) $(KERNEL_IMAGE) | grep " _text" | cut -f1 -d\ )
>>  KERNEL_ENTRY = $(shell $(NM) $(KERNEL_IMAGE) | grep kernel_entry | cut -f1 -d\ )
>>  
>> @@ -24,7 +24,7 @@ HEAD_DEFINES := -D_kernel_start=0x$(KERNEL_START) \
>>  		-D TIMESTAMP=$(shell date +%s)
>>  
>>  $(obj)/head.o: $(obj)/head.S $(KERNEL_IMAGE)
>> -	$(CC) -fno-pic $(HEAD_DEFINES) -I$(TOPDIR)/include -c -o $@ $<
>> +	$(CC) -fno-pic $(HEAD_DEFINES) -I$(objtree)/include -c -o $@ $<
>This has never worked with O=.. builds.
>The correct fix here is to use:
>> +	$(CC) -fno-pic $(HEAD_DEFINES) -Iinclude -Iinclude2 -c -o $@ $<
>
>The -Iinclude2 is only for O=... builds so to keep current
>behaviour removing $(TOPDIR)/ would do it.

Thank you for your explanations!

The following one corrects all the mistakes as you told.

------->

Since TOPDIR is obsolete, this patch removes TOPDIR
from the Mips Makefiles.

Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

diff --git a/arch/mips/lasat/image/Makefile b/arch/mips/lasat/image/Makefile
index 5332449..1ae73ce 100644
--- a/arch/mips/lasat/image/Makefile
+++ b/arch/mips/lasat/image/Makefile
@@ -12,7 +12,7 @@ endif
 
 MKLASATIMG = mklasatimg
 MKLASATIMG_ARCH = mq2,mqpro,sp100,sp200
-KERNEL_IMAGE = $(TOPDIR)/vmlinux
+KERNEL_IMAGE = vmlinux
 KERNEL_START = $(shell $(NM) $(KERNEL_IMAGE) | grep " _text" | cut -f1 -d\ )
 KERNEL_ENTRY = $(shell $(NM) $(KERNEL_IMAGE) | grep kernel_entry | cut -f1 -d\ )
 
@@ -24,7 +24,7 @@ HEAD_DEFINES := -D_kernel_start=0x$(KERNEL_START) \
 		-D TIMESTAMP=$(shell date +%s)
 
 $(obj)/head.o: $(obj)/head.S $(KERNEL_IMAGE)
-	$(CC) -fno-pic $(HEAD_DEFINES) -I$(TOPDIR)/include -c -o $@ $<
+	$(CC) -fno-pic $(HEAD_DEFINES) -Iinclude -Iinclude2 -c -o $@ $<
 
 OBJECTS = head.o kImage.o
 
