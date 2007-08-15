Return-Path: <linux-kernel-owner+w=401wt.eu-S936745AbXHOVS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936745AbXHOVS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 17:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761373AbXHOVSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 17:18:09 -0400
Received: from smtpout.mac.com ([17.250.248.175]:52873 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410AbXHOVSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 17:18:07 -0400
In-Reply-To: <46C3644C.9020102@cfl.rr.com>
References: <106259.96671.qm@web52501.mail.re2.yahoo.com> <Pine.LNX.4.64.0708141546510.22494@blackbox.fnordora.org> <46C2F96D.5030908@partiallystapled.com> <20070815133021.GB9412@csclub.uwaterloo.ca> <ECFEFFF7-0210-4D16-B508-5284FCE58B28@mac.com> <46C33934.7060802@cfl.rr.com> <DE34FF90-3143-4978-BBC5-3CF74B8C3C07@mac.com> <46C3644C.9020102@cfl.rr.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <87EEB1B3-7FFA-472C-B539-1A7AA2843869@mac.com>
Cc: Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       Marc Perkel <mperkel@yahoo.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Al Viro <viro@zeniv.linux.org.uk>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Thinking outside the box on file systems
Date: Wed, 15 Aug 2007 17:17:17 -0400
To: Phillip Susi <psusi@cfl.rr.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro added to the CC, since he's one of the experts on this stuff  
and will probably whack me with a LART for explaining it all wrong,  
or something. :-D

On Aug 15, 2007, at 16:38:36, Phillip Susi wrote:
> Kyle Moffett wrote:
>> We've *always* had to do this; that's what "chmod -R" or "setfacl - 
>> R" are for :-D.  The major problem is that the locking and lookup  
>> overhead gets really significant if you have to look at the entire  
>> directory tree in order to determine the permissions for one  
>> single object.  I definitely agree that we need better GUIs for  
>> managing file permissions, but I don't see how you could modify  
>> the kernel in this case to do what you want.
>
> I am well aware of that, I'm simply saying that sucks.  Doing a  
> recursive chmod or setfacl on a large directory tree is slow as all  
> hell.

Doing it in the kernel won't make it any faster.


> As for hard links, your access would depend on which name you use  
> to access the file.  The file itself may still have an acl that  
> grants or denies access to people no matter what name they use, but  
> if it allows inheritance, then which name you access it by will  
> modify the effective acl that it gets.

You can't safely preserve POSIX semantics that way.  For example,  
even without *ANY* ability to read /etc/shadow, I can easily "ln /etc/ 
shadow /tmp/shadow", assuming they are on the same filesystem.  If  
the /etc/shadow permissions depend on inherited ACLs to enforce  
access then that one little command just made your shadow file world- 
readable/writeable.  Oops.

Think about it this way:
Permissions depend on *what* something is, not *where* it is.  Under  
Linux you can leave the digital equivalent of a $10,000 piece of  
jewelry lying around in /var/www and not have to worry about it being  
compromised as long as you set your permissions properly (not that I  
recommend it).  Moving the piece of jewelry around your house does  
not change what it *is* (and by extension does not change the  
protection required on it), any more than "ln /etc/shadow /tmp/ 
shadow" (or "mv") changes what *it* is.  If your /house is really  
extraordinarily secure then you could leave the jewelry lying around  
as /house/gems.bin with permissions 0777, but if somebody had a back- 
door to /house (an open fd, a careless typo, etc) then you'd have the  
same issues.


> As for performance implications, I hardly think it is worrisome.   
> Each directory in the path has to be looked up anyhow so you  
> already have their acls, so when you finally reach the file, you  
> just have to take the union of the acls encountered on the way.   
> Should only be a few cpu cycles.

Not necessarily.  When I do "vim some-file-in-current-directory", for  
example, the kernel does *NOT* look up the path of my current  
directory.  It does (in pseudocode):

if (starts_with_slash(filename)) {
	entry = task->cwd;
} else {
	entry = task->root;
}
while (have_components_left(filename)
	entry = lookup_next_component(filename);
return entry;


That's not even paying attention to functions like "fchdir" or their  
interactions with "chroot" and namespaces.  I can probably have an  
open directory handle to a volume in a completely different  
namespace, a volume which isn't even *MOUNTED* in my current fs  
namespace.  Using that file-handle I believe I can "fchdir",  
"openat", etc, in a completely different namespace.  I can do the  
same thing with a chroot, except there I can even "escape":
   /* Switch into chroot.  Doesn't drop root privs */
   chdir("/some/dir/somewhere");
   chroot(".");

   /* Malicious code later on */
   chdir("/");
   chroot("another_dir");
   chdir("../../../../../../../../..");
   chroot(".");
   /* Now I'm back in the real root filesystem */


>> There's also the question of what to do about namespaces and bind  
>> mounts.  If I run "mount --bind /foo /home/foo", then do I get  
>> different file permissions depending on what path I access the  
>> file by?  What if I then run chroot("/foo"), do I get different  
>> file permissions then?  What if I have two namespaces, each with  
>> their own root filesystem (say "root1" and "root2"), and I mount  
>> the other namespace's root filesystem in a subdir of each:
>>   NS1:  mount /dev/root2 /otherns
>>   NS2:  mount /dev/root1 /otherns
>> Now I have the following paths to the same file, do these get  
>> different permissions or the same?
>>   NS1:/foo == NS2:/otherns/foo
>>   NS2:/bar == NS1:/otherns/bar
>> If you answered that they get different permissions, then how do  
>> you handle the massive locking performance penalty due to the  
>> extra lookups?  If you answered "same permissions", then how do  
>> you explain the obvious discrepancy to the admin?
>
> Good question.  I would say the bind mount should have a flag to  
> specify.  That way the admin can choose where it should inherit  
> from.  I also don't see where this locking penalty is.

The locking penalty is because the path-lookup is *not* implied.  The  
above chroot example shows that in detail.  If you have to do the  
lookup in *reverse* on every open operation then you have to either:

   (A) Store lots of security context with every open directory (cwd  
included).  When a directory you have open is moved, you still have  
full access to everything inside it since your handle's data hasn't  
changed.

OR

   (B) Do a reverse-lookup on every operation, which means you are  
taking locks in the reverse order from the normal lookup order and  
you're either very inefficient and slow or you're deadlocky.  This is  
also vulnerable to confusion when the "path" isn't visible from your  
namespace/chroot at all.  This also causes problems with overmounted  
directories:
	root@ares:/# mkdir -p /foo/bar
	root@ares:/# cd /foo/bar
	root@ares:/foo/bar# mount -t tmpfs tmpfs /foo
	root@ares:/foo/bar# touch /foo/bar/baz
	touch: cannot touch `/foo/bar/baz': No such file or directory
	root@ares:/foo/bar# pwd
	/foo/bar
	root@ares:/foo/bar# ls -al
	total 4
	drwxr-xr-x 2 root root 4096 2007-08-15 17:04 .
	drwxrwxrwt 2 root root   40 2007-08-15 17:04 ..


>> The idea is nice, but as soon as you add multiple namespaces,  
>> chroots, or bind mounts the concept breaks down.  For security- 
>> sensitive things like file permissions, you really do want  
>> determinate behavior regardless of the path used to access the data.
>
> How does it break down?  Chroots have absolutely no impact at all,  
> and the bind mounts/namespaces can be handled as I mentioned  
> above.  If you really want to be sure of the effective permissions  
> on the file, then you simply flag it to not inherit from its parent  
> or use an inherited rights mask to block the specific inherited  
> permissions you want.

See above.  Linux has a very *very* powerful VFS nowadays.  It also  
has support for shared subtrees across private namespaces, allowing  
things like polyinstantiation.  For example you can configure a Linux  
box so every user gets their own empty /tmp directory created and  
mounted on their namespace's /tmp when they log in, but all the rest  
of the system mounts are all shared.

I'll be offline for a couple days, we can chat more when I get back.

Cheers,
Kyle Moffett

