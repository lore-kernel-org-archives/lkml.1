Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbZF3IdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbZF3IdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 04:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbZF3IdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 04:33:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54029 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751088AbZF3Ic7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 04:32:59 -0400
Date: Tue, 30 Jun 2009 09:34:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Lennart Poettering <lennart@poettering.net>
Cc: linux-kernel@vger.kernel.org, William Jon McCann <jmccann@redhat.com>
Subject: Re: [PATCH] vt: extend VT_WAITACTIVE ioctl to allow waiting until a
 specific VT becomes inactive
Message-ID: <20090630093418.4670980e@lxorguk.ukuu.org.uk>
In-Reply-To: <20090630000003.GA21004@omega>
References: <20090630000003.GA21004@omega>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009 02:00:04 +0200
Lennart Poettering <lennart@poettering.net> wrote:

> Currently, the VT_WAITACTIVE ioctl can be used to wait until a
> specific VT becomes _active_. 

Well sort of - by the time it returns another VT may have switched again
unless you are using all the VT locking mess. Ditto with your changesit
seems.

> This is used by ConsoleKit

Yes someone posted a similar patch over a year ago (but ignored the
request for a signed-off-by) and his consolekit bug which was marked "Not
a bug" and ignored. I'm aware of this issue and the original patch would
have been merged but for the signed-off-by: issue.

> which VT is the active one.  This patch extends this logic in a simple
> way, so that it can be used to wait until a specific VT becomes
> _inactive_.

Only it may have become active again by the time the call returns or it
may have become active and inactive again and be missed.

> will get a woken up once for each VT change. Having that many threads
> around is certainly ugly and also racy, since multiple quick VT changes

Good to see this has finally been accepted.

>   /* this will wait until VT 5 is activated */
>   ioctl(0, VT_WAITACTIVE, 5L);

I'd rather
	ioctl(0, VT_WAITINACTIVE, ...)

[and both waits should be bitmasks of consoles but its a bit late for
that]

but wouldn't the following be a more useful looking call for most stuff

	struct vtevent vtinfo {
		int event;
#define VT_EVENT_SWITCH		1
#define VT_EVENT_BLANK		2
#define VT_EVENT_UNBLANK	3
#define VT_EVENT_RESIZE		4
		unsigned int old;
		unsigned int new;
		unsigned int pad[4];
	}
	ioctl(0, VT_WAITEVENT, &vtinfo);

either way adding magic "negative number" semantics to VT_WAITACTIVE
isn't very nice.

We have an open bug for VT blank reporting to user space (and the
notifier hooks internally to do it). We also have races with the implicit
races in the WAITfoo APIs unless you are using the VT locking/change
stuff for things like X11

It looks like the job could be done better once even if for the moment it
simply reports VT changes.


