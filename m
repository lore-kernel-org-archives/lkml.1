Return-Path: <linux-kernel-owner+w=401wt.eu-S1755110AbXHSMvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbXHSMvX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 08:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbXHSMvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 08:51:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:24799 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbXHSMur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 08:50:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=fBe6tr6D2Y7RN4mEks+OBOqJUPnJkynhM3vyEr8h9XQolRRBM7wFs4uuPbaqgztSJ3qVfYLQ9Qd6EhFanNRhpk+AaO47z5nTeigi8M7Ru3b/X0fvqwjzwtqApIIermCotfj+bGYaBIwUYSIGVfYQllNGg29Ckanj8g0UKqGcKek=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: davids@webmaster.com
Subject: Re: O_NONBLOCK is broken
Date: Sun, 19 Aug 2007 13:50:39 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <MDEHLPKNGKAHNMBLJOLKIEKAGCAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKIEKAGCAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708191350.39173.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2007 22:59, David Schwartz wrote:
> > The problem is, O_NONBLOCK flag is not attached to file *descriptor*,
> > but to a "file description" mentioned in fcntl manpage:
>
> [snip]
>
> > We don't know whether our stdout descriptor #1 is shared with
> > anyone or not,
> > and if we were started from shell, it typically is. That's why we try to
> > restore flags ASAP.
> >
> > But "ASAP" isn't soon enough. Between setting and clearing O_NONBLOCK,
> > other process which share fd #1 with us may well be affected
> > by file suddenly becoming O_NONBLOCK under its feet.
> >
> > Worse, other process can do the same
> >     fcntl(1, F_SETFL, fl | O_NONBLOCK);
> >     ...
> >     fcntl(1, F_SETFL, fl);
> > sequence, and first fcntl can return flags with O_NONBLOCK set
> > (because of
> > us), and then second fcntl will set O_NONBLOCK permanently, which is not
> > what was intended!
>
> [snip]
>
> > P.S. Hmm, it seems fcntl GETFL/SETFL interface seems to be racy:
> >
> >     int fl = fcntl(fd, F_GETFL, 0);
> >     /* other process can muck with file flags here */
> >     fcntl(fd, F_SETFL, fl | SOME_BITS);
> >
> > How can I *atomically* add or remove bits from file flags?
>
> Simply put, you cannot change file flags on a shared descriptor. It is a
> bug to do so, a bug that is sadly present in many common programs.

It means that the design is flawed and if done right, file flags
which are changeable by fcntl (O_NONBLOCK, O_APPEND, O_ASYNC, O_DIRECT, 
O_NOATIME) shouldn't be shared, they are useless as shared.
IOW, they should be file _descriptor_ flags.

It's unlikely that kernel tribe leaders will agree to violate POSIX
and make fcntl(F_SETFL) be per-fd thing. There can be users of this
(mis)feature.

Making fcntl(F_SETFD) accept those same flags and making it override
F_SETFL flags may fare slightly better, but may require propagation
of these flags into *a lot* of kernel codepaths.

> I like the idea of being able to specify blocking or non-blocking behavior
> in the operation. It is not too uncommon to want to perform blocking
> operations sometimes and non-blocking operations other times for the same
> object and having to keep changing modes, even if it wasn't racy, is a
> pain.

I am submitting a patch witch allows this. Let's see what people will say.

Yet another way to fix this problem is to add a new fcntl operation
"duplicate an open file":

fd = fcntl(fd, F_DUPFL, min_fd);

which is analogous to F_DUPFD, but produces _unshared_ file descriptor.
You can F_SETFL it as you want, no one else will be affected.

> However, there's a much more fundamental problem here. Processes need a
> good way to get exclusive use of their stdin, stdout, and stderr streams
> and there is no good way. Perhaps an "exclusive lock" that blocked all
> other process' attempts to use the terminal until it was released would be
> a good thing.

Yep, maybe. But this is a different problem.
IOW: there are cases where one doesn't want this kind of locking,
but simply needs to do unblocked read/write. That's what I'm trying
to solve.
--
vda
