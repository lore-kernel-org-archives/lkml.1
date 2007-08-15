Return-Path: <linux-kernel-owner+w=401wt.eu-S935035AbXHOUig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935035AbXHOUig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 16:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbXHOUiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 16:38:25 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:6159 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753650AbXHOUiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 16:38:23 -0400
Message-ID: <46C3644C.9020102@cfl.rr.com>
Date: Wed, 15 Aug 2007 16:38:36 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Kyle Moffett <mrmacman_g4@mac.com>
CC: Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       Marc Perkel <mperkel@yahoo.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: Thinking outside the box on file systems
References: <106259.96671.qm@web52501.mail.re2.yahoo.com> <Pine.LNX.4.64.0708141546510.22494@blackbox.fnordora.org> <46C2F96D.5030908@partiallystapled.com> <20070815133021.GB9412@csclub.uwaterloo.ca> <ECFEFFF7-0210-4D16-B508-5284FCE58B28@mac.com> <46C33934.7060802@cfl.rr.com> <DE34FF90-3143-4978-BBC5-3CF74B8C3C07@mac.com>
In-Reply-To: <DE34FF90-3143-4978-BBC5-3CF74B8C3C07@mac.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Aug 2007 20:38:36.0299 (UTC) FILETIME=[4102CDB0:01C7DF7C]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1021-15364.001
X-TM-AS-Result: No--15.542300-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> We've *always* had to do this; that's what "chmod -R" or "setfacl -R" 
> are for :-D.  The major problem is that the locking and lookup overhead 
> gets really significant if you have to look at the entire directory tree 
> in order to determine the permissions for one single object.  I 
> definitely agree that we need better GUIs for managing file permissions, 
> but I don't see how you could modify the kernel in this case to do what 
> you want.

I am well aware of that, I'm simply saying that sucks.  Doing a 
recursive chmod or setfacl on a large directory tree is slow as all hell.

> So what would you have happen when you move another directory into that 
> directory?  Should it retain its permissions?  If they change based on 
> the new directory then do you recurse into each subdirectory?  Such 
> recursing to modify permissions also has significant performance 
> implications.  What about if the file is hardlinked elsewhere; do those 
> permissions change?

Simple... the file retains any acl it already had, AND the acl of the 
new directory now applies.  Most likely the moved file had no acl and 
was just inheriting its effective acl from its old parent directory. 
The end result is that people who used to have access to the file by 
virtue of it being in their directory no longer do, and the people who 
are supposed to have access to all files in the new directory get access 
to this one.

As for hard links, your access would depend on which name you use to 
access the file.  The file itself may still have an acl that grants or 
denies access to people no matter what name they use, but if it allows 
inheritance, then which name you access it by will modify the effective 
acl that it gets.

As for performance implications, I hardly think it is worrisome.  Each 
directory in the path has to be looked up anyhow so you already have 
their acls, so when you finally reach the file, you just have to take 
the union of the acls encountered on the way.  Should only be a few cpu 
cycles.

> There's also the question of what to do about namespaces and bind 
> mounts.  If I run "mount --bind /foo /home/foo", then do I get different 
> file permissions depending on what path I access the file by?  What if I 
> then run chroot("/foo"), do I get different file permissions then?  What 
> if I have two namespaces, each with their own root filesystem (say 
> "root1" and "root2"), and I mount the other namespace's root filesystem 
> in a subdir of each:
>   NS1:  mount /dev/root2 /otherns
>   NS2:  mount /dev/root1 /otherns
> 
> Now I have the following paths to the same file, do these get different 
> permissions or the same?
>   NS1:/foo == NS2:/otherns/foo
>   NS2:/bar == NS1:/otherns/bar
> 
> If you answered that they get different permissions, then how do you 
> handle the massive locking performance penalty due to the extra 
> lookups?  If you answered "same permissions", then how do you explain 
> the obvious discrepancy to the admin?

Good question.  I would say the bind mount should have a flag to 
specify.  That way the admin can choose where it should inherit from.  I 
also don't see where this locking penalty is.

> The idea is nice, but as soon as you add multiple namespaces, chroots, 
> or bind mounts the concept breaks down.  For security-sensitive things 
> like file permissions, you really do want determinate behavior 
> regardless of the path used to access the data.

How does it break down?  Chroots have absolutely no impact at all, and 
the bind mounts/namespaces can be handled as I mentioned above.  If you 
really want to be sure of the effective permissions on the file, then 
you simply flag it to not inherit from its parent or use an inherited 
rights mask to block the specific inherited permissions you want.


