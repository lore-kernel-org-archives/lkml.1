Return-Path: <linux-kernel-owner+w=401wt.eu-S1760150AbYAHPrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbYAHPrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 10:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbYAHPrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 10:47:09 -0500
Received: from neon.samage.net ([85.17.153.66]:38543 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538AbYAHPrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 10:47:08 -0500
Message-ID: <45796.81.207.0.53.1199807221.squirrel@secure.samage.net>
In-Reply-To: <200801082250.CBI21893.FOQMOtSJFLOHFV@I-love.SAKURA.ne.jp>
References: <200801011116.AFH73928.MHFLtOSOOVJFQF@I-love.SAKURA.ne.jp>
    <200801061520.JEF52626.LFHMtSQJOOVFFO@I-love.SAKURA.ne.jp>
    <20080106062609.GC20753@1wt.eu>
    <200801070020.DGI17963.HOOJStVMOFFQLF@I-love.SAKURA.ne.jp>
    <51953.81.207.0.53.1199738255.squirrel@secure.samage.net>
    <200801082250.CBI21893.FOQMOtSJFLOHFV@I-love.SAKURA.ne.jp>
Date: Tue, 8 Jan 2008 16:47:01 +0100 (CET)
Subject: Re: [PATCH][RFC] Simple tamper-proof device filesystem.
From: "Indan Zupancic" <indan@nul.nu>
To: "Tetsuo Handa" <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, w@1wt.eu,
       serue@us.ibm.com
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 9bf25e62613229f0beb95d8bfda7a7aa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tetsuo,

I think you focus too much on your way of enforcing filename/attributes
pairs. The same can be achieved by creating the device nodes with
expected attributes, and preventing processes from changing those files.
This because expected combinations are known beforehand. And once
those files are present, the MAC system used doesn't have to have special
device nodes attributes support. Protecting those files is enough to
guarantee filename/attributes pairs.

On Tue, January 8, 2008 14:50, Tetsuo Handa wrote:
> Hello.
>
>
> Indan Zupancic wrote:
>> > I want to use this filesystem in case where a process with root privilege
>> was
>> > hijacked but the behavior of the hijacked process is still restricted by
>> MAC.
>>
>> 1) If the behaviour can be controlled, why can't the process be
>>    disallowed to change anything badly in /dev? Like disallowing anything
>>    from modifying existing nodes that weren't created by that process.
>>    That would have practically the same effect as your filesystem,
>>    won't it?
> MAC system can prevent hijacked processes from changing anything badly in /dev
> .
> But MAC system can't prevent hijacked processes from doing
> "mv /dev/hda1 /dev/hda1.tmp; mv /dev/hda2 /dev/hda1; mv /dev/hda1.tmp
> /dev/hda2"
> if permissions to rename device nodes in /dev are given to hijacked processes.
> This is because MAC implementation doesn't check filename/attribute pairs.

No, this is because rename permission was given for files that it shouldn't had.
Either you want a process to manage device names and attributes, and then you
give it permission to do that, or you want to enforce certain filename/attribute
pairs and then you just do it yourself.

Will your filesystem prevent the trivial case of

rm /dev/hda1
ln -s /dev/hda2 /dev/hda1

>
> But this filesystem can prevent hijacked processes from doing
> "mv /dev/hda1 /dev/hda1.tmp; mv /dev/hda2 /dev/hda1; mv /dev/hda1.tmp
> /dev/hda2"
> even if permissions to rename device nodes in /dev are given to hijacked
> processes.

Rename permission can be given for /dev in general, but prohibited for
certain files in /dev, the ones you want to have specific attributes.
It isn't all or nothing.

>
> This filesystem is not designed to
> "forbid modifying nodes if that process needn't to modify nodes".
> This filesystem is designed to
> "forbid breaking filename/attribute pairs of nodes
> even if that process need to (or permitted to) modify nodes".

It's "forbid modifying certain nodes that process needn't to modify"
versus "forbid breaking filename/attribute pairs of certain nodes".

Both have the same effect, except that the first one is generic and
can be done by existing MAC systems, while the second one needs
a special filesystem and a handful of MAC rules to make it effective.


