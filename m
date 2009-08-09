Return-Path: <linux-kernel-owner+w=401wt.eu-S1751853AbZHIFqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbZHIFqL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 01:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbZHIFqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 01:46:10 -0400
Received: from mail2.shareable.org ([80.68.89.115]:43035 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbZHIFqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 01:46:10 -0400
Date: Sun, 9 Aug 2009 06:46:01 +0100
From: Jamie Lokier <jamie@shareable.org>
To: eranian@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, oleg@redhat.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       robert.richter@amd.com, paulus@samba.org, andi@firstfloor.org,
       mpjohn@us.ibm.com, cel@us.ibm.com, cjashfor@us.ibm.com,
       mucci@eecs.utk.edu, terpstra@eecs.utk.edu,
       perfmon2-devel@lists.sourceforge.net, mtk.manpages@googlemail.com,
       roland@redhat.com
Subject: F_SETOWN_TID: F_SETOWN was thread-specific for a while
Message-ID: <20090809054601.GA26152@shareable.org>
References: <7c86c4470907270951i48886d56g90bc198f26bb0716@mail.gmail.com> <1248869948.6987.3083.camel@twins> <20090729221703.GA25368@redhat.com> <1248953485.6391.41.camel@twins> <20090730192040.GA9503@redhat.com> <1248984003.4164.0.camel@laptop> <20090730202804.GA13675@redhat.com> <1249029320.6391.72.camel@twins> <20090731141122.a1939712.akpm@linux-foundation.org> <7c86c4470908030553v5a0a4448p94ab612700d68066@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470908030553v5a0a4448p94ab612700d68066@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stephane eranian wrote:
> As Peter found out, the man page seems to indicate that if you specify a TID
> instead a PID with F_SETOWN, then the kernel should interpret this as meaning
> this particular thread, but this is not what is implemented right now.

The behaviour was changed quietly in kernel 2.6.12.

I wrote that part of the man page, and it was true at the time.  SIGIO
signals _were_ thread-specific.

Starting in kernel 2.5.60, SIGIO signals were thread-specific when
F_SETSIG was used to enable queued siginfo.

Prompted by this F_SETOWN_TID patch, I checked through old kernel
patches, and found that signals set by F_SIGSIG were changed to
process-wide in 2.6.12:

    @@ -437,7 +438,7 @@ static void send_sigio_to_task(struct ta
			    else
				    si.si_band = band_table[reason - POLL_IN];
			    si.si_fd    = fd;
    -                       if (!send_sig_info(fown->signum, &si, p))
    +                       if (!send_group_sig_info(fown->signum, &si, p))
				    break;
		    /* fall-through: fall back on the old plain SIGIO signal */
		    case 0:

That's a bit annoying, because it breaks a library which uses queued
I/O signals as an I/O event mechanism when used with multiple threads.
(Fortunatelly epoll is available nowadays; it does I/O events much
better, but sometimes you want SIGIO from epoll's descriptor...)

So the man page is now incorrect, but if F_SETOWN_TID is added and has
the behaviour which F_SETOWN used to have, then the text can be
shuffled around.

If anyone is interested, I have a fairly detailed test program which
checks queued "SIGIO" (F_SETSIG) signals due to I/O on a socket,
including SIGURG and SIGIO on overflow, and checks whether each one is
delivered properly and is thread-specific.  I found quite a few Glibc
and kernel bugs with it in the past.

-- Jamie
