Return-Path: <linux-kernel-owner+w=401wt.eu-S1755767AbYIIAVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbYIIAVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 20:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbYIIAVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 20:21:08 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:64384 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbYIIAVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 20:21:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QB/knjb8/aDQBHa4Gx/vnm5G2UeFGFItym9nW9vnnbmcAeRqlKI6++tsnFsPXXYrYp
         grXap3aipUAx7Uo8lh5EtcDW+0w7ohWGZa1SDRbhTkpkNMP9ShDiqVLH/83qdhJwZaZt
         Y+JPsvEi+2I4UXD/EaUlQSfPygyVoMxTmw+hU=
Date: Tue, 9 Sep 2008 08:20:56 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yan Li <elliot.li.tech@gmail.com>, linux-kernel@vger.kernel.org,
       joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 1/2] VMware detection support for x86 and x86-64
Message-ID: <20080909002055.GA8573@yantp.cn.ibm.com>
References: <20080221115452.GB13948@elte.hu> <20080907234510.GA24133@yantp.cn.ibm.com> <20080908140423.GG11993@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080908140423.GG11993@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2008 at 04:04:23PM +0200, Ingo Molnar wrote:
> hm, i know it's not your fault as you just took this vmware code, but 
> this is really not an acceptable method of detection. The above is 
> totally unsafe to do on native hardware - we dont know whether there's 
> anything on that port.

Yeah, I agree with you, it's a bad method. I just took it for granted
that vmware has done the necessary study and they knew what they were
doing.  I have tested it on two boxes so I thought they were OK. Now I
agree it's a bit dangerous to put this in a general purpose kernel.

> vmware could have used one of the following methods to communicate to 
> the guest kernel:
> 
>  - a CPUID and an MSR range - like a good virtual CPU should. That way 
>    even bootloaders could detect the presence of vmware.

They haven't done this. Per VMware's design, the cpuinfo in virtual
guest is identical to the underlying physical CPU. I guess they want
to send most of the code to run on underlying CPU directly and won't
have to do code mutation or emulation and get better performance.

>  - or a PCI ID and a PCI driver like KVM does

Yup. But checking DMI would be easier for us.

>  - or a system call hypercall gateway like Xen and KVM does

I think they didn't use this way cause VMware wanted it to be
OS-neutral.

>  - or it could even have used a DMI signature of some sort

Some people are using this idea. From dmidcode, the VMware-related
parts are:

Handle 0x0001, DMI type 1, 25 bytes
System Information
        Manufacturer: VMware, Inc.
        Product Name: VMware Virtual Platform
        Version: None
        Serial Number: VMware-56 4d d2 bf 8d ea 6e ec-81 67 6d 50 42
	72 07 46
        UUID: 564DD2BF-8DEA-6EEC-8167-6D5042720746
        Wake-up Type: Power Switch
............

Handle 0x001A, DMI type 10, 8 bytes
On Board Device 1 Information
        Type: Video
        Status: Disabled
        Description: VMware SVGA II

I think it's pretty safe to assume all VMware products include
"[VM|vm]ware" in the manufacturer.

> but no, vmware had to use 30 year old unsafe ISA port magic...
> 
> To add insult to injury that port is named 'backdoor' - very smart and 
> confidence raising naming. Plus it does not even use some well-known PC 
> port that is harmless to read - it has to be from the middle of the 
> generic IO port resource range where a real PCI card could sit: 0x5658. 
> Brilliant.
> 
> is there really no vmware PCI ID to query? Could you post the lspci -v 
> output of your vmware guest? We could add an early-quirk for one of the 
> core vmware PCI devices (in case there are any - i bet there are).

VMware may change the PCI ID at their will so I prefer checking the
DMI since it's easier.

So if we ditched the official method we run the risk of some false
negatives.  But checking the DMI manufacturer would be good enough.

-- 
Li, Yan

"Everything that is really great and inspiring is created by the
individual who can labor in freedom."
              - Albert Einstein, in Out of My Later Years (1950)
