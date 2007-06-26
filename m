Return-Path: <linux-kernel-owner+w=401wt.eu-S1759563AbXFZVm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563AbXFZVm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 17:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbXFZVmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 17:42:49 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:55662 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbXFZVms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 17:42:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Vv+fUYTQ/HBs8tgUFYjRTrpLGqsbGjJcswoVCFF7HWNP61m1oX7T+YUCaBtXUMs1MPyZbI+qAZJhAcdHUMZ5MwymZUnJOwVVbPn20BDw1Q+5vKbSwpwobpjXkz4iiEl8lErHjqg3qbZT+gXRF5U23Zte2+LYZXJwv1ZDHPfGZ8E=
Message-ID: <a781481a0706261442h198cc8a6o2be7cd15c72d58@mail.gmail.com>
Date: Wed, 27 Jun 2007 03:12:46 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [Bug 8679] New: Section mismatch: reference to .init.text
Cc: bugme-daemon@bugzilla.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       wbrana@gmail.com, "Sam Ravnborg" <sam@ravnborg.org>
In-Reply-To: <a781481a0706261432g52b0e73ep1ebcd3c099a36048@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <bug-8679-10286@http.bugzilla.kernel.org/>
	 <20070626120134.17aa6143.randy.dunlap@oracle.com>
	 <a781481a0706261432g52b0e73ep1ebcd3c099a36048@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ I have a sinking feeling Gmail mangled the patch yet again. So,
resending. And I'm getting myself a decent mailer ASAP. Sorry for
all the noise. ]

On 6/27/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> On 6/27/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > > [...]
> > > Software Environment:
> > > gcc 3.4.6, binutils 2.17
> > >
> > > Problem Description:
> > > Warnings appeared while building kernel:
> > >
> > > WARNING: kernel/built-in.o(.text+0x15f84): Section mismatch: reference to
> > > .init.text: (between 'kthreadd' and 'init_waitqueue_head')
> > [...]
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> >
> > kthreadd_setup() is in an __init section, but we know that it's
> > safe to be called from kthreadd() since the latter is only called
> > at kernel init time, so mark kthreadd_setup() __init_refok so
> > that modpost won't complain about what text section it is in.
>
> Hi Randy,
>
> __init_refok is for callers, so we should actually be marking kthreadd()
> as __init_refok. But I feel kthreadd_setup() doesn't want to be a separate
> function at all. This is for 2.6.22-rc6, so kindly apply.

---

From: Satyam Sharma <satyam.sharma@gmail.com>

> > WARNING: kernel/built-in.o(.text+0x15f84): Section mismatch: reference to
> > .init.text: (between 'kthreadd' and 'init_waitqueue_head')

is because kernel/kthread.c:kthreadd() is not __init but calls
kthreadd_setup() which is __init. But this is ok, because kthreadd_setup()
is only ever called at init time, and then kthreadd() proceeds into its
"for (;;)" loop.

We could mark kthreadd() __init_refok, but I feel kthreadd_setup() with
just one call site and 4 lines in it shouldn't be a separate function at
all. So let's lose it and code it explicitly in kthreadd() itself.

Signed-off-by: Satyam Sharma <satyam.sharma@gmail.com>

---

 kernel/kthread.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

---

diff -ruNp a/kernel/kthread.c b/kernel/kthread.c
--- a/kernel/kthread.c	2007-06-26 06:33:08.000000000 +0530
+++ b/kernel/kthread.c	2007-06-27 02:57:46.000000000 +0530
@@ -214,23 +214,15 @@ int kthread_stop(struct task_struct *k)
 }
 EXPORT_SYMBOL(kthread_stop);

-
-static __init void kthreadd_setup(void)
+int kthreadd(void *unused)
 {
 	struct task_struct *tsk = current;

+	/* Setup a clean context for our children to inherit. */
 	set_task_comm(tsk, "kthreadd");
-
 	ignore_signals(tsk);
-
 	set_user_nice(tsk, -5);
 	set_cpus_allowed(tsk, CPU_MASK_ALL);
-}
-
-int kthreadd(void *unused)
-{
-	/* Setup a clean context for our children to inherit. */
-	kthreadd_setup();

 	current->flags |= PF_NOFREEZE;
