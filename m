Return-Path: <linux-kernel-owner+w=401wt.eu-S1756052AbYDJKcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbYDJKcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 06:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbYDJKcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 06:32:13 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:63334 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbYDJKcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 06:32:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=m8Fg2hFp/s6wHPWiSkN/p+P2jAZ4b9CsoM9Yxm8wpW+qDXHriMNn31BGdMZ6nvXxnauq7+v1XQjwu/067MJl4JfaS6uvpGEFRkd9GUTdHgWm65LcDa4UlH+BXyBkSdolbAqG2XkWgnsxAh9H2QbsTrtxVhOmHXxClnnATqekmQQ=
Message-ID: <cfd18e0f0804100332v5d5d9becqbd0a612ca81abfe8@mail.gmail.com>
Date: Thu, 10 Apr 2008 12:32:10 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: signalfd() not handling sigqueue() sigval data correctly
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <cfd18e0f0804092203s33f0ca5as92f47c4db0b0220f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47FBDF12.8090400@gmail.com>
	 <Pine.LNX.4.64.0804091256490.6235@alien.or.mcafeemobile.com>
	 <cfd18e0f0804092203s33f0ca5as92f47c4db0b0220f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 7:03 AM, Michael Kerrisk
<mtk.manpages@googlemail.com> wrote:
> Hi Davide,
>
> > > I was doing some playing about with signalfd(), and seem to have encountered a
> > > bug: when a signalfd read() fetches data for a signal that was sent by
> > > sigqueue(), the data accompanying the signal is not returned.  Instead
> > > ssi_int/ssi_ptr is zero.
> >
> > Michael, can you give the patch below a spin? I tested it on my x86_64 box
> > and seems to be working fine:
> >
> > Got signal 44
> >   ssi_code= -1
> >   ssi_pid = 6314
> >   ssi_uid = 1000
> >   ssi_int = 123
> >   ssi_ptr = 7b
>
> This works for me on x86-32.  Thanks Davide!

Davide,

Are you going to get this pushed into 2.6.26?  I assume we can't get
it into 2.6.25...

Cheers,

Michael

> > ---
> >  fs/signalfd.c |    7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > Index: linux-2.6.mod/fs/signalfd.c
> > ===================================================================
> > --- linux-2.6.mod.orig/fs/signalfd.c    2008-04-09 11:53:37.000000000 -0700
> > +++ linux-2.6.mod/fs/signalfd.c 2008-04-09 12:05:46.000000000 -0700
> > @@ -111,9 +111,14 @@
> >                err |= __put_user(kinfo->si_uid, &uinfo->ssi_uid);
> >                err |= __put_user((long) kinfo->si_ptr, &uinfo->ssi_ptr);
> >                break;
> > -       default: /* this is just in case for now ... */
> > +       default:
> > +               /*
> > +                * This case catches also the signals queued by sigqueue().
> > +                */
> >                err |= __put_user(kinfo->si_pid, &uinfo->ssi_pid);
> >                err |= __put_user(kinfo->si_uid, &uinfo->ssi_uid);
> > +               err |= __put_user((long) kinfo->si_ptr, &uinfo->ssi_ptr);
> > +               err |= __put_user(kinfo->si_int, &uinfo->ssi_int);
> >                break;
> >        }
> >
> >
>
>
>
>
> --
> Michael Kerrisk
> Maintainer of the Linux man-pages project: http://www.kernel.org/doc/man-pages/
> Want to report a man-pages bug? Look here:
> http://www.kernel.org/doc/man-pages/reporting_bugs.html
>



-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug? Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html
