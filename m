Return-Path: <linux-kernel-owner+w=401wt.eu-S1758063AbYLPTi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063AbYLPTi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbYLPTis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:38:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42717 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbYLPTir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:38:47 -0500
Date: Tue, 16 Dec 2008 14:38:44 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Robert Richter <robert.richter@amd.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 6/9] oprofile: port to the new ring_buffer
In-Reply-To: <20081216172341.GK15411@erda.amd.com>
Message-ID: <alpine.DEB.1.10.0812161432000.23871@gandalf.stny.rr.com>
References: <1229013723-8191-1-git-send-email-robert.richter@amd.com> <1229013723-8191-7-git-send-email-robert.richter@amd.com> <alpine.DEB.1.10.0812111424470.24741@gandalf.stny.rr.com> <20081216172341.GK15411@erda.amd.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 16 Dec 2008, Robert Richter wrote:
> 
> In the beginning, the use of separate locks for reading and writing
> would be sufficient. Then, there would be only one atomic comparison
> needed to check, if the write pointer meets the read pointer. This
> should be not as difficult since read and write is always in different
> pages (if a am not wrong) and thus only the pointer to the pages have
> to be compared.
> 

Most of the ftrace work uses the ring buffer in overwrite mode. That is, 
when the head meets the tail, we move the tail. The way the reader works, 
is that the first read will swap a page out of the ring with a blank page. 
This means, what is on that page is safe from further writes. When the 
reader is finished with the page, it will swap the empty page with a tail 
of the buffer.

The problem is that there needs to be a lock to protect this change. If 
the writer is moving the tail and the reader is about to swap it, things 
can get corrupted. There are tricks to protect this with cmpxchg, but for 
now we are playing it safe with spin locks. Note, the lock is only taken 
by the reader when it needs to go to the next page.

The writers do not need any locks to protect against other writers, 
because the buffers are per cpu and a write may only be performed on a 
buffer on the local cpu.

-- Steve


Note: I may have tail and head backwards, I do not remember which end I 
called what.
