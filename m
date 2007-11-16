Return-Path: <linux-kernel-owner+w=401wt.eu-S1756397AbXKPC2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbXKPC2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 21:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932319AbXKPC15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 21:27:57 -0500
Received: from ro-out-1112.google.com ([72.14.202.179]:50283 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765788AbXKPC1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 21:27:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=mNY2rif3i9+2HOrblf52QRPBqRAQ2Z+tuej5J+z5hf++U4HrkjmYJocKzwsKTlmQmEkyFI2KIRMRE7dqqXvS2RRCyaGBvFgbAgzcvbJYB5w8OYEoPbinNk3lyCLMpt6ZKT9FFsZVQMiFGS2GMrWtlBweFeQko2NosD0MSdDA3nw=
Date: Fri, 16 Nov 2007 10:25:47 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [Patch] kernel/exit.c: Fix use-before-check in exit_mm()
Message-ID: <20071116022546.GA2563@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <9a8748490711111540q10503eday7f06b3e72b20fe82@mail.gmail.com> <4738F442.3040905@goop.org> <9a8748490711151634t6d8cfb5tf8c3953c74a6b9a3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a8748490711151634t6d8cfb5tf8c3953c74a6b9a3@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 01:34:54AM +0100, Jesper Juhl wrote:
>On 13/11/2007, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>> Jesper Juhl wrote:
>> > In kernel/exit.c we have this code :
>> >
>> > static void exit_mm(struct task_struct * tsk)
>> > {
>> >         struct mm_struct *mm = tsk->mm;
>> >
>> >         mm_release(tsk, mm);
>> >         if (!mm)
>> >                 return;
>> > ...
>> >
>> >
>> > But, mm_release() may dereference it's second argument ('mm'), so
>> > shouldn't we be doing the "!mm" test *before* we call mm_release() and
>> > not after?
>> > I don't know the mm code well enough to be able to tell if some of the
>> > other stuff mm_release does needs to be done always and the mm
>> > dereference can't actually happen, but maybe someone else who knows
>> > the code better can tell...  In any case, what's currently there looks
>> > a little shaky..
>> >
>>
>> Yeah, it looks wrong.  mm_release() calls deactivate_mm() as its first
>> act, which could well dereference mm (though it often doesn't).
>>
>So, whould simply moving the !mm check up as the first in the function
>be an appropriate way to deal with this?

I think yes. Patch below.

Fix use-before-check in kernel/exit.c

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

diff --git a/kernel/exit.c b/kernel/exit.c
index cd0f1d4..dca1e0d 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -558,9 +558,9 @@ static void exit_mm(struct task_struct * tsk)
 {
 	struct mm_struct *mm = tsk->mm;
 
-	mm_release(tsk, mm);
 	if (!mm)
 		return;
+	mm_release(tsk, mm);
 	/*
 	 * Serialize with any possible pending coredump.
 	 * We must hold mmap_sem around checking core_waiters
