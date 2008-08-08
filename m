Return-Path: <linux-kernel-owner+w=401wt.eu-S1757615AbYHHNLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615AbYHHNLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 09:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbYHHNLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 09:11:12 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:37845 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbYHHNLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 09:11:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18588.17892.1819.479800@stoffel.org>
Date: Fri, 8 Aug 2008 09:11:00 -0400
From: "John Stoffel" <john@stoffel.org>
To: Pavel Machek <pavel@suse.cz>
Cc: Sage Weil <sage@newdream.net>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, ceph-devel@lists.sourceforge.net
Subject: Re: Recursive directory accounting for size, ctime, etc.
In-Reply-To: <20080805182610.GD8380@ucw.cz>
References: <Pine.LNX.4.64.0806192313530.7379@cobra.newdream.net>
	<20080805182610.GD8380@ucw.cz>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Pavel" == Pavel Machek <pavel@suse.cz> writes:

Pavel> On Tue 2008-07-15 11:28:22, Sage Weil wrote:
>> All-
>> 
>> Ceph is a new distributed file system for Linux designed for scalability 
>> (terabytes to exabytes, tens to thousands of storage nodes), reliability, 
>> and performance.  The latest release (v0.3), aside from xattr support and 
>> the usual slew of bugfixes, includes a unique (?) recursive accounting 
>> infrastructure that allows statistics about all metadata nested beneath a 
>> point in the directory hierarchy to be efficiently propagated up the tree.  
>> Currently this includes a file and directory count, total bytes (summation 
>> over file sizes), and most recent inode ctime.  For example, for a 
>> directory like /home, Ceph can efficiently report the total number of 
>> files, directories, and bytes contained by that entire subtree of the 
>> directory hierarchy.
>> 
>> The file size summation is the most interesting, as it effectively gives 
>> you directory-based quota space accounting with fine granularity.  In many 
>> deployments, the quota _accounting_ is more important than actual 
>> enforcement.  Anybody who has had to figure out what has filled/is filling 
>> up a large volume will appreciate how cumbersome and inefficient 'du' can 
>> be for that purpose--especially when you're in a hurry.
>> 
>> There are currently two ways to access the recursive stats via a standard 
>> shell.  The first simply sets the directory st_size value to the 
>> _recursive_ bytes ('rbytes') value (when the client is mounted with -o 
>> rbytes).  For example (watch the directory sizes),
Pavel> ...

>> Naturally, there are a few caveats:
>> 
>> - There is some built-in delay before statistics fully propagate up 
>> toward the root of the hierarchy.  Changes are propagated 
>> opportunistically when lock/lease state allows, with an upper bound of (by 
>> default) ~30 seconds for each level of directory nesting.

Pavel> Having instant rctime would be very nice -- for stuff like locate and
Pavel> speeding up kde startup.

>> I'm extremely interested in what people think of overloading the file 
>> system interface in this way.  Handy?  Crufty?  Dangerous?  Does anybody 

Pavel> Too ugly to live.

Pavel> What about new rstat() syscall?

Or how about tying this into the quotactl() syscall and extending it a
bit?  Say quotactl2(cmd,device,id,addr,path) which is probably just as
ugly, but seems to make better sense.

Me, I'd love to have this type of reporting on my filesystems, esp
since it would help me in my day job.

How exports over NFS would look is an issue too.

John
