Return-Path: <linux-kernel-owner+w=401wt.eu-S1753097AbYAIOAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbYAIOAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 09:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbYAIN77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 08:59:59 -0500
Received: from neon.samage.net ([85.17.153.66]:49967 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbYAIN75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 08:59:57 -0500
Message-ID: <47176.81.207.0.53.1199887192.squirrel@secure.samage.net>
In-Reply-To: <200801090439.m094d267092095@www262.sakura.ne.jp>
References: <200801011116.AFH73928.MHFLtOSOOVJFQF@I-love.SAKURA.ne.jp>
    <200801061520.JEF52626.LFHMtSQJOOVFFO@I-love.SAKURA.ne.jp>
    <20080106062609.GC20753@1wt.eu>
    <200801070020.DGI17963.HOOJStVMOFFQLF@I-love.SAKURA.ne.jp>
    <51953.81.207.0.53.1199738255.squirrel@secure.samage.net>
    <200801082250.CBI21893.FOQMOtSJFLOHFV@I-love.SAKURA.ne.jp>
    <45796.81.207.0.53.1199807221.squirrel@secure.samage.net>
    <200801090439.m094d267092095@www262.sakura.ne.jp>
Date: Wed, 9 Jan 2008 14:59:52 +0100 (CET)
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
X-Scan-Signature: ac18bfb1ce7d6ff8844f825bb75e86c2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, January 9, 2008 05:39, Tetsuo Handa wrote:
> Hello.
>
> Indan Zupancic wrote:
>> I think you focus too much on your way of enforcing filename/attributes
>> pairs.
> So?

So that you miss alternatives and don't see the bigger picture.

>
>> The same can be achieved by creating the device nodes with
>> expected attributes, and preventing processes from changing those files.
> The device nodes have to be deletable if some process (including udev) needs
> to delete.
> Thus, you cannot unconditionally prevent processes from changing those files.
>
>> This because expected combinations are known beforehand.
> Yes.
>
>> And once those files are present, the MAC system used doesn't have to have
>> special
>> device nodes attributes support. Protecting those files is enough to
>> guarantee filename/attributes pairs.
> If MAC system needn't to support this filesystem's functionality,
> who creates those files with warrantee of expected attributes? The udev does?
> If udev is exploited, who can guarantee?

The person that would write the config file for your fs, the one who wants
that guarantee.

>
>> No, this is because rename permission was given for files that it shouldn't
>> had.
> Do you think all MAC implementation have the same granularity and
> functionalities?
> I don't think so. Not all MAC implementation can control with such
> granularity.
> This filesystem is designed to be combined with any MAC,
> although the MAC used with this filesystem should be able to restrict
> namespace manipulation requests so that this filesystem can remain /dev
> and visible to userland applications.

Good point, but I assume they all have at least a directory granularity, and then
/dev/ can be static and udev and other can have free reign in e.g. /dev/dynamic/.
Just use subdirs for the dynamic stuff and this granularity problem is, with
slight
inconvenience, solved.

>
>> Either you want a process to manage device names and attributes, and then
>> you
>> give it permission to do that, or you want to enforce certain
>> filename/attribute
>> pairs and then you just do it yourself.
> If I modify udev to enforce certain filename/attribute pairs and the modified
> udev
> was exploited, who can guarantee?
> "Don't trust userland application" is the basis of restricting access in
> kernel space.
> If you can trust userland application, you don't need in-kernel access
> control.

Funny, I thought that it was in the kernel because that's the way to protect
processes against eachother, the fs against processes, and for performance
reasons.

Exploits are in code, and where that code is doesn't matter that much, either
kernel or userspace, though if it's exploitable you'll rather not have it in the
kernel. So I think it's more secure if the checking would be done by udev than
in a special filesystem, even if that means that you're screwed if udev is
exploited. Of course you fully trust your own code, naturally.

A tiny daemon that communicates with udev and does the checking you have
now, and if ok it creates the node is really not much more code than your fs,
so as hard to exploit too. Then if udev is hacked you have the same guarantee
as you have now.

I can think of more alternatives that are as secure or more secure than the
current solution.

>
>
>> Will your filesystem prevent the trivial case of
>>
>> rm /dev/hda1
>> ln -s /dev/hda2 /dev/hda1
>>
> Of course. To permit the above operation, the following permissions are
> needed.
>
>   hda1    660     0       6       2       b       3       1
>   hda1    777     0       0      33       l       .

Yes, I should've read the code before asking that, instead of the other way
round.

>
>> Rename permission can be given for /dev in general, but prohibited for
>> certain files in /dev, the ones you want to have specific attributes.
>> It isn't all or nothing.
> Do you think all MAC implementation can prohibit renaming for certain files in
> /dev ?
>
>> It's "forbid modifying certain nodes that process needn't to modify"
>> versus "forbid breaking filename/attribute pairs of certain nodes".
>>
>> Both have the same effect, except that the first one is generic and
>> can be done by existing MAC systems, while the second one needs
>> a special filesystem and a handful of MAC rules to make it effective.
> Do you think all MAC implementation can do?
> I think the first one is implementation specific and the second one is
> generic.

Protecting certain files from being modified seems to me more generic than
enforcing filename/attributes pairs on device nodes. And if they can't do it
surely they can do it per directory, and the using subdirs solves it.

>
>> It doesn't matter where they are, it's that a different fs than yours could
>> be
>> mounted over it. You say a MAC can prevent that from happening, but a
>> MAC can also prevent all processes except for udev from modifying /dev.
> But MAC cannot prevent udev from modifying /dev . And what if exploited?
> Not all MAC can enforce access control over all processes with the granularity
> you are talking. And what if a process that cannot be controlled with your
> boolean level granularity exists (e.g. an administrator running his/her
> administrative applications that require modification of /dev )?
>
> A crazy example of administrative applications:
> (Please don't say "Don't use such crazy application".)
>
>   #! /bin/sh
>   rm -f /dev/either-null-or-zero
>   read
>   mknod /dev/either-null-or-zero c 1 $REPLY && echo "Administrative task
> finished successfully." | mail root
>
> This filesystem can guarantee /dev/either-null-or-zero is either char-1-3 or
> char-1-5 by using a policy
>
>   either-null-or-zero    666     0       0       3       c       1       3
>   either-null-or-zero    666     0       0      35       c       1       5
>
> The boolean level granularity (e.g. forbid all processes except for udev ,
> and modify udev to perform name/attribute pair enforcement) is not generic.

This is one solution. The other is to protect the files you want to guaruante
with
MAC and then all apps can do whatever they want, not only udev, except for
breaking the guaranteed filename/attributes pairs. And if that can't happen
within dev on a per filename base, then it can happen per directory, and apps
may create only nodes in certain subdirs of /dev/, instead of /dev/ itself.

And those other programs could be taught to create the nodes via udev who
does the checking, or they all modify a /dyndev/ and a daemon who does the
checking copies nodes over to the real /dev/ when it's sane. There are plenty
of ways to solve those details.

rm -f /dev/either-null-or-zero

as said before, if this is possible then the MAC config used is wrong. Exactly
the same as for your filesystem with

mknod /dev/tmp1 c 1 X
mount --bind /dev/tmp1 /dev/either-null-or-zero

and you count on the MAC to prevent that.

And as for that app, if you trust it to create device nodes, why don't you
trust it
to make the right nodes too? If an administrator wants something else than
3 or 5, you're breaking something. The worst is that as it's an administrator
app it's made for policy handling, but you just moved that to somewhere else,
basically making the app useless and spreading around config stuff.

This app is unrealistic anyway. The standard way to choose between /dev/null
and /dev/zero is to open one instead of the other, instead of changing the
content.
The interface is also crap because if the choice is really between null and
zero, the
argument shouldn't be a cryptic number but the choice. And then it are two if
checks with fixed mknod commands. If you trust this script you get what you
deserve when something else is passed than 3 or 5, because it's obvious that
that's
possible.

> Userland application sometimes misbehaves.
> I assume kernel process doesn't misbehave.
> If you doubt my assumption, you have to doubt in-kernel MAC implementation
> too.

See above. But who says that the MAC used can provide the additional protection
that's needed to make your fs work at all?

>
>> I don't. What I complain about is that it's too specific and does it one
>> chosen
>> job badly. It lacks abstraction. As far as I can see any decent MAC can
>> achieve
>> the same end result as your filesystem, without directly enforcing name/attr
>> pairs.
> Can SELinux guarantee the same result as my filesystem even if udev or
> administrative programs have to be able to modify /dev ?

More, because your filesystem doesn't guarantee anything at all on its own.
But assuming the MAC is decent enough to protect your fs from being bypassed,
I'm sure it can do what's needed fine without your fs. I can't answer for SELinux
because I don't know it well. But I trust it can protect files and/or
directories, and
that's all that's needed to achieve the same end result.

>
>> The thing is, all special device nodes that are expected to exist by
>> applications
>> are known beforehand.
> Yes.
>
>> Thus they can be created statically and can be protected
>> against any modifications with any MAC system.
> But sometimes some modifications needs to be permitted.
> Who can guarantee that there is no application (other than udev)
> that creates/deletes /dev/zero instead of /dev/either-null-or-zero ?

I hope the MAC can do it. If not, I hope it can protect /dev/ and all
modifications need to be done in subdirs of dev, which practically
already happens anyway. And if the MAC can't even do that, I think
it's a useless piece of junk.

>
>> The dynamic nodes aren't known beforehand, so applications can't expect
>> anything
>> specific. And for things like usb-sticks andwhatnot, so what if the app gets
>> hda2
>> instead of the proper sdc1? It shouldn't matter, because at that point the
>> malicious process has access to the device anyway, so all potential harm
>> that could've been
>> caused by the confusion (if any, which I doubt) it could do itself already.
> Yes, they are the boundary.
>
>> Call me silly, but implementing your checks in udev, or whatever handles
>> /dev,
>> and disallowing everything else from modifying /dev would also have the same
>> effect. Or if you don't trust udevd write your own tiny replacement which
>> does
>> the checking, I'm sure that can be done in little extra code. Or modify udev
>> so
>> that it doesn't handle /dev directly, but passes it to your daemon who does
>> the
>> ckecks you want.
> If everyone can always get source code and modify the source code
> and make the code always error-free, I don't need in-kernel implementation.
> As I said, userland application sometimes misbehaves.
> I trust only in-kernel access control implementations
> about guaranteeing name/attributes pairs.

You seem to assume that the in-kernel implementation is suddenly
guaranteed bugfree. And the alternative above doesn't require any
source code except of udev, which is available. And it doesn't need to
be more bugfree than your current code either.

You didn't answer my question why the checking isn't done globally
if it's so important.

Greetings,

Indan


