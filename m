Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbZFHTR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbZFHTR5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbZFHTRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:17:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:9517 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbZFHTRq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:17:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bM4fsAHcAgZH/uneGH5M+0rkU+aDM4qm6auAI8d3Hl8EtCkOY5USxzv/+j77qzYOjm
         ygxF1K3zz51dOT/psqr20MKp7JD3wpW6a+7HgMmgiYevK/hN90yCiSHGUBZ18yloqXx4
         9//1arM8WOK1iSug5PJEX1sbgy8cfCQwz8qGo=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0906081120400.6847@localhost.localdomain>
References: <200906061959.55592.chris2553@googlemail.com>
	 <c6b1100b0906080108y191bb157n67ec681ade2a0d13@mail.gmail.com>
	 <c6b1100b0906080358y4033c402ra236eff3f972d169@mail.gmail.com>
	 <1244460875.12644.2.camel@ht.satnam>
	 <c6b1100b0906080553o2aa77a40pe0077b1b10a7d88a@mail.gmail.com>
	 <alpine.LFD.2.01.0906080916130.6847@localhost.localdomain>
	 <1244479879.4079.284.camel@mulgrave.site>
	 <1244480790.2716.7.camel@ht.satnam>
	 <c6b1100b0906081045t47c77b94ubc89d450c3a75147@mail.gmail.com>
	 <alpine.LFD.2.01.0906081120400.6847@localhost.localdomain>
Date: Mon, 8 Jun 2009 20:17:46 +0100
Message-ID: <c6b1100b0906081217t57484774w475f79a93d37c221@mail.gmail.com>
Subject: Re: 2.6.30-rc8 Oops whilst booting
From: Chris Clayton <chris2553@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       scsi <linux-scsi@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

2009/6/8 Linus Torvalds <torvalds@linux-foundation.org>:
>
>
> On Mon, 8 Jun 2009, Chris Clayton wrote:
>>
>> I can confirm that a kernel built with Jaswinder's patch applied
>> survived 200 boots without a panic.
>
> Ok, goodie.
>
> Can you confirm that the further cleanup (removing the pointless 'ret'
> variable and the useless empty checking around 'for_each_entry') also
> works for you?
>
>                Linus
>
> ---
>  kernel/async.c |   15 +++++----------
>  1 files changed, 5 insertions(+), 10 deletions(-)
>
> diff --git a/kernel/async.c b/kernel/async.c
> index 5054030..27235f5 100644
> --- a/kernel/async.c
> +++ b/kernel/async.c
> @@ -92,23 +92,18 @@ extern int initcall_debug;
>  static async_cookie_t  __lowest_in_progress(struct list_head *running)
>  {
>        struct async_entry *entry;
> -       async_cookie_t ret = next_cookie; /* begin with "infinity" value */
>
>        if (!list_empty(running)) {
>                entry = list_first_entry(running,
>                        struct async_entry, list);
> -               ret = entry->cookie;
> +               return entry->cookie;
>        }
>
> -       if (!list_empty(&async_pending)) {
> -               list_for_each_entry(entry, &async_pending, list)
> -                       if (entry->running == running) {
> -                               ret = entry->cookie;
> -                               break;
> -                       }
> -       }
> +       list_for_each_entry(entry, &async_pending, list)
> +               if (entry->running == running)
> +                       return entry->cookie;
>
> -       return ret;
> +       return next_cookie;     /* "infinity" value */
>  }
>
>  static async_cookie_t  lowest_in_progress(struct list_head *running)
>

Yes, rc8-git5 with your patch applied has booted 100 times without a panic.

May I add that the people who thought of, designed and implemented
kexec should have a large and shiny medals pinned to their chests.
Well over 1000 kernel boots have been executed on my PC today and, if
I hadn't been able to do that automatically with a few lines of script
at the head of /etc/rc.d/rc.local, I would have been bleary-eyed
before noon :-)

Chris

-- 
No, Sir; there is nothing which has yet been contrived by man, by
which so much happiness is produced as by a good tavern or inn -
Doctor Samuel Johnson
