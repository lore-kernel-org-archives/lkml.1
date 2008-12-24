Return-Path: <linux-kernel-owner+w=401wt.eu-S1752520AbYLXBHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbYLXBHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 20:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYLXBHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 20:07:45 -0500
Received: from smtp-out.google.com ([216.239.45.13]:30712 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbYLXBHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 20:07:45 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=bFVDbZZWWa5dgRQoyYTBCmcjRxA7ZVrxU47WV6bevSxGpjDsYu8oMCvuQc4+5dV+6
	PJE6lalxCCLVFnnbAzbPQ==
MIME-Version: 1.0
In-Reply-To: <b040c32a0812231546s70cf651la19aec03fb9a308c@mail.gmail.com>
References: <86802c440812231328oa5e9682q9ad70a96680463b2@mail.gmail.com>
	 <20081223213630.GA5053@elte.hu>
	 <b040c32a0812231546s70cf651la19aec03fb9a308c@mail.gmail.com>
Date: Tue, 23 Dec 2008 17:07:40 -0800
Message-ID: <b040c32a0812231707w7a1704c5y169b659a394ba2a7@mail.gmail.com>
Subject: Re: panic with tg_shares_up again?
From: Ken Chen <kenchen@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.24.198.69
X-GMailtapped: kenchen
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2008 at 3:46 PM, Ken Chen <kenchen@google.com> wrote:
> And from my local build of linux-tip with the patch, I have the
> following assembly:
>     1  ffffffff8023b74f:  48 8b 88 a8 00 00 00    mov    0xa8(%rax),%rcx
>     2  ffffffff8023b756:  48 c7 45 d0 00 00 00    movq   $0x0,-0x30(%rbp)
>     3  ffffffff8023b75d:  00
>     4  ffffffff8023b75e:  48 85 c9                test   %rcx,%rcx
>     5  ffffffff8023b761:  0f 95 c0                setne  %al
>     6  ffffffff8023b764:  84 45 af                test   %al,-0x51(%rbp)
>     7  ffffffff8023b767:  74 15                   je     ffffffff8023b77e
>     8  ffffffff8023b769:  48 8b 45 b8             mov    -0x48(%rbp),%rax
>     9  ffffffff8023b76d:  31 d2                   xor    %edx,%edx
>    10  ffffffff8023b76f:  48 0f af c1             imul   %rcx,%rax
>    11  ffffffff8023b773:  48 f7 75 b0             divq   -0x50(%rbp)
>
> line 6 is the compare against sd_rq_weight, but it was only to one
> byte instead of the entire unsigned long.
>
> /me scratching my head ....

After a couple of hours joggling with type cast and different order in
which these two variables are checked, the compiler I'm using seems to
insist only check one byte out of sd_rq_weight.  I give up for the day
and removed the 'static' function declaration of
update_group_shares_cpu().  Without the 'static', the assembly looks
alright to me.

I will ask compiler expert to see what's wrong with this code.  For
now, the following add on patch seems generate correct x86 assembly
code.

on top of git commit d71f5a7c8bf9cd7c74159a53e522e363f2eddaf5

diff --git a/kernel/sched.c b/kernel/sched.c
index 413f16f..7f6b801 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1494,7 +1494,7 @@
 /*
  * Calculate and set the cpu's group shares.
  */
-static void
+void
 update_group_shares_cpu(struct task_group *tg, int cpu, unsigned long boost,
 			unsigned long sd_shares, unsigned long sd_rq_weight)
 {
