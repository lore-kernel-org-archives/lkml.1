Return-Path: <linux-kernel-owner+w=401wt.eu-S1760229AbZE0NBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760229AbZE0NBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 09:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762745AbZE0NBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 09:01:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47969 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762435AbZE0NBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 09:01:08 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: npiggin@suse.de, linux-ext4@vger.kernel.org
Subject: [PATCH 0/11] Fix page_mkwrite() for blocksize < pagesize
Date: Wed, 27 May 2009 15:00:57 +0200
Message-Id: <1243429268-3028-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


patches below are an attempt to solve problems filesystems have with
page_mkwrite() when blocksize < pagesize (see the changelog of the third patch
for details).

The series is against 2.6.30-rc7. The first two patches are just small cleanup
and should be merged separately (Ted should have the ext4 cleanup rebased on
top of current ext4 tree). For ext3 the fix is done in two phases, in the first
we make it to correctly allocate space at page-fault time from page_mkwrite().
This has the disadvantage that under random mmaped writes, the file gets much
more fragmented and performance of e.g. Berkeley DB drops by ~20%. Therefore
in the second phase I've implemented delayed allocation for ext3 and blocks
are just reserved during page_mkwrite time and really allocated only during
writepage. This gets the performance back to original numbers for me.

The patches should be fairly complete and sustained quite some testing. OTOH
the area is kind of complex so please review them so that they can get merged.
Thanks.

									Honza
