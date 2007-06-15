Return-Path: <linux-kernel-owner+w=401wt.eu-S1759284AbXFOXbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbXFOXbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 19:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758081AbXFOXaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 19:30:55 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:41262 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757803AbXFOXax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 19:30:53 -0400
Message-ID: <46732124.80509@novell.com>
Date: Fri, 15 Jun 2007 16:30:44 -0700
From: Crispin Cowan <crispin@novell.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Pavel Machek <pavel@ucw.cz>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
References: <20070514110607.549397248@suse.de> <200706090003.57722.agruen@suse.de> <20070609001703.GA17644@kroah.com> <466C303E.5010304@novell.com> <20070615165054.GA11345@kroah.com> <20070615200623.GA2616@elf.ucw.cz> <20070615211157.GB7337@kroah.com>
In-Reply-To: <20070615211157.GB7337@kroah.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Jun 15, 2007 at 10:06:23PM +0200, Pavel Machek wrote:
>   
>>>>     * Renamed Directory trees: The above problem is compounded with
>>>>       directory trees. Changing the name at the top of a large, bushy
>>>>       tree can require instant relabeling of millions of files.
>>>>         
>>> Same daemon can do this.  And yes, it might take a ammount of time, but
>>> the times that this happens in "real-life" on a "production" server is
>>> quite small, if at all.
>>>       
>> And now, if you move a tree, there will be old labels for a while. But
>> this does not matter, because attacker could be keeping file
>> descriptors.
>>     
> Agreed.
>   
We have built a label-based AA prototype. It fails because there is no
reasonable way to address the tree renaming problem.

>> Only case where attacker _can't_ be keeping file descriptors is newly
>> created files in recently moved tree. But as you already create files
>> with restrictive permissions, that's okay.
>>
>> Yes, you may get some -EPERM during the tree move, but AA has that
>> problem already, see that "when madly moving trees we sometimes
>> construct path file never ever had".
>>     
> Exactly.
>   
You are remembering old behavior. The current AppArmor generates only
correct and consistent paths. If a process has an open file descriptor
to such a file, they will retain access to it, as we described here:
http://forgeftp.novell.com//apparmor/LKML_Submission-May_07/techdoc.pdf

Under the restorecon-alike proposal, you have a HUGE open race. This
post http://bugs.centos.org/view.php?id=1981 describes restorecon
running for 30 minutes relabeling a file system. That is so far from
acceptable that it is silly.

Of course, this depends on the system in question, but restorecon will
necessarily need to traverse whatever portions of the filesystem that
have changed, which can be quite a long time indeed. Any race condition
measured in minutes is a very serious issue.

> I can't think of a "real world" use of moving directory trees around
> that this would come up in as a problem.
Consider this case: We've been developing a new web site for a month,
and testing it on the server by putting it in a different virtual
domain. We want to go live at some particular instant by doing an mv of
the content into our public HTML directory. We simultaneously want to
take the old web site down and archive it by moving it somewhere else.

Under the restorecon proposal, the web site would be horribly broken
until restorecon finishes, as various random pages are or are not
accessible to Apache.

In a smaller scale example, I want to share some files with a friend. I
can't be bothered to set up a proper access control system, so I just mv
the files to ~crispin/public_html/lookitme and in IRC say "get it now,
going away in 10 minutes" and then move it out again. Yes, you can
manually address this by running "restorecon ~crispin/public_html". But
AA does this automatically without having to run any commands.

You could get restorecon to do this automatically by using inotify. But
to make it as general and transparent as AA is now, you would have to
run inotify on every directory in the system, with consequences for
kernel memory and performance.

This problem does not exist for SELinux, because SELinux does not expect
access to change based on file names.

This problem does not exist in the proposed AA implementation, because
the patch makes the access decision based on the current name of the
file, so it doesn't have a consistency problem between the file and its
label; there is no label.

The problem is induced by trying to emulate AA on top of SELinux. They
don't fit well together. AA fits much better with LSM, which is the
reason LSM exists.

>   Maybe a source code control
> system might have this issue for the server, but in a second or two
> everything would be working again as the new files would be relabled
> correctly.
>   
Try an hour or two for a large source code repository. Its linear in the
number of files, and several hundred thousand files would take a while
to relabel. A large GIT tree would be particularly painful because of
the very large number of files.

> Can anyone else see a problem with this that I'm just being foolish and
> missing?
>   
It is not foolish. The label idea is so attractive that last September
from discussions with Arjan we actually thought it was the preferred
implementation. However, what we've been saying over and over again is
that we *tried* this, and it *doesn't* work at the implementation level.
There is no good answer, restorecon is an ugly kludge, and so this
seductive approach turns out to be a dead end.

Caveat: I am *not* saying that labels in general are bad, just that they
are a bad way to emulate the AppArmor model. And yes, I am working on a
model paper that is more abstract than Andreas' paper
<http://forgeftp.novell.com//apparmor/LKML_Submission-May_07/techdoc.pdf>,
but that takes time.

Then there's all the other problems, such as file systems that don't
support extended attributes, particularly NFS3. Yes, NFS3 is vulnerable
to network attack, but that is not the threat AA is addressing. AA is
preventing an application with access to an NFS mount from accessing the
*entire* mount. There is lots of practical security value in this, and
label schemes cannot do it. Well, mostly; you could do it with a dynamic
labeling scheme that labels files as they are pulled into kernel memory,
but that requires an AA-style regexp parser in the kernel to apply the
labels.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin/
Director of Software Engineering   http://novell.com
	AppArmor Chat: irc.oftc.net/#apparmor

