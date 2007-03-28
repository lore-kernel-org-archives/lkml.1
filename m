Return-Path: <linux-kernel-owner+w=401wt.eu-S965025AbXC1RXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965025AbXC1RXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 13:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964983AbXC1RXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 13:23:43 -0400
Received: from twin.jikos.cz ([213.151.79.26]:50243 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964988AbXC1RXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 13:23:42 -0400
Date: Wed, 28 Mar 2007 19:23:32 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Lee Revell <rlrevell@joe-job.com>,
       Andrew Morton <akpm@linux-foundation.org>
cc: =?ISO-8859-2?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>, andrea@suse.de,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: fs/block_dev.c:953: warning: 'found' might be used uninitialized
 in this function
In-Reply-To: <75b66ecd0703280956i522cf6cbyc4c9ef8b1666ec15@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0703281909240.29565@twin.jikos.cz>
References: <200703281847.05356.toralf.foerster@gmx.de>
 <75b66ecd0703280956i522cf6cbyc4c9ef8b1666ec15@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007, Lee Revell wrote:

> > I compiled current git source 2.6.21-rc5-g28defbe and got this warning:
> > ...
> > fs/block_dev.c: In function `bd_claim_by_kobject':
> > fs/block_dev.c:953: warning: 'found' might be used uninitialized in this
> > function
> > ...
> Most of these warnings are really GCC bugs.  Please examine the code
> in question.

Anyway imho this time gcc got it right?



From: Jiri Kosina <jkosina@suse.cz>

blockdev: bd_claim_by_kobject() could check value of unititalized pointer

Fixes this warning:

fs/block_dev.c: In function `bd_claim_by_kobject':
fs/block_dev.c:953: warning: 'found' might be used uninitialized in this function

struct bd_holder *found is initialized only when bd_claim() returns zero. If it
returns nonzero, ptr stays uninitialized. Later the value of the pointer is checked.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/drivers/usb/input/hid-tmff.c b/drivers/usb/input/hid-tmff.c
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 575076c..e87d84a 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -950,7 +950,7 @@ static int bd_claim_by_kobject(struct block_device *bdev, void *holder,
 				struct kobject *kobj)
 {
 	int res;
-	struct bd_holder *bo, *found;
+	struct bd_holder *bo, *found = NULL;
 
 	if (!kobj)
 		return -EINVAL;
