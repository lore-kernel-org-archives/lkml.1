Return-Path: <linux-kernel-owner+w=401wt.eu-S1030894AbXDZViW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030894AbXDZViW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 17:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030859AbXDZViV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 17:38:21 -0400
Received: from thunk.org ([69.25.196.29]:55375 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755150AbXDZViU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 17:38:20 -0400
Date: Thu, 26 Apr 2007 17:38:07 -0400
From: Theodore Tso <tytso@mit.edu>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Xavier Bestel <xavier.bestel@free.fr>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
Message-ID: <20070426213806.GE24852@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Nigel Cunningham <nigel@nigel.suspend2.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Xavier Bestel <xavier.bestel@free.fr>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	LKML <linux-kernel@vger.kernel.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com> <1177573348.5025.224.camel@nigel.suspend2.net> <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org> <1177607026.30284.197.camel@frg-rhel40-em64t-04> <alpine.LFD.0.98.0704261021160.9964@woody.linux-foundation.org> <1177618081.4737.42.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177618081.4737.42.camel@nigel.suspend2.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 06:08:01AM +1000, Nigel Cunningham wrote:
> We tried that. It would need some work. IIRC remounting filesystems
> read-only makes files become marked read-only. Perfectly sensible,
> except that if you then remount the filesystem rw at resume time, all
> those files are still marked ro and userspace crashes and burns. Not
> unfixable, I'll agree, but there is more work to do there.

There are other solutions, though.  One is that we could export a
system call interface which freezes a filesystem and prevents any
further I/O.  We mostly have something like that right now (via the
the write_super_lockfs function in the superblock operations
structure), but we haven't exported it to userspace.  And right now
not all filesystems support it, but in theory that could be fixed (or
you only suppor suspend/resume if all filesystems support lockfs).

We would also need a similar interface to freeze any block device I/O,
in case you have a database running and doing direct I/O to a block
device.  (Or again, we could simply not support that case; how many
people will be running running a database accessing a block deivce on
their laptop?)

So in order to do this right, we would have to double the number of
new interfaces needed from the two proposed by Linus --- which is why
I think the userspace suspend solution is fundamentally NOT the right
one.  Rather the right one is the one which Linux ultimately used for
PCMCIA, which is to do it all in the kernel.

						- Ted
