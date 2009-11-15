Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbZKOTEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbZKOTEw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 14:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbZKOTEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 14:04:52 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55424 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbZKOTEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 14:04:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=uL2BE6xEV8Gwd6elkv5vu42am1cr/e6EjZdISJCTygPxNR0D1MpX+1gdV4Qi7F1zl9
         tKLLhCD+1zdVQjncsSMCnStvLR/qU+0AkbJ11YTXJheoJrRY70G81IqKYNEp+shOwjXF
         mub6MkkhPJRLq6CskFVrDoM7HNizDEh5tBshY=
From: Stijn Devriendt <highguy@gmail.com>
To: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] sched_wait_block: wait for blocked threads
Date: Sun, 15 Nov 2009 20:04:18 +0100
Message-Id: <1258311859-6189-1-git-send-email-HIGHGuY@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Peter, all,

The attached patch is a prototype for a new system call which
allows threads to wait for other threads being blocked.

Its main use is to allow threading libraries to resume
executing more CPU-bound work when one of its threads is
blocked while not having to over-allocating threads in a 
normal situation. 

Benefit over asynchronous I/O is that a threadpool
thread that performs asynchronous I/O might not have
work enough in one item to keep the CPU busy during the
whole asynchronous operation and that not all operations
are async capable.
Giving control back to the library through a thread
waiting for the blocked one allows new workitems to be
executed as long as the former is blocked.

Code performing this wait could look like:
  pid_t parent = ...;
  while (waitpid(parent, NULL, WNOHANG) != 0)
  {
    if (sched_wait_block(parent, NULL) == 0)
		{
      // do work, possibly notify threadpool manager
			// to start another thread blocked on this one
			// first
		}
  }

Any feedback on the concept is much appreciated.

Regards,
	Stijn Devriendt

