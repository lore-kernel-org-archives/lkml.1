Return-Path: <linux-kernel-owner+w=401wt.eu-S1755539AbYLKFDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbYLKFDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 00:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750867AbYLKFDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 00:03:41 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:11436 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbYLKFDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 00:03:40 -0500
X-IronPort-AV: E=Sophos;i="4.33,751,1220227200"; 
   d="scan'208";a="122530720"
From: Roland Dreier <rdreier@cisco.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nguyen Anh Quynh <aquynh@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Kuniyasu Suzaki <k.suzaki@aist.go.jp>
Subject: Re: [PATCH] fix calls to request_module()
References: <9cde8bff0812101935j5ef56140k67035d892a868738@mail.gmail.com>
	<20081211040118.GK28946@ZenIV.linux.org.uk>
	<20081210201455.0c611484.akpm@linux-foundation.org>
	<20081211044901.GL28946@ZenIV.linux.org.uk>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 10 Dec 2008 21:03:37 -0800
In-Reply-To: <20081211044901.GL28946@ZenIV.linux.org.uk> (Al Viro's message of
	"Thu, 11 Dec 2008 04:49:01 +0000")
Message-ID: <adatz9b2thy.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Dec 2008 05:03:37.0454 (UTC) FILETIME=[D36D60E0:01C95B4D]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I mean, I do not believe that any gcc version would start spewing warnings
 > of
 > 	printf("-- \n");
 > and its ilk...

No, I haven't seen gcc warn about anything that crazy (ie where it can
see the format string and prove it's safe).

I do see warnings from the Ubuntu gcc with code like:

#include <stdio.h>

extern char *a;

void foo()
{
	printf(a);
}

which produces

a.c: In function 'foo':
a.c:7: warning: format not a string literal and no format arguments


The kernel has such code eg in init/main.c, which does

	printk(linux_banner);

when linux_banner is only visible to the compiler as

extern const char linux_banner[];

however the trivial fix

diff --git a/init/main.c b/init/main.c
index 7e117a2..e471598 100644
--- a/init/main.c
+++ b/init/main.c
@@ -568,7 +568,7 @@ asmlinkage void __init start_kernel(void)
 	boot_cpu_init();
 	page_address_init();
 	printk(KERN_NOTICE);
-	printk(linux_banner);
+	printk("%s", linux_banner);
 	setup_arch(&command_line);
 	mm_init_owner(&init_mm, &init_task);
 	setup_command_line(command_line);

doesn't seem that appealing, since it bloats the object code for a
non-bug -- 7 bytes for me on x86_64:

add/remove: 0/0 grow/shrink: 1/0 up/down: 7/0 (7)
function                                     old     new   delta
start_kernel                                 680     687      +7

given the number of such warnings I see in a typical compile, this would
be a fairly hefty amount of bloat just to shut up gcc.

On the other hand, gcc warning on such code (untrusted format string
passed into a printf-like function) seems quite legitimate as well.

So I dunno.

 - Roland
