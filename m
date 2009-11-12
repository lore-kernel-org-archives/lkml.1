Return-Path: <linux-kernel-owner+w=401wt.eu-S1759946AbZKLCOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759946AbZKLCOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 21:14:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759910AbZKLCOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 21:14:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:33097 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759907AbZKLCOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 21:14:06 -0500
Date: Wed, 11 Nov 2009 18:15:29 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>, auke-jan.h.kok@intel.com
Subject: Re: [PATCH] vfs: Add a trace point in the mark_inode_dirty function
Message-ID: <20091111181529.64ff5d1d@infradead.org>
In-Reply-To: <20091111182925.GH13262@mit.edu>
References: <20091025225342.007138f5@infradead.org>
	<20091111020108.GA11423@localhost>
	<20091110223456.01ef355f@infradead.org>
	<4AFA6AEF.5060306@garzik.org>
	<20091111074542.GB25132@elte.hu>
	<20091111182925.GH13262@mit.edu>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009 13:29:25 -0500
Theodore Tso <tytso@mit.edu> wrote:
 
> If you really want to avoid that, one relatively lightweight thing we
> could do, which would avoid needing to dump the entire pathname out,
> would be to print out the triple (devno, dir_ino, file_ino), and then
> provide a privileged syscall which translates this to a user-visible
> pathname.  It won't be necessarily the pathname which the user used to
> open the file (since there might be links, and bind mounts, et. al),
> but if the goal is to give one of the user-friendly names of the inode
> (as opposed to _the_ pathname used to open the file), it's quite
> sufficient.


here's the problem. PowerTOP wants to tell you "application FOO caused
the disk to spin up. BAD APPLICATION." And then give a suggestion as to
which file in question was involved, to give the developer a hint as to
what to fix. Oh and this has to be done 30 seconds after the actual
dirty happened of course (since clearly we don't want to wake a cpu up
or interfere with the running system).

What the patch does is perfectly fine for that. Your "solution" to get a
filename 30 seconds later with debugfs involves spinning up the disk...
... exactly the kind of thing this trace point wants to avoid in the
first place! 
(and for those who say "yeah but the file may have been renamed". I
don't care! I want to show the filename that the app dirtied! Not what
name that file is right now, 30 seconds later. At least, I want to show
enough so that the developer of the app knows how to fix his pile of
power-eating-dung.

Fixing an OS this way (and yes I have used this patch to fix Moblin and
other partner linux OSes) saves around 0.5 Watts or so. Quite worth it 
in terms of battery life.

I would like to turn this around: The current patch is sufficient for my
real-world usecase. I am still looking for the "other" mythical usecase
that would need an inode number instead.... lets put it this way: if
one of those comes around it's trivial to extend the trace data in an
ABI compatible way to include that. Until then.. it's just bloat.





-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
