Return-Path: <linux-kernel-owner+w=401wt.eu-S1753753AbZBPPEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbZBPPEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 10:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbZBPPEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 10:04:40 -0500
Received: from cmpxchg.org ([85.214.51.133]:49251 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbZBPPEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 10:04:40 -0500
Message-Id: <20090216142926.440561506@cmpxchg.org>
User-Agent: quilt/0.47-1
Date: Mon, 16 Feb 2009 15:29:26 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [patch 0/8] kzfree()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series introduces kzfree() and converts callsites which do
memset() + kfree() explicitely.

The callsites may be incomplete, I used coccinelle [1] to find them.

Regarding the recent re-exporting of ksize() to modules and the
discussion around it [2], this removes the single modular in-tree user
of ksize() again (unless I overgrepped something).

kfree() uses ksize() internally to determine the size of the memory
region to zero out.  This could mean overhead as the size is actually
that of the kmalloc cache the object is from, but memset() + kfree()
isn't really the common fast path pattern.

I left out w1 because I think it doesn't need to zero the memory at
all.  I will take a deeper look into it and send a followup with
either a kzfree() conversion or removal of the memset() alltogether.

	Hannes

[1] http://www.emn.fr/x-info/coccinelle/

	@@
	expression M, S;
	@@

	- memset(M, 0, S);
	- kfree(M);
	+ kzfree(M);

   (from the back of my head, no coccinelle installed on this box)

[2] http://lkml.org/lkml/2009/2/10/144

 arch/s390/crypto/prng.c             |    3 +--
 crypto/api.c                        |    5 +----
 drivers/md/dm-crypt.c               |    6 ++----
 drivers/s390/crypto/zcrypt_pcixcc.c |    3 +--
 drivers/usb/host/hwa-hc.c           |    3 +--
 drivers/usb/wusbcore/cbaf.c         |    3 +--
 fs/cifs/connect.c                   |    7 ++-----
 fs/cifs/misc.c                      |   12 ++++--------
 fs/ecryptfs/keystore.c              |    3 +--
 fs/ecryptfs/messaging.c             |    3 +--
 include/linux/slab.h                |    1 +
 mm/util.c                           |   19 +++++++++++++++++++
 net/atm/mpoa_caches.c               |   14 ++++----------
 13 files changed, 39 insertions(+), 43 deletions(-)

