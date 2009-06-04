Return-Path: <linux-kernel-owner+w=401wt.eu-S1753057AbZFDVGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbZFDVGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 17:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZFDVF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 17:05:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751331AbZFDVFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 17:05:55 -0400
Date: Thu, 4 Jun 2009 14:05:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Salman Qazi <sqazi@google.com>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: A bug in read operation for /dev/zero and a proposed fix.
In-Reply-To: <alpine.LFD.2.01.0906041355560.4880@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0906041405030.4880@localhost.localdomain>
References: <alpine.DEB.1.00.0906041330170.32557@bumblebee1.mtv.corp.google.com> <20090604135050.ceb6bf18.akpm@linux-foundation.org> <alpine.LFD.2.01.0906041355560.4880@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Jun 2009, Linus Torvalds wrote:
> 
> If we want to do this for 2.6.30, though, I very much agree with the 
> notion of limiting it to just fatal signals, though.

IOW, I really think the patch should look like the following, and that 
this has nothing to do with OOM-killing at all.

		Linus
---
 drivers/char/mem.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 8f05c38..65e12bc 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -694,6 +694,9 @@ static ssize_t read_zero(struct file * file, char __user * buf,
 		written += chunk - unwritten;
 		if (unwritten)
 			break;
+		/* Consider changing this to just 'signal_pending()' with lots of testing */
+		if (fatal_signal_pending(current))
+			return written ? written : -EINTR;
 		buf += chunk;
 		count -= chunk;
 		cond_resched();
