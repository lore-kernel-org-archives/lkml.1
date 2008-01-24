Return-Path: <linux-kernel-owner+w=401wt.eu-S1758838AbYAXWIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838AbYAXWIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbYAXWIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:08:41 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:33372 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbYAXWIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:08:39 -0500
Date: Thu, 24 Jan 2008 15:07:39 -0700
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] Parallelize IO for e2fsck
In-reply-to: <E1JI5vz-0001GG-Vs@be1.7eggert.dyndns.org>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Valdis.Kletnieks@vt.edu,
       David Chinner <dgc@sgi.com>, Valerie Henson <val@vahconsulting.com>,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
       Andreas Dilger <adilger@clusterfs.com>, Ric Wheeler <ric@emc.com>
Mail-followup-to: Bodo Eggert <7eggert@gmx.de>,
 Alan Cox <alan@lxorguk.ukuu.org.uk>, Valdis.Kletnieks@vt.edu,
 David Chinner <dgc@sgi.com>, Valerie Henson <val@vahconsulting.com>,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
 Andreas Dilger <adilger@clusterfs.com>, Ric Wheeler <ric@emc.com>
Message-id: <20080124220738.GM18433@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <9Mo9w-7Ws-25@gated-at.bofh.it> <9Mo9w-7Ws-23@gated-at.bofh.it>
 <9OdWm-7uN-25@gated-at.bofh.it> <9Oi9A-5EJ-3@gated-at.bofh.it>
 <9OiMg-6IC-1@gated-at.bofh.it> <9OlqL-2xG-3@gated-at.bofh.it>
 <9Orda-3ub-45@gated-at.bofh.it> <E1JI5vz-0001GG-Vs@be1.7eggert.dyndns.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 24, 2008  18:32 +0100, Bodo Eggert wrote:
> I think a single, system-wide signal is the second-to worst solution: All
> applications (or the wrong one, if you select one) would free their caches
> and start to crawl, and either stay in this state or slowly increase their
> caches again until they get signaled again. And the signal would either
> come too early or too late. The userspace daemon could collect the weighted
> demand of memory from all applications and tell them how much to use.

Well, sending a few signals (maybe to the top 5 processes in the OOM killer
list) is still a LOT better than OOM-killing them without warning...  That
way important system processes could be taught to understand SIGDANGER and
maybe do something about it instead of being killed, and if Firefox and
other memory hungry processes flush some of their cache it is not fatal.

I wouldn't think that SIGDANGER means "free all of your cache", since the
memory usage clearly wasn't a problem a few seconds previously, so as
an application writer I'd code it as "flush the oldest 10% of my cache"
or similar, and the kernel could send SIGDANGER again (or kill the real
offender) if the memory usage again becomes an issue.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

