Return-Path: <linux-kernel-owner+w=401wt.eu-S1758953AbZDIOp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953AbZDIOp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 10:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZDIOpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 10:45:17 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:52487 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbZDIOpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 10:45:15 -0400
Date: Thu, 9 Apr 2009 16:45:11 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>, Justin Madru <jdm64@gawab.com>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.30-rc1: invalid opcode with call trace
Message-ID: <20090409164511.16602da7@gondolin>
In-Reply-To: <19f34abd0904080915t1a47cab4jbfe748eeaa47d675@mail.gmail.com>
References: <49DC367A.90603@gawab.com>
	<20090408063240.GQ5178@kernel.dk>
	<20090408064733.GA16984@elte.hu>
	<19f34abd0904080027h5b7d2acfp7fdf774e67917175@mail.gmail.com>
	<20090408074021.GU5178@kernel.dk>
	<20090408074832.GA11097@elte.hu>
	<19f34abd0904080915t1a47cab4jbfe748eeaa47d675@mail.gmail.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Apr 2009 18:15:21 +0200,
Vegard Nossum <vegard.nossum@gmail.com> wrote:

> The problem is that you have two async port probes:
> 
> [   24.177306] calling  1_async_port_probe+0x0/0xaa @ 2841
> [   24.177825] calling  2_async_port_probe+0x0/0xaa @ 2842
> 
> of which only the first completes, because the first async call itself
> tries to flush the async list while holding a lock (the
> &shost->scan_mutex in __scsi_add_device), causing deadlock.
> 
> In short, I don't think we should call async_synchronize_full() from
> scsi_complete_async_scans() at all. I'm including a more detailed
> description/justification in the patch (attached).

Not that I understand much about the scsi code, but there seem to be
two 'async' processes going on:

- async scanning of the Scsi_Host (which scsi_complete_async_scans()
  waits for)
- async execution of a part of scsi_probe (which the
  async_synchronize_full() waits for)

Considering the async scanning complete only when all probes have
finished seems sensible, so the fix doesn't look correct to me.

Would it perhaps make sense to introduce a per-Scsi_Host running list
so that do_scsi_scan_host() could use async_synchronize_domain() to
wait for all async probes for the host to finish? Or am I
misunderstanding the aim of the scsi code?
