Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbYAIEjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbYAIEjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 23:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbYAIEjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 23:39:32 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:54042 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbYAIEja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 23:39:30 -0500
Message-Id: <200801090439.m094d267092095@www262.sakura.ne.jp>
Subject: Re: [PATCH][RFC] Simple tamper-proof device filesystem.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: "\"\\\"Indan Zupancic\\\"\"" <indan@nul.nu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, w@1wt.eu,
       serue@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Wed, 09 Jan 2008 13:39:02 +0900
References: <200801011116.AFH73928.MHFLtOSOOVJFQF@I-love.SAKURA.ne.jp> <200801061520.JEF52626.LFHMtSQJOOVFFO@I-love.SAKURA.ne.jp> <20080106062609.GC20753@1wt.eu> <200801070020.DGI17963.HOOJStVMOFFQLF@I-love.SAKURA.ne.jp> <51953.81.207.0.53.1199738255.squirrel@secure.samage.net> <200801082250.CBI21893.FOQMOtSJFLOHFV@I-love.SAKURA.ne.jp> <45796.81.207.0.53.1199807221.squirrel@secure.samage.net>
In-Reply-To: <45796.81.207.0.53.1199807221.squirrel@secure.samage.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Indan Zupancic wrote:
> I think you focus too much on your way of enforcing filename/attributes
> pairs.
So?

> The same can be achieved by creating the device nodes with
> expected attributes, and preventing processes from changing those files.
The device nodes have to be deletable if some process (including udev) needs to delete.
Thus, you cannot unconditionally prevent processes from changing those files.

> This because expected combinations are known beforehand.
Yes.

> And once those files are present, the MAC system used doesn't have to have special
> device nodes attributes support. Protecting those files is enough to
> guarantee filename/attributes pairs.
If MAC system needn't to support this filesystem's functionality,
who creates those files with warrantee of expected attributes? The udev does?
If udev is exploited, who can guarantee?

> No, this is because rename permission was given for files that it shouldn't had.
Do you think all MAC implementation have the same granularity and functionalities?
I don't think so. Not all MAC implementation can control with such granularity.
This filesystem is designed to be combined with any MAC,
although the MAC used with this filesystem should be able to restrict
namespace manipulation requests so that this filesystem can remain /dev
and visible to userland applications.

> Either you want a process to manage device names and attributes, and then you
> give it permission to do that, or you want to enforce certain filename/attribute
> pairs and then you just do it yourself.
If I modify udev to enforce certain filename/attribute pairs and the modified udev
was exploited, who can guarantee?
"Don't trust userland application" is the basis of restricting access in kernel space.
If you can trust userland application, you don't need in-kernel access control.


> Will your filesystem prevent the trivial case of
> 
> rm /dev/hda1
> ln -s /dev/hda2 /dev/hda1
> 
Of course. To permit the above operation, the following permissions are needed.

  hda1    660     0       6       2       b       3       1
  hda1    777     0       0      33       l       .

> Rename permission can be given for /dev in general, but prohibited for
> certain files in /dev, the ones you want to have specific attributes.
> It isn't all or nothing.
Do you think all MAC implementation can prohibit renaming for certain files in /dev ?

> It's "forbid modifying certain nodes that process needn't to modify"
> versus "forbid breaking filename/attribute pairs of certain nodes".
> 
> Both have the same effect, except that the first one is generic and
> can be done by existing MAC systems, while the second one needs
> a special filesystem and a handful of MAC rules to make it effective.
Do you think all MAC implementation can do?
I think the first one is implementation specific and the second one is generic.

> It doesn't matter where they are, it's that a different fs than yours could be
> mounted over it. You say a MAC can prevent that from happening, but a
> MAC can also prevent all processes except for udev from modifying /dev.
But MAC cannot prevent udev from modifying /dev . And what if exploited?
Not all MAC can enforce access control over all processes with the granularity
you are talking. And what if a process that cannot be controlled with your
boolean level granularity exists (e.g. an administrator running his/her
administrative applications that require modification of /dev )?

A crazy example of administrative applications:
(Please don't say "Don't use such crazy application".)

  #! /bin/sh
  rm -f /dev/either-null-or-zero
  read
  mknod /dev/either-null-or-zero c 1 $REPLY && echo "Administrative task finished successfully." | mail root

This filesystem can guarantee /dev/either-null-or-zero is either char-1-3 or char-1-5 by using a policy

  either-null-or-zero    666     0       0       3       c       1       3
  either-null-or-zero    666     0       0      35       c       1       5

The boolean level granularity (e.g. forbid all processes except for udev ,
and modify udev to perform name/attribute pair enforcement) is not generic.
Userland application sometimes misbehaves.
I assume kernel process doesn't misbehave.
If you doubt my assumption, you have to doubt in-kernel MAC implementation too.

> I don't. What I complain about is that it's too specific and does it one chosen
> job badly. It lacks abstraction. As far as I can see any decent MAC can achieve
> the same end result as your filesystem, without directly enforcing name/attr
> pairs.
Can SELinux guarantee the same result as my filesystem even if udev or
administrative programs have to be able to modify /dev ?

> The thing is, all special device nodes that are expected to exist by applications
> are known beforehand.
Yes.

> Thus they can be created statically and can be protected
> against any modifications with any MAC system.
But sometimes some modifications needs to be permitted.
Who can guarantee that there is no application (other than udev)
that creates/deletes /dev/zero instead of /dev/either-null-or-zero ?

> The dynamic nodes aren't known beforehand, so applications can't expect anything
> specific. And for things like usb-sticks andwhatnot, so what if the app gets hda2
> instead of the proper sdc1? It shouldn't matter, because at that point the
> malicious process has access to the device anyway, so all potential harm that could've been
> caused by the confusion (if any, which I doubt) it could do itself already.
Yes, they are the boundary.

> Call me silly, but implementing your checks in udev, or whatever handles /dev,
> and disallowing everything else from modifying /dev would also have the same
> effect. Or if you don't trust udevd write your own tiny replacement which does
> the checking, I'm sure that can be done in little extra code. Or modify udev so
> that it doesn't handle /dev directly, but passes it to your daemon who does the
> ckecks you want.
If everyone can always get source code and modify the source code
and make the code always error-free, I don't need in-kernel implementation.
As I said, userland application sometimes misbehaves.
I trust only in-kernel access control implementations
about guaranteeing name/attributes pairs.


Thanks.
