Return-Path: <linux-kernel-owner+w=401wt.eu-S1757436AbYAJFIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbYAJFIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 00:08:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbYAJFIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 00:08:43 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:60891 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbYAJFIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 00:08:41 -0500
Message-Id: <200801100457.m0A4vcoi024209@www262.sakura.ne.jp>
Subject: Re: [PATCH][RFC] Simple tamper-proof device filesystem.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: "\"\\\"Indan Zupancic\\\"\"" <indan@nul.nu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, w@1wt.eu,
       serue@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Thu, 10 Jan 2008 13:57:38 +0900
References: <200801011116.AFH73928.MHFLtOSOOVJFQF@I-love.SAKURA.ne.jp> <200801061520.JEF52626.LFHMtSQJOOVFFO@I-love.SAKURA.ne.jp> <20080106062609.GC20753@1wt.eu> <200801070020.DGI17963.HOOJStVMOFFQLF@I-love.SAKURA.ne.jp> <51953.81.207.0.53.1199738255.squirrel@secure.samage.net> <200801082250.CBI21893.FOQMOtSJFLOHFV@I-love.SAKURA.ne.jp> <45796.81.207.0.53.1199807221.squirrel@secure.samage.net> <200801090439.m094d267092095@www262.sakura.ne.jp> <47176.81.207.0.53.1199887192.squirrel@secure.samage.net>
In-Reply-To: <47176.81.207.0.53.1199887192.squirrel@secure.samage.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Indan Zupancic wrote:
> Good point, but I assume they all have at least a directory granularity, and then
> /dev/ can be static and udev and other can have free reign in e.g. /dev/dynamic/.
> Just use subdirs for the dynamic stuff and this granularity problem is, with
> slight inconvenience, solved.

It seems to me that the alternatives you are proposing include modification of
userland applications. But my assumption is that
"Don't require modification of userland applications".
In other words, I want to implement without asking applications
to use /dev/dynamic/ or something.
This filesystem is intended to provide support for legacy applications.
(In fact, this filesystem in TOMOYO Linux is for kernel 2.4.30/2.6.11 and later.)



> Exploits are in code, and where that code is doesn't matter that much, either
> kernel or userspace, though if it's exploitable you'll rather not have it in the
> kernel. So I think it's more secure if the checking would be done by udev than
> in a special filesystem, even if that means that you're screwed if udev is
> exploited. Of course you fully trust your own code, naturally.

I'm keeping the mechanism as simple as possible
so that there is unlikely room (e.g. buffer overflow) for running exploits.



> A tiny daemon that communicates with udev and does the checking you have
> now, and if ok it creates the node is really not much more code than your fs,
> so as hard to exploit too. Then if udev is hacked you have the same guarantee
> as you have now.

Use of a tiny daemon that communicates with udev is not sufficient.
The udev is not the only application that modifies /dev files.
At least, the tiny daemon should communicate with the kernel
so that all requests are checked by the tiny daemon.
But use of the tiny daemon (which is a process running in userland)
causes a lot of troubles.
See the block after the "---------- boundary ----------" of this posting.

My assumption is that "Don't require userland process's assistance",
as written at "Why not use FUSE?".



> Protecting certain files from being modified seems to me more generic than
> enforcing filename/attributes pairs on device nodes. 
OK. You are saying that from the point of view of "what it can".
I thought you were saying "enforcing filename/attributes pairs
from out-of-this-filesystem (e.g. MAC) is more flexible than this-filesystem".



> rm -f /dev/either-null-or-zero
> 
> as said before, if this is possible then the MAC config used is wrong. Exactly
> the same as for your filesystem with
> 
> mknod /dev/tmp1 c 1 X
> mount --bind /dev/tmp1 /dev/either-null-or-zero
> 
> and you count on the MAC to prevent that.

An administrator asks MAC to prevent processes
(except specific processes who need to do "rm -f /dev/either-null-or-zero")
from doing "rm -f /dev/either-null-or-zero".

An administrator asks this filesystem to prevent processes from doing
"mknod /dev/tmp1 c 1 X".

An administrator asks MAC to prevent processes from doing
"mount --bind /dev/tmp1 /dev/either-null-or-zero".



> And as for that app, if you trust it to create device nodes, why don't you
> trust it to make the right nodes too?

If that app has a bug that triggers
  mknod /dev/either-null-or-zero 1$REPLY
instead of
  mknod /dev/either-null-or-zero $REPLY
under an unexpected circumstance, it will create unwanted nodes.
Thus I don't trust the app.



