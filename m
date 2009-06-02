Return-Path: <linux-kernel-owner+w=401wt.eu-S1759652AbZFBEvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759652AbZFBEvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 00:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757790AbZFBEvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 00:51:36 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:44703 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063AbZFBEvf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 00:51:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=n27v2v5hO1wDewvdOEJ0It377phJaSCmHDUqn/bQ48UYHrgFzodK/mNH3WW+goEVnV
         +GwsAiVZmRVVyvDwS5Sy/U3cARjnCyarvtcMOd42CdgpvJ+I0K1QYZ6sDts7sV3doUgA
         Edsapkir7ToPxSekFJK5vwIJt9L6LvIA6+Wy0=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20090526175622.687B.A69D9226@jp.fujitsu.com>
References: <20090526175622.687B.A69D9226@jp.fujitsu.com>
Date: Tue, 2 Jun 2009 06:45:22 +0200
Message-ID: <cfd18e0f0906012145h28827eccu1d9fa2aed2e7355@mail.gmail.com>
Subject: Re: poll never return EBADF?
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Motohiro,

On Tue, May 26, 2009 at 11:09 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Hi
>
> I have one stupid question.

It doesn't look stupid to me...

> "man poll" describe this error code.
>
>>ERRORS
>>       EBADF  An invalid file descriptor was given in one of the sets.

This text seems to have been added in man-pages-1.39 (around 2000),
but with no explanation or note on authorship. I suspect someone was
confused.

> but current kernel implementation ignore invalid file descriptor,
> not return EBADF.

Which is what I understand it should do.

> ================ cut code ========================================
> static inline unsigned int do_pollfd(struct pollfd *pollfd, poll_table *pwait)
> {
>        unsigned int mask;
>        int fd;
>
>        mask = 0;
>        fd = pollfd->fd;
>        if (fd >= 0) {                                  //// here
>                int fput_needed;
>                struct file * file;
>
>                file = fget_light(fd, &fput_needed);
>                mask = POLLNVAL;
>                if (file != NULL) {                     //// and here
>                        mask = DEFAULT_POLLMASK;
>                        if (file->f_op && file->f_op->poll)
>                                mask = file->f_op->poll(file, pwait);
>                        /* Mask out unneeded events. */
>                        mask &= pollfd->events | POLLERR | POLLHUP;
>                        fput_light(file, fput_needed);
>                }
>        }
> ================ end code ========================================
>
> In the other hand, SUSv3 talk about
>
>> POLLNVAL
>>    The specified fd value is invalid. This flag is only valid in the
>>    revents member; it shall ignored in the events member.
>
> and
>
>> If the value of fd is less than 0, events shall be ignored, and revents
>> shall be set to 0 in that entry on return from poll().

Exactly.

> but, no desribe EBADF.
> (see http://www.opengroup.org/onlinepubs/009695399/functions/poll.html)
>
> So, I think the implementation is correct.

Agreed.

> Why don't we remove EBADF description?

Yes, that seems corrrrect for me. I've removed it for the next release (3.22).

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
