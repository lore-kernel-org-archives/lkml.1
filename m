Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbZFVIwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbZFVIwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 04:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755964AbZFVIwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 04:52:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:58469 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957AbZFVIwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 04:52:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WB3sH4wQhMB/y4RHyN3g7tXDKGgSLRkAxwJelm6E1YcNeAEfHaXSGGCjJTdK7WYnFd
         5+2jwvIaYbdVVIE/uhjzCf8t5cbg9SP7d8TJP+ysV/COcFRIc0EqYjH9eqmBTy1m783Z
         tBx5kZMqQ1dnb8iLg+vKP7CdRoZZmdAneYKCE=
Date: Mon, 22 Jun 2009 16:54:05 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, Tao Ma <tao.ma@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alexey Dobriyan <adobriyan@gmail.com>, mtk.manpages@gmail.com
Subject: [Patch] kcore: remove its pointless size
Message-ID: <20090622085405.GA6499@cr0.nay.redhat.com>
References: <20090611050929.GA2706@cr0.nay.redhat.com> <m11vpqvozl.fsf@fess.ebiederm.org> <20090613040958.GA2959@cr0> <m17hzdhkr8.fsf@fess.ebiederm.org> <2375c9f90906160829g3d605836yb4c5b9beeac50c5f@mail.gmail.com> <m1my88568n.fsf@fess.ebiederm.org> <20090618030051.GA6133@cr0.nay.redhat.com> <m1tz2ei54r.fsf@fess.ebiederm.org> <20090618044055.GB6133@cr0.nay.redhat.com> <m1prd2rtdf.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1prd2rtdf.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 10:41:32PM -0700, Eric W. Biederman wrote:
>Amerigo Wang <xiyou.wangcong@gmail.com> writes:
>>
>> Of course I knew this.
>>
>> Just read the code:
>>
>>      phdr->p_offset = kc_vaddr_to_offset(m->addr) + dataoff;
>>
>> So it should be 0, 'dataoff' is there...
>
>Sorry.  The naming then is horrible.  It is really
>kc_vaddr_to_something_like_the_offset.
>
>I still don't see the need for a flat offset space.
>
>I can see a real point of only having a single kc_vaddr_to_offset
>function.  Instead of the 3 in existence.
>
>No point in cluttering the whole world with the oddities of the kcore
>code.  Especially when it should get cleaned up.
>
>My real point earlier is that kc_vaddr_to_offset and
>kc_offset_to_vaddr actually on x86_64 aren't broken.  They are just
>peculiar.  There is some small point to their oddities, in that if
>something is in the upper half of the address space (like xen) but
>below PAGE_OFFSET you have a chance of accessing it with /proc/kcore.
>But that is a very minor benefit.

It looks like that Linus fixes this in commit 9063c61fd5cbd.

So I will only fix the rest.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: mtk.manpages@gmail.com

---
diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 59b43a0..eca5201 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -405,9 +405,6 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
 static int __init proc_kcore_init(void)
 {
 	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL, &proc_kcore_operations);
-	if (proc_root_kcore)
-		proc_root_kcore->size =
-				(size_t)high_memory - PAGE_OFFSET + PAGE_SIZE;
 	return 0;
 }
 module_init(proc_kcore_init);

---
diff --git a/man5/proc.5 b/man5/proc.5
index ed47f70..e31aae4 100644
--- a/man5/proc.5
+++ b/man5/proc.5
@@ -1246,8 +1246,6 @@ kernel
 binary, GDB can be used to
 examine the current state of any kernel data structures.
 
-The total length of the file is the size of physical memory (RAM) plus
-4KB.
 .TP
 .I /proc/kmsg
 This file can be used instead of the
