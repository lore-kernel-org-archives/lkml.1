Return-Path: <linux-kernel-owner+w=401wt.eu-S1754240AbXDQBf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbXDQBf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 21:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbXDQBf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 21:35:26 -0400
Received: from mail.suse.de ([195.135.220.2]:54913 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbXDQBfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 21:35:24 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [AppArmor 31/41] Fix __d_path() for lazy unmounts and make it unambiguous; exclude unreachable mount points from /proc/mounts
Date: Tue, 17 Apr 2007 03:35:21 +0200
User-Agent: KMail/1.9.5
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Andrew Morton <akpm@linux-foundation.org>
References: <20070412090809.917795000@suse.de> <200704151940.22528.agruen@suse.de> <20070416225748.3e5d3003@the-village.bc.nu>
In-Reply-To: <20070416225748.3e5d3003@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704170335.21805.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 April 2007 23:57, Alan Cox wrote:
> I don't believe the existing behaviour _IS_ a mistake.

So what would be the arguments why this behavior makes sense, other than 
legacy?

For /proc/mounts, one could argue that the admin might want to see everything, 
but then that's not actually true even today because /proc/mounts doesn't 
show lazyily unmounted stuff or mounts from other namespaces, so that 
everything is quite relative.

Along that line of argumentation, I would at least expect unambiguous output, 
to be able to tell which mountpoints are actually meaningful to the 
requesting process. It's not only human operators looking at /proc/mounts; 
applications care as well.

But after thinking about this issue quite a while, I really can't see what 
that should be good for. The current /proc/mounts interface is obviously 
broken; the chroot example should have demonstrated that. There are also 
unnecessary special cases because of that, such as having to filter out the 
rootfs entry when trying to figure out what's really mounted on /, and having 
to guess what's there and what's not in a particular context. The more 
complex mount scenarios will get, the more obviously broken the 
current /proc/mounts interface will become.

The getcwd() case is even stronger as the "see everything" argument makes even 
less sense there. I really can't see why the kernel should return processes 
fake pathnames. The process is explicitly asking for the current pathname to 
the working directory, it doesn't want to know what the pathname was at some 
previous point in time.

> > Process can access file descriptors which are unreachable via path name
> > just fine indeed, but those fds still don't have a valid path in the
> > context of that process.
> 
> Which while problematic to your name based security is just fine to
> everything else.

Actually, no. We could live fine with leaving getcwd() and /proc/mounts as 
ambiguous / weird / broken as they are right now. All it would take would be 
to reambiguate the result of the unambiguous __d_path(), which is really 
easy. Everything that cares about real pathnames would use the unambiguous 
version while the legacy interfaces would use the ambiguous version. But that 
really wouldn't make sense.

> Ok, providing the "real" root sees them all it isn't so bad, but to
> assume you can filter based upon what the task can see is dodgy as an
> assumption.

Why?

Thanks,
Andreas
