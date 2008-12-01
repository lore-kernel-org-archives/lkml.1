Return-Path: <linux-kernel-owner+w=401wt.eu-S1753315AbYLAV0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbYLAV0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 16:26:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbYLAVZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 16:25:58 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35635 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbYLAVZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:25:57 -0500
Subject: Re: [RFC v10][PATCH 08/13] Dump open file descriptors
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oren Laadan <orenl@cs.columbia.edu>, Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Serge Hallyn <serue@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <alpine.LFD.2.00.0812011258390.3256@nehalem.linux-foundation.org>
References: <1227747884-14150-1-git-send-email-orenl@cs.columbia.edu>
	 <1227747884-14150-9-git-send-email-orenl@cs.columbia.edu>
	 <20081128101919.GO28946@ZenIV.linux.org.uk>
	 <1228153645.2971.36.camel@nimitz> <493447DD.7010102@cs.columbia.edu>
	 <1228164679.2971.91.camel@nimitz>
	 <alpine.LFD.2.00.0812011258390.3256@nehalem.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 01 Dec 2008 13:25:45 -0800
Message-Id: <1228166745.2971.113.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-01 at 13:02 -0800, Linus Torvalds wrote:
> On Mon, 1 Dec 2008, Dave Hansen wrote:
> > 
> > Why is this done in two steps?  It first grabs a list of fd numbers
> > which needs to be validated, then goes back and turns those into 'struct
> > file's which it saves off.  Is there a problem with doing that
> > fd->'struct file' conversion under the files->file_lock?
> 
> Umm, why do we even worry about this?
> 
> Wouldn't it be much better to make sure that all other threads are 
> stopped before we snapshot, and if we cannot account for some thread (ie 
> there's some elevated count in the fs/files/mm structures that we cannot 
> see from the threads we've stopped), just refuse to dump.

My guess is that the mm is probably ok here, but we'll need some work on
the vfs structures, at least eventually.

The mm is nice that it has ->count separated from ->users.  We can
easily compare the sum of mm->users to the number of tasks we've frozen
since mm->users has nice defined behavior.

But, we've got suckers like proc_fd_info() that do a
get/put_files_struct().  So, somebody just doing lots of looks in /proc
could stop us from ever checkpointing.  Unfortunately, I know of a
number of "monitoring" programs that do just that. :)

I guess we can use the plain counts for now, and add something like
mm->users for the vfs structures in a bit.  

-- Dave

