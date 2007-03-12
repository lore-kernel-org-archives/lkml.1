Return-Path: <linux-kernel-owner+w=401wt.eu-S1751056AbXCLPHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751056AbXCLPHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 11:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbXCLPHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 11:07:42 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:6781 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbXCLPHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 11:07:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nBJuwmHSRqAJeyqdthphTVTnG2roE3IbUb9yUjaUD/v/vlIT8mK6FrCABfl/8GSDNRdstU1iGdPLuKyf9DRYifduFyPG4+9S4Sc0fHTQh9ArWw4SgOi8pysLrkKZskf4WTYYYotj+/j5yYsUCtBKvFmcoPjloNcdjuinY9moShw=
Message-ID: <b0943d9e0703120807t796e6c62k2422a93f6161db3a@mail.gmail.com>
Date: Mon, 12 Mar 2007 15:07:39 +0000
From: "Catalin Marinas" <catalin.marinas@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Possible "struct pid" leak from tty_io.c
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <m1lki64a3i.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b0943d9e0703080927hde01f7dt9ae06433e0c87549@mail.gmail.com>
	 <m13b4f7ggy.fsf@ebiederm.dsl.xmission.com>
	 <b0943d9e0703090844i6459372auba8e408ccce0c1f0@mail.gmail.com>
	 <m1lki64a3i.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> If I can manage to focus on this, it looks like the information I need to
> start fixing this.

I had a look at the second leak reported it seems to be caused by the
same proc_set_tty() call but, in this case, there is no
disassociate_tty() call for the task (and the patch I posted is not
enough). Maybe something like below (no thourough testing):

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index db91398..ea6ca7d 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -3854,7 +3854,14 @@ EXPORT_SYMBOL(tty_devnum);

 void proc_clear_tty(struct task_struct *p)
 {
+	struct tty_struct *tty;
+
 	spin_lock_irq(&p->sighand->siglock);
+	tty = p->signal->tty;
+	if (tty) {
+		put_pid(tty->session);
+		put_pid(tty->pgrp);
+	}
 	p->signal->tty = NULL;
 	spin_unlock_irq(&p->sighand->siglock);
 }

-- 
Catalin
