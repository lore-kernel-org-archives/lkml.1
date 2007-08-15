Return-Path: <linux-kernel-owner+w=401wt.eu-S1764248AbXHONyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764248AbXHONyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 09:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760457AbXHONyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 09:54:04 -0400
Received: from smtpout.mac.com ([17.250.248.171]:59010 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760695AbXHONyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 09:54:01 -0400
In-Reply-To: <20070815133021.GB9412@csclub.uwaterloo.ca>
References: <106259.96671.qm@web52501.mail.re2.yahoo.com> <Pine.LNX.4.64.0708141546510.22494@blackbox.fnordora.org> <46C2F96D.5030908@partiallystapled.com> <20070815133021.GB9412@csclub.uwaterloo.ca>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <ECFEFFF7-0210-4D16-B508-5284FCE58B28@mac.com>
Cc: alan <alan@clueserver.org>, Marc Perkel <mperkel@yahoo.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Thinking outside the box on file systems
Date: Wed, 15 Aug 2007 09:53:45 -0400
To: Michael Tharp <gxti@partiallystapled.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 15, 2007, at 09:30:21, Lennart Sorensen wrote:
> On Wed, Aug 15, 2007 at 09:02:37AM -0400, Michael Tharp wrote:
>> Personally, what I'd like to see is a better way of dealing with  
>> propagation of ownership. Currently, in order to allow  
>> "collaboration" directories where a directory tree is owned by a  
>> certain group and anyone in that group can write and create files,  
>> one has to change the system umask, use a magical bit on the  
>> collaboration directory to propagate group ownership, and create a  
>> group for every user on the system in order to keep their personal  
>> files safe with the new umask. This seems highly flawed. I suggest  
>> that propagation of group  ownership should be the default mode,  
>> not a special one, and that the group-writable permissions should  
>> also be propagated to new files and directories. This way, the  
>> user's home directory would remain 0755, while the collaboration  
>> directory could be 0775, without any changing of umasks.
>
> Posix ACLs seem to solve most group permissions issues and control  
> of permission propegation.  It actually works quite well on Linux.   
> I am surprised if there aren't lots of people already using it.

Going even further in this direction, the following POSIX ACL on the  
directories will do what you want:

## Note: file owner and group are kmoffett
u::rw-
g::rw-
u:lsorens:rw-
u:mtharp:rw-
u:mperkel:rw-
g:randomcvsdudes:r-
default:u::rw-
default:g::rw-
default:u:lsorens
default:u:mtharp:rw-
default:u:mperkel:rw-
default:g:randomcvsdudes:r-

Basically any newly-created item in such a directory will get the  
permissions described by the "default:" entries in the ACL, and  
subdirectories will get a copy of said "default:" entries.

So yes, such functionality is nice; even more so because we already  
have it.  I think if you were really going to "extend" a UNIX  
filesystem it would need to be in 2 directions:
   (A)  Handling disk failures by keeping multiple copies of  
important files.
   (B)  Have version-control support
   (C)  Allowing distributed storage (also lazy synchronization and  
offline modification support)

With some appropriate modifications and hooks, GIT actually comes  
pretty close here.  For larger files it needs to use a "list-of-4MB- 
chunks" approach to minimize the computation overhead for committing  
a randomly-modified file.  The "index" of course would be directly  
read and modified by vfs calls and via mapped memory.  Merge handling  
would need careful integration, preferably with allowing custom  
default-merge-handlers per subtree.  There would be lots more design  
issues to work out, but it's something to think about

Cheers,
Kyle Moffett
