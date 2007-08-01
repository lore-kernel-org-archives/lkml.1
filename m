Return-Path: <linux-kernel-owner+w=401wt.eu-S933992AbXHAPCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933992AbXHAPCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759188AbXHAPC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:02:27 -0400
Received: from postfix2-g20.free.fr ([212.27.60.43]:49585 "EHLO
	postfix2-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759929AbXHAPC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:02:26 -0400
From: Raphael Manfredi <Raphael_Manfredi@pobox.com>
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: [2.6.22.1] Copying to full NFS dir
X-Mailer: MH [version 6.8]
Organization: Home, Grenoble, France
Date: Wed, 01 Aug 2007 17:00:21 +0200
Message-ID: <30002.1185980421@nice>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've stumbled into a problem running 2.6.22.1 on both my NFS client and
my NFS server.  I've just upgraded from 2.4.31, so I have no idea whether
this is a new problem or if it is known in the 2.6.x series.

Here's a high-level description of the context:

* The NFS server has a directory which is full.
* That directory is mounted on the NFS client.
* The NFS client tries to "mv local-file /nfs/remote-dir/"
* local-file is big (typically 700 MiB).

What happens is:

* The "mv" takes a long long time and eventually fails, of course.
* The load on the NFS server (initially at 0) increases to about 8.
* Any access to the NFS-mounted dir from the client whilst "mv" is in
  progress stalls (e.g. ls -l /nfs/remote-dir).

I've tried to write my own "mv" in C to see which syscalls were involved.
What happens is:

* All the write() succeed with no error.
* The final close() returns -1 with either EINTR or ENOSPC.

I could not determine what makes close return EINTR or ENOSPC.

Problem is, under 2.4.31, the write() was immediately failing when writing
to a full NFS partition.

This looks like an important bug, but I don't know if it is in the NFS-client
or NFS-server side.  I'm tempted to say NFS-server, but that's more a hunch.

Raphael
