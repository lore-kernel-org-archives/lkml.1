Return-Path: <linux-kernel-owner+w=401wt.eu-S1755676AbZFHUFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676AbZFHUFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 16:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbZFHUEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 16:04:54 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:62951 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbZFHUEx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 16:04:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=SPxZSDfQNrjDBRqXl41hQ857a1yrQ+hTca52MDTIk1Ue9tTTOV4ALZpNVzO4CA9wvh
         IEB4BiGMJbkQylEEctPHy0yfhxF5DLTVBp2a0S6v7V2kDvDOYgrfeUIhOFO98ioHhf0e
         0d5uXT73E01A3LpHsRNd3kSCy6/5M/Qprt33c=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.30-rc8 Oops whilst booting
Date: Mon, 8 Jun 2009 21:03:53 +0100
User-Agent: KMail/1.9.10
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       scsi <linux-scsi@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <200906061959.55592.chris2553@googlemail.com> <alpine.LFD.2.01.0906081120400.6847@localhost.localdomain> <c6b1100b0906081217t57484774w475f79a93d37c221@mail.gmail.com>
In-Reply-To: <c6b1100b0906081217t57484774w475f79a93d37c221@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906082103.53281.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 June 2009, Chris Clayton wrote:
> Linus,
>
> 2009/6/8 Linus Torvalds <torvalds@linux-foundation.org>:
> > On Mon, 8 Jun 2009, Chris Clayton wrote:
> >> I can confirm that a kernel built with Jaswinder's patch applied
> >> survived 200 boots without a panic.
> >
> > Ok, goodie.
> >
> > Can you confirm that the further cleanup (removing the pointless 'ret'
> > variable and the useless empty checking around 'for_each_entry') also
> > works for you?
> >
> >                Linus
> >
> > ---
> >  kernel/async.c |   15 +++++----------
> >  1 files changed, 5 insertions(+), 10 deletions(-)
> >
> > diff --git a/kernel/async.c b/kernel/async.c
> > index 5054030..27235f5 100644
> > --- a/kernel/async.c
> > +++ b/kernel/async.c
> > @@ -92,23 +92,18 @@ extern int initcall_debug;
> >  static async_cookie_t  __lowest_in_progress(struct list_head *running)
> >  {
> >        struct async_entry *entry;
> > -       async_cookie_t ret = next_cookie; /* begin with "infinity" value
> > */
> >
> >        if (!list_empty(running)) {
> >                entry = list_first_entry(running,
> >                        struct async_entry, list);
> > -               ret = entry->cookie;
> > +               return entry->cookie;
> >        }
> >
> > -       if (!list_empty(&async_pending)) {
> > -               list_for_each_entry(entry, &async_pending, list)
> > -                       if (entry->running == running) {
> > -                               ret = entry->cookie;
> > -                               break;
> > -                       }
> > -       }
> > +       list_for_each_entry(entry, &async_pending, list)
> > +               if (entry->running == running)
> > +                       return entry->cookie;
> >
> > -       return ret;
> > +       return next_cookie;     /* "infinity" value */
> >  }
> >
> >  static async_cookie_t  lowest_in_progress(struct list_head *running)
>
> Yes, rc8-git5 with your patch applied has booted 100 times without a panic.
>

...so I should have added:

Tested-by: Chris Clayton <chris2553@googlemail.com>

> May I add that the people who thought of, designed and implemented
> kexec should have a large and shiny medals pinned to their chests.
> Well over 1000 kernel boots have been executed on my PC today and, if
> I hadn't been able to do that automatically with a few lines of script
> at the head of /etc/rc.d/rc.local, I would have been bleary-eyed
> before noon :-)
>
> Chris



-- 
No, Sir; there is nothing which has yet been contrived by man, by which
so much happiness is produced as by a good tavern or inn - Doctor Samuel
Johnson
