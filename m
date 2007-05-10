Return-Path: <linux-kernel-owner+w=401wt.eu-S1760011AbXEJSwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760011AbXEJSwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 14:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbXEJSwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 14:52:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52677 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbXEJSwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 14:52:36 -0400
Date: Thu, 10 May 2007 19:52:26 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Neil Brown <neilb@suse.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utimensat implementation
Message-ID: <20070510185226.GA1458@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Ulrich Drepper <drepper@redhat.com>, Neil Brown <neilb@suse.de>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <200704262249.l3QMn5C2021588@devserv.devel.redhat.com> <17969.22692.855242.359680@notabene.brown> <46315C61.30001@redhat.com> <464363DC.7060607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464363DC.7060607@redhat.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 11:26:36AM -0700, Ulrich Drepper wrote:
> >That's still on the table.  We might end up with an fpathconf() solution.
> 
> OK, the pathconf()-based solution will most probably be in the next 
> POSIX spec.
> 
> Now, somebody has to provide a way to get to this information.  The 
> kernel does not export it so far.  Is it finally time to break down and 
> allow pathconf() and fpathconf() syscalls into the kernel?

I'd be happy to have them.  While it's not the nicest API in the world
it's in Posix and we have to support it at the library level, so we
should better get it right.

I'd like to avoid having a big swithc statement in every filesystem,
though, instead of we should have a table-driven approach instead
where each filesystem defines one table (or multiple ones when it
supports subtypes with different limits) and just sets a pointer in
the superblock to it.

E.g.

long foofs_pathconf {
	[_PC_LINK_MAX]		= 16384,
	[_PC_2_SYMLINKS]	= 1,
	...
}

and then in fill_super:

	sb->s_pathconf = &foofs_pathconf;
