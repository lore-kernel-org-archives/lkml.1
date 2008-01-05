Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbYAEBii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbYAEBii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 20:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbYAEBi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 20:38:29 -0500
Received: from smtpoutm.mac.com ([17.148.16.81]:61346 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754308AbYAEBi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 20:38:28 -0500
In-Reply-To: <200801042154.08758.oliver@neukum.org>
References: <4744FD87.7010301@goop.org> <200801031215.07145.oliver@neukum.org> <477D5C4F.8050800@nigel.suspend2.net> <200801042154.08758.oliver@neukum.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <DDC440DB-7D27-44CA-B78C-5B8CDFB1D163@mac.com>
Cc: nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       David Chinner <dgc@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       xfs-masters@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: freeze vs freezer
Date: Fri, 4 Jan 2008 20:38:20 -0500
To: Oliver Neukum <oliver@neukum.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 04, 2008, at 15:54:06, Oliver Neukum wrote:
> Am Donnerstag, 3. Januar 2008 23:06:07 schrieb Nigel Cunningham:
>> Hi.
>>> a) mount fuse on /tmp/first
>>> b) mount fuse on /tmp/second
>>>
>>> Then the server task for (a) does "ls /tmp/second". So it will be  
>>> frozen, right? How do you then freeze (a)? And keep in mind that  
>>> the server task may have forked.
>>
>> I guess I should first ask, is this a real life problem or a  
>> hypothetical twisted web? I don't see why you would want to make  
>> two filesystems interdependent - it sounds like the way to create  
>> livelock and deadlocks in normal use, before we even begin to  
>> think about hibernating.
>
> Good questions. I personally don't use fuse, but I do care about  
> power management. The problem I see is that an unprivileged user  
> could make that dependency, even inadvertedly.

I don't think it makes sense for the kernel to try to keep track of  
hard data dependencies for FUSE filesystems, or to even *attempt* to  
auto-suspend them.  You should instead allow a privileged program to  
initiate a "freeze-and-flush" operation on a particular FUSE  
filesystem and optionally wait for it to finish.  Then your userspace  
would be configured with the appropriate data dependencies and would  
stop FUSE filesystems in the appropriate order.

In addition, the kernel would automatically understand  
ext3=>loopback=>fuse, and when asked to freeze the "fuse" part, it  
would first freeze the "ext3" and the "loopback" parts using similar  
mechanisms as device-mapper currently uses when you do "dmsetup  
suspend mydev" followed by "echo 0 $SIZE snapshot /dev/mapper/mydev- 
base /dev/mapper/mydev-snap-back p 8 | dmsetup load mydev"  (IE: when  
you create a snapshot of a given device).

Naturally userspace could deadlock itself (although not the kernel)  
by freezing a block device and then attempting to access it, but  
since the "freeze" operation is limited to root this is not a big  
issue.  The way to freeze all filesystems safely would be to clone a  
new mount namespace, mlockall(), mount a tmpfs, pivot_root() into the  
tmpfs, bind-mount the filesystems you want to freeze directly onto  
subdirectories of the tmpfs, and then freeze them in an appropriate  
order.

Besides which the worst-case is a pretty straightforward non-critical  
failure; you might fail to fully sync a FUSE filesystem because its  
daemon is asleep waiting on something (possibly even just sitting in  
a "sleep(10000)" call with all signals masked).  You simply need to  
make sure that all tasks are asleep outside of driver critical  
sections so that you can properly suspend your device tree.

Cheers,
Kyle Moffett
