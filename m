Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbXKWWms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbXKWWms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 17:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbXKWWmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 17:42:39 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:7103 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbXKWWmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 17:42:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=azhfApf+wwh803Gy3wr/5rLbhwM+SslDMmdbobyyoVWPL1puKn1LmAda1tR59YmlgaCEjeD8Vg8NMZDrtqvlPqkb6351LXQFqqOK1ruFRbp5ALNYDrN29XS/SUNJ29vyHijU4VwapHnMGpyuLJGOrBOIBxEvfaDcUVX81BVu6OE=
Message-ID: <64bb37e0711231442y7603366aib9642eab97e5be6b@mail.gmail.com>
Date: Fri, 23 Nov 2007 23:42:36 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Milan Broz" <mbroz@redhat.com>
Subject: Re: 2.6.24-rc2-mm1: kcryptd vs lockdep
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Alasdair G Kergon" <agk@redhat.com>
In-Reply-To: <4741F97D.6090808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <64bb37e0711182323v1e2a1341tfc7f20df771b988@mail.gmail.com>
	 <20071119075627.GB28432@elte.hu>
	 <64bb37e0711191134l6dac07a2ie3b4258c43e1f1f0@mail.gmail.com>
	 <4741F97D.6090808@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 19, 2007 10:00 PM, Milan Broz <mbroz@redhat.com> wrote:
> Torsten Kaiser wrote:
> > On Nov 19, 2007 8:56 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >> * Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> ...
> > Above this acquire/release sequence is the following comment:
> > #ifdef CONFIG_LOCKDEP
> >                 /*
> >                  * It is permissible to free the struct work_struct
> >                  * from inside the function that is called from it,
> >                  * this we need to take into account for lockdep too.
> >                  * To avoid bogus "held lock freed" warnings as well
> >                  * as problems when looking into work->lockdep_map,
> >                  * make a copy and use that here.
> >                  */
> >                 struct lockdep_map lockdep_map = work->lockdep_map;
> > #endif
> >
> > Did something trigger this anyway?
> >
> > Anything I could try, apart from more boots with slub_debug=F?
>
> Please could you try which patch from the dm-crypt series cause this ?
> (agk-dm-dm-crypt* names.)
>
> I suspect agk-dm-dm-crypt-move-bio-submission-to-thread.patch because
> there is one work struct used subsequently in two threads...
> (io thread already started while crypt thread is processing lockdep_map
> after calling f(work)...)
>
> (btw these patches prepare dm-crypt for next patchset introducing
> async cryptoapi, so there should be no functional changes yet.)

I looked at all of these agk-*-patches, as the error is not
bisectable, because it triggers unreliable.
The one that looks suspicious is agk-dm-dm-crypt-tidy-io-ref-counting.patch

This one does a functional change, as there now is an additional ref
on io->pending. Instead of only increasing io->pending if there really
are more then one clone-bio, it will now take an additional ref in
crypt_write_io_process().

I certainly agree with the cleanup, but this introduces the following change:

Before the cleanup *all* calls to crypt_dec_pending() was via crypt_endio().
Now there is an additional call to crypt_dec_pending() to balance the
additional ref placed into crypt_write_io_process(). And that one is
not called from whatever context/thread cleans up after
make_generic_request, but directly in the context/thread of the caller
of crypt_write_io_process(), and that is kcryptd.

So now it is possible (if all requests finish before
crypt_write_io_process() returns) that kcryptd itself will release the
bio, but the workqueue infrastructure still seems to have a lock on
that.

But as the comment in run_workqueue says, this should be legal, and I
can't figure out what would make the the lockdep copy mechanism fail.
Especially if the trigger was really a WRITE request, as with
agk-dm-dm-crypt-move-bio-submission-to-thread.patch reverted this
should never use the kcrypt_io-workqueue and so there should be not
even the problem with using INIT_WORK twice on the same work_struct.

... or I just don't see the bug.

Torsten
