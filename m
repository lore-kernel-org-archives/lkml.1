Return-Path: <linux-kernel-owner+w=401wt.eu-S1758945AbYHHXcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945AbYHHXcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 19:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbYHHXce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 19:32:34 -0400
Received: from cobra.newdream.net ([66.33.216.30]:53861 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbYHHXcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 19:32:33 -0400
Date: Fri, 8 Aug 2008 16:32:32 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: John Stoffel <john@stoffel.org>
Cc: Pavel Machek <pavel@suse.cz>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, ceph-devel@lists.sourceforge.net
Subject: Re: Recursive directory accounting for size, ctime, etc.
In-Reply-To: <18588.17892.1819.479800@stoffel.org>
Message-ID: <Pine.LNX.4.64.0808081629440.29906@cobra.newdream.net>
References: <Pine.LNX.4.64.0806192313530.7379@cobra.newdream.net>
 <20080805182610.GD8380@ucw.cz> <18588.17892.1819.479800@stoffel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008, John Stoffel wrote:
> >>>>> "Pavel" == Pavel Machek <pavel@suse.cz> writes:
> 
> Pavel> On Tue 2008-07-15 11:28:22, Sage Weil wrote:
> >> All-
> >> 
> >> Ceph is a new distributed file system for Linux designed for scalability 
> >> (terabytes to exabytes, tens to thousands of storage nodes), reliability, 
> >> and performance.  The latest release (v0.3), aside from xattr support and 
> >> the usual slew of bugfixes, includes a unique (?) recursive accounting 
> >> infrastructure that allows statistics about all metadata nested beneath a 
> >> point in the directory hierarchy to be efficiently propagated up the tree.  
> >> Currently this includes a file and directory count, total bytes (summation 
> >> over file sizes), and most recent inode ctime.  For example, for a 
> >> directory like /home, Ceph can efficiently report the total number of 
> >> files, directories, and bytes contained by that entire subtree of the 
> >> directory hierarchy.
> >> 
> >> The file size summation is the most interesting, as it effectively gives 
> >> you directory-based quota space accounting with fine granularity.  In many 
> >> deployments, the quota _accounting_ is more important than actual 
> >> enforcement.  Anybody who has had to figure out what has filled/is filling 
> >> up a large volume will appreciate how cumbersome and inefficient 'du' can 
> >> be for that purpose--especially when you're in a hurry.
> >> 
> >> There are currently two ways to access the recursive stats via a standard 
> >> shell.  The first simply sets the directory st_size value to the 
> >> _recursive_ bytes ('rbytes') value (when the client is mounted with -o 
> >> rbytes).  For example (watch the directory sizes),
> Pavel> ...
> 
> >> Naturally, there are a few caveats:
> >> 
> >> - There is some built-in delay before statistics fully propagate up 
> >> toward the root of the hierarchy.  Changes are propagated 
> >> opportunistically when lock/lease state allows, with an upper bound of (by 
> >> default) ~30 seconds for each level of directory nesting.
> 
> Pavel> Having instant rctime would be very nice -- for stuff like locate and
> Pavel> speeding up kde startup.
> 
> >> I'm extremely interested in what people think of overloading the file 
> >> system interface in this way.  Handy?  Crufty?  Dangerous?  Does anybody 
> 
> Pavel> Too ugly to live.

:)

> Pavel> What about new rstat() syscall?
> 
> Or how about tying this into the quotactl() syscall and extending it a
> bit?  Say quotactl2(cmd,device,id,addr,path) which is probably just as
> ugly, but seems to make better sense.

Introducing or modifying system calls makes for pretty interfaces, but is
a bit impractical (and overkill) to support something present in only one
filesystem.

So far I think Andreas' suggestion of using pseudo-xattrs is the cleanest 
and simplest: it's doesn't interfere with any existing interfaces 
(provided the virtual xattr name is well chosen), and is usable via 
standard command line tools like getfattr.

sage