> If an administrator wants something else than
> 3 or 5, you're breaking something.
That's the fate of white-list based access control.

Does this filesystem sound too strict to support dynamic device?
May be this filesystem should be able to permit creation of device nodes
that are not listed in the policy file.



> > Can SELinux guarantee the same result as my filesystem even if udev or
> > administrative programs have to be able to modify /dev ?
> 
> More, because your filesystem doesn't guarantee anything at all on its own.
> But assuming the MAC is decent enough to protect your fs from being bypassed,
> I'm sure it can do what's needed fine without your fs. I can't answer for SELinux
> because I don't know it well. But I trust it can protect files and/or
> directories, and that's all that's needed to achieve the same end result.

I don't know SELinux well, but as far as seeing an example
(found by Googling "selinux allow mknod")

  allow udev_t self:capability { chown dac_override dac_read_search fowner fsetid sys_admin sys_nice mknod net_raw net_admin sys_rawio };

I can't find a place to specify filename/attributes pairs in this syntax.
So, if the process who is permitted to create device nodes misbehaves,
it will generate unexpected filename/attribute pairs.
I think SELinux can't guarantee the same result as my filesystem.



> You seem to assume that the in-kernel implementation is suddenly
> guaranteed bugfree.
I keep the implementation as simple as possible.



>From your next posting:
> But I think doing more is getting ridiculous, because if a process can
> create a device node, it can also access it and do whatever harm could
> be done by the confusion caused by unexpected name/attribute pairs.

FYI. Being able to create a device node is different from being able to access it
and do whatever harm. You will need read and/or write permission to open that device.
It is possible to write an application who can create a device node but cannot open that node.
What this filesystem is trying to solve is that
"guarantee filename/attribute pairs for device nodes".


---------- boundary ----------


This filesystem is a kind of MAC implementation dedicated for
guaranteeing filename/attributes pairs.
But to avoid confusion with generic MAC implementation
(which performs access controls based on subject's rights and
object's attributes, such as SELinux),
I'm not calling this filesystem as a MAC implementation.

The problem is caused by the Unix's way of calling special functions
(e.g. a function that always gets EOF on read()) is associated with
filenames (e.g. /dev/null) and applications calls special functions
using the filenames.

If the way of calling special functions were
  int fd = opendev("char", "1", "3", O_RDONLY);
instead of
  int fd = open("/dev/null", O_RDONLY);
I don't need to implement this filesystem.

And the association of filename and attributes is performed
when a device node is created by mknod() (e.g. shmem_get_inode() for tmpfs).
So, I believe it is natural to implement filename/attributes pair enforcement
in the same layer (i.e. filesystem layer).

Fortunately, administrators use a dedicated partition for /dev
(i.e. mount tmpfs on /dev and let udev manipulate device nodes).
So, I can implement this filename/attributes enforcement within tmpfs.

Implementing this filename/attributes enforcement out of filesystem layer
causes a lot of troubles (i.e. amount of source code that developers have to write
and the amount of policy configuration that administrators have to configure).

  If you don't rely on help from a userland process,
  you have to be careful with the following points.

    Guarantee the MAC implementation has enough granularities to support
    filename/attribute information for mknod permission.

    Guarantee the MAC policy never contains an entry that can cause
    filename/attribute mismatching (e.g. a permission to link from
    /dev/hda1 (which has char-3-1 attributes) to /dev/hda2 (which has
    char-3-2 attributes)).

  If you rely on help from a userland process, you have to be careful with
  the following points.

    Guarantee that the daemon process the kernel is communicating with is genuine.
    (If the daemon is a fake, no one can guarantee.)

    Guarantee that the daemon process the kernel is communicating with
    is free from segmentation faults or signals or ptraces.
    (If the daemon dies by SIGSEGV or SIGKILL, the kernel can no longer judge.
     If the daemon is controlled by other process using ptrace(),
     the kernel will receive fake response from the daemon.
     I'm sure the daemon is killed by a shutdown script in /etc/init.d/ directory.)

Do you want to let developers implement these functionalities and
let administrators configure all policy for these functionalities?

I'm sure it is impossible.
Not all MAC supports these functionalities.
Not all administrators have enough knowledge and skills for configuring policy.

But implementing this filename/attributes enforcement in filesystem layer
causes less troubles. It just requires that:

  Keep this filesystem mounted on /dev always visible to userland.

In other words,

  Prevent unauthorized users/processes from mounting other filesystem over this filesystem.
  Prevent unauthorized users/processes from unmounting this filesystem.

This is much easier and likely to configure proper policy for this filesystem.

Regards.
