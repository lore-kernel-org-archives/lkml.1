Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbXEIVJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbXEIVJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 17:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758604AbXEIVJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 17:09:48 -0400
Received: from gw.goop.org ([64.81.55.164]:39859 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758524AbXEIVJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 17:09:47 -0400
Message-ID: <4642389E.4080804@goop.org>
Date: Wed, 09 May 2007 14:09:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>
Subject: 2.6.21-git10/11: files getting truncated on xfs? or maybe an nlink
 problem?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've had a couple of instances of a linux-2.6 mercurial repo getting
corrupted in some odd way this morning.  It looks like files are being
truncated; not to size 0, but losing something off the end.

This is on an xfs filesystem.  I haven't had any crashes/oops, and I
don't think its the normal files getting filled with 0 problem.  I saw
this before the most recent set of xfs updates, but it happened again
afterwards too.

Mercurial uses a strictly append-only model for updating its repo files,
but it looks like maybe an append operation didn't stick.

I'm repulling a fresh copy of the repo; I'll be able to compare
before/after.  Update: yep, definitely truncated:

$ ls -l .hg-new/store/data/_documentation/pi-futex.txt.i .hg-broken/store/data/_documentation/pi-futex.txt.i
4 -rw-rw-r-- 1 jeremy jeremy 3309 May  9 09:43 .hg-broken/store/data/_documentation/pi-futex.txt.i
4 -rw-rw-r-- 1 jeremy jeremy 3797 May  9 13:38 .hg-new/store/data/_documentation/pi-futex.txt.i

also
  3476 -rw-rw-r--  1 jeremy jeremy   3558208 May  9 13:55 00manifest.i
  3476 -rw-rw-r--  1 jeremy jeremy   3555200 May  9 09:41 00manifest.i~


where 00manifest.i~ is the broken one. The files are identical up to the
truncation point.

The repo passed "hg verify" just after I pulled it, so this corruption
came about after a while.

Hm, the other possibility is that nlinks is being misreported.  When
cloning a repo, mercurial will generally hard-link files where possible,
and then break the link if it sees nlink > 1.  If xfs is mis-reporting
the link count, then this will cause havok.  Is that possible?  Seems
unlikely, but it would also explain the symptoms.  I just did a linking
clone with an older kernel, and the link count is as expected.

xfs_check passes without any output, which I presume is good.

    J
