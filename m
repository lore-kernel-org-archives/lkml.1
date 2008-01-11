Return-Path: <linux-kernel-owner+w=401wt.eu-S1760377AbYAKIrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760377AbYAKIrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 03:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760027AbYAKIq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 03:46:56 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:52257 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759967AbYAKIqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 03:46:55 -0500
Message-Id: <200801110846.m0B8kIf7088823@www262.sakura.ne.jp>
Subject: Re: [PATCH][RFC] Simple tamper-proof device filesystem.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: "\"\\\"Indan Zupancic\\\"\"" <indan@nul.nu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, w@1wt.eu,
       serue@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Fri, 11 Jan 2008 17:46:18 +0900
References: <200801011116.AFH73928.MHFLtOSOOVJFQF@I-love.SAKURA.ne.jp> <200801061520.JEF52626.LFHMtSQJOOVFFO@I-love.SAKURA.ne.jp> <20080106062609.GC20753@1wt.eu> <200801070020.DGI17963.HOOJStVMOFFQLF@I-love.SAKURA.ne.jp> <51953.81.207.0.53.1199738255.squirrel@secure.samage.net> <200801082250.CBI21893.FOQMOtSJFLOHFV@I-love.SAKURA.ne.jp> <45796.81.207.0.53.1199807221.squirrel@secure.samage.net> <200801090439.m094d267092095@www262.sakura.ne.jp> <47176.81.207.0.53.1199887192.squirrel@secure.samage.net> <200801100457.m0A4vcoi024209@www262.sakura.ne.jp> <36843.81.207.0.53.1200006346.squirrel@secure.samage.net>
In-Reply-To: <36843.81.207.0.53.1200006346.squirrel@secure.samage.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.



Indan Zupancic wrote:
> > It seems to me that the alternatives you are proposing include
> > modification of userland applications. But my assumption is
> > that "Don't require modification of userland applications".
> 
> If you want a secure system it isn't that unreasonable to expect
> applications to not do brain dead things, so not requiring any
> modifications or config changes seems a bit optimistic to me.

It depends.
Some users have to continue using brain dead legacy applications
without modification because ...

   the application's source code is not available.

   the distributor no longer supports the application.

   the application is too difficult/complicated to reconstruct.

For cases where you can expect "application won't do brain dead things"
and/or "we can reconstruct application", your approach is OK.



> > In other words, I want to implement without asking applications
> > to use /dev/dynamic/ or something.
> > This filesystem is intended to provide support for legacy applications.
> > (In fact, this filesystem in TOMOYO Linux is for kernel 2.4.30/2.6.11 and
> > later.)
> 
> Legacy applications should cope with a static /dev/.
> What is the advantage of your filesystem compared to a static /dev/?

