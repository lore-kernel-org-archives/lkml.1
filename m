Return-Path: <linux-kernel-owner+w=401wt.eu-S1753236AbZKWOIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbZKWOIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 09:08:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbZKWOIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 09:08:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbZKWOIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 09:08:41 -0500
Date: Mon, 23 Nov 2009 15:03:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 1/2] pid: tighten pidmap spinlock critical section by
	removing kfree()
Message-ID: <20091123140323.GA4495@redhat.com>
References: <cover.1258805412.git.andre.goddard@gmail.com> <0e91f1c4ecc5bc5000f729ccb56e9b6e1fbd4bd3.1258805412.git.andre.goddard@gmail.com> <84144f020911230138v11b18709q28c186f9260f6d66@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84144f020911230138v11b18709q28c186f9260f6d66@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23, Pekka Enberg wrote:
> (Adding some CC's.)
>
> On Sat, Nov 21, 2009 at 2:16 PM, André Goddard Rosa
> <andre.goddard@gmail.com> wrote:
> > Avoid calling kfree() under pidmap spinlock, calling it afterwards.
> >
> > Normally kfree() is very fast, but sometimes it can be slow, so avoid
> > calling it under the spinlock if we can.

kfree() is called when we race with another process which also
finds map->page == NULL, allocs the new page and takes pidmap_lock
before us. This is extremely unlikely case, right?

> > @@ -141,11 +141,12 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
> >                         * installing it:
> >                         */
> >                        spin_lock_irq(&pidmap_lock);
> > -                       if (map->page)
> > -                               kfree(page);
> > -                       else
> > +                       if (!map->page) {
> >                                map->page = page;
> > +                               page = NULL;
> > +                       }
> >                        spin_unlock_irq(&pidmap_lock);
> > +                       kfree(page);

And this change pessimizes (a little bit) the likely case, when
the race doesn't happen. And imho this change doesn't make the
code more readable.

But this is subjective, and technically the patch is correct
afaics.

> >                        if (unlikely(!map->page))
> >                         �

Hmm. Off-topic, but why alloc_pidmap() does not do this right
after kzalloc() ?

Oleg.

