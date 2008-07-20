Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbYGTQe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbYGTQe3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 12:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757360AbYGTQeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 12:34:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33272 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757471AbYGTQeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 12:34:21 -0400
Date: Sun, 20 Jul 2008 17:34:06 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: pjones@redhat.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org
Subject: [RFC] breakage in bsg
Message-ID: <20080720163406.GW28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	* with "bsg: bind bsg to request_queue instead of gendisk" we
get all requests with NULL ->rq_disk.  SCSI can cope with that, anything
else is not promised to be able to surive that.  Indeed, quite a few
drivers do not.

	* WTF are these per-bd flags doing, seeing that you set them
on every ->read() and ->write()?  Just what will happen if you have
two openers?

	* cmd_filter thing is broken as well (we have no access to
gendisk in question and there's a lot of obvious issues when you have
several openers).

#2 and part of #3 are fixable, but I really don't see what to do with #1.
If nothing else, it's absolutely incompatible with cmd_filter, even if you
leave aside the issue with non-IDE/non-SCSI drivers.

Comments?
