Return-Path: <linux-kernel-owner+w=401wt.eu-S1757865AbZCMDHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbZCMDHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 23:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbZCMDGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 23:06:54 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:37721 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbZCMDGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 23:06:53 -0400
X-Greylist: delayed 1066 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Mar 2009 23:06:53 EDT
Message-ID: <49B9CD91.8070909@cs.columbia.edu>
Date: Thu, 12 Mar 2009 23:05:53 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       containers <containers@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 00/11] track files for checkpointability
References: <20090305163857.0C18F3FD@kernel>	<20090305174037.GA2274@x200.localdomain>	<1236280567.22399.99.camel@nimitz>	<20090305210840.GA2499@x200.localdomain>	<1236288427.22399.122.camel@nimitz>	<20090305220044.GA2819@x200.localdomain>	<1236291865.22399.139.camel@nimitz> <20090306143425.GA31250@us.ibm.com>
In-Reply-To: <20090306143425.GA31250@us.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Serge E. Hallyn wrote:
> Quoting Dave Hansen (dave@linux.vnet.ibm.com):
>> On Fri, 2009-03-06 at 01:00 +0300, Alexey Dobriyan wrote:
>>> On Thu, Mar 05, 2009 at 01:27:07PM -0800, Dave Hansen wrote:
>>>>> Imagine, unsupported file is opened between userspace checks
>>>>> for /proc/*/checkpointable and /proc/*/fdinfo/*/checkpointable
>>>>> and whatever, you stil have to do all the checks inside checkpoint(2).
>>>> Alexey, we have two problems here.  I completely agree that we have to
>>>> do complete and thorough checks of each file descriptor at
>>>> sys_checkpoint().  Any checks made at other times should not be trusted.
>>>>
>>>> The other side is what Ingo has been asking for.  How do we *know* when
>>>> we are checkpointable *before* we call (and without calling)
>>> This "without calling checkpoint(2)" results in much complications
>>> as demonstrated.
>> I'll let you take that up with Ingo. :)
>>
>>> task_struct and file are not like other structures because they are exposed
>>> in /proc.
>> Very true.  But, we can always use the task as a proxy to say whether
>> any of this tasks's *resources* are uncheckpointable.  Is this task's
>> ipc_namespace checkpointable, etc...
>>
>>> For PROC_FS=n kernels, one can't even check.
>> Definitely.  I'd be happy to make this check require PROC=y or even
>> DEBUGFS=y.  I just want to make the mechanism usable for developers so
>> they're more motivated to find and fix checkpoint issues.
>>
>>> You can do checkpoint(2) without actual dump. You pass, you're most
>>> certainly checkpointable (with inevitable race condition in mind).
>> OK, so you envision this as maybe calling sys_checkpoint() with a -1 fd
>> or something?  I'm generally OK with that.  If the /proc stuff is really
>> the sticking point here, I'd be happy to stick it at the end of the
>> series so we can throw it away more easily.
> 
> Yeah thing is I definately like what Alexey is suggesting.

I totally agree with Alexey. Use a CR_CHECKPOINT_PROBE to indicate that
you want a 'quick' test pass.

> 
> The only reason for going the route of Dave's patches is to implement
> the pain Ingo wants to inflict to push us to faster support the
> resources which users actually want/need.  As Alexey says that's
> a temporary gain and therefore not worth permanent code.

Not only the gain is temporary, it's also not that big to begin with.
We're talking about the file system. The basic code, e.g. without an
optimization for unlinked files, is file system agnostic. The exception
are pseudo file systems that must be handles specifically.

In other words, the "special" cases are: pseudo file systems, devices,
and aliens like epollfd. Pseudo file systems require special handling
in any implementation. Devices -- how many of these are there that in
practice we need to checkpoint and restart ?  certainly not network
drivers, nor graphics cards etc. The list is short: pty, null, random,
rtc, tty, ... some of which will also require some sort of virtalization
(e.g. RTC should be per container, but that's another topic).

It isn't a "pain" to support more resources - it's the joy !

Oren

> 
> Oh, right, there's the second reason:
> 
>>> With time the amount of stuff C/R won't support will approach zero,
>>> but the infrastructure for "checkpointable" will stay constant.
>>> If it's too much right now, it will be way too much in future.
>> What have you seen in OpenVZ?  Do new things that are not checkpointable
>> pop up very often?
> 
> Realistically, do you think the uncheckpointable stuff would catch a
> brand-new unsupported feature?  If it has a file interface then I
> suppose it would.  Well, might.  I wouldn't be surprised if the authors
> would cut and paste enough code to paste the .checkpoint =
> generic_file_checkpoint line :)
> 
> -serge
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
> 
