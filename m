Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbYHHKOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbYHHKOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 06:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbYHHKOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 06:14:05 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:25514 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225AbYHHKOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 06:14:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EAu/Dy0juvBzXVBO/URp7MhDWEtOXNiMNxhHnXrOv39oO4IaZt5M9BxYSJeWN/gnHb
         ZwLiSqAcqy9ydo3+vchdzIzBiQg3T82EmNfXhAC5akm7YUJdsDxHw8csJWcqMIy6kV8i
         qDZtWXTvuWwwpvTRvbpJT3ky/fJKpfGv0DrRU=
Message-ID: <a4423d670808080314weed9178o9f9ef52803a68501@mail.gmail.com>
Date: Fri, 8 Aug 2008 14:14:00 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: 2.6.26-rc: SPARC: Sun Ultra 10 can not boot
Cc: mikpe@it.uu.se, kernel-testers@vger.kernel.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080808.024024.205614839.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670807070859y74f529b5i60f04e0a37a01cd3@mail.gmail.com>
	 <20080807.230139.220174417.davem@davemloft.net>
	 <a4423d670808080231nc4d5e25q6636fe8ff090b84@mail.gmail.com>
	 <20080808.024024.205614839.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/8 David Miller <davem@davemloft.net>:
> From: "Alexander Beregalov" <a.beregalov@gmail.com>
> Date: Fri, 8 Aug 2008 13:31:40 +0400
>
>> 2008/8/8 David Miller <davem@davemloft.net>:
>> > From: "Alexander Beregalov" <a.beregalov@gmail.com>
>> > Date: Mon, 7 Jul 2008 19:59:04 +0400
>> >
>> >> I have turned off LOCKDEP and it boots properly.
>> >> 2.6.26-rc9-00005-g1b40a89
>> >>
>> >> Mikael's config also does not contain LOCKDEP.
>> >
>> > I have finally reproduced the problem locally and figured out the
>> > bug.
>> >
>> > Please try this patch:
>> >
>> Thanks David,  but 2.6.27-rc2-00166-gaeee90d hangs in the same way.
>
> That patch was for you to add on top of whatever tree you
> have handy.  Did you apply the patch?
>
> That patch will fix all trees.
>
Yes, I applied it manually on top of 2.6.27-rc2-0166

$git diff
diff --git a/arch/sparc64/kernel/stacktrace.c b/arch/sparc64/kernel/stacktrace.c
index b3e3737..c22a131 100644
--- a/arch/sparc64/kernel/stacktrace.c
+++ b/arch/sparc64/kernel/stacktrace.c
@@ -26,13 +26,15 @@ void save_stack_trace(struct stack_trace *trace)

                /* Bogus frame pointer? */
                if (fp < (thread_base + sizeof(struct thread_info)) ||
-                   fp >= (thread_base + THREAD_SIZE))
+                   fp > (thread_base + THREAD_SIZE - sizeof(struct
sparc_stackf)))
                        break;

                sf = (struct sparc_stackf *) fp;
                regs = (struct pt_regs *) (sf + 1);

-               if ((regs->magic & ~0x1ff) == PT_REGS_MAGIC) {
+               if (((unsigned long)regs <=
+                       (thread_base + THREAD_SIZE - sizeof(*regs))) &&
+                       (regs->magic & ~0x1ff) == PT_REGS_MAGIC) {
                        if (!(regs->tstate & TSTATE_PRIV))
                                break;
                        pc = regs->tpc;
