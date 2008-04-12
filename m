Return-Path: <linux-kernel-owner+w=401wt.eu-S1757436AbYDLTxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbYDLTxl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 15:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755051AbYDLTxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 15:53:32 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:27589 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbYDLTxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 15:53:31 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Oeser <ioe-lkml@rameria.de>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Replace completions with semaphores
References: <20080411210022.GJ11962@parisc-linux.org>
	<1208003081.7427.7.camel@twins>
	<20080412172606.GL11962@parisc-linux.org>
X-Message-Flag: Warning: May contain useful information
Date: Sat, 12 Apr 2008 12:53:30 -0700
In-Reply-To: <20080412172606.GL11962@parisc-linux.org> (Matthew Wilcox's
	message of "Sat, 12 Apr 2008 11:26:07 -0600")
Message-ID: <adaskxqrgsl.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Apr 2008 19:53:30.0422 (UTC) FILETIME=[E1BC7D60:01C89CD6]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Arnd contacted me off-list and made the very sensible suggestion of:
 > 
 > struct completion {
 > 	struct semaphore sem;
 > }
 > 
 > That lets us eliminate the duplicate code since all the completion
 > functions become very thin wrappers around semaphore operations.

Just make sure you don't forget the history of completions...  As
Linus said long ago (http://lwn.net/2001/0802/a/lt-completions.php3):

  In case anybody cares, the race was that Linux semaphores only protect the
  accesses _inside_ the semaphore, while the accesses by the semaphores
  themselves can "race" in the internal implementation. That helps make an
  efficient implementation, but it means that the race was:
  
            cpu #1                       cpu #2
  
            DECLARE_MUTEX_LOCKED(sem);
            ..
            down(&sem);                   up(&sem);
            return;
                                          wake_up(&sem.wait) /*BOOM*/
