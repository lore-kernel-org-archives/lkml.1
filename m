Return-Path: <linux-kernel-owner+w=401wt.eu-S1753735AbYKCS6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbYKCS6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 13:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbYKCS6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 13:58:34 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:22000 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbYKCS6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 13:58:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RtGvM6R6s0pm0oZTcCCGPoELSgOh5PISA4fMsAxCp4NwYXboIEuEaZrhuZXt/IeuU6
         pISsFH3pk+Zy59rQNHSvjMYmiu7RqzOtW77wYTPlT+LulJtWoFu0+EHQisqFTfFFmcRh
         2BVSMVPYWNm5j2GYVDYpwDPJdgjaV83g4X7wY=
Message-ID: <490F496C.2010608@gmail.com>
Date: Mon, 03 Nov 2008 20:56:44 +0200
From: Constantine Gavrilov <constantine.gavrilov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080417 Fedora/1.1.9-2.fc7 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: patch: support long (above 14 bytes) HW addresses in arp_ioctl
References: <490EDBDD.1030104@gmail.com> <ada63n4wvxp.fsf@cisco.com>
In-Reply-To: <ada63n4wvxp.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In arp_req_get() in net/arp.c, there is code:

memcpy(r->arp_ha.sa_data, neigh->ha, dev->addr_len);

dev->addr_len can be larger than size of r->arp_ha.sa_data. Inititally, 
I thought it would corrupt kernel stack. I was wrong, since r still has 
enough space not to overflow even for the largest HW address (32 bytes). 
It would corrupt the data structure though, and that corrupted reply 
would be propagated to user.

There is a similar situation in arp_req_set(), where a "junk" arp entry 
will be set if dev->addr_len is larger that 14 bytes. 

At the very minimum, both arp_req_set() and arp_req_get() should return 
error (-EINVAL), and not return junk or set junk. Truncated 
/proc/net/arp output should also be fixed.

I was not aware that rtnetlink is capable of doing things like arp  
table or interface manipulation (like netdevice ioctls). My applications 
needs to be able to manipulate arp cache for large macs, and I do not 
mind recompiling by adding a flag. I do not mind fixing arp cli to use 
this either (venerable arp  does use arp_ioctl). And there are many many 
legacy solutions that use arp_ioctl() in programs and arp utility in 
scripts. Consider porting those to infiniband.

Will rtnetlink work for any net_device (like netdevice ioctls do) for 
ARP and interface configurations calls or does it require special 
support in net_device itself? Any possible problems with rtnetlink?

Roland Dreier wrote:
>  > * arp_ioctl will corrupt the kernel and user memory when this ioctl is
>  > used on the adapters that have HW addresses longer that 14 bytes.
>  > This is because when copying the HW address, the arp_ioctl code copies
>  > dev->addr_len bytes without checking that addr_len is not above 14
>  > bytes. This is done both for copy_to_user() and memcpy() calls on
>  > kernel data structures allocated on stack. The memcpy() call in
>  > particular, will corrupt kernel stack.
>
> It's not obvious to me after a quick glance where this kernel memory
> corruption occurs, but clearly we should at least fix this bug.
>
>  > The patch does not change the existing ABI but extends it.  The kernel
>  > structure used in arp_ioctl calls is changed to support larger
>  > addresses, while the user-space structure is extended by appending
>  > extra-space to the end of the structure if ATF_NEWARPCTL -- a new flag
>  > -- is set in arp_flags of existing user-space structure. This allows
>  > avoiding big changes to the existing code while preserving the ABI
>  > compatibility.
>
> However, given that applications need to be changed to use this,
> wouldn't it make more sense just to change those applications to use
> rtnetlink, which already supports large hardware addresses?  ie is there
> much point to extending a legacy ABI to add a feature that the preferred
> modern interface already has?
>
>  - R.
>   

-- 
----------------------------------------
Constantine Gavrilov
Kernel Developer
Platform Group
XIV, an IBM global brand 
1 Azrieli Center, Tel-Aviv
Phone: +972-3-6074672
Fax:   +972-3-6959749
----------------------------------------


