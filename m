Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbZEYW4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbZEYW4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 18:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbZEYW4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 18:56:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42267 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753032AbZEYW4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 18:56:04 -0400
Date: Tue, 26 May 2009 00:51:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, ebiederm@xmission.com,
       roland@redhat.com, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] signal: make group kill signal fatal
Message-ID: <20090525225150.GA12362@redhat.com>
References: <1243198054-13816-1-git-send-email-jirislaby@gmail.com> <20090525000750.GA2301@redhat.com> <4A1AC5A3.9000600@gmail.com> <20090525172033.GA12586@redhat.com> <4A1AE02D.5080701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1AE02D.5080701@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25, Jiri Slaby wrote:
>
> On 05/25/2009 07:20 PM, Oleg Nesterov wrote:
> > On 05/25, Jiri Slaby wrote:
> >> If the poll isn't there, it works well.
> >
> > Hmm. this is strange. Do you mean that if this program does
> > sleep(10000) (or something else) instead of poll() above, it
> > prints pend != 0 ?
>
> No, only when there is nothing, i.e. when it directly calls close. It's
> consistent with what you wrote. When there is sleep(), it works the same
> as the poll case.

Good ;)

> > And. Why do you need fatal_signal_pending() ? It is special,
> > should be used by things like wait_event_killable().
>
> I need to wait for a device to finish its work in last release, but also
> want to allow user to kill the waiting by SIGKILL if he thinks the
> device locked up (this is pretty usual for that particular device). If I
> use wait_event_killable, I end up with this.

Heh. In this case you have another (long-standing) issue, please note
the "if (p->flags & PF_EXITING)" check in wants_signal().

There is no guarantee the signal will wake up the exiting task task.
Even SIGKILL, even if you use wait_event_interruptible() instead of
_killable.

Oleg.