I assume "a static /dev/" means a /dev/ directory in 2.4 kernels.
This filesystem's advantage:

  (1) Can guarantee filename/attribute pairs.

      A process with "root" privilege can do
      "mv /dev/hda1 /dev/hda1.tmp; mv /dev/hda2 /dev/hda1; mv /dev/hda1.tmp /dev/hda2"
      if /dev is in / partition or is a devfs partition, whereas
      a process with "root" privilege cannot do
      "mv /dev/hda1 /dev/hda1.tmp; mv /dev/hda2 /dev/hda1; mv /dev/hda1.tmp /dev/hda2"
      if /dev is this filesystem unless granted by the configuration file.

      So, you can guarantee that /dev/hda1 is block-3-1 and /dev/hda2 is block-3-2 .
      (e.g. "mount /dev/hda1 /home" won't mount block-3-2 partition on /home .)

  (2) Can keep nodes that needn't to be deleted/modified for read-only.

      A process with "root" privilege can delete /dev/null on / partition or
      on devfs partition, whereas a process with "root" privilege cannot delete
      /dev/null on this filesystem unless granted by the configuration file.

      So, you can guarantee the node which needn't to be deleted/modified
      won't be deleted/modified.
      (e.g. /dev/null is always there with char-1-3 attribute.)

  (3) Can hide unwanted device nodes.

      A process with "root" privilege can create new nodes on / partition or on devfs,
      whereas a process with "root" privilege cannot create new nodes on this filesystem
      that are not specified by configuration file.

      So, you can expose specific nodes selectively.
      (e.g. Allow accessing /dev/hda1 , but forbid accessing /dev/hda2 .)



> > Use of a tiny daemon that communicates with udev is not sufficient.
> > The udev is not the only application that modifies /dev files.
> 
> Oh, it isn't? Which other applications do modify /dev files? I'd like to
> hear about a few, no matter how obscure or proprietary. And please
> tell how many of those will stop working with a static /dev with all
> nodes they might create already existing.

I don't know. I'm not using rare software.



> > At least, the tiny daemon should communicate with the kernel
> > so that all requests are checked by the tiny daemon.
> 
> No, why should the kernel be involved? The tiny daemon would be
> the only one allowed to modify /dev/, so all mknod commands will
> be done by it. Of course it means that you might need to modify
> the two or three apps wanting to create device nodes, or you can
> make an LD_PRELOAD lib that intercepts mknod commands and
> sends them to the daemon.

No. The kernel must be involved.

Suppose the tiny daemon is the only one allowed to modify /dev/ .
"foo" requests "mknod /dev/null" from chroot() environment.
"bar" requests "mknod /dev/null" from clone(CLONE_FS) + mount() environment.

How can the daemon know where to create the node?
How can the daemon determine whether the requested pathname is
in /dev directory or not?
The process who requests "mknod" and the process who performs "mknod"
are not always using the same "/" directory.
The daemon must not forbid creation of /dev/null if the realpath() is
/tmp/dev/null (i.e. "mknod /dev/null" after "chroot /tmp"),
because the daemon is not asked to manage /tmp/dev directory.

Who can guarantee that the daemon can access all namespaces?
The process who requests "mknod" and the process who performs "mknod"
are not always using the same namespace.

If "foo" or "bar" is a statically linked or suid-root application
(where LD_PRELOAD is ignored), they would attempt to create device nodes
directly (i.e. call sys_mknod() instead of communicating with the daemon)
and abort due to failure.
Not only applications who wants to create device nodes in /dev/ ,
but also all applications who wants to modify entries in /dev/ .


>From the beginning, the kernel is deeply involved because in-kernel MAC
is essential to realize "only the tiny daemon can modify /dev/".
Why not do this "filename/attribute" checking in the kernel too?



> The ammount of code will be the current parsing code + a few hundred
> lines of code, including the preloaded library.

You will be bothered with "what is the realpath of /dev/null?" and
"how can I reach the realpath?" because you have to manage
namespace information.
In the LSM list, there was a discussion of
"How to implement (pathname based) AppArmor using (label based) SELinux",
and somebody proposed to use a daemon that immediately updates labels of
accessed files.
But I think such daemon cannot always access to all namespaces.



> >> If an administrator wants something else than
> >> 3 or 5, you're breaking something.
> > That's the fate of white-list based access control.
> >
> > Does this filesystem sound too strict to support dynamic device?
> > May be this filesystem should be able to permit creation of device
> > nodes that are not listed in the policy file.
> 
> Actually, I assumed that was the case, because if it's strictly white-list
> based it's almost the same as a static /dev with some nodes hidden.
> Without it has even less value, because it just complicates matters
> compared to a normal static dev.
> 
> I thought it checked that if a device name was in the list, it has the
> correct attributes, and was free to create nodes without restricted
> names.

OK. I'll consider adding this feature.
But I'd like to use approach (B) to keep the advantage (3).

(A) White-listing + Black-listing approach.

    "Permit any operations if the filename didn't appear
     in the configuration file".

(B) White-listing + Wild-card approach.

    "Support wildcard and permit only operations if
     the filename-with-wildcard/attributes-with-wildcard appeared
     in the configuration file".



Thanks.
