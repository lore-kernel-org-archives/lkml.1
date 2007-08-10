Return-Path: <linux-kernel-owner+w=401wt.eu-S937409AbXHJP0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937409AbXHJP0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 11:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759833AbXHJP0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 11:26:45 -0400
Received: from 24-75-174-210-st.chvlva.adelphia.net ([24.75.174.210]:60005
	"EHLO sanosuke.troilus.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755114AbXHJP0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 11:26:44 -0400
X-Greylist: delayed 2084 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Aug 2007 11:26:44 EDT
To: Vlad <vladc6@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Noatime vs relatime
References: <233939.75965.qm@web54403.mail.yahoo.com>
From: Michael Poole <mdpoole@troilus.org>
Date: Fri, 10 Aug 2007 10:51:58 -0400
In-Reply-To: <233939.75965.qm@web54403.mail.yahoo.com> (Vlad's message of "Fri\, 10 Aug 2007 07\:26\:46 -0700 \(PDT\)")
Message-ID: <87bqdffnn5.fsf@graviton.dyn.troilus.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vlad writes:

> Relatime seems to be wasteful of both IO resources _and_ CPU cycles.
> Instead of performing a single IO operation (as atime does), relatime
> performs at least three IO operations and three CPU-dependent
> operations:
>
> 1) a read IO operation to find out the old atime
> 2) a read IO operation to find out the old ctime
> 3) a read IO operation to find out the old mtime
> 4) Comparison of "old atime is <= than mtime/ctime"
> 5) Find out current time
> 6) Comparison of "current time minus old atime is > X"
>
> People are going to wonder why all of the sudden everything is running
> so slow due to atimes being updated after a long break.

Filesystems deal with block devices, which have fairly large (at least
512-byte) read and write granularity.  Sane filesystems have atime,
ctime and mtime all in the same block, so one read gets all three.
The file's metadata would be in the cache while it's open anyway.

CPU operations are many orders of magnitude faster than block I/O, so
if steps 4-6 eliminate even a fraction of a percent of atime
writebacks, relatime is a net benefit.  In practice, most files are
read many more times than they are written, and most of those are
eliminated even with step #6.  Academic journals abound with
storage-related studies of read versus write patterns (often including
temporal locality of reference) for various kinds of files; I refer
you to those for details.

Michael.
