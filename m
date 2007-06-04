Return-Path: <linux-kernel-owner+w=401wt.eu-S1758428AbXFDRRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428AbXFDRRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 13:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757939AbXFDRQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 13:16:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:64754 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757719AbXFDRQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 13:16:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EuPQIzjfbv26VHugxdgTM43SVG3g9AKA0qWHqFo+fxN1tt0DVy+Nc3XjVvgosyBfODRo8beZfYv9ocO+/NMaJ2ywUNHK0kdGQkDEcIhpLXeYnzT109xBGDWmxe1jXUZgyRl8KZgixQYOWZwj0V3D22vsDAPw+Ywk+30Whn7XKiA=
Message-ID: <a36005b50706041016g5b45a030g80ffcf229f871c49@mail.gmail.com>
Date: Mon, 4 Jun 2007 10:16:56 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Jeff Dike" <jdike@addtoit.com>
Subject: Re: Syslets, signals, and security
Cc: "Zach Brown" <zach.brown@oracle.com>, "Ingo Molnar" <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070604163145.GA7144@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070604163145.GA7144@c2.user-mode-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/07, Jeff Dike <jdike@addtoit.com> wrote:
> First, there are signals.  If the app has an interval timer enabled,
> every thread will inherit it and you will have 32 threads getting
> alarms, which seems surprising and wasteful.

Not only that.  IIRC the current code does nothing about blocking
signals while the thread is not yet a real thread.  If these worked
threads would receive a signal sent to the process (process group in
kernel-speak) this could severely irritate the application.  The
signal mask of a new thread is inherited from the parent thread.  If
the parent has it unset, the child will by default.  Until and unless
the aio-created thread is used to deliver a notification because
SIGEV_THREAD is selected it must not appear doing any work for the
process.

This should be easy to fix: when creating a thread for aio, the kernel
should block all signals (probably including SIGSTOP etc).  If and
when the thread is seen at userlevel the glibc code can then set a
reasonable signal mask if the thread is to be reused.


> I can imagine other
> signals (like SIGWINCH and  SIGHUP) which might be surprising to
> receive multiple times in an obstensibly single-threaded process.

Normal signals are sent to only one thread in the process.  If a
thread cannot handle the signal it has to block it.  The kernel will
then choose a different thread or keep it pending.  Special signals
are delivered to all threads.  SIGSTOP, for instance.  There is a lot
of special code in the kernel to handle these cases and they should be
fine.


> Second, security.  What happens if a well-written server starts life
> as root, does some (async) I/O, and setuids to a non-root uid?  There
> will be a bunch of async threads still running as root, with the
> result that async operations (and the main thread) will more than
> occassionally regain root privs.

This is indeed a problem and the reason is that we are forced to
implement setuid etc at userlevel.  The code currently works by
sending a special signal to all threads in the process and the signal
handler issues the appropriate setuid etc call.

We would need to extend this implementation to all threads created via
AIO.  This requires that we can send a signal to the syslet before it
has left the kernel and maybe before it's done with the request.  The
reason is that the thread calling setuid etc has to wait until all
threads have been successfully changed.  We cannot indefinitely delay
the thread just because of outstanding AIO requests.

My preferred solution would still be to implement setuid etc in the
kernel.  I.e., have a new syscall setuid_pgrp or so.


> You can fix this by going around to all the threads in the thread
> group and changing their ->uid, but that seems somewhat kludgy.

That's what we do already and I couldn't agree more with you.


>  You
> could also fix this by killing off the async threads on a setuid, and
> make the app recreate the async threads under its new uid.

This cannot work reliably, some of the AIO might already have happened.


> There's also ptrace, which (as I think Zach already mentioned) gets
> along badly with syslets.

syslets should be invisible to ptrace until they enter userlevel.
