Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbZD2J2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbZD2J2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbZD2J2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:28:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41127 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbZD2J2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:28:40 -0400
Date: Wed, 29 Apr 2009 11:28:38 +0200
From: Jan Kara <jack@suse.cz>
To: Theodore Tso <tytso@mit.edu>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/5] ext4: Avoid races caused by on-line resizing and
	SMP memory reordering
Message-ID: <20090429092838.GB18273@duck.suse.cz>
References: <1240717765-16572-1-git-send-email-tytso@mit.edu> <1240717765-16572-2-git-send-email-tytso@mit.edu> <20090428162359.GK21950@atrey.karlin.mff.cuni.cz> <20090428171445.GD24043@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428171445.GD24043@mit.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 28-04-09 13:14:45, Theodore Tso wrote:
> On Tue, Apr 28, 2009 at 06:23:59PM +0200, Jan Kara wrote:
> >   Ouch... Hmm, smp_rmb() isn't completely free and mainly it's a bit
> > ugly and prone to errors (I'm afraid next time someone changes the
> > allocation code, we miss some barriers again)... so.. Maybe a stupid
> > idea but wouldn't it be easier to solve the online resize like: freeze
> > the filesystem, do all the changes required for extend, unfreeze the
> > filesystem?
> 
> Eric suggested a helper function when reading from s_groups_count.
> That would take care of the code maintenance headache.  One problem
> with using freeze/thaw is it won't work without a journal, and we do
> support filesystems without journals in ext4.  (Probably the best
> solution for netbooks with crapola SSD's.)
  Well, in non-journalling case, we could introduce a rw semaphore
(read acquired / released in journal_start / journal_stop, write acquired
when the fs is frozen). This might be useful for other rare cases where
freezing the fs would be beneficial. But yes, if wrapping into a helper
function works then that might be the easiest way to go.

> As far as smb_rmb() not being free, it's essentially free for
> x86/x86_64 platforms.  Is it really that costly on other
> architectures?
  I had a feeling that it's not that expensive but not quite free either on
x86/x86_64 (I know even less about other archs) - it has to lock the bus,
writes in local CPU caches have to be flushed, no? Probably we don't care
given the size of the functions doing allocation... As an excercise I was
trying to google some numbers but was not really successful, just some
comments about tens of cycles in some emails...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
