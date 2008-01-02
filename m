Return-Path: <linux-kernel-owner+w=401wt.eu-S1758547AbYABUMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547AbYABUMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758065AbYABUMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:12:24 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52728 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757296AbYABUMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:12:22 -0500
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080102194030.GC11638@parisc-linux.org>
References: <20080102162534.GA4041@elte.hu>
	 <1199292381.3258.32.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org>
	 <20080102194030.GC11638@parisc-linux.org>
Content-Type: text/plain
Date: Wed, 02 Jan 2008 14:12:15 -0600
Message-Id: <1199304735.3258.53.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-02 at 12:40 -0700, Matthew Wilcox wrote:
> On Wed, Jan 02, 2008 at 11:19:14AM -0800, Linus Torvalds wrote:
> > It's totally immaterial if we have one reporter or many. The fact is, that 
> > thing has been outstanding for almost two months now. The root cause is 
> > almost certainly known (and Matthew is apparently even aware of it), but 
> 
> I really don't think the root cause is known.
> 
> > By now, it needs to either have a patch, or to be reverted. It's too late 
> > to make excuses.
> 
> I think reverting it is the correct thing to do.

OK ... I'll revert it.  However, I still think it's the wrong course of
action, because as far as my analysis goes, this code is functionally
equivalent to what went before with the exception that we now rely on
the request->cmd_type information in the post processing (previously we
just relied on the cmnd->done pointer).

As far as I understand what's going on, the reporter is misusing the
interface.  He sets up a packet mapping and then accesses the underlying
device, which is wrong (you're supposed to access now via the packet
device).  The one thing the packet mapping does is to alter the
blocksize, which could lead to the errors reported (because the
underlying fs block size and the actual block size differ) ... however,
I think it should do this all the time, so what I'm unable to explain is
why it doesn't write past the end of the device with this commit
reverted.

But all of the above is the hallmark of an existing bug that this commit
exposes ... revert it, and we'll cover the underlying problem up again.

James


