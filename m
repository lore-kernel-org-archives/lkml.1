Return-Path: <linux-kernel-owner+w=401wt.eu-S932244AbZJSUU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbZJSUU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 16:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757457AbZJSUU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 16:20:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:46154 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423AbZJSUU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 16:20:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=OftG9i/TjKKsMyFL2hjnz6h4kR7BOIB+/havDQDUFME9Rx1MRNChAez5VMbqwEBCa4
         YF2gLSatnxh9WR5n1T5VKiVEj3pWRxO4Sir6DrbWXaoMlbms9jJVeSPSnan88HPaCo4q
         uQVThyhPDhteT3t4zR+flLbTfI7msGunF3efM=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: [RFC PATCH 0/5] cfq-iosched: improve latency for no-idle queues
Date: Mon, 19 Oct 2009 22:20:52 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.32cz; KDE/4.2.4; i686; ; )
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200910192220.53203.czoccolo@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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


