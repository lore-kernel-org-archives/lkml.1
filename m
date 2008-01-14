Return-Path: <linux-kernel-owner+w=401wt.eu-S1751438AbYANOZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbYANOZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 09:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbYANOZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 09:25:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbYANOZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 09:25:20 -0500
Date: Mon, 14 Jan 2008 09:24:54 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: akpm@linux-foundation.org, neilb@suse.de, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] NLM: Initialize completion variable in lockd_up
Message-ID: <20080114092454.66a41c29@tleilax.poochiereds.net>
In-Reply-To: <20080113181743.GA20219@infradead.org>
References: <1199820798-5289-1-git-send-email-jlayton@redhat.com>
	<1199820798-5289-2-git-send-email-jlayton@redhat.com>
	<1199820798-5289-3-git-send-email-jlayton@redhat.com>
	<1199820798-5289-4-git-send-email-jlayton@redhat.com>
	<20080109173542.GA30523@infradead.org>
	<20080113082718.396890f7@tleilax.poochiereds.net>
	<20080113181743.GA20219@infradead.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jan 2008 18:17:43 +0000
Christoph Hellwig <hch@infradead.org> wrote:

> On Sun, Jan 13, 2008 at 08:27:18AM -0500, Jeff Layton wrote:
> >    I've been hitting an intermittent null pointer dereference ever
> > since I've made this change:
> 
> The first thing lockd does is to call lock_kernel().  This may either
> block (or spin) when it is contended and thus delay updating
> nlmsvc_serv.  Now lockd_up checks for nlmsvc_task which already is
> non-NULL and happily dereference nlmsvc_serv.   The patch below
> updates nlmsvc_serv in lockd_up where it is protected by nlmsvc_mutex
> and also checks for nlmsvc_serv beeing set instead of nlmsvc_task to
> fix this problem.
> 
> The patch hasn't actually been tested but I'm sure it will fix this
> issue.
> 

Thanks Christoph. I incorporated this into my latest patchset. It does
seem to fix the issue (tested by bouncing NFS up and down for 30 mins
or so). Let me know if you want me to add a signed-off-by line for
you...

> Btw, lockd() takes BKL just after starting up and only implicitly
> drops it when blocking.  This seems very dangerous to me and badly
> wants updating to some real locking scheme..
> 

Yep -- It's ugly. I took a look a while back at what it would take to
change that. The problem is that it's very difficult to tell exactly
what the BKL is intended to protect in. I assume it does it for the same
reason that fs/locks.c uses it, but there may be other things that need
protection if it's removed.

It might be best to try to change this incrementally -- gradually audit
and move pieces of lockd() outside of the BKL, until it's clear that
it's no longer needed.

-- 
Jeff Layton <jlayton@redhat.com>
