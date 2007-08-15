Return-Path: <linux-kernel-owner+w=401wt.eu-S934128AbXHOWOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934128AbXHOWOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 18:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758042AbXHOWOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 18:14:34 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:7290 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754533AbXHOWOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 18:14:33 -0400
Message-ID: <46C37AD4.5060006@cfl.rr.com>
Date: Wed, 15 Aug 2007 18:14:44 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Kyle Moffett <mrmacman_g4@mac.com>
CC: Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       Marc Perkel <mperkel@yahoo.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Thinking outside the box on file systems
References: <106259.96671.qm@web52501.mail.re2.yahoo.com> <Pine.LNX.4.64.0708141546510.22494@blackbox.fnordora.org> <46C2F96D.5030908@partiallystapled.com> <20070815133021.GB9412@csclub.uwaterloo.ca> <ECFEFFF7-0210-4D16-B508-5284FCE58B28@mac.com> <46C33934.7060802@cfl.rr.com> <DE34FF90-3143-4978-BBC5-3CF74B8C3C07@mac.com> <46C3644C.9020102@cfl.rr.com> <87EEB1B3-7FFA-472C-B539-1A7AA2843869@mac.com>
In-Reply-To: <87EEB1B3-7FFA-472C-B539-1A7AA2843869@mac.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Aug 2007 22:14:45.0755 (UTC) FILETIME=[AFDFECB0:01C7DF89]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1021-15364.001
X-TM-AS-Result: No--23.267300-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
>> I am well aware of that, I'm simply saying that sucks.  Doing a 
>> recursive chmod or setfacl on a large directory tree is slow as all hell.
> 
> Doing it in the kernel won't make it any faster.

Right... I'm talking about getting rid of it entirely.

> You can't safely preserve POSIX semantics that way.  For example, even 
> without *ANY* ability to read /etc/shadow, I can easily "ln /etc/shadow 
> /tmp/shadow", assuming they are on the same filesystem.  If the 
> /etc/shadow permissions depend on inherited ACLs to enforce access then 
> that one little command just made your shadow file 
> world-readable/writeable.  Oops.

That's why /etc/shadow would have an IRM that would block inheriting any 
permissions.

> Think about it this way:
> Permissions depend on *what* something is, not *where* it is.  Under 

No, they don't.  At least not always.  A lot of times people want 
permissions based on where it is.

> Linux you can leave the digital equivalent of a $10,000 piece of jewelry 
> lying around in /var/www and not have to worry about it being 
> compromised as long as you set your permissions properly (not that I 
> recommend it).  Moving the piece of jewelry around your house does not 
> change what it *is* (and by extension does not change the protection 
> required on it), any more than "ln /etc/shadow /tmp/shadow" (or "mv") 
> changes what *it* is.  If your /house is really extraordinarily secure 
> then you could leave the jewelry lying around as /house/gems.bin with 
> permissions 0777, but if somebody had a back-door to /house (an open fd, 
> a careless typo, etc) then you'd have the same issues.

Yes, but if you move it to your front porch, you have changed the 
protection on it.  If you want to be sure of it being protected, keep it 
locked up in a safe... in other words, use the IRM.

> Not necessarily.  When I do "vim some-file-in-current-directory", for 
> example, the kernel does *NOT* look up the path of my current 
> directory.  It does (in pseudocode):
> 
> if (starts_with_slash(filename)) {
>     entry = task->cwd;
> } else {
>     entry = task->root;
> }
> while (have_components_left(filename)
>     entry = lookup_next_component(filename);
> return entry;

Right.... and task->cwd would have the effective acl in memory, ready to 
be combined with any acl set on the file.

> That's not even paying attention to functions like "fchdir" or their 
> interactions with "chroot" and namespaces.  I can probably have an open 
> directory handle to a volume in a completely different namespace, a 
> volume which isn't even *MOUNTED* in my current fs namespace.  Using 
> that file-handle I believe I can "fchdir", "openat", etc, in a 
> completely different namespace.  I can do the same thing with a chroot, 
> except there I can even "escape":
>   /* Switch into chroot.  Doesn't drop root privs */
>   chdir("/some/dir/somewhere");
>   chroot(".");
> 
>   /* Malicious code later on */
>   chdir("/");
>   chroot("another_dir");
>   chdir("../../../../../../../../..");
>   chroot(".");
>   /* Now I'm back in the real root filesystem */

I don't see what this has to do with this discussion, and I also can't 
believe that is correct... the chdir( "../../../../.." ) should fail 
because there is no such directory.

> The locking penalty is because the path-lookup is *not* implied.  The 
> above chroot example shows that in detail.  If you have to do the lookup 
> in *reverse* on every open operation then you have to either:
> 
>   (A) Store lots of security context with every open directory (cwd 
> included).  When a directory you have open is moved, you still have full 
> access to everything inside it since your handle's data hasn't changed.

Yes, the effective acl of the open directory is kept in memory, but in 
the directory itself, not the handle to it, thus when the directory is 
moved, it's acl is recomputed for the new location and updated 
immediately.  It is like using fcntl to set a file to non blocking... it 
is the file you set, not the handle to it, so it effects other processes 
that have inherited or duplicated the file.

> See above.  Linux has a very *very* powerful VFS nowadays.  It also has 
> support for shared subtrees across private namespaces, allowing things 
> like polyinstantiation.  For example you can configure a Linux box so 
> every user gets their own empty /tmp directory created and mounted on 
> their namespace's /tmp when they log in, but all the rest of the system 
> mounts are all shared.

I still can't see how these features cause a problem.

