Return-Path: <linux-kernel-owner+w=401wt.eu-S1757228AbYEAGYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbYEAGYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 02:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbYEAGYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 02:24:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34257 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbYEAGYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 02:24:39 -0400
Date: Thu, 1 May 2008 07:24:32 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Bryan Wu <cooloney@kernel.org>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       willy@debian.org, uclinux-dist-devel@blackfin.uclinux.org,
       richterd@citi.umich.edu
Subject: Re: [LTP/VFS] fcntl SETLEASE fails on ramfs/tmpfs
Message-ID: <20080501062432.GT5882@ZenIV.linux.org.uk>
References: <386072610804282042y2dda4b52h927683a8a938ce1f@mail.gmail.com> <20080429135454.efebec8f.akpm@linux-foundation.org> <20080429214231.GC26468@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429214231.GC26468@fieldses.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 05:42:31PM -0400, J. Bruce Fields wrote:
> The most likely consequences are that a local reader gets out-of-date
> data for a file that a Samba client has modified.
> 
> I suppose that re-checking the d_count and i_count after step 3 might
> close the race.
 
The hell it might.  Leases are broken, plain and simple.  Not to mention
anything else, a couple of threads with shared descriptor table will
bypass these checks happily.

FWIW, that's far from the worst problem in fs/locks.c, and not even the
worst one with leases.

That, BTW, is a fine demonstration of the reasons why application-specific
kernel warts(tm) are bad.  Lease support is samba-only turd; so's dnotify,
with its lovely problems.  And interfaces like that *suck*; they are
developed with one application in mind and that leads to "we know how it
will be used" mentality.  With obvious implications for quality of review
they get from their developers...

Al, currently crawling through struct file_lock review and extremely annoyed
by the amount of turds being found...
