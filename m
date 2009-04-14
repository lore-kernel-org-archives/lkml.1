Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbZDNT3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbZDNT3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 15:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbZDNT3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 15:29:11 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:33772 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbZDNT3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 15:29:09 -0400
Message-ID: <49E4E353.9090508@cs.columbia.edu>
Date: Tue, 14 Apr 2009 15:26:11 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/30] cr: core stuff
References: <20090410023539.GK27788@x200.localdomain> <49E41D7B.8030003@cs.columbia.edu> <20090414160003.GD27461@x200.localdomain>
In-Reply-To: <20090414160003.GD27461@x200.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Alexey Dobriyan wrote:
> On Tue, Apr 14, 2009 at 01:22:03AM -0400, Oren Laadan wrote:
>> Alexey Dobriyan wrote:
>>> * add struct file_operations::checkpoint
>>>
>>>   The point of hook is to serialize enough information to allow restoration
>>>   of an opened file.
>>>
>>>   The idea (good one!) is that the code which supplies struct file_operations
>>>   know better what to do with file.
>> Actually, credit is due to Dave Hansen (or Christoph Hellwig, or both?).
>>
>>>   Hook gets C/R context (a cookie more or less) on which dump code can
>>>   cr_write() and small restrictions on what to write: globally unique object id
>>>   and correct object length to allow jumping through objects.
>>>
>>>   For usual files on on-disk filesystem add generic_file_checkpoint()
>>>
>>>   Add ext3 opened regular files and directories for start.
>>>
>>>   No ->checkpoint, checkpointing is aborted -- deny by default.
>>>
>>> FIXME: unlinked, but opened files aren't supported yet.
>>>
>>> * C/R image design
>>>
>>>   The thing should be flexible -- kernel internals changes every day, so we can't
>>>   really afford a format with much enforced structure.
>>>
>>>   Image consists of header, object images and terminator.
>>>
>>>   Image header consists of immutable part and mutable part (for future).
>>>
>>>   Immutable header part is magic and image version: "LinuxC/R" + __le32
>>>
>>>   Image version determines everything including image header's mutable part.
>>>   Image version is going to be bumped at earliest opportunity following changes
>>>   in kernel internals.
>>>
>>>   So far image header mutable part consists of arch of the kernel which dumped
>>>   the image (i386, x86_64, ...) and kernel version as found in utsname.
>>>
>>>   Kernel version as string is for distributions. Distro can support C/R for
>>>   their own kernels, but can't realistically be expected to bump image version --
>>>   this will conflict with mainline kernels having used same version. We also don't
>>>   want requests for private parts of image version space.
>> So far so good, like in our patch-set.
>>
>> You also need to address differences in configuration (kernel could
>> have been recompiled) and runtime environment (boot params, etc).
>>
>> We deferred this issue to a later time.
>>
>>>   Distro expected to keep image version alone and on restart(2) check utsname
>>>   version and compare it against previously release kernel versions and based
>>>   on that turn on compatibility code.
>> Are you suggesting that conversion of a checkpoint image from an older
>> version to a newer version be done in the kernel ?
> 
> For mainline kernel it's completely unrealistic to support all backwards
> compatibility code for previous versions. Some mythical userspace
> program will convert images.
> 
> But it's completely realistic and much easier for distro kernel because
> distro kernel doesn't generally include patches with significant in-kernel
> internals changes, so they simply can support
> '2.6.26-1-amd64' => '2.6.26-2-amd64' situation.
> 
> Distros can write conversion program too, but I don't expect they will.
> 
>> It may work for a few versions, and then you'll get a spaghetti of
>> #ifdef's in the code, together with a plethora of legacy code.
> 
> Expectation is for one kernel branch like RHEL5 kernel updates during
> RHEL5 lifecycle.
> 
> For RHEL5 => RHEL6, it's up to them what to do.
> 
> Anyway distro can add compat code _anyway_, for this we help them with
> this image format tweak, so they won't bug mainline with "reserve bit 31
> for Red Hat".
> 
> Image version is kept small (__le32) for this reason too :-)
> 

So a simple kernel version won't suffice. For instance, even with the
same (distro) kernel, a user can choose vdso-compat at boot time.
Not to mention that a monotonically increasing version number can't
possible be a catch-all.

(while your favorite libc doesn't use it, in non-compat mode the
syscall gettimeofday() gets the data off the vdso page; besides
possibly breaking an application that migrates from non-compat to
compat, it is also impossible to check vdso page validity by a
simple memcmp() of old and new !).

We need (at least) some sort of kernel-hardware-capabilities-vector
that will encapsulate such dependencies. There will also be per
task vector, possibly (e.g. if never used math we don't care about
FPU capabilities, otherwise we do).

I don't expect to get that sorted out anytime soon - it will be a
long gradual process in which we gradually add what's needed to
describe the "environment" in which the tasks are running.

We do need to make the format of this vector easily extensible for
exactly this reason.

Oren.


