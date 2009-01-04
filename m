Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbZADCca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbZADCca (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 21:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbZADCcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 21:32:23 -0500
Received: from thunk.org ([69.25.196.29]:47827 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbZADCcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 21:32:22 -0500
Date: Sat, 3 Jan 2009 21:32:11 -0500
From: Theodore Tso <tytso@mit.edu>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       mtk.manpages@gmail.com, rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
Message-ID: <20090104023211.GJ4758@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Pavel Machek <pavel@suse.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org
References: <20090103123813.GA1512@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090103123813.GA1512@ucw.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 03, 2009 at 01:38:15PM +0100, Pavel Machek wrote:
> +Requirements
> +============
> +
> +Ext3 expects disk/storage subsystem to behave sanely. On sanely
> +behaving disk subsystem, data that have been successfully synced will
> +stay on the disk. Sane means:
> +
> +* writes to media never fail. Even if disk returns error condition during
> +  write, ext3 can't handle that correctly, because success on fsync was already
> +  returned when data hit the journal.
> +
> +	   (Fortunately writes failing are very uncommon on disks, as they
> +	   have spare sectors they use when write fails.)

This is not unique to ext3; per the discussion two weeks ago, this is
largely because of the fsync() interface not possibly being able to
return errors caused by failures when creating or modifying parent
directories.  Given this, it's a bit misleading to place this in the
Documentation/filesystems/ext3.txt.  At the minimum it should include
a discussion about what the issues might be, and given that pretty
much any Unix/Linux filesystem doesn't have a way of reflecting these
errors to application programs, it probably should be in a
filesystem-independent documentation file.

> +* either whole sector is correctly written or nothing is written during
> +  powerfail.
> +
> +	   (Unfortuantely, none of the cheap USB/SD flash cards I seen do behave
> +	   like this, and are unsuitable for ext3. Because RAM tends to fail
> +	   faster than rest of system during powerfail, special hw killing
> +	   DMA transfers may be neccessary. Not sure how common that problem
> +	   is on generic PC machines).

Again, this is true for other filesystems (it was first discovered on
SGI "pizza boxes" machines running XFS, and special hardware changes
added to allow DMA aborts) --- in fact, because of ext3's use of
physical block journaling, it's much more likely that it will recover
from these sorts of errors.  So it's very misleading to have this sort
of discussion in Documentation/filesystems/ext3.txt.

> +* either write caching is disabled, or hw can do barriers and they are enabled.
> +
> +	   (Note that barriers are disabled by default, use "barrier=1"
> +	   mount option after making sure hw can support them). 

We really should get akpm to agree to accept the patch to default
barriers by default instead.  :-)

							- Ted
