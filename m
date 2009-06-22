Return-Path: <linux-kernel-owner+w=401wt.eu-S1757091AbZFVSPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091AbZFVSPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 14:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbZFVSPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 14:15:48 -0400
Received: from smtp-out.google.com ([216.239.33.17]:30013 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbZFVSPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 14:15:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:content-type:
	content-transfer-encoding:x-system-of-record;
	b=gNOMhzBCuQ1Nx12BOcT2ljIdwxCWNqZ5IAYdP2gwj3SJayOez2inCPsaWcCm40u9T
	yNU9M04HTGNwnMvXnx/PA==
MIME-Version: 1.0
Date: Mon, 22 Jun 2009 14:15:36 -0400
Message-ID: <21c5ff280906221115v302d8b95t4a4ae2df86289056@mail.gmail.com>
Subject: [patch] small sendfile fixes
From: Robert Love <rlove@google.com>
To: lkml <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Three fixes for sendfile, mostly related to sending large files from pseudo
filesystems:

- Fix sendfile for offsets > 300G. This can happen with pseudo filesystems.
  This happens because the overflow check is using inode->i_sb->s_maxbytes
  and not the superblock of the backing device's s_maxbytes. For a regular file
  these are interchangible but for a special file these are different and you
  want the latter.

- Don't compare against the max of the out_inode's superblock. Doesn't make
  sense.

- For pseudo and other filesystems with s_maxbytes set to ~0ULL, max ends up
  holding a negative number as it is signed. Check for and correct that.

Git patch is against 2.6.30. I'd like Al to take a look and make sure
my logic is right before applying.

        Robert

From: Mandeep Singh Baines <msb@google.com>
Signed-off-by: Robert Love <rlove@google.com>
