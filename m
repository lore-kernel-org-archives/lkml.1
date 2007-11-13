Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbXKMNTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbXKMNTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 08:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbXKMNTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 08:19:46 -0500
Received: from wr-out-0506.google.com ([64.233.184.227]:33175 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbXKMNTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 08:19:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=io3FqiI/p2slS4eeZu7KHWoHqA+Ki9kcGMxsZsjSrsVYOvbw6CtowqUsFUm1o/E8zUxcgIZz8ilEzWqg1V/N2ipal7FPbpDbBS80FNqkxzFg6sWWkyBmhbawf1IXDXHRl81U655ONu9RnNmloBVxPLwdGb2oAMPwci0IGCyqMQs=
Message-ID: <4739A41F.5010802@gmail.com>
Date: Tue, 13 Nov 2007 08:18:23 -0500
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: Gregory Haskins <gregory.haskins@gmail.com>,
       Anthony Liguori <aliguori@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Dor Laor <dor.laor@qumranet.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Use of virtio device IDs
References: <4730A15A.6070001@us.ibm.com> <4730B753.2000901@us.ibm.com> <4731334A.6090405@gmail.com> <47314FBD.1070505@qumranet.com> <47322262.8000101@gmail.com> <4732AE9A.4070701@qumranet.com>
In-Reply-To: <4732AE9A.4070701@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Gregory Haskins <gregory.haskins.ml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Gregory Haskins wrote:
>>> PCI means that you can reuse all of the platform's infrastructure for
>>> irq allocation, discovery, device hotplug, and management.
>>>     
>> Its tempting to use, yes.  However, most of that infrastructure is
>> completely inappropriate for a PV implementation, IMHO.  
> 
> Why?

(Sorry for the delay)

Since PCI was designed as a hardware solution it has all kinds of stuff
specifically geared towards hardware constraints.   Those constraints
are different in a virtualized platform, so some things do not translate
well to an optimal solution.  Half of the stuff wouldn't be used, and
the other half has some nasty baggage associated with it (like still
requiring partial emulation in a PV environment).

The point of PV, of course, is high performance guest/host interfaces,
and PCI baggage just gets in the way in many respects.  Once a
particular guest's subsystem is HV aware we no longer strictly require
legacy emulation.  It should know how to talk to the host using whatever
is appropriate.  I aim to strip out all of those emulation points
whenever possible.  Once you do that, all of the PCI features that we
would use drops to zero.

On the flip side, we have full emulation if you want broader
compatibility with legacy, at the expense of performance.

> 
>> You are
>> probably better off designing something that is PV specific instead of
>> shoehorning it in to fit a different model (at least for the things I
>> have in mind).  
> 
> Well, if we design our pv devices to look like hardware, they will fit
> quite well.  Both to the guest OS and to user's expectations.

Like what hardware?  Like PCI hardware?  What if the platform in
question doesn't have PCI?  Also note that devices don't have to look
like emulated PCI devices per se to look like hardware to the
guest-OS/user.  That is just one way to do it.

> 
>> Its not a heck of a lot of code to write a pv-centric
>> version of these facilities.
>>
>>   
> 
> It is.  

After having done it in the past, I disagree.   But it sounds like you
are lumping core-pv and io-pv together.  To be clear, I am not.  I agree
that core-pv is invasive and not legacy friendly.  io-pv is different,
however, and generally can be retrofitted to an OS in the same way that
support for an arbitrary device X over subsystem Y (PCI, usb, pv, etc)
can be.  e.g. you load a driver for the subsystem.

> Especially if you consider Windows and a gazillion versions of
> deployed, non-pv-capable Linux systems.

I am ;)

> For pv-friendly newer Linux,
> it's probably doable, but why?
> 
> Look at the mess Xen finds itself in.

I see hanging our hats on PCI as creating a mess for KVM/virtio ;)

> 
>>> You can write it for new guests but backporting it to older guests will be a
>>> huge task.
>>>
>>> We will support non-pci for s390, but in order to support Windows and
>>> older Linux PCI is necessary.
>>>     
>> I don't know if I would agree with "necessary".  "Easier" perhaps. ;) By
>> definition once you are PV you are hypervisor aware.  Now its just a
>> matter of plugging in the appropriate plumbing to bridge the hypervisor
>> to the guest-os.  Some might be easier than others, sure.  But all
>> should be extensible to a degree.
>>
>>   
> 
> It's "necessary" in a pragmatic sense: we want to deliver drivers that
> provide features for a wide variety of guests in a reasonable
> timeframe.  And that means no rewriting guest OS infrastructure.
>

I guess what I am really trying to say in all this is; I would be
careful about painting KVM into a PCI corner.  If you want to "render" a
view of PV devices as PCI for platforms that can utilize it, there is
probably not any harm in that.

However, I believe having things be PCI centric, especially in the long
term, will easily turn into a mistake for the project.  I don't think
its going to be as useful as you think it is, and then we might find
ourselves in a "backwards compatibility maintenance" situation to
support all these decisions.  If the current architecture already is
shaping up to be PCI neutral, great! (I haven't had a chance to follow
lately).  If not, I think we should reconsider before things get too messy.

Regards,
-Greg





