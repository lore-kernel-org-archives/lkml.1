Return-Path: <linux-kernel-owner+w=401wt.eu-S1752594AbZIEQq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbZIEQq5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 12:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbZIEQqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 12:46:55 -0400
Received: from THUNK.ORG ([69.25.196.29]:49816 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521AbZIEQqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 12:46:54 -0400
Date: Sat, 5 Sep 2009 12:46:51 -0400
From: Theodore Tso <tytso@mit.edu>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       jack@suse.cz
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
Message-ID: <20090905164651.GJ16217@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Richard Kennedy <richard@rsk.demon.co.uk>,
	Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
	david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
	jack@suse.cz
References: <1252050406-22467-1-git-send-email-jens.axboe@oracle.com> <1252050406-22467-9-git-send-email-jens.axboe@oracle.com> <4AA13232.5000309@rsk.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA13232.5000309@rsk.demon.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 04:28:50PM +0100, Richard Kennedy wrote:
>
> I've been testing this & it works pretty well here, but setting  
> max_writeback_mb to 128 seems much too large for normal desktop machines.
>
> Because it is so large the background writes don't stop when they get  
> down to the background threshold, but just keep on writing.  
> background_threshold on my machine is only about 300Mb so it can  
> undershoot by quite a bit. This could impact random write workloads  
> significantly.

Keep in mind that the threshold has always been on a per-inode basis.
So on a desktop machine where KDE or GNOME decides to dirty (and
write) a few hundred or thousand small files in ~/.gnome or ~/.kde the
1024 MAX_WRITEBACK_PAGES threshold wuldn't stop it.

It doesn't seem likely to me that a desktop machine is likely to have
a random write workload where multiple megabytes worth of random
writes to a single file.  That's more of a heavy database workload,
which tends not to show up on desktop machines.

What is much more likely is that a desktop machine, we might be trying
to write a 800 mb ISO image, and there, stopping after 4mb (1024
pages) is pathetically short place to stall just to seek over to some
other random part of the disk because firefox wants to record that the
user just clicked on some URL, or some KDE app wants to record to disk
the fact that someone just moved or resized a KDE window.

You're right that the amount of time that we might spend doing
background writes does very greatly depending on whether we are doing
lots of small seeky writes, or a big contiguous writes (such as an iso
image or a large mp3 file).  But that's always a problem that we've
had with the current writeout algorithm, and we're not making that
problem any worse with respect to the typical desktop workload, since
the small seeky writes tend to be hundreds of different small dot
files, and changing the max_writeback_{mb,pages} threshold isn't going
to change that.

> Or can the check for the background threshold be pushed further down  
> into writeback_inodes_wb and just check it every N pages? I think this  
> would do a better job but make the code even more complex.

In the long run if we want to cap the amount of work being done in the
threshold, it needs to be a global limit, instead of a per-file limit,
and it needs to take into account whether it is a large contiguous
writeback, or lots of small seeky writes.  But that's a previously
unsolved problem, and I don't think we'll be making that problem any worse.

After all, the workloads that do lots of random writes to a single
file also tend to intersperse those writes with fsync()'s, since
that's also characteristic of database workloads.

						- Ted
