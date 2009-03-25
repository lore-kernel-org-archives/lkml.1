Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbZCYVp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbZCYVp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 17:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbZCYVpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 17:45:15 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:56424 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbZCYVpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 17:45:14 -0400
From: Eric Anholt <eric@anholt.net>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.sourceforge.net
Subject: DRM lock ordering fix series
Date: Wed, 25 Mar 2009 14:45:04 -0700
Message-Id: <1238017510-26784-1-git-send-email-eric@anholt.net>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's hopefully the final attempt at the lock ordering fix for GEM.  The
problem was introduced in .29 with the GTT mapping support.  We hashed out
a few potential fixes on the mailing list and at OSTS.  Peter's plan was
to use get_user_pages, but it has significant CPU overhead (10% cost to text
rendering, though part of that is due to some dumb userland code.  But it's
dumb userland code we're all running).  Linus's plan was to just try the
atomic copy_from_user and see if it succeeds, then fall back to allocating
space and copying in to the kernel since it'll "never" happen.  Except that
we can't allocate as much as a user may try to copy in in kernel space, so
we'd have had to break up the write into multiple passes dropping the lock
in between, and I wasn't comfortable with that.

So, this time, I try the optimistic Linus path, and if not, fall back to the
slow Peter Zijlstra path.   It seems to be working, and I forced the
slow paths and tested each case against some regression tests I have, so I
think it's good to go.  But I'd love some Reviewed-bys on the ones that are
missing it, because this morning I had to fix 9 bugs in 60 LOC, and that's
just what I caught with testcases.

