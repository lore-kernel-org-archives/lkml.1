Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbZEBNbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbZEBNbT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 09:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbZEBNbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 09:31:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:36094 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbZEBNbF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 09:31:05 -0400
MIME-Version: 1.0
In-Reply-To: <a55d774e0905012142p7acd1086kc5a10d834b021eaa@mail.gmail.com>
References: <1241097822.2516.3.camel@poy> <20090430222900.c13b63d5.akpm@linux-foundation.org> 
	<20090501061701.GB19234@kroah.com> <20090430234312.a63fa5cf.akpm@linux-foundation.org> 
	<20090501065527.GA19773@kroah.com> <a55d774e0905011824k11e06f61ibc9937a2b26fd9e0@mail.gmail.com> 
	<ac3eb2510905011848i51aef8e6wbe9506a13e67377d@mail.gmail.com> 
	<a55d774e0905011902y1827322ascd7d2eb42570d1dc@mail.gmail.com> 
	<ac3eb2510905011928o26ae45efr2b23deafda76e1fc@mail.gmail.com> 
	<a55d774e0905012142p7acd1086kc5a10d834b021eaa@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 2 May 2009 15:30:49 +0200
Message-ID: <ac3eb2510905020630h1261958ey8dca74e3b1cbaa63@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
To: Brian Swetland <swetland@google.com>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 2, 2009 at 06:42, Brian Swetland <swetland@google.com> wrote:

>>> In our world we use groups to provide access to specific classes of
>>> hardware resources (audio, video, display, dsp, etc) and processes
>>> that have the appropriate permissions are arranged to run with
>>> necessary additional groups for the hardware they need to access.
>>
>> These group numbers are always static on your system, and don't get
>> changed while the system is running? Like you always assign gid X to
>> all sound devices? Or do you need to manage them dynamically?
>
> The gids for device access are static, part of the platform
> definition.

This definition does mainly assign a specific gid to every device of a
specific subsystem, right? Like you have all sound devices use one
gid, all video devices use another one, ...  Very similar what udev
does on every system with the:
  SUBSYSTEM=="...", GROUP="..."
matches, right?

> I could imagine a model where the board file for a target
> defined the ownership for devices or that was loaded in from userspace
> at boot (just a table of path-match-string, uid, gid, perms).  Not
> sure if that'd be considered too ugly, but it would certainly solve
> the problem in a straightforward way.

Hmm, at the point we would need it, there is no userspace to load it,
or a file to read.

> Early on the "device ownership
> policy" is installed and then userspace can leave everything to the
> kernel.

It would need to be right in the kernel, linked into the driver core.
Some "module" could do that, and hook into the processing, when a
device is registered.

> The uids for applications are dynamic, assigned on app install (every
> app gets its own uid).
>
>> Do your device nodes permissions/ownership ever change on the running
>> system after the device is alive?
>
> We never change device node permissions or ownership at runtime.  I
> could see situations in which that would be useful, but it's not
> something that is currently used by the platform.

That would in theory make it possible for your system to put the gid
information in a custom kernel "module" and link it to the driver
core. Usual systems, like the distros do, can not do that, they have a
far more complex policy and completely depend on meaningful symlinks
to the device nodes - but udev solves that problem already, and will
continue to do that.
For very customized systems like yours, maybe we can make it possible
to link-in custom code. I can definitely see the advantage over the
weird hacks you need in your userspace code, just to bring the system
up. Let's just wait, where this discussion ends up with, and if
somebody finds a fundamental problem with devtmpfs approach, otherwise
I'll take look what we can do.

We have a well defined common device naming today, and nobody
implements any custom "naming scheme" like the misguided devfs
hierarchy with default names like:
/dev/ide/host0/bus0/target0/lun0/part1, or /dev/tty/0, or
/dev/cdroms/0 anymore.
We all use the default kernel names, and udev just follows the kernel
given name already for almost all devices. We have a few exceptions in
udev rules left, but there is no good reason not to add these
exceptions as a few strings per subsystem to the kernel itself, and
have the kernel create the default nodes, if it solves a real problem.

Thanks,
Kay