>> 2) The MAC system may not be able to guarantee certain combinations
>>    of device names and properties, but isn't that policy that shouldn't
>>    be in the kernel anyway? But if it is, shouldn't all device nodes be
>>    checked? That is, shouldn't it be a global check instead of a filesystem
>>    specific one?
> I think the reason why MAC system doesn't handle filename/attributes pairs is
> that:
>
>     Filename and its attributes pairs are conventionally considered as
>     constant and reliable.
>
>     It makes the MAC's policy syntax complicated to describe this attribute
>     enforcement information in MAC's policy.
>
> Thus, this should be a global check. But usually device nodes are only in /dev
> .

It doesn't matter where they are, it's that a different fs than yours could be
mounted over it. You say a MAC can prevent that from happening, but a
MAC can also prevent all processes except for udev from modifying /dev.
Done globally instead of as a filesystem it can actually guarantee name/attr
pairs, now it can't even do that on its own.

>
>> 3) Code efficiency. Thousand lines of code just to close one very specific
>>    attack, which can be done in lots of different other ways that all need
>>    to be prevented by the MAC system. (mounting over it, intercepting open
>>    calls, duping the fd, etc.) Is it worth it?
> This filesystem is doing what MAC system is not doing.
> So, please don't complain about inability of this filesystem to close all
> attacks.

I don't. What I complain about is that it's too specific and does it one chosen
job badly. It lacks abstraction. As far as I can see any decent MAC can achieve
the same end result as your filesystem, without directly enforcing name/attr
pairs.

> You can use MAC system to prevent attackers from mounting other filesystem
> over this filesystem.
>
> The filename/attribute pairs are something like system call entry tables.
> The application will go wrong if __NR_read is mapped to sys_write() and
> __NR_write is mapped to sys_read().
> Userland applications access special functionalities (e.g. /dev/zero and
> /dev/random)
> by name (i.e. syscall numbers). Therefore, keeping the filename/attribute
> pairs
> tamper-proof is important.
>
> You recognize that there is a threat that device nodes may have irregular
> attribute (e.g. /dev/null existing as a regular file), do you?
> You don't deny implementing mechanisms somehow to avoid such threat, do you?
> OK. Then the matter is the comparison of code efficiency.

The thing is, all special device nodes that are expected to exist by applications
are known beforehand. Thus they can be created statically and can be protected
against any modifications with any MAC system.

The dynamic nodes aren't known beforehand, so applications can't expect anything
specific. And for things like usb-sticks andwhatnot, so what if the app gets hda2
instead of the proper sdc1? It shouldn't matter, because at that point the
malicious
process has access to the device anyway, so all potential harm that could've been
caused by the confusion (if any, which I doubt) it could do itself already.

>
> This patch is less than 1100 lines in total.
> Large part of this patch is for parsing and managing policy file.

That doesn't make it better.

> If you try to extend every MAC implementation (SELinux, SMACK, AppArmor,
> TOMOYO)
> so that they can handle filename/attributes pairs (i.e. expand policy file's
> syntax
> and both in-kernel and userland data structures, manage strings with variant
> length
> and non-printable characters etc.), I think that modification exceeds this
> patch.
> I think guaranteeing filename/attribute pairs in filesystem layer can keep
> MAC system implementation simple and compact.
> http://www.mail-archive.com/linux-fsdevel@vger.kernel.org/msg10653.html

That's because the way you would do it in MACs is the same wrong way as
you do it now.

Call me silly, but implementing your checks in udev, or whatever handles /dev,
and disallowing everything else from modifying /dev would also have the same
effect. Or if you don't trust udevd write your own tiny replacement which does
the checking, I'm sure that can be done in little extra code. Or modify udev so
that it doesn't handle /dev directly, but passes it to your daemon who does the
ckecks you want.

Because all your filesystem does is handling the case that udev is exploited,
when a proper MAC system is used.

There are so many ways to achieve the same goal, but better, and if you're really
serious about guarantees it shouldn't be in the filesystem anyway.

Greetings,

Indan


