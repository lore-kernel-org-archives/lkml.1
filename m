Return-Path: <linux-kernel-owner+w=401wt.eu-S1755822AbYKDUjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbYKDUjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 15:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615AbYKDUjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 15:39:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47307 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513AbYKDUjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 15:39:21 -0500
Date: Tue, 4 Nov 2008 15:38:35 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH] lockd: convert reclaimer thread to kthread interface
Message-ID: <20081104153835.04f4f05e@tleilax.poochiereds.net>
In-Reply-To: <1225829834.30407.38.camel@heimdal.trondhjem.org>
References: <1225278945-15407-1-git-send-email-jlayton@redhat.com>
	<20081103131215.75a83236.akpm@linux-foundation.org>
	<20081103191924.16528bfd@tleilax.poochiereds.net>
	<1225802508.19864.2.camel@heimdal.trondhjem.org>
	<20081104134235.0382c873@tleilax.poochiereds.net>
	<1225826781.30407.11.camel@heimdal.trondhjem.org>
	<20081104144652.18d2910d@tleilax.poochiereds.net>
	<1225829834.30407.38.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Nov 2008 15:17:14 -0500
Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> On Tue, 2008-11-04 at 14:46 -0500, Jeff Layton wrote:
> > On Tue, 04 Nov 2008 14:26:21 -0500
> > Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > 
> > > On Tue, 2008-11-04 at 13:42 -0500, Jeff Layton wrote:
> > > > While we're on the subject of signals...
> > > > 
> > > > Do you have any thoughts/objections to just making the reclaimer thread
> > > > ignore them altogether? That would simplify the code a bit.
> > > 
> > > How does the administrator then get out of the situation where the
> > > server dies (permanently) in the middle of a reclaim?
> > > 
> > 
> > Erm...Reboot? :)
> > 
> > Ok, I'm convinced. I suppose that's a good enough argument for
> > continuing to allow SIGKILL. I guess the only change we need to make to
> > this patch for now is to remove the "memory leak" comment (unless there
> > is a leak and I'm just not seeing it).
> 
> Hold on... I'm not saying that I'm absolutely wedded to the idea of
> SIGKILL. I'm just stating the reason for allowing it in the first place.
> 
> All booting NLM servers will have a finite grace period during which
> lock recovery is allowed, so it is obvious that retrying each RPC call
> forever is not a good solution. The questions are then "How long do you
> wait before giving up?" and "What do you do after timing out?".
> 
> One solution may be to let the administrator set a time-out via a
> sysctl, and then set a policy for how to deal with the failure. A
> reasonable set of possible policies may be to either retry recovery at a
> later time, or to wait for a new reboot notification from the server, or
> at some point to start sending out SIGLOST to the applications...
> 

Fair enough -- those are good ideas. For now, I think keeping the
signaling in place is probably reasonable since we do want to allow the
admin to take down the thread. 

Long term, adding better mechanisms to handle failed lock reclaims is
something that ought to be on the to-do list.

-- 
Jeff Layton <jlayton@redhat.com>
