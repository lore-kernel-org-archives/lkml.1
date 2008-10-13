Return-Path: <linux-kernel-owner+w=401wt.eu-S1759542AbYJMTdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbYJMTdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 15:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbYJMTcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 15:32:55 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:16495 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbYJMTcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 15:32:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WZXlQV6iykZDieBir3kykipGFp0JKeKBWUXSSU94K8D1K3u4QxFfBm5yrc9zWq2f53
         06aaG69FenqwU1t6k/fYkEaVxL02j+S4attkXsxWbsL/cpiDI3g1ETDXWBJwZio1yuOo
         QYzbDEhdUSg3R38PyCfYQswCkztXewx3MmfxE=
Date: Mon, 13 Oct 2008 21:31:19 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Alan Cox <alan@redhat.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: inconsistent lock state (tty? input?)
Message-ID: <20081013193114.GA5647@joi>
References: <20081013183731.GA5676@joi> <20081013145712.5aa06871@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081013145712.5aa06871@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 02:57:12PM -0400, Arjan van de Ven wrote:
> On Mon, 13 Oct 2008 20:37:43 +0200
> Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> 
> > On current git (a447c0932445f92ce6f4c1bd020f62c5097a7842):
> \
> 
> good spotting;
> 
> the patch below should fix this:
> 
> From 26c117549415c55585f46ad38cd58a5f84f5adc7 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Mon, 13 Oct 2008 14:56:39 -0400
> Subject: [PATCH] tty: make sure that proc_clear_tty stores the cpu flags
> 
> proc_clear_tty() gets called with interrupts off (while holding the task list lock)
> from sys_setid. This means that it needs the _irqsave version of the locking primitives.
> 
> Reported-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  drivers/char/tty_io.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
> index e4dce87..4715961 100644
> --- a/drivers/char/tty_io.c
> +++ b/drivers/char/tty_io.c
> @@ -3595,9 +3595,10 @@ EXPORT_SYMBOL(tty_devnum);
>  
>  void proc_clear_tty(struct task_struct *p)
>  {
> -	spin_lock_irq(&p->sighand->siglock);
> +	unsigned long flags;
> +	spin_lock_irqsave(&p->sighand->siglock, flags);
>  	p->signal->tty = NULL;
> -	spin_unlock_irq(&p->sighand->siglock);
> +	spin_unlock_irqrestore(&p->sighand->siglock, flags);
>  }
>  
>  /* Called under the sighand lock */
> -- 

It worked, thanks!

But I had to manually apply this patch (this function looks different now)
Updated patch below:
---
From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] tty: make sure that proc_clear_tty stores the cpu flags

proc_clear_tty() gets called with interrupts off (while holding the task list lock)
from sys_setid. This means that it needs the _irqsave version of the locking primitives.

Reported-and-tested-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/char/tty_io.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 7053d63..3f48d88 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -3032,11 +3032,12 @@ EXPORT_SYMBOL(tty_devnum);
 
 void proc_clear_tty(struct task_struct *p)
 {
+	unsigned long flags;
 	struct tty_struct *tty;
-	spin_lock_irq(&p->sighand->siglock);
+	spin_lock_irqsave(&p->sighand->siglock, flags);
 	tty = p->signal->tty;
 	p->signal->tty = NULL;
-	spin_unlock_irq(&p->sighand->siglock);
+	spin_unlock_irqrestore(&p->sighand->siglock, flags);
 	tty_kref_put(tty);
 }
 
-- 
1.5.6.4

