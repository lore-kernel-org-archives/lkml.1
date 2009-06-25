Return-Path: <linux-kernel-owner+w=401wt.eu-S1760311AbZFYTpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760311AbZFYTpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 15:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760072AbZFYToi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 15:44:38 -0400
Received: from thunk.org ([69.25.196.29]:49347 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759922AbZFYToh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 15:44:37 -0400
Date: Thu, 25 Jun 2009 15:44:23 -0400
From: Theodore Tso <tytso@mit.edu>
To: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, penberg@cs.helsinki.fi,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Message-ID: <20090625194423.GB6472@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Rientjes <rientjes@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	penberg@cs.helsinki.fi, arjan@infradead.org,
	linux-kernel@vger.kernel.org, cl@linux-foundation.org,
	npiggin@suse.de
References: <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain> <20090624123624.26c93459.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090624130121.99321cca.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <alpine.LFD.2.01.0906241334260.3154@localhost.localdomain> <20090624150714.c7264768.akpm@linux-foundation.org> <20090625132544.GB9995@mit.edu> <alpine.DEB.2.00.0906251135440.30090@chino.kir.corp.google.com> <20090625193806.GA6472@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090625193806.GA6472@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 03:38:06PM -0400, Theodore Tso wrote:
> Hmm, is there a reason to avoid using GFP_ATOMIC on the first
> allocation, and only adding GFP_ATOMIC after the first failure?

Never mind, stupid question; I hit the send button before thinking
about this enough.  Obviously we should try without GFP_ATOMIC so the
allocator can try to release some memory.  So maybe the answer for
filesystem code where the alternative to allocator failure is
remounting the root filesystem read-only or panic(), should be:

1)  Try to do the allocation GFP_NOFS.

2)  Then try GFP_ATOMIC

3) Then retry the allocator with GFP_NOFS in a loop (possibly with a
timeout than then panic's the system and allows the system to reboot,
although arguably a watchdot timer should really perform that
function).

Obviously if we can rework the filesystem code to avoid this as much
as possible, this would be desirable, but if there are some cases left
over where we really have no choice, that's probably what we should
do.

						- Ted
