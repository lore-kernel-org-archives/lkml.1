Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbZDYIB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbZDYIB5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 04:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbZDYIBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 04:01:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60058 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbZDYIBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 04:01:46 -0400
Date: Sat, 25 Apr 2009 04:01:43 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: npiggin@suse.de, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/27] [rfc] vfs scalability patchset
Message-ID: <20090425080143.GA29033@infradead.org>
References: <20090425012020.457460929@suse.de> <20090425041829.GX8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090425041829.GX8633@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 05:18:29AM +0100, Al Viro wrote:
> However, files_lock part 2 looks very dubious - if nothing else, I would
> expect that you'll get *more* cross-CPU traffic that way, since the CPU
> where final fput() runs will correlate only weakly (if at all) with one
> where open() had been done.  So you are getting more cachelines bouncing.
> I want to see the numbers for this one, and on different kinds of loads,
> but as it is I've very sceptical.  BTW, could you try to collect stats
> along the lines of "CPU #i has done N_{i,j} removals from sb list for
> files that had been in list #j"?
> 
> Splitting files_lock on per-sb basis might be an interesting variant, too.

We should just kill files_lock and s_files completely.  The remaining
user are may remount r/o checks, and with counters in place not only on
the vfsmount but also on the superblock we can kill fs_may_remount_ro in
it's current form.  The only interesting bit left after that is
mark_files_ro which is so buggy that I'd prefer to kill it including the
underlying functionality.
