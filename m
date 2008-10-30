Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbYJ3Pzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbYJ3Pzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 11:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139AbYJ3Pzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 11:55:42 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:52584 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbYJ3Pzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 11:55:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=JY7xSVxbaQwlo0lNdFSFArkJRojzK/oIsoGw5Rf3n8TP8EH74N1Q1ZIBNaugXuQdcy
         7Dub+K6GWbtbvLqFGwByTA5YZbhiX2jxGyMeXE3J38ifzot5WwE94iv4oGfaD3uxNLks
         6JCkBgZ1veQz7+lFqjI1t/5ueul8lsr+XfEco=
Message-ID: <cfd18e0f0810300855w6e14bb81gfacd33d6bcb103b5@mail.gmail.com>
Date: Thu, 30 Oct 2008 10:55:40 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Oleg Nesterov" <oleg@redhat.com>
Subject: Re: Strange stop-signal behavior in multithreaded program with defunct main
Cc: lkml <linux-kernel@vger.kernel.org>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Bert Wesarg" <bert.wesarg@googlemail.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Roland McGrath" <roland@redhat.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20081030110000.GA3767@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4907E6B9.8080700@gmail.com> <20081030110000.GA3767@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On Thu, Oct 30, 2008 at 6:00 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 10/28, Michael Kerrisk wrote:
>>
>> Bert Wesarg described a scenario that I quickly replicated on
>> 2.6.28-rc2 (and 2.6.25 -- it's not a regression in 2.6.28-rc)
>> using the program below: if we have a multithreaded process
>> with a defunct main thread running on a tty, and that
>> process is sent a stop signal (either ^Z (SIGTSTP) or a stop
>> signal sent from another terminal using kill(1)), then:
>>
>> a) the terminal is locked up; and
>>
>> b) the program is unresponsive to any other signal, except SIGKILL
>> or SIGCONT.
>
> Yes, known problem. Please look at
>
>        [RFC,PATCH 3/3] do_wait: fix waiting for stopped group with dead leader
>        http://marc.info/?t=119713920000003

Okay -- thanks for the info.  I've added some text to man-pages to
cover this bug.

Cheers,

Michael

--- a/man3/pthread_exit.3
+++ b/man3/pthread_exit.3
@@ -21,7 +21,7 @@
 .\" Formatted or processed versions of this manual, if unaccompanied by
 .\" the source, must acknowledge the copyright and authors of this work.
 .\"
-.TH PTHREAD_EXIT 3 2008-10-24 "Linux" "Linux Programmer's Manual"
+.TH PTHREAD_EXIT 3 2008-10-30 "Linux" "Linux Programmer's Manual"
 .SH NAME
 pthread_exit \- terminate calling thread
 .SH SYNOPSIS
@@ -87,6 +87,18 @@ The value pointed to by
 .IR retval
 should not be located on the calling thread's stack,
 since the contents of that stack are undefined after the thread terminates.
+.SH BUGS
+Currently,
+.\" Linux 2.6.27
+there are limitations in the kernel implementation logic for
+.BR wait (2)ing
+on a stopped thread group with a dead thread group leader.
+This can manifest in problems such as a locked terminal if a stop signal is
+sent to a foreground process whose thread group leader has already called
+.BR pthread_exit (3).
+.\" FIXME . review a later kernel to see if this gets fixed
+.\" http://thread.gmane.org/gmane.linux.kernel/611611
+.\" http://marc.info/?l=linux-kernel&m=122525468300823&w=2
 .SH SEE ALSO
 .BR pthread_create (3),
 .BR pthread_join (3),
