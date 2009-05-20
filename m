Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbZETUa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbZETUa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 16:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755826AbZETUaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 16:30:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755798AbZETUaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 16:30:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Vitaly Mayatskikh <v.mayatskih@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Split wait_noreap_copyout()
In-Reply-To: Oleg Nesterov's message of  Wednesday, 20 May 2009 17:57:15 +0200 <20090520155715.GA23682@redhat.com>
References: <1242048349-2766-1-git-send-email-v.mayatskih@gmail.com>
	<1242048349-2766-2-git-send-email-v.mayatskih@gmail.com>
	<87tz3fssv1.wl%vmayatsk@redhat.com>
	<20090520155715.GA23682@redhat.com>
Emacs: Lovecraft was an optimist.
Message-Id: <20090520202950.4FFB6FC38D@magilla.sf.frob.com>
Date: Wed, 20 May 2009 13:29:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> do_wait() && infop interaction is really strange before the patch.

do_wait() underlies sys_wait4() and sys_waitid().  The original intent was
that all the infop==NULL cases are just for the sys_wait4() path.  In the
sys_waitid() path, infop comes from the user and NULL always ought to have
been invalid.

See http://lkml.org/lkml/2009/1/13/446 for the previous thread about this.
We wanted to clean it up, but Linus objected to changing the userland
behavior of passing NULL to waitid on the grounds of "never regress the
ABI, even if it was not supposed to be the ABI".

> When do_wait() is called without WNOWAIT, then infop == NULL is fine.
> 
> If WNOWAIT is set, we return -EFAULT. Except in WCONTINUED case
> infop == NULL is fine again.

WNOWAIT can only be set in the sys_waitid() path, not by sys_wait4().
Without WNOWAIT, it might be sys_wait4(), where infop==NULL is normal.
The WCONTINUED variance was unintended.

I would be fine with any way you want to clean this up.
But presumably Linus would object again if any combination of userland
arguments that is now permitted were to start returning an error.
I'm guessing he won't object to making the WNOWAIT case consistent
with other sys_waitid() calls that pass NULL (i.e. -EFAULT -> success
acceptable, but success -> -EFAULT not acceptable).


Thanks,
Roland
