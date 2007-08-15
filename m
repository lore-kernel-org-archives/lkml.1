Return-Path: <linux-kernel-owner+w=401wt.eu-S934120AbXHORSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934120AbXHORSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 13:18:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758651AbXHORRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 13:17:52 -0400
Received: from smtpout.mac.com ([17.250.248.172]:57805 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755792AbXHORRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 13:17:51 -0400
In-Reply-To: <184413.25590.qm@web52503.mail.re2.yahoo.com>
References: <184413.25590.qm@web52503.mail.re2.yahoo.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <152F34EE-58BE-43BE-9E33-597F2AE1DFAA@mac.com>
Cc: Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Thinking outside the box on file systems
Date: Wed, 15 Aug 2007 13:17:39 -0400
To: Marc Perkel <mperkel@yahoo.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One note before you read the rest of this:
   The kinds of things you are discussing here are usually called  
"MAC" or "Mandatory Access Control", and they are always implemented  
on top of an LSM *after* ordinary "DAC" or "Discretionary Access  
Control" (IE: file permissions) are applied.  If your MAC rules are  
good enough you could theoretically just chmod 6777 all the files on  
the system and make them all root-owned, but why throw away mostly- 
free security?

On Aug 15, 2007, at 12:36:38, Marc Perkel wrote:
> --- Michael Tharp <gxti@partiallystapled.com> wrote:
>> Kyle Moffett wrote:
>>> Basically any newly-created item in such a directory will get the  
>>> permissions described by the "default:" entries in the ACL, and  
>>> subdirectories will get a copy of said "default:" entries.
>>
>> This would work well, although I would give write permissions to a  
>> group so the entire dir wouldn't need to be re-ACLed when a user  
>> is added. I may give this a shot; I've been avoiding ACLs because  
>> they have always
>> sounded incomplete/not useful, but the inheritance aspect sounds  
>> rather nice.
>
> Michael, my idea in this model is that there will be no permissions  
> stored in files. So you would not have to re-ACL anything.
>
> What I'm thinking is there would be a new permission system that is  
> completely different.
>
> It might be something like this. I am loged in as mperkel. I get  
> all the rights of mperkel and all other objects like groups or  
> management lists that I am a member of. Once the system has a full  
> list of my rights it starts to compare the file name I'm trying to  
> access to the rights I have by testing each section of the name. So  
> if the file is /home/mperkel/files/myfile then the test would be:

Big flashing "WARNING" sign number 1:  "Once the system has a _full_  
_list_ of..."  A "full list of" anything does not scale at all.  When  
coming up with kernel ideas, think of the biggest possible box you  
can imagine, then scale it up by 2-3 orders of magnitude.  If it  
still works then you're fine; otherwise....


> /home/mperkel/files/myfile - nothing
> /home/mperkel/files - nothing
> /home/mperkel - match - mperkel granted tree permission
>
> Rights tests would be based on trees so if you hit a tree  
> permission they you can access anything in the tree unless you have  
> hit a deny in the branches. All of this is based on the text  
> strings in the file name with the "/" separator for the tests.

Big flashing "WARNING" sign number 2:  You are doing privileges based  
on pathnames, which is a massive no-no.  Please go see the huge  
AppArmor/SELinux flame-war that occurred a month or so ago for all  
the reasons why pathname-based security doesn't work (and  
furthermore, doesn't scale).  Hint:  It has to do with 4 syscalls:  
chroot(), mount(), clone(CLONE_NEWNS), and link()


> The correct way of thinking of this is applying permissions to name  
> strings. Directories will become artificial constructs. For  
> example, one might grant permissions for files:
>
> /etc/*.conf - read only
> /etc - deny

And so when both /etc/shadow and /tmp/ 
file_about_to_be_nuked_by_a_daemon point to the same block of data,  
you now lose *ALL* of the benefits of that model.


> In this example the user would be able to read any file in the /etc  
> directory that ended in *.conf but no other files. If the object  
> listed the /etc directory it would only show the *.conf files and  
> no other file
> would appear to exist.

Big flashing "WARNING" sign number 3:  This means putting some kind  
of pattern matcher in the kernel.  I don't even want to *THINK* about  
how unholy of a hell that would be.  The way SELinux does this is by  
using regexes in userspace to set the appropriate *initial* labels on  
all the files, and let the system's automatic type transitions take  
care of the rest.

> The important point here is that directories don't really exist.

Except they do, and without directories the performance of your  
average filesystem is going to suck.


> Imagine that every file has an internal number that is linked to  
> the blocks that contain that file. Then there are file names that  
> link to that number directly.

These are called "inodes" and "hardlinks".  Every file and directory  
is a hardlink to the inode (using the inode number) containing its  
data.  For directories the inode data blocks have more inode  
references, and for files they have actual data blocks.  This is the  
model that UNIX operating systems have been using for years.


> Then there is a permission system that compares the name you are  
> requesting to a permission algorithm that determines what you are  
> allowed to do to the name that you are requesting.

The "name" that you are requesting is a fundamentally bad security  
concept.  Better is the attributes of the actual *inode* that you are  
requesting.


> Then you will not only be denied access to the /etc/passwd file,  
> you wouldn't even be able to tell if it exists.

You could theoretically do this with SELinux now; there was even a  
thread recently about somebody trying to add an LSM hook for readdir 
(), so that he could hide entries from an "ls".  On the other hand,  
under SELinux right now such a file looks like this:

root@ares:~# ls -al /foo
dr-xr-xr-x  3 root root 4096 2007-08-15 13:14 .
dr-xr-xr-x 26 root root 4096 2007-08-15 13:14 ..
?---------  - -    -       -                - file_with_no_selinux_perms

I can still tell that "file_with_no_selinux_perms" is actually a  
directory, though, by looking at the hardlink count of /foo.  Since  
it's 3, I can count up the parent-dir's-link and our own link,  
leaving one left which must be a child-dir's link.

Cheers,
Kyle Moffett


