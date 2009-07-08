Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbZGHE2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbZGHE2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 00:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750717AbZGHE2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 00:28:40 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:46685 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbZGHE2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 00:28:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=BeWtER1GWCWuyOmdS8ve6dyxskMd+RCdorFE/fcQ3sjcjwFYACuw2y5NZWDqfjskIo
         06yUfZ4H0grHud3DNvE8Ga2bsIxDb5IAEhH/eUjjh3EDc3l6MyFo6BtdPD4Bk/SzZgCD
         k3/cVpyBuDnUwQke1fc6Yw3zfKjujAFGk6DY0=
Date: Wed, 8 Jul 2009 12:30:36 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, teawater@gmail.com, mingo@elte.hu,
       tj@kernel.org, xiyou.wangcong@gmail.com
Subject: Re: [PATCH] elfcore.h : Fix UML build breakage
Message-ID: <20090708043036.GA5917@cr0.nay.redhat.com>
References: <alpine.DEB.2.00.0907072226140.24195@parag-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.00.0907072226140.24195@parag-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 10:41:50PM -0400, Parag Warudkar wrote:
>Commit a65e7bfcd74e4c0939f235d2bf9f48ddb3a57991 breaks UML build with 
>below error - 
>
>In file included from fs/proc/kcore.c:17:
>include/linux/elfcore.h: In function ‘elf_core_copy_task_regs’:
>include/linux/elfcore.h:129: error: implicit declaration of function 
>‘task_pt_regs’
>
>Fix this by restoring the previous behavior of returning 0 for all arches 
>like UML that don't define task_pt_regs.

Good catch!

>
>Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>
>
>diff --git a/include/linux/elfcore.h b/include/linux/elfcore.h
>index 03ec167..28f722e 100644
>--- a/include/linux/elfcore.h
>+++ b/include/linux/elfcore.h
>@@ -125,7 +125,7 @@ static inline int elf_core_copy_task_regs(struct task_struct *t, elf_gregset_t*
> #ifdef ELF_CORE_COPY_TASK_REGS
> 	
> 	return ELF_CORE_COPY_TASK_REGS(t, elfregs);
>-#else
>+#elif defined task_pt_regs
> 	elf_core_copy_regs(elfregs, task_pt_regs(t));
> #endif
> 	return 0;

#elif defined doesn't match #ifdef well, how about:

#if defined (ELF_CORE_COPY_TASK_REGS)
...
#elif defined (task_pt_regs)
...
#endif

?

Thank you.
