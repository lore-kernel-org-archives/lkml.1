Return-Path: <linux-kernel-owner+w=401wt.eu-S1759824AbZDBRQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759824AbZDBRQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 13:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754962AbZDBRP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 13:15:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59266 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420AbZDBRP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:15:58 -0400
Subject: Re: Issues with using fanotify for a filesystem indexer
From: Alexander Larsson <alexl@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: eparis@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20090402165023.GG3010@duck.suse.cz>
References: <1238158043.23703.20.camel@fatty>
	 <20090402145457.GA17275@atrey.karlin.mff.cuni.cz>
	 <1238689744.5704.1.camel@localhost.localdomain>
	 <20090402165023.GG3010@duck.suse.cz>
Content-Type: text/plain
Organization: Red Hat
Date: Thu, 02 Apr 2009 19:15:37 +0200
Message-Id: <1238692537.5704.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 18:50 +0200, Jan Kara wrote:
> On Thu 02-04-09 18:29:04, Alexander Larsson wrote:
> > Another potential issue with this is that every change bubbles up to the
> > top, modifying the recursive mtime of that. This will become very
> > contented, and may imply a partial serialization of fs activity, which
> > is kinda costly.
>   Not every change - only the first change bubbles to the top, clearing the
> flag on its way. Then next change stops bubbling up as soon as it reaches
> a directory with the flag cleared. So no contention happen - we update flag
> + timestamp only at most once per scan of the directory by indexer (or
> someone else interested in recursive mtime) => once per a few minutes on
> average system.

Ah, I see. The indexer sets the flag. 
I see some issues. First of all, writing the flag/mtime to disk seems
like a bad idea. It'll cause a lot of writing when the indexer recurses
throught the filesystem, similar to atimes. But, if you're not
persisting the flag/mtime then you need to keep all the dentries with
the flag set in memory, which has resource use risks similar to
unbounded event queues.


