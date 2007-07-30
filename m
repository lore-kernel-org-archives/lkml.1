Return-Path: <linux-kernel-owner+w=401wt.eu-S937024AbXG3LzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937024AbXG3LzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 07:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758355AbXG3LzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 07:55:00 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:20596 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509AbXG3Ly7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 07:54:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=cvhSHjb/6dUdAI065Vw2bo7AB5EVFkD1ggR8IFbsz/9s5b6erPr+t9Mn9La1L9+3C/+NLuo0qnpYbjoT3vIPfoDKgyOISZDCtaE4PRBbyEbIt+TjppNfoXDDMeQFQpixKRhbZBzpfHc+pi69T1Gezx2poR+S6An8YdzYyXzaqEI=
Message-ID: <6a1c323c0707300454yaf6eebfye9c5aaa3d4fe3723@mail.gmail.com>
Date: Mon, 30 Jul 2007 07:54:58 -0400
From: RG <cryptococa@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Question regarding process' final mmdrop
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
   I've been reading through the kernel source code trying to figure
out when the final mmdrop() after a exit_mm() is called on a task that
is having its virtual address deleted. I have discovered one instance
in finish_task_switch(), the local variable mm is set (for a single
access) to the last user task's active mm_struct, which is then
mmdrop()'d if found not to be NULL. This implies that the user task
that runs before a kernel thread has its mm_struct mmdrop()'d after
said kernel thread is switched out because the kernel thread leeched
off of its mm_struct. When kernel threads leeches off a user task's
active_mm, it's logical for the kernel to increase the reference value
to avoid race conditions, however, exit_mm() increases the mm_struct's
count value in order to deffer the final mmdrop() to
finish_task_switch() (according to the UTLK, end of chapter 9.5). I
assume the final mmdrop() is deferred solely to have a valid pgd left
in %cr3 after mmput() calls mmdrop().
This one pair of switching to a kernel thread then mmdrop()ing its
active_mm once it's switched out makes sense to me. But what I don't
understand is, how the kernel calls mmdrop() after exit_mm().
To clarify, the kernel executes the following code at
finish_task_switch() (kernel/sched.c):
        struct mm_struct *mm = rq->prev_mm;
        ...
        if (mm)
                mmdrop(mm);
I don't see how the kernel is supposed to execute mmdrop() on a
exit_mm()'s behalf when exit_mm() does not set nor even touch
rq->prev_mm.

 Thank you, Robert G.
