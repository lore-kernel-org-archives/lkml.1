Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbZBHW2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbZBHW2O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 17:28:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbZBHW16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 17:27:58 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:9667 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbZBHW15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 17:27:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=nJPR8xXXRWAzXjaAl5RxfwCVRoesrit8Sg8IkPZmM2qLs5yLDo5lz84D7t4oLT0Q5W
         TTZ2poJAzp5x4qxac1DxV8a/1oCzgjuky91aQUMzloGiy+95cQSAT00hqXaq6nBmsh0Y
         /x684lu1aLUKnwYrLFPcmjqqgZHN+msi1sGfM=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20090208221027.GA14523@kroah.com>
References: <cfd18e0f0902081025t3fe333ev1616af990e6d19ce@mail.gmail.com>
	 <alpine.DEB.1.10.0902081127510.18839@alien.or.mcafeemobile.com>
	 <alpine.DEB.1.10.0902081245560.18839@alien.or.mcafeemobile.com>
	 <cfd18e0f0902081329j4b18c4f2g91269d3209f1932d@mail.gmail.com>
	 <alpine.DEB.1.10.0902081340320.18839@alien.or.mcafeemobile.com>
	 <cfd18e0f0902081353t70f9e107g28f8003f356f84db@mail.gmail.com>
	 <alpine.DEB.1.10.0902081405120.18839@alien.or.mcafeemobile.com>
	 <20090208221027.GA14523@kroah.com>
Date: Mon, 9 Feb 2009 11:27:55 +1300
Message-ID: <cfd18e0f0902081427g78e56d61k6caac8ebaf1a2012@mail.gmail.com>
Subject: Re: [stable] Why does timerfd() only support CLOCK_REALTIME and 
	CLOCK_MONOTONIC?
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: Greg KH <greg@kroah.com>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>, stable@kernel.org,
       Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 9, 2009 at 11:10 AM, Greg KH <greg@kroah.com> wrote:
> On Sun, Feb 08, 2009 at 02:06:34PM -0800, Davide Libenzi wrote:
>> On Mon, 9 Feb 2009, Michael Kerrisk wrote:
>>
>> > On Mon, Feb 9, 2009 at 10:50 AM, Davide Libenzi <davidel@xmailserver.org> wrote:
>> > > On Mon, 9 Feb 2009, Michael Kerrisk wrote:
>> > >
>> > >> > @@ -186,12 +187,9 @@ SYSCALL_DEFINE2(timerfd_create, int, clo
>> > >> >        BUILD_BUG_ON(TFD_CLOEXEC != O_CLOEXEC);
>> > >> >        BUILD_BUG_ON(TFD_NONBLOCK != O_NONBLOCK);
>> > >> >
>> > >> > -       if (flags & ~(TFD_CLOEXEC | TFD_NONBLOCK))
>> > >> > +       if ((flags & ~TFD_FLAGS_SET) ||
>> > >> > +           invalid_clockid(clockid))
>> > >> >                return -EINVAL;
>> > >>
>> > >> Oh!  Does this mean that in 2.6.2[789] it wasn't possible to use
>> > >> TFD_TIMER_ABSTIME?
>> > >
>> > > No, sorry, my fault. Patch is wrong. In "create" ATM we accept only
>> > > FCNTL-like flags. In "settime" we get TFD_TIMER_ABSTIME (that needs a
>> > > check too for EINVAL).
>> >
>> > That last piece should be a separate patch, that also gets pushed back
>> > into -stable.  Do you agree?
>>
>> Hmm, it's a check for extra bits that do not cause any harm. Dunno if it
>> fits -stable requirements. You should ask Greg.
>
> If it fixes a bug, it would go into -stable.  Does this?

Depends on the definition of bug, I guess ;-).

The issue is this:

a) timerfd_create() (added in kernel 2.6.25) has a flags argument.
b) Currently, one such flag is supported: TFD_TIMER_ABSTIME
c) Eventually, we may add other flag bits to the flags argument.
d) Currently, timerfd_settime() does not check for invalid values in
its flags argument (i.e., bits other than TFD_TIMER_ABSTIME)
e) If/when new flag bits are added, then applications would like to
have a way of determining whether there is support in a given kernel,
something like:

s = timerfd_settime(fd, TFD_XXX, newval, currval);
if (s == 1 && errno == EINVAL)
    printf("TFD_XXX isn't supported by this kernel\n");

Davide, I think, proposes to add the missing check d) in kernel 2.6.29
(or 30).   But, IMO, checks like the above are going to be more useful
to userspace the further back in kernel time that we can push them.
So, it's a philosophical kind of bug.  Your call, I guess.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
