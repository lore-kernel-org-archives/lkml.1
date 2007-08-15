Return-Path: <linux-kernel-owner+w=401wt.eu-S933362AbXHORy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933362AbXHORy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 13:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934386AbXHORyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 13:54:23 -0400
Received: from smtpout.mac.com ([17.250.248.172]:57404 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932520AbXHORyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 13:54:22 -0400
In-Reply-To: <46C33934.7060802@cfl.rr.com>
References: <106259.96671.qm@web52501.mail.re2.yahoo.com> <Pine.LNX.4.64.0708141546510.22494@blackbox.fnordora.org> <46C2F96D.5030908@partiallystapled.com> <20070815133021.GB9412@csclub.uwaterloo.ca> <ECFEFFF7-0210-4D16-B508-5284FCE58B28@mac.com> <46C33934.7060802@cfl.rr.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <DE34FF90-3143-4978-BBC5-3CF74B8C3C07@mac.com>
Cc: Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       Marc Perkel <mperkel@yahoo.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Thinking outside the box on file systems
Date: Wed, 15 Aug 2007 13:53:53 -0400
To: Phillip Susi <psusi@cfl.rr.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 15, 2007, at 13:34:44, Phillip Susi wrote:
> The problem that I have with this setup is that it specifies an ACL  
> on EACH file.  Yes, you can set a default on the directory for  
> newly created files, but what if I want to add a user to the access  
> list for that whole directory?  I have to individually update every  
> acl on every file in that directory.

We've *always* had to do this; that's what "chmod -R" or "setfacl -R"  
are for :-D.  The major problem is that the locking and lookup  
overhead gets really significant if you have to look at the entire  
directory tree in order to determine the permissions for one single  
object.  I definitely agree that we need better GUIs for managing  
file permissions, but I don't see how you could modify the kernel in  
this case to do what you want.


> Also if you move a file created elsewhere into that directory, it  
> retains its existing permissions doesn't it?

So what would you have happen when you move another directory into  
that directory?  Should it retain its permissions?  If they change  
based on the new directory then do you recurse into each  
subdirectory?  Such recursing to modify permissions also has  
significant performance implications.  What about if the file is  
hardlinked elsewhere; do those permissions change?


There's also the question of what to do about namespaces and bind  
mounts.  If I run "mount --bind /foo /home/foo", then do I get  
different file permissions depending on what path I access the file  
by?  What if I then run chroot("/foo"), do I get different file  
permissions then?  What if I have two namespaces, each with their own  
root filesystem (say "root1" and "root2"), and I mount the other  
namespace's root filesystem in a subdir of each:
   NS1:  mount /dev/root2 /otherns
   NS2:  mount /dev/root1 /otherns

Now I have the following paths to the same file, do these get  
different permissions or the same?
   NS1:/foo == NS2:/otherns/foo
   NS2:/bar == NS1:/otherns/bar

If you answered that they get different permissions, then how do you  
handle the massive locking performance penalty due to the extra  
lookups?  If you answered "same permissions", then how do you explain  
the obvious discrepancy to the admin?


> I would rather just add a new ace to the directory itself which  
> specifies that it applies to the entire tree.  Then you only need  
> to store a single acl on disk, and only have to update one acl to  
> add a new user.

The idea is nice, but as soon as you add multiple namespaces,  
chroots, or bind mounts the concept breaks down.  For security- 
sensitive things like file permissions, you really do want  
determinate behavior regardless of the path used to access the data.

Cheers,
Kyle Moffett

