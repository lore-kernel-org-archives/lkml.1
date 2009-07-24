Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbZGXTkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbZGXTkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 15:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbZGXTkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 15:40:21 -0400
Received: from fieldses.org ([174.143.236.118]:46761 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbZGXTkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 15:40:20 -0400
Date: Fri, 24 Jul 2009 15:40:12 -0400
To: Sage Weil <sage@newdream.net>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       linux-fsdevel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/19] ceph: address space operations
Message-ID: <20090724194012.GB16811@fieldses.org>
References: <1248292313-31326-4-git-send-email-sage@newdream.net> <1248292313-31326-5-git-send-email-sage@newdream.net> <1248292313-31326-6-git-send-email-sage@newdream.net> <1248292313-31326-7-git-send-email-sage@newdream.net> <1248292313-31326-8-git-send-email-sage@newdream.net> <1248292313-31326-9-git-send-email-sage@newdream.net> <874ot33ddd.fsf@basil.nowhere.org> <Pine.LNX.4.64.0907231122070.2930@cobra.newdream.net> <1248374834.6139.13.camel@heimdal.trondhjem.org> <Pine.LNX.4.64.0907231642590.2930@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907231642590.2930@cobra.newdream.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 09:44:57PM -0700, Sage Weil wrote:
> On Thu, 23 Jul 2009, Trond Myklebust wrote:
> > On Thu, 2009-07-23 at 11:26 -0700, Sage Weil wrote:
> > > A related question I had on writepages failures: what is the 'right' thing 
> > > to do if we get a server error on writeback?  If we believe it may be 
> > > transient (say, ENOSPC), should we redirty pages and hope for better luck 
> > > next time?
> > 
> > How would ENOSPC be transient? On most systems, ENOSPC requires some
> > kind of user action in order to allow recovery, so will they pass the
> > error back to the application.
> 
> In a distributed environment, other users may be deleting data, or the 
> cluster might be expanding/rebalancing as new storage is added to the 
> system.

The client doesn't have much ability to distinguish between these cases,
so if you wanted to handle them I'd think the way to do it would be by
adding errors in the protocol.  (E.g. your MDS could use something like
"EJUKEBOX" to mean "I'm bringing new storage online" or "a user just
asked me to truncate a 5TB file", and reserve "ENOSPC" for the case
where the next call isn't going to succeed without somebody's help.)

> Of course, any retry after ENOSPC should be limited to a small 
> number of additional attempts.

There may be cases when the delay returning ENOSPC becomes annoying.

--b.
