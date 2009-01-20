Return-Path: <linux-kernel-owner+w=401wt.eu-S1762155AbZATQKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762155AbZATQKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 11:10:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757127AbZATQJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 11:09:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755194AbZATQJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 11:09:53 -0500
Date: Tue, 20 Jan 2009 08:08:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       schwidefsky@de.ibm.com
Subject: Re: SET_PERSONALITY and TASK_SIZE
Message-Id: <20090120080844.d681a750.akpm@linux-foundation.org>
In-Reply-To: <20090118111831.GA4818@osiris.boeblingen.de.ibm.com>
References: <20090118111831.GA4818@osiris.boeblingen.de.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 18 Jan 2009 12:18:31 +0100 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> Hi Andrew,
> 
> while debugging I noticed the following comment in fs/binfmt_elf.c:
> 
> 			/*
> 			 * The early SET_PERSONALITY here is so that the lookup
> 			 * for the interpreter happens in the namespace of the 
> 			 * to-be-execed image.	SET_PERSONALITY can select an
> 			 * alternate root.
> 			 *
> 			 * However, SET_PERSONALITY is NOT allowed to switch
> 			 * this task into the new images's memory mapping
> 			 * policy - that is, TASK_SIZE must still evaluate to
> 			 * that which is appropriate to the execing application.
> 			 * This is because exit_mmap() needs to have TASK_SIZE
> 			 * evaluate to the size of the old image.
> 			 *
> 			 * So if (say) a 64-bit application is execing a 32-bit
> 			 * application it is the architecture's responsibility
> 			 * to defer changing the value of TASK_SIZE until the
> 			 * switch really is going to happen - do this in
> 			 * flush_thread().	- akpm
> 			 */

Cripes, that must have been a different akpm.

> At least s390 isn't doing the deferred TASK_SIZE switch. Also it seems like
> MIPS, PARISC and IA64 don't do it either. However from a quick a view I
> couldn't see that exit_mmap depends on TASK_SIZE. So is this still necessary?
> 
> And the bug I was looking for is this one: in SET_PERSONALITY we do this:
> 
> 	if (current->personality != PER_LINUX32)
> 		set_personality(PER_LINUX);
> 
> However we should use the PER_MASK if we want to check for PER_LINUX32,
> since there are more bits in the personality flags. In case any of the
> 'extra' bits is set we may incorrectly set personality to PER_LINUX even
> when we want PER_LINUX32.
> 
> Looks like more architectures should do something like:
> 
> 	if (personality(current->personality) != PER_LINUX32)
> 		...

I'm stuck in planes and hotels for the rest of the week and don't have a
git tree to dig through, sorry.  I'd prefer to hold off until next week
before diving into that one.
