Return-Path: <linux-kernel-owner+w=401wt.eu-S1758174AbYGOV4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174AbYGOV4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYGOV43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:56:29 -0400
Received: from mail2.shareable.org ([80.68.89.115]:48950 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbYGOV42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:56:28 -0400
Date: Tue, 15 Jul 2008 22:56:26 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Sage Weil <sage@newdream.net>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, ceph-devel@lists.sourceforge.net
Subject: Re: Recursive directory accounting for size, ctime, etc.
Message-ID: <20080715215626.GB9222@shareable.org>
References: <Pine.LNX.4.64.0806192313530.7379@cobra.newdream.net> <20080715195333.GK21590@fieldses.org> <Pine.LNX.4.64.0807151326130.1976@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807151326130.1976@cobra.newdream.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sage Weil wrote:
> Having fully up to date values would definitely be nice, but unfortunately 
> doesn't play nice with the fact that different parts of the directory 
> hierarchy may be managed by different metadata servers.  A primary goal in 
> implementing this was to minimize any impact on performance.  The uses I 
> had I mind were more in line with quota-based accounting than cache 
> validation.
> 
> I think I can adjust the propagation heuristics/timeouts to make updates 
> seem more or less immediate to a user in most cases, but that won't be 
> sufficient for a tool like git that needs to reliably identify very recent 
> updates.  For backup software wanting a consistent file system image, it 
> should really be operating on a snapshot as well, in which case a delay 
> between taking the snapshot and starting the scan for changes would allow 
> those values to propagate.

I have a similar thing in a distributed database (with some
filesystem-like characteristics) I'm working on.

The way I handle propagating compound values which are derived from
multiple metadata servers, like that, is using leases.  (Similar to
fcntl F_GETLEASE, Windows oplocks, and CPU MESI protocol).

E.g. when a single server is about to modify a file, it grabs a lease
covering the metadata for this file _plus_ leases for the aggregated
values for all parent directories, prior to allowing the file
modification.  The first file modification will be delayed briefly to
do this, but then subsequent modifications, including to other files
covered by the same directories, are instant because those servers
already have leases.  They can renew them asynchronously as needed.

When a client wants the aggregate values for a directory (i.e. total
size of all files recursively under it), it acquires a lease on that
directory only.  To do that, it has to query all the metadata servers
which currently hold a lease covering that.

The net effect is you can use the results for cache validation as the
git example.  There's a network ping-pong if someone is alternately
modifying a file under the tree and reading the aggregate value from a
parent directory elsewhere, but at least the values are always
consistent.  Most times, there is no ping-pong because that's not a
common scenario.

(In my project, you can also specify that some queries are allowed to
be a little out of date, to avoid lease acquisition delays if getting
an inaccurate result fast is better.  That's useful for GUIs, but not
suitable for git-like cache validation.)

-- Jamie
