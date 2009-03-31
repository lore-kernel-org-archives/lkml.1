Return-Path: <linux-kernel-owner+w=401wt.eu-S1762490AbZCaGVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762490AbZCaGVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 02:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758471AbZCaGVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 02:21:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33330 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895AbZCaGVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 02:21:01 -0400
Date: Tue, 31 Mar 2009 07:19:53 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Hugh Dickins <hugh@veritas.com>,
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
Message-ID: <20090331061953.GT28946@ZenIV.linux.org.uk>
References: <20090329213635.GA21820@redhat.com> <20090329222022.GJ28946@ZenIV.linux.org.uk> <20090329235639.GA32199@redhat.com> <20090330000338.GB32199@redhat.com> <20090330010843.GM28946@ZenIV.linux.org.uk> <20090330011303.GN28946@ZenIV.linux.org.uk> <20090330013612.GA4080@redhat.com> <20090330014040.GA4807@redhat.com> <20090330123101.GQ28946@ZenIV.linux.org.uk> <20090330234539.GA3462@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090330234539.GA3462@us.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 06:45:39PM -0500, Serge E. Hallyn wrote:

> (note exactly *meaningful* review, but)
> 
> exit_fs() and daemonize_fs_struct() do:
> 
>                 if (--fs->users)
>                         fs = NULL;
>                 write_unlock(&fs->lock);
> 
> Moving the write_unlock up actually let's the kernel boot and
> start running ltp.

Correct fix is
		kill = !--fs->users;
		write_unlock(&fs->lock);
		...
		if (kill)
			free_fs_struct(fs);
and similar in other places with the same idiocy (one of which forgets to
unlock, on top of everything else).

Anyway, hopefully much saner (== looked through after getting some sleep,
as opposed to "what I've got in that branch at ~26 hours of uptime")
variant is in the same repository, same branch.
