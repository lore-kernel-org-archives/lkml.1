Return-Path: <linux-kernel-owner+w=401wt.eu-S1759847AbZGIF5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759847AbZGIF5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 01:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbZGIF4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 01:56:51 -0400
Received: from mail-px0-f193.google.com ([209.85.216.193]:55025 "EHLO
	mail-px0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbZGIF4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 01:56:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=s63IGvrKDJWewm40MvbE6wyxleaUGA9r5G2hXMg6PLihfABj9a9Aw92ywDa0nXYaAg
         gbHKRIhygsjItJqJ0o3oxM30iQL/jcK2MTUZCEA3zFVyLFaEYA73iycDb7TQAxEiaAQL
         Z1RxMUtjYN2PCSBSfc3yr76egPG8xK4ps2b48=
Date: Thu, 9 Jul 2009 13:58:55 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       teawater@gmail.com, mingo@elte.hu, tj@kernel.org
Subject: Re: [PATCH] elfcore.h : Fix UML build breakage
Message-ID: <20090709055855.GB5648@cr0.nay.redhat.com>
References: <alpine.DEB.2.00.0907072226140.24195@parag-desktop> <20090708043036.GA5917@cr0.nay.redhat.com> <alpine.DEB.2.00.0907081141500.4155@parag-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.00.0907081141500.4155@parag-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 11:46:02AM -0400, Parag Warudkar wrote:
>
>
>On Wed, 8 Jul 2009, Amerigo Wang wrote:
>
>> On Tue, Jul 07, 2009 at 10:41:50PM -0400, Parag Warudkar wrote:
>> >Commit a65e7bfcd74e4c0939f235d2bf9f48ddb3a57991 breaks UML build with 
>> >below error - 
>> >
>> >In file included from fs/proc/kcore.c:17:
>> >include/linux/elfcore.h: In function ‘elf_core_copy_task_regs’:
>> >include/linux/elfcore.h:129: error: implicit declaration of function 
>> >‘task_pt_regs’
>> >
>> >Fix this by restoring the previous behavior of returning 0 for all arches 
>> >like UML that don't define task_pt_regs.
>
>> #elif defined doesn't match #ifdef well, how about:
>> 
>> #if defined (ELF_CORE_COPY_TASK_REGS)
>> ...
>> #elif defined (task_pt_regs)
>> ...
>> #endif
>
>Updated patch below -
>
>Fix UML build breakage due to commit 
>a65e7bfcd74e4c0939f235d2bf9f48ddb3a57991.
>
>Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>
>


ACK. Thank you!

It looks like Linus already merged this...


>diff --git a/include/linux/elfcore.h b/include/linux/elfcore.h
>index 03ec167..00d6a68 100644
>--- a/include/linux/elfcore.h
>+++ b/include/linux/elfcore.h
>@@ -122,10 +122,9 @@ static inline void elf_core_copy_kernel_regs(elf_gregset_t *elfregs, struct pt_r
> 
> static inline int elf_core_copy_task_regs(struct task_struct *t, elf_gregset_t* elfregs)
> {
>-#ifdef ELF_CORE_COPY_TASK_REGS
>-	
>+#if defined (ELF_CORE_COPY_TASK_REGS)
> 	return ELF_CORE_COPY_TASK_REGS(t, elfregs);
>-#else
>+#elif defined (task_pt_regs)
> 	elf_core_copy_regs(elfregs, task_pt_regs(t));
> #endif
> 	return 0;
