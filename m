Return-Path: <linux-kernel-owner+w=401wt.eu-S933199AbZARLSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199AbZARLSz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 06:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763516AbZARLSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 06:18:45 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:49631 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762883AbZARLSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 06:18:44 -0500
Date: Sun, 18 Jan 2009 12:18:31 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: SET_PERSONALITY and TASK_SIZE
Message-ID: <20090118111831.GA4818@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

while debugging I noticed the following comment in fs/binfmt_elf.c:

			/*
			 * The early SET_PERSONALITY here is so that the lookup
			 * for the interpreter happens in the namespace of the 
			 * to-be-execed image.	SET_PERSONALITY can select an
			 * alternate root.
			 *
			 * However, SET_PERSONALITY is NOT allowed to switch
			 * this task into the new images's memory mapping
			 * policy - that is, TASK_SIZE must still evaluate to
			 * that which is appropriate to the execing application.
			 * This is because exit_mmap() needs to have TASK_SIZE
			 * evaluate to the size of the old image.
			 *
			 * So if (say) a 64-bit application is execing a 32-bit
			 * application it is the architecture's responsibility
			 * to defer changing the value of TASK_SIZE until the
			 * switch really is going to happen - do this in
			 * flush_thread().	- akpm
			 */

At least s390 isn't doing the deferred TASK_SIZE switch. Also it seems like
MIPS, PARISC and IA64 don't do it either. However from a quick a view I
couldn't see that exit_mmap depends on TASK_SIZE. So is this still necessary?

And the bug I was looking for is this one: in SET_PERSONALITY we do this:

	if (current->personality != PER_LINUX32)
		set_personality(PER_LINUX);

However we should use the PER_MASK if we want to check for PER_LINUX32,
since there are more bits in the personality flags. In case any of the
'extra' bits is set we may incorrectly set personality to PER_LINUX even
when we want PER_LINUX32.

Looks like more architectures should do something like:

	if (personality(current->personality) != PER_LINUX32)
		...
