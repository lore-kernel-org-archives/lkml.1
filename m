Return-Path: <linux-kernel-owner+w=401wt.eu-S1030993AbXDWEJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030993AbXDWEJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 00:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030991AbXDWEJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 00:09:32 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:35289 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030989AbXDWEJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 00:09:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NzEf0JqCs2e/RAOlvluHP/b3pJ6zhclZ5wjprR0hcxE/xKNhDZT2VneQwBJp9meHbxCUxJEjZNF/jLN3oP7FMs1qTG7aWQx0ue35bPvlY7SyY9ds4YlNTdH7kxU+tTOHwCOQKBUjBh4uG3IXTaM7blXM1oCiTy5+KgID46HLxto=
Message-ID: <a781481a0704222109t5c92e4d6t280c21b256945ac8@mail.gmail.com>
Date: Mon, 23 Apr 2007 09:39:30 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH -mm 2/3] freezer: Introduce freezer_flags
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       ego@in.ibm.com, "Oleg Nesterov" <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org, vatsa@in.ibm.com, paulmck@us.ibm.com,
       pavel@ucw.cz
In-Reply-To: <200704222139.27128.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070419120131.GB13435@in.ibm.com> <20070420183118.GA695@elte.hu>
	 <200704222128.49419.rjw@sisk.pl> <200704222139.27128.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

> +/*
> + *     Per task flags used by the freezer
> + *
> + *     They should not be referred to directly outside of this file.
> + */
> +#define TFF_NOFREEZE   0       /* task should not be frozen */
> +#define TFF_FREEZE     8       /* task should go to the refrigerator ASAP */
> +#define TFF_SKIP       9       /* do not count this task as freezable */
> +#define TFF_FROZEN     10      /* task is frozen */

Aren't NOFREEZE and SKIP doing the same thing? One of them appears
superfluous. I'm looking at 21-rc6-mm1 and vfork(2) seems to be its
only user. Seeing how vfork(2) used it, can't the call to
freezer_do_not_count() be replaced with a call to freezer_exempt()?
Similarly, the freezer_count() after the wait_for_completion might
just as well be a clear of the NOFREEZE bit followed by a
try_to_freeze(). Could you please explain the rationale behind the
SKIP flag?

I do see that SKIP seems to be relevant for only userspace threads and
presumably only kernel threads are allowed to set NOFREEZE, but why
this distinction between the two?

Also, I do have several gripes against the naming of some of these functions:

>  static inline int freezing(struct task_struct *p)

This could be called task_should_freeze().

>  /*
> - * Sometimes we may need to cancel the previous 'freeze' request
> + * Cancel the previous 'freeze' request
>   */
>  static inline void do_not_freeze(struct task_struct *p)

This definitely needs to be undo_freeze() or unfreeze().
do_not_freeze() sounds like what freeze_exempt() does.

>  static inline void frozen_process(struct task_struct *p)

frozen_process() sounds like what frozen() is supposed to do. This
could instead be mark_task_frozen(), or even mark_frozen(), because
only the current task can ever mark *itself* frozen before freezing
itself.

>  static inline void freezer_do_not_count(void)
>  static inline void freezer_count(void)

These could be called freezer_skip() and freezer_do_not_skip(). Better
to stick to consistent naming / terminology.

Cheers,
Satyam
