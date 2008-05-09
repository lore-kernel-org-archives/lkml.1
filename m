Return-Path: <linux-kernel-owner+w=401wt.eu-S1765181AbYEIGW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765181AbYEIGW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 02:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbYEIGWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 02:22:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752035AbYEIGWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 02:22:47 -0400
Date: Thu, 8 May 2008 23:22:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Krogh <jesper@krogh.cc>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Many open/close on same files yeilds
 "No such file or directory".
Message-Id: <20080508232241.4b177abb.akpm@linux-foundation.org>
In-Reply-To: <4823EA9E.6050703@krogh.cc>
References: <4819E316.7000607@krogh.cc>
	<4823DFA6.9010504@krogh.cc>
	<20080508223635.523b8fa7.akpm@linux-foundation.org>
	<4823EA9E.6050703@krogh.cc>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 May 2008 08:09:34 +0200 Jesper Krogh <jesper@krogh.cc> wrote:

> Andrew Morton wrote:
> >> My feeling is that the script below may reveal the bug on any "busy" 
> >> volume, where busy is lots of activity in the OS-cache of the volume,
> >> not on the actual drives.
> > 
> > By this do you mean that there has to be a lot of other activity on the
> > system to reproduce it?  Stuff which is turning over memory?
> 
> Yes, something like that. (sorry for not being able to be more
> concrete). The applications has "high activity" on a few files, not
> spread activity throughout the volume.
> 
> > Because one possiblity is that the cached dentry got reclaimed by memory
> > pressure and we have some race bug which causes us to think that the file
> > doesn't exist.
> 
> What can i do to explore this theory?

Watch /proc/vmstat while the tests is running.  If the "*steal*" numbers
are going up, the system is reclaiming memory.

> Can I disable caching of dentries
> and see it go away?

Nope.

> Does it fit the pattern that it is only the 
> "open"-syscall that is hit (not read for example)?

Yes.  open() will look up the filename in the dentry cache, read() wil not.
 If name lookup has a race agaisnt dentry cache reclaim, something like
this might happen.

But it'd be damned odd.

> > (That still shouldn't happen because the dentry should be marked
> > recently-accessed, but perhaps the underlying inode gets reclaimed or
> > something.  Grasping at straws here)
> 
> When I disabled the NFS-server and rand my "real-world" program on a
> single processor (make -j 1). It ran through fine. It basically
> gets around 20 million chunks out of differnet file and assemble the
> chuncks in a few other files. This processes more or less 5 individual
> sections, so make can run effectively with a concurrency of 5.
> 
> I dont know if there can be any technical reasons for not seeing it on
> internal attached disks? (other than I just hadn't been able to
> reproduce the same error conditions there.

I can't think of any reason.

I guess a suitable test would be to run your little test app and then read
large files as fast as you can from as many disks as you can, to force
memory reclaim.  If that triggers the bug, and the bug is more likely to
trigger the faster you read those files, then we have a theory.

Damned odd though.
