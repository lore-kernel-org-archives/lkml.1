Return-Path: <linux-kernel-owner+w=401wt.eu-S1760068AbXHEWrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068AbXHEWrT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 18:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbXHEWrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 18:47:08 -0400
Received: from thunk.org ([69.25.196.29]:56212 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbXHEWrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 18:47:07 -0400
Date: Sun, 5 Aug 2007 18:46:47 -0400
From: Theodore Tso <tytso@mit.edu>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       neilb@suse.de, dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, richard@rsk.demon.co.uk
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070805224646.GC32217@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Florian Weimer <fw@deneb.enyo.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, miklos@szeredi.hu, neilb@suse.de,
	dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
	trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
	richard@rsk.demon.co.uk
References: <20070803123712.987126000@chello.nl> <alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org> <20070804063217.GA25069@elte.hu> <20070804070737.GA940@elte.hu> <20070804103347.GA1956@elte.hu> <alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org> <20070804094119.81d8e533.akpm@linux-foundation.org> <87wswbjejw.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wswbjejw.fsf@mid.deneb.enyo.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2007 at 09:16:35PM +0200, Florian Weimer wrote:
> * Andrew Morton:
> 
> > The easy preventive is to mount with data=writeback.  Maybe that should
> > have been the default.
> 
> The documentation I could find suggests that this may lead to a
> security weakness (old data in blocks of a file that was grown just
> before the crash leaks to a different user).  XFS overwrites that data
> with zeros upon reboot, which tends to irritate users when it happens.
> 
> From this point of view, data=ordered doesn't seem too bad.

The other alternative which addresses the security concern is
data=journal, which if you have a big enough journal, can sometimes be
*faster* than data=ordered or even data=writeback, because it reduces
seeking.  The problem is that it's workload dependent which is better;
if the workload is very, very heavy on data writes, each data block
ends up getting writen twice, once to the journal and once to the
final location on disk, and so this halves your total max write
bandwidth.  But if the workload doesn't do as much writing, and is
very seeky, and or is very, very, fsync()-centric (like a mailhub),
data=journal is probably the right answer.

						- Ted
