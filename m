Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbXH0LdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbXH0LdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 07:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbXH0Lcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 07:32:53 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:49481 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751053AbXH0Lcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 07:32:52 -0400
Message-ID: <388214369.05937@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070827112152.816663278@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Mon, 27 Aug 2007 19:21:52 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Chris Mason <chris.mason@oracle.com>
Cc: Andrew Morton <akpm@osdl.org>
Cc: David Chinner <dgc@sgi.com>
Cc: Michael Rubin <mrubin@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] [RFC][PATCH] clustered writeback
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

This is one possible implementation of the clustered writeback idea.
It runs OK on ext3 (compiling, syncing, etc.).

The patch is based on 2.6.23-rc3-mm1 and the writeback patches here:
http://lkml.org/lkml/2007/8/19/10

By default, with many dirty inodes, it works as follows:
- store dirty inodes in a radix tree, indexed by their inode numbers
- sweep the whole inode number space in 25s and do it in 5 times
- each time we walk only 1/5 of the inode number space
- pull all inodes with dirty-age larger than 5s to the io dispatching queue

Because it does the work in small batches of 10 inodes, when the system has
<=10 dirty inodes, its behavior will reduce to:
- do a full sweep *at once* on every 25s
Which means the disk will flicker once every 25s, not bad :)


The implications for the majority users could be:
- medium-to-heavy writes becomes less seeky
- dirty inodes are getting synced earlier(before: 30s; now: 5-30s)
- less panic for the 'atime' mount option (a future work)

Fengguang
-- 
