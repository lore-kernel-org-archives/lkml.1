Return-Path: <linux-kernel-owner+w=401wt.eu-S1753558AbZDYIHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbZDYIHP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 04:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbZDYIGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 04:06:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48944 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbZDYIGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 04:06:51 -0400
Date: Sat, 25 Apr 2009 09:06:49 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: npiggin@suse.de, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/27] [rfc] vfs scalability patchset
Message-ID: <20090425080649.GA8633@ZenIV.linux.org.uk>
References: <20090425012020.457460929@suse.de> <20090425041829.GX8633@ZenIV.linux.org.uk> <20090425080143.GA29033@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090425080143.GA29033@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 04:01:43AM -0400, Christoph Hellwig wrote:
> On Sat, Apr 25, 2009 at 05:18:29AM +0100, Al Viro wrote:
> > However, files_lock part 2 looks very dubious - if nothing else, I would
> > expect that you'll get *more* cross-CPU traffic that way, since the CPU
> > where final fput() runs will correlate only weakly (if at all) with one
> > where open() had been done.  So you are getting more cachelines bouncing.
> > I want to see the numbers for this one, and on different kinds of loads,
> > but as it is I've very sceptical.  BTW, could you try to collect stats
> > along the lines of "CPU #i has done N_{i,j} removals from sb list for
> > files that had been in list #j"?
> > 
> > Splitting files_lock on per-sb basis might be an interesting variant, too.
> 
> We should just kill files_lock and s_files completely.  The remaining
> user are may remount r/o checks, and with counters in place not only on
> the vfsmount but also on the superblock we can kill fs_may_remount_ro in
> it's current form.  The only interesting bit left after that is
> mark_files_ro which is so buggy that I'd prefer to kill it including the
> underlying functionality.

Maybe...  What Eric proposed is essentially a reuse of s_list for per-inode
list of struct file.  Presumably with something like i_lock for protection.
So that's not a conflict.
