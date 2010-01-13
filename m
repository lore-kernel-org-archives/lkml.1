Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192Ab0AMRPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab0AMRPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 12:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756058Ab0AMRP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 12:15:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756049Ab0AMRP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 12:15:26 -0500
Date: Wed, 13 Jan 2010 19:12:30 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Davide Libenzi <davidel@xmailserver.org>,
       "Michael S. Tsirkin" <mst@redhat.com>, Avi Kivity <avi@redhat.com>,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] kvm: fix spurious interrupt with irqfd
Message-ID: <20100113171230.GB19798@redhat.com>
References: <cover.1263402727.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1263402727.git.mst@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm didn't clear irqfd counter on deassign, as a result we could get a
spurious interrupt when irqfd is assigned back. this leads to poor
performance and, in theory, guest crash.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 virt/kvm/eventfd.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 62e4cd9..a9d3fc6 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -72,12 +72,13 @@ static void
 irqfd_shutdown(struct work_struct *work)
 {
 	struct _irqfd *irqfd = container_of(work, struct _irqfd, shutdown);
+	u64 cnt;
 
 	/*
 	 * Synchronize with the wait-queue and unhook ourselves to prevent
 	 * further events.
 	 */
-	remove_wait_queue(irqfd->wqh, &irqfd->wait);
+	eventfd_ctx_remove_wait_queue(irqfd->eventfd, &irqfd->wait, &cnt);
 
 	/*
 	 * We know no new events will be scheduled at this point, so block
-- 
1.6.6.144.g5c3af

