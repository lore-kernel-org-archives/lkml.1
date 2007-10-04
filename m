Return-Path: <linux-kernel-owner+w=401wt.eu-S1760879AbXJDTT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760879AbXJDTT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 15:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756658AbXJDTTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 15:19:50 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:44973 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713AbXJDTTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 15:19:49 -0400
Message-ID: <47053CC7.7090206@us.ibm.com>
Date: Thu, 04 Oct 2007 12:19:35 -0700
From: David Wilder <dwilder@us.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       randy.dunlap@oracle.com, hch@infradead.org,
       systemtap@sources.redhat.com
Subject: Re: [patch 1/3]  Trace code and documentation
References: <1191342800.31351.9.camel@lc4eb748232119.ibm.com> <p73odff5j1x.fsf@bingen.suse.de>
In-Reply-To: <p73odff5j1x.fsf@bingen.suse.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> "David J. Wilder" <dwilder@us.ibm.com> writes:
>> @@ -0,0 +1,160 @@
>> +Trace Setup and Control
>> +=======================
>> +In the kernel, the trace interface provides a simple mechanism for
>> +starting and managing data channels (traces) to user space.
> 
> Wasn't relayfs supposed to do that already? Why do you need another
> wrapper around it? 

The code in trace is exactly what all the current users of relay do. 
Therefor trace reduces the duplication of code.


> 
> Is this also really still faster than a printk below log level
> (without console driver overhead). If not then why not just
> use printk?

Are you arguing against relayfs or trace?  Trace just makes relayfs 
easer to use.  I think relayfs can stand up for it's self.


> 
> Especially your example is worrying. It essentially defines a new
> printk. I think there is a case for a fast logging subsystem because
> printk() is admittedly a little slow [somewhat slow below log level
> and incredible slow above it]
> 
> But fast means binary items (not sprintf), no global locks, not
> multiple layers, per CPU etc.. But your example and this patch has all
> this and I bet it is not very fast.
>

Each user of trace has its own requirements for passing data over 
relayfs channels. This is why the documentation describes separate 
control and data layers.  The trace API provides a control layer with 
this flexibility.

The example shows a way to create an ASCII data layer.  The format of 
the data (binary or ascii) is just a function of how the data layer 
formats it.

Locking is only required when using global bufferers. The option of 
selecting per-cpu vs global bufferers is available to the trace user. 
The example (and the documentation) shows how to use both methods (See: 
#define USE_GLOBAL_BUFFER in the example).

There is no impact of adding an extra layer. The primitives for trace 
adds code for trace setup and control, but trace is not doing anything 
that a relayfs user would not have to do anyway.  We mostly care about 
the impact of writing data to the trace channels and trace has no impact 
there.

> Is the result (e.g. the trace example module) still any faster
> than printk below log level? If not then why bother.
> 
> Adding another slow logger would be just a waste of time imho.
> It just means that everybody who needs a fast logger just need
> to reimplement their own anyways. And the people who can tolerate
> slow loggers are probably already adequately served by 
> printk. Also there is already direct relayfs.

True, to make trace "fast" you need a data layer that can handle the 
requirements of per-cpu buffers.  However there are still advantages of 
trace over printk even when using global bufferers: selectable bufferer 
sizes, separate data channels (not have to share data channels with 
every other subsystem in the kernel), trace control, non-overwrite mode 
and buffer management.

The next step is to provide data layer that can fully take advantage of 
per-cpu bufferers (systemtap shows us one example). Trace give us a 
place to build it.  As Christoph's said about trace:

    "Long term we probably want more complex tracing based on lttng,
     but I'm a big fan of starting out simple and doing incremental
     changes."

One advantage of the trace approach is separating control and data 
layers, therefor trace can support multiple data layers to fit multiple 
requirements.

I have my ideas on how to develop data layer, others may have their own 
ideas and I welcome the input.

-Dave

PS: Systemtap has been criticized for introducing out-of-tree kernel 
code.  A clear direction from the community is to move re-usable code 
in-tree where it can be maintained.  Trace is a move in that direction.

Dave
> 
> -Andi
> 

