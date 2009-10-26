Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbZJZVnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbZJZVnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 17:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbZJZVni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 17:43:38 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:43591 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbZJZVni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 17:43:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=MmW1QeRPcoKQd3QvUJzzuNMaj4LbHlnM98y41LeUld2fRZ/c3Uro22THWcj4tK7Tip
         XPIA96nd02czWeOs/K8lqRYCHt0XItkwrEUvkV3accaRVG7XzDJDpKg7UcuWyU5RhqVC
         LcZm/mLOkGTMDELHS2AAigkYeV8+oIwI7duI4=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 0/5] cfq-iosched: improve latency for no-idle queues (v3)
Date: Mon, 26 Oct 2009 22:43:41 +0100
User-Agent: KMail/1.11.4 (Linux/2.6.32cz; KDE/4.2.4; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910262243.41327.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[rebased on top of Jeff's latest changes for 2.6.33. Various code style improvements over v1 & v2]

This patch series is intended to improve I/O latency, addressing an often
neglected, important subset of workloads: the ones for which cfq currently
prefers not to do any idling.

Those are the ones that would benefit most from having low latency, in fact
they are any of:
* processes with large think times (e.g. interactive ones like file managers)
* seeky (e.g. programs faulting in their code at startup)
* or marked as no-idle from upper levels.

The patch series addresses this by:
* reducing queues' timeslice when many queues have pending I/O
* separating queues with different priorities and different characteristics in
different service trees, each with an allocated time slice
* enable idling when switching between service trees, even for queues that
would not have idling enabled otherwise.

This provides various benefits:
* service tree insertion code is simplified, since it doesn't need to cope with
priorities any more.
* high priority no_idle queues are no longer penalized when competing with
lower priority, idling queues
* seeky and no_idle queues have their fair share of disk time, without
penalizing NCQ drives' performances, since they can all dispatch together,
filling up the available NCQ slots.

On a non-NCQ capable drive, a workload of 4 random readers competing with
sequential writer, the maximum latency experienced by readers decreased from >
500ms to about 160ms.

