Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbYCFIhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbYCFIhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 03:37:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbYCFIg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 03:36:56 -0500
Received: from sacred.ru ([62.205.161.221]:47531 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbYCFIgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 03:36:55 -0500
Message-ID: <47CFAD06.7020501@openvz.org>
Date: Thu, 06 Mar 2008 11:36:22 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: Re: [PATCH 0/9] Devices accessibility control group (v4)
References: <47CED717.60406@openvz.org> <20080306015513.GA5359@kroah.com> <20080306031525.GA9070@sergelap.austin.ibm.com> <20080306043427.GA15498@kroah.com>
In-Reply-To: <20080306043427.GA15498@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 06 Mar 2008 11:36:19 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Mar 05, 2008 at 09:15:25PM -0600, Serge E. Hallyn wrote:
>> Quoting Greg KH (greg@kroah.com):
>>> On Wed, Mar 05, 2008 at 08:23:35PM +0300, Pavel Emelyanov wrote:
>>>> Changes from v3:
>>>> * Ported on 2.6.25-rc3-mm1;
>>>> * Re-splitted into smaller pieces;
>>>> * Added more comments to tricky places.
>>>>
>>>> This controller allows to tune the devices accessibility by tasks,
>>>> i.e. grant full access for /dev/null, /dev/zero etc, grant read-only
>>>> access to IDE devices and completely hide SCSI disks.
>>>  From within the kernel itself?  The kernel should not be keeping track
>>> of the mode of devices, that's what the filesystem holding /dev is for.
>>> Those modes change all the time depending on the device plugged in, and
>>> the user using the "console".  Why should the kernel need to worry about
>>> any of this?
>> These are distinct from the permissions on device files.  No matter what
>> the permissions on the device files, a task in a devcg cgroup which
>> isn't allowed write to chardev 4:64 will not be able to write to
>> /dev/ttyS0.
> 
> Then why not do that from userspace with a different /dev, or with a
> LSM?

Different dev is not suitable, since task may still call mknod to
create device it needs and use it. This is not about comfortable
use, this is about security.

LSM approach was proposed, but that required some API to configure
the permissions. This API done via control groups, so there were no
difference between this approach and that. Except for this one doesn't
create one more level of filtering at the top of kobject lookup and
thus is simpler and faster.

>> The purpose is to prevent a root task from granting itself access to
>> certain devices.  Without this, the only option currently is to take
>> CAP_MKNOD out of the capability bounding set for a container and make
>> sure that /dev is set up right (and enforce nodev for mounts).  In
>> itself that doesn't sound so bad and it was my preference at first,
> 
> that would be my preference as well.

That approach relies on a proper user space setup inside a container, 
but this creates security holes, since container user may ignore all
these "requirements".

>> but the argument is that things like udev should be able to run in a
>> container, and will object about not being able to create devices.
> 
> No reason you can't modify udev to do something like this.  At the

Sure we _can_ modify udev, but the problem is that users of virtualisation
solutions often (very often) use old software (e.g. set up some out-dated
distribution inside a container), so trick with modified udev simply won't
work in many cases.

> worse, just disable udev warning messages, that is pretty trivial to do.
> 
> This really makes it seem like this kernel change is not needed at all.
> 
>>>> Tasks still can call mknod to create device files, regardless of
>>>> whether the particular device is visible or accessible, but they
>>>> may not be able to open it later.
>>>>
>>>> This one hides under CONFIG_CGROUP_DEVS option.
>>>>
>>>> To play with it - run a standard procedure:
>>>>
>>>>  # mount -t container none /cont/devs -o devices
>>>>  # mkdir /cont/devs/0
>>>>  # echo -n $$ > /cont/devs/0/tasks
>>> What is /cont/ for?
>> cgroups used to be called containers, so 'cont' is presumably shorthand
>> for container.
>>
>>>> and tune device permissions.
>>> How is this done?
>>>
>>> Why would the kernel care about this stuff?
>> Because there is no way for userspace to restrict a root process in a
>> container from accessing whatever devices it wants.
> 
> LSM does this quite well today, why reinvent the wheel and put wierd
> hooks in other parts of the kernel that do not need them at all?

These are not hooks actually. I just made kobj_map-s per-group.

> thanks,
> 
> greg k-h
> 

Thanks,
Pavel
