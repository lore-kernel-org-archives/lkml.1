Return-Path: <linux-kernel-owner+w=401wt.eu-S1760758AbYAKMWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760758AbYAKMWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 07:22:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757163AbYAKMWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 07:22:23 -0500
Received: from neon.samage.net ([85.17.153.66]:45549 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756395AbYAKMWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 07:22:21 -0500
Message-ID: <38047.81.207.0.53.1200054134.squirrel@secure.samage.net>
In-Reply-To: <200801110846.m0B8kIf7088823@www262.sakura.ne.jp>
References: <200801011116.AFH73928.MHFLtOSOOVJFQF@I-love.SAKURA.ne.jp>
    <200801061520.JEF52626.LFHMtSQJOOVFFO@I-love.SAKURA.ne.jp>
    <20080106062609.GC20753@1wt.eu>
    <200801070020.DGI17963.HOOJStVMOFFQLF@I-love.SAKURA.ne.jp>
    <51953.81.207.0.53.1199738255.squirrel@secure.samage.net>
    <200801082250.CBI21893.FOQMOtSJFLOHFV@I-love.SAKURA.ne.jp>
    <45796.81.207.0.53.1199807221.squirrel@secure.samage.net>
    <200801090439.m094d267092095@www262.sakura.ne.jp>
    <47176.81.207.0.53.1199887192.squirrel@secure.samage.net>
    <200801100457.m0A4vcoi024209@www262.sakura.ne.jp>
    <36843.81.207.0.53.1200006346.squirrel@secure.samage.net>
    <200801110846.m0B8kIf7088823@www262.sakura.ne.jp>
Date: Fri, 11 Jan 2008 13:22:14 +0100 (CET)
Subject: Re: [PATCH][RFC] Simple tamper-proof device filesystem.
From: "Indan Zupancic" <indan@nul.nu>
To: "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, w@1wt.eu,
       serue@us.ibm.com
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 025acf9a139f050bc01ccdeba87e03e0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, January 11, 2008 09:46, Tetsuo Handa wrote:
> It depends.
> Some users have to continue using brain dead legacy applications
> without modification because ...
>
>    the application's source code is not available.

Source isn't needed, as long as the vendor has it.

>    the distributor no longer supports the application.

Then why should anyone else support it?

>    the application is too difficult/complicated to reconstruct.

Then you can't trust it and it shouldn't have permission to do
potentially dangerous things in /dev/ either. Even if you can
contain the device node creation, it most likely does other
potentially dangerous things too. As a whole it can't be trusted.

> I assume "a static /dev/" means a /dev/ directory in 2.4 kernels.
> This filesystem's advantage:

I'm not talking about devfs, I'm talking about a real static /dev.
I'm using it now and it works fine (I let udev manage /udev/ to see
what's it's doing).

>   (1) Can guarantee filename/attribute pairs.

Wrong. All nodes are created and thus there's never a need to create
new nodes. So /dev/ can't be modified by anyone. This works because
all nodes that anyone might want to create already exist.

>   (2) Can keep nodes that needn't to be deleted/modified for read-only.

This would also be true for all nodes in a static /dev I think.

>   (3) Can hide unwanted device nodes.

In a static /dev you only create the nodes you want. It's true that it
can't hide nodes for hardware that doesn't exist (other than deleting
the nodes manually), but that was the norm for years before the
whole dynamic /dev thing catched up.

> I don't know. I'm not using rare software.

It doesn't have to be rare, anything is fine. You don't know
anything else than udev? (And shell commands like mknod etc.)

Then why all the talk about mysterious apps that might need to
do all kind of crazy things in /dev?

> No. The kernel must be involved.

> Who can guarantee that the daemon can access all namespaces?
> The process who requests "mknod" and the process who performs "mknod"
> are not always using the same namespace.

This is true on a theoretical level. But practically I think you can either
run multiple daemons, one for each namespace where you want to
control /dev/, or if you really want one daemon you can pass the
directory fd to it where the node should be created and use mknodat().
I believe that crosses namespaces correctly.

If the daemon can't be contacted or doesn't want to do a mknod for you,
the preloaded lib can fallback to doing the mknod itself, though normally
that would be disallowed by MAC.

But I think that the chance that any process needs to create device nodes
in a chroot is at the level of fairy existance.

> If "foo" or "bar" is a statically linked or suid-root application
> (where LD_PRELOAD is ignored), they would attempt to create device nodes
> directly (i.e. call sys_mknod() instead of communicating with the daemon)
> and abort due to failure.
> Not only applications who wants to create device nodes in /dev/ ,
> but also all applications who wants to modify entries in /dev/ .

If the preloaded library is setuid, it will also work for setuid programs.
It's true that it won't work for statically linked apps, but so what?

Device node creating apps are rare enough, let alone the ones that are
also statically linked. Nice theoretical problem, but I don't think anyone
will care in practice.

> From the beginning, the kernel is deeply involved because in-kernel MAC
> is essential to realize "only the tiny daemon can modify /dev/".
> Why not do this "filename/attribute" checking in the kernel too?

That "only the tiny daemon can modify /dev/" is done with MAC rules,
the ones that should be the default for all applications except udev by
default already. For teh kernel nothing changes.

>> The ammount of code will be the current parsing code + a few hundred
>> lines of code, including the preloaded library.
>
> You will be bothered with "what is the realpath of /dev/null?" and
> "how can I reach the realpath?" because you have to manage
> namespace information.

Or ignore the problem and see if it's a real problem or a nice theoretical
case. And when it turns out to be a real problem, there are probably
ways to fix it (See above). But you know what exactly is needed only
after problems do turn up.

> OK. I'll consider adding this feature.
> But I'd like to use approach (B) to keep the advantage (3).
>
> (A) White-listing + Black-listing approach.
>
>     "Permit any operations if the filename didn't appear
>      in the configuration file".
>
> (B) White-listing + Wild-card approach.
>
>     "Support wildcard and permit only operations if
>      the filename-with-wildcard/attributes-with-wildcard appeared
>      in the configuration file".

With this the filesystem at least adds some unique abilities.

If anyone really needs it and where/how it should be implemented is
another matter.

Without it it's a glorified and complicated drop-in replacement for
a static /dev/.

Regards,

Indan


