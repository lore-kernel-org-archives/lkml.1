Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbZC2WVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbZC2WVo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 18:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbZC2WVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 18:21:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53802 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZC2WVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 18:21:32 -0400
Date: Sun, 29 Mar 2009 23:20:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Malicki <jmalicki@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Kenneth Baker <bakerk@metacarta.com>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Q: check_unsafe_exec() races (Was: [PATCH 2/4] fix setuid
	sometimes doesn't)
Message-ID: <20090329222022.GJ28946@ZenIV.linux.org.uk>
References: <Pine.LNX.4.64.0903282307050.14892@blonde.anvils> <Pine.LNX.4.64.0903282319270.15432@blonde.anvils> <20090329005343.GA12139@redhat.com> <20090329041022.GF28946@ZenIV.linux.org.uk> <20090329045206.GA15519@redhat.com> <20090329055513.GH28946@ZenIV.linux.org.uk> <20090329060118.GI28946@ZenIV.linux.org.uk> <20090329213635.GA21820@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090329213635.GA21820@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 11:36:35PM +0200, Oleg Nesterov wrote:
> > ... or just do that to fs_struct.  After finding that there's no outside
> > users.  Commenst?
> 
> This is even worse. Not only we race with our sub-threads, we race
> with CLONE_FS processes.
> 
> We can't mark fs_struct after finding that there's no outside users
> lockless. Because we can't know whether this is "after" or not, we
> can't trust "atomic_read(fs->count) <= n_fs".

We can lock fs_struct in question, go through the threads, then mark
or bail out.  With cloning a reference to fs_struct protected by the
same lock.

FWIW, I'm not at all sure that we want atomic_t for refcount in that
case...
