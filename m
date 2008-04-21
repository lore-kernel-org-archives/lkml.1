Return-Path: <linux-kernel-owner+w=401wt.eu-S1759734AbYDUPmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759734AbYDUPmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 11:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbYDUPl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 11:41:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:42427 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbYDUPl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 11:41:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wzpgD77XIGRUffF57cxJhXREBu0pXVeBL58y4qfKXLtTbPiQvnJWp/KOAoWQnOyI8kDFzNm0LKt/QaUrkjGaUx25FnloiMo8QavAubsHlZSjHgsxOWMtXK1giWcQHWSqoL7whKS5BVSU0KcTndyNkboO5CUSfs0rMEcFmYlthEE=
Message-ID: <cfd18e0f0804210841v600c9e7w5081146a68590630@mail.gmail.com>
Date: Mon, 21 Apr 2008 17:41:57 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Ulrich Drepper" <drepper@redhat.com>
Subject: Re: [PATCH] utimensat() non-conformances and fixes
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org
In-Reply-To: <480C323B.3060608@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47FA9DA1.8040508@gmail.com> <480C323B.3060608@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 8:20 AM, Ulrich Drepper <drepper@redhat.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Michael Kerrisk wrote:
> > 1. The draft POSIX.1-200x specification for utimensat() says that if a
> > times[n].tv_nsec field is UTIME_OMIT or UTIME_NOW, then the value in the
> > corresponding tv_sec field is ignored.  However the current Linux
> > implementation requires the tv_sec value to be zero (or the EINVAL error
> > results).  This requirement should be removed.
>
> OK, for now.  I think the implemented behavior is better, though.

My only real objection to the implemented behavior is that it doesn't
follow the spec.  It doesn't seem unreasonable to change the spec
here.  Or is it already too late for that?  (I suppose it may well
be.)

> > However, the current implementation does not generate
> > EPERM if one tv_nsec field is UTIME_NOW while the other is UTIME_OMIT -- it
> > should give this error for that case.
>
> This is probably a necessary change.  Non-synchronized changes might be
> a security problem.

Yes.

> > However, in
> > the same circumstances, when utimensat() is given a 'times' array in which
> > both tv_nsec fields are UTIME_NOW, which provides equivalent functionality
> > to specifying 'times' as NULL, the call succeeds.  I think that it should fail
> > with the error EACCES in this case.
>
> I guess so.

Ok.

> > (times == NULL && times[0].tv_nsec == UTIME_NOW && times[1].tv_nsec ==
> > UTIME_NOW)
> >
> > case should be treated like the traditional utimes() case where 'times'
> > is NULL.  That is, the call should succeed for a file marked append-only
> > and should give the error EACCES if the file is marked as immutable.
>
> Is this something I changed?  I doubt I added this.

Well, I just went away and tested yet again, and utime[s]() with a
NULL second argument gives the behavior I describe (and always did) --
and utimensat() should behave the same way for the
(times == NULL && times[0].tv_nsec == UTIME_NOW && times[1].tv_nsec ==
UTIME_NOW)
case, but does not.

Cheers,

Michael

-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug? Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html
