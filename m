Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776AbYANOGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbYANOGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 09:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbYANOF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 09:05:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbYANOFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 09:05:21 -0500
From: Jeff Layton <jlayton@redhat.com>
To: neilb@suse.de
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Intro: convert lockd to kthread and fix use-after-free (try #8)
Date: Mon, 14 Jan 2008 09:05:14 -0500
Message-Id: <1200319518-22422-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the eighth patchset to fix the use-after-free problem in lockd
which we originally discussed back in October. Along the way, Christoph
Hellwig mentioned that it would be advantageous to convert lockd to use
the kthread API. This patch set first makes that change and then patches
it to actually fix the use after free problem. 

The main changes from the last patchset are:

- dropped the try_to_freeze() patch. svc_recv calls try_to_freeze() too,
  so that wasn't really necessary. I added a comment to clarify that for
  future reference.

- fixed a race whereby make_socks() could get called with a null
  nlmsvc_serv pointer and cause an oops. Thanks to Christoph Hellwig for
  the original patch.

- moved lock_kernel() down slightly in the lockd() function, and
  unlock_kernel() up. It's not much of a change, but it's a start. I
  also added a FIXME comment that we should fix lockd to not run under
  the BKL. Perhaps someone can clarify why lockd() does this.

I've done some very basic testing and everything seems to work as
expected.  I've also tested this against the reproducer that I have for
the use-after-free problem and this does fix it. I've tried to make this
cleanly bisectable, but have only really tested the final result.

Many thanks to Trond Myklebust, Chuck Lever, Neil Brown and Christoph
Hellwig for their guidance on this.

Signed-off-by: Jeff Layton <jlayton@redhat.com>

