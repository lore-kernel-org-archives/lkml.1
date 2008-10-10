Return-Path: <linux-kernel-owner+w=401wt.eu-S1758916AbYJJL7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916AbYJJL7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 07:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754618AbYJJL7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 07:59:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:23322 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbYJJL7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 07:59:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=IYr6oHWueSkQhcutnd7osC+FPRxi2Ttk+eE/yaAFVEwWyO0GNR+BCmFIAnq6I9gKHo
         wWE/QdeqUfgYKT+EA2NkuUC7ozrPbyguDrIDiMelni8O00N7/5Lzu/fp7gGSj4Xw6ZXp
         1BjpfiMJH8FxngJYUHi3oz36/sxrOmwn75FpY=
Message-ID: <cfd18e0f0810100459n13ae6fbfx53861f423114f4f7@mail.gmail.com>
Date: Fri, 10 Oct 2008 13:59:30 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: 7eggert@gmx.de
Subject: Re: dup2() vs dup3() inconsistency when
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Ulrich Drepper" <drepper@redhat.com>,
       "Al Viro" <viro@zeniv.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <E1KoGNo-0001bu-C2@be1.7eggert.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <bl2EV-7G2-9@gated-at.bofh.it> <bl7v3-5sk-17@gated-at.bofh.it>
	 <blasN-OS-9@gated-at.bofh.it> <blaCu-Z0-11@gated-at.bofh.it>
	 <blaMj-18o-23@gated-at.bofh.it> <blaMj-18o-21@gated-at.bofh.it>
	 <bliqg-2DH-1@gated-at.bofh.it>
	 <E1KoGNo-0001bu-C2@be1.7eggert.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 1:42 PM, Bodo Eggert <7eggert@gmx.de> wrote:
> Michael Kerrisk <mtk.manpages@googlemail.com> wrote:
>
>> Well, as long as we are fixing the dup3() interface in the way that Al
>> and Ulrich have suggested, what about another fix:
>>
>> give an error if newfd is already open, thus forcing the user to do an
>> explicit close
>>
>> ?
>>
>> This silent close in dup2() is an implementation blemish.  Why not eliminate
>> it?
>
> I think it might be usefull:
> Thread B does some logging to fd 42
> Thread A switches the logfile by creating a new file, writing a header and
> then does dup3(fd, 42, O_WRONLY|O_APPEND|O_CLOEXEC); close(fd);

I don't know the details of the kernel locks here, so perhaps this is
a naive question: but, as things stand is there not the potential for
some nasty race if one thread is writing to fd 42 at the same time as
another thread does a dup2(fd, 42)?

> (Off cause this is not yet implemented, O_RDONLY would give some problems,
>  O_CLOEXEC alone might be better done while open()ing the file, ... but you
>  get the idea.)
>
>
> BTW: I think dup3(fd, -1, flags) should use the file descriptor dup() would
> return. Or should there be a dupf(fd, flags) syscall instead?

If one did this, maybe it would be better to have an extra flag that
said: "use the first free file descriptor >= newfd", thus giving the
more general functionality like fcntl(F_DUPFD).

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
