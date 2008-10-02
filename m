Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbYJBQN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbYJBQN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 12:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbYJBQNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 12:13:19 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:24194 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbYJBQNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 12:13:19 -0400
Subject: Re: [PATCH] Improve buffered streaming write ordering
From: Chris Mason <chris.mason@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <1222950054.6745.18.camel@think.oraclecorp.com>
References: <1222886451.9158.34.camel@think.oraclecorp.com>
	 <20081001215239.ee2ae63f.akpm@linux-foundation.org>
	 <1222950054.6745.18.camel@think.oraclecorp.com>
Content-Type: text/plain
Date: Thu, 02 Oct 2008 12:12:35 -0400
Message-Id: <1222963955.12099.12.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-02 at 08:20 -0400, Chris Mason wrote:
> On Wed, 2008-10-01 at 21:52 -0700, Andrew Morton wrote:
> > On Wed, 01 Oct 2008 14:40:51 -0400 Chris Mason <chris.mason@oracle.com> wrote:
> > 
> > > The patch below changes write_cache_pages to only use writeback_index
> > > when current_is_pdflush().  The basic idea is that pdflush is the only
> > > one who has concurrency control against the bdi, so it is the only one
> > > who can safely use and update writeback_index.
> > 
> > Another approach would be to only update mapping->writeback_index if
> > nobody else altered it meanwhile.
> > 
> 
> Ok, I can give that a short.
> 

I tried a few variations on letting anyone update writeback_index if it
hadn't changed, including always letting pdflush update it, and only
letting non-pdflush update it when walking forward in the file.

They all performed badly for both xfs and ext4, making me think the real
benefit from my patch comes with making non-pdflush writers start at 0.

So I'm a bit conflicted on this one.  The filesystems could be doing
better, but the current logic in write_cache_pages isn't very
predictable.

-chris


