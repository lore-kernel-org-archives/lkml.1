Return-Path: <linux-kernel-owner+w=401wt.eu-S933255AbZDBSTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255AbZDBSTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763823AbZDBSTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:19:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:29559 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760710AbZDBSTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:19:07 -0400
Message-ID: <49D5018E.4040801@codemonkey.ws>
Date: Thu, 02 Apr 2009 13:18:54 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
References: <20090331184057.28333.77287.stgit@dev.haskins.net> <87ab71monw.fsf@basil.nowhere.org> <49D35825.3050001@novell.com> <20090401132340.GT11935@one.firstfloor.org> <49D37805.1060301@novell.com> <20090401170103.GU11935@one.firstfloor.org> <49D3B64F.6070703@codemonkey.ws> <49D3D7EE.4080202@novell.com> <49D46089.5040204@redhat.com> <49D497A1.4090900@novell.com> <49D4A4EB.8020105@redhat.com> <49D4AE0C.3000604@novell.com> <49D4B2C0.5060906@redhat.com> <49D4B594.6080703@novell.com> <49D4B8B4.4020003@redhat.com> <49D4BF70.1060301@novell.com> <49D4C191.2070502@redhat.com> <49D4CAA7.3020004@novell.com> <49D4CC61.6010105@redhat.com> <49D4CEB1.9020001@redhat.com> <49D4D075.9010702@codemonkey.ws> <49D4E33F.5000303@codemonkey.ws> <49D4E583.4080505@redhat.com>
In-Reply-To: <49D4E583.4080505@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Anthony Liguori wrote:
>>> I don't think we even need that to end this debate.  I'm convinced 
>>> we have a bug somewhere.  Even disabling TX mitigation, I see a ping 
>>> latency of around 300ns whereas it's only 50ns on the host.  This 
>>> defies logic so I'm now looking to isolate why that is.
>>
>> I'm down to 90us.  Obviously, s/ns/us/g above.  The exec.c changes 
>> were the big winner... I hate qemu sometimes.
>>
>>
>
> What, this:

UDP_RR test was limited by CPU consumption.  QEMU was pegging a CPU with 
only about 4000 packets per second whereas the host could do 14000.  An 
oprofile run showed that phys_page_find/cpu_physical_memory_rw where at 
the top by a wide margin which makes little sense since virtio is zero 
copy in kvm-userspace today.

That leaves the ring queue accessors that used ld[wlq]_phys and friends 
that happen to make use of the above.  That led me to try this terrible 
hack below and low and beyond, we immediately jumped to 10000 pps.  This 
only works because almost nothing uses ld[wlq]_phys in practice except 
for virtio so breaking it for the non-RAM case didn't matter.

We didn't encounter this before because when I changed this behavior, I 
tested streaming and ping.  Both remained the same.  You can only expose 
this issue if you first disable tx mitigation.

Anyway, if we're able to send this many packets, I suspect we'll be able 
to also handle much higher throughputs without TX mitigation so that's 
what I'm going to look at now.

Regards,

Anthony Liguori
