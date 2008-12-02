Return-Path: <linux-kernel-owner+w=401wt.eu-S1751065AbYLBUGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751065AbYLBUGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:06:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbYLBUG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:06:28 -0500
Received: from mail2.shareable.org ([80.68.89.115]:54447 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbYLBUG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:06:26 -0500
Date: Tue, 2 Dec 2008 20:06:21 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Andreas Dilger <adilger@sun.com>
Cc: Steve French <smfrench@gmail.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>
Subject: Re: Support for applications which need NFS or CIFS "share_deny"	flags on open
Message-ID: <20081202200621.GA4451@shareable.org>
References: <524f69650812020831q4e089b87k9a8306ac37f4234a@mail.gmail.com> <20081202193819.GJ3186@webber.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202193819.GJ3186@webber.adilger.int>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Dilger wrote:
> This is a disaster waiting to happen, and I would be against adding
> such functionality to Linux.  It would allow userspace applications
> to implement a denial of service to any file that they can open (e.g.
> open("/lib/libc-2.7.so", O_DENYREAD) would be really bad :-).
> 
> It was always also a pain in the ass on Windows systems (back when I used
> them) that backing up the filesystem would fail because something (app or
> kernel) had files open in this mode and the backup tool couldn't even read
> them to do the backup.  In some cases these files were opened very early
> in boot and the only way to do a full backup was to boot from a separate
> device and run the backup.  Not my idea of fun.

It's a pain on Windows, yes.  It's necessary because you can't delete
or rename over an open file (the unix way), so for files which must be
updated without any program seeing them as temporarily corrup (.exe,
.dll, config files, pid files, etc.) to do it on Windows is
open-with-deny-read and write the new file contents.

> I can't see any reason for O_DENYREAD or O_DENYWRITE that can't be met
> with existing file locking to maintain coherency if that is really needed.

Good point!

Is there any reason why Wine cannot take an advisory lock _every_ time
it opens a file?  That would give Windows apps the behaviour they
expect, including across the network, without DOSing unix apps.

> As for O_DENYDELETE - wouldn't that be irrelevant if the WINE code keeps
> an open file reference?  The data would still be accessible until WINE
> exits, and it wouldn't be a DOS.

Windows apps do expect a file can't disappear while it's open.  This
is one way to detect if an app is running, and this particular
behaviour goes back to the oldest versions of Windows.

Inside a single WINE instance or on a single host, your suggestion
works, but what about Windows apps on different hosts over a network share?

The bit I find interesting is that other CIFS clients are said to
implement these flags.  If that means real unixes, maybe they've
worked out a sensible way to handle them?

-- Jamie
