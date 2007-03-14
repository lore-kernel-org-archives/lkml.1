Return-Path: <linux-kernel-owner+w=401wt.eu-S1030845AbXCNJ7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030845AbXCNJ7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030849AbXCNJ7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:59:24 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:56106 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030845AbXCNJ7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:59:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PacnuT1sCahOwG7eqnEK5Rp5zHcmmPeW8ZHp5z2rpEh//POvKkxW27L2lf3ukTu2iLv0bnehHxH12J+BzoJk7a1Ld+yFtTBqc6MSjNVUj9v//LVVZvthGD9Uhoy8CE3d8Tr7Q8KCL+Yfhg6xE4ipYRo0dKIknzgRm5I9kNILE/s=
Message-ID: <b0943d9e0703140259p773b0eb8p9c142d33934e64ff@mail.gmail.com>
Date: Wed, 14 Mar 2007 09:59:21 +0000
From: "Catalin Marinas" <catalin.marinas@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Possible "struct pid" leak from tty_io.c
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <m1veh5q6s7.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b0943d9e0703080927hde01f7dt9ae06433e0c87549@mail.gmail.com>
	 <m13b4f7ggy.fsf@ebiederm.dsl.xmission.com>
	 <b0943d9e0703090844i6459372auba8e408ccce0c1f0@mail.gmail.com>
	 <m1lki64a3i.fsf@ebiederm.dsl.xmission.com>
	 <b0943d9e0703120807t796e6c62k2422a93f6161db3a@mail.gmail.com>
	 <m1veh5q6s7.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/03/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> "Catalin Marinas" <catalin.marinas@gmail.com> writes:
> > void proc_clear_tty(struct task_struct *p)
> > {
> > +     struct tty_struct *tty;
> > +
> >       spin_lock_irq(&p->sighand->siglock);
> > +     tty = p->signal->tty;
> > +     if (tty) {
> > +             put_pid(tty->session);
> > +             put_pid(tty->pgrp);
> > +     }
> >       p->signal->tty = NULL;
> >       spin_unlock_irq(&p->sighand->siglock);
> > }
>
> This patch can't be right.  Not the way proc_clear_tty is called
> once for each process in the session, plus we aren't clearing
> tty->session and tty->pgrp here.
>
> If the above patch works it's a fluke.

I looked at the logs and the pointer isn't freed indeed. It is just a
false negative in kmemleak and it would appear as a leak at some
point. But the previous patch (do_tty_hangup) seems to fix one of the
leaks.

For the 2nd leak, proc_set_tty is called and, for symmetry, I added
put_pid in proc_clear_tty (but without any deep thought). I also
haven't checked any lockdep issues with adding put_pid when
p->sighand->siglock is held.

-- 
Catalin
