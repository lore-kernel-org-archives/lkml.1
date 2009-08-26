Return-Path: <linux-kernel-owner+w=401wt.eu-S932834AbZHZKl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834AbZHZKl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932794AbZHZKlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:41:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932802AbZHZKlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:41:19 -0400
Message-ID: <4A95114F.8020107@redhat.com>
Date: Wed, 26 Aug 2009 13:41:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Davide Libenzi <davidel@xmailserver.org>, gleb@redhat.com,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
References: <20090820182847.GB9282@redhat.com> <4A913DA9.1020403@redhat.com> <20090823133620.GA12841@redhat.com> <4A9146E3.2090007@redhat.com> <20090823143021.GA27495@redhat.com> <alpine.DEB.2.00.0908241114501.7951@makko.or.mcafeemobile.com> <20090824214900.GA9899@redhat.com> <alpine.DEB.2.00.0908241508440.7951@makko.or.mcafeemobile.com> <20090825072229.GA10608@redhat.com> <alpine.DEB.2.00.0908251456230.18518@makko.or.mcafeemobile.com> <20090826102908.GA21523@redhat.com>
In-Reply-To: <20090826102908.GA21523@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2009 01:29 PM, Michael S. Tsirkin wrote:
> How we wanted to solve it with EFD_STATE: Share a separate eventfd
> between each device and the hypervisor.  device sets state to either 0
> or 1.  hypervisor polls all eventfds, reads interrupt line on changes,
> calculates the interrupt level and updates guest.
>
> Alternative solution: shared memory where each device writes interrupt
> line value. This makes setup more complex (need to share around much more
> than just an fd), and makes access from interrupt impossible unless we
> lock the memory (and locking userspace memory introduces yet another set
> of issues).
>    

For completeness:

If the device is implemented in the same process as the hypervisor, an 
eventfd isn't really needed, as there is an ioctl which performs the 
same operation.

An important class of device implementations is real devices that are 
assigned to a guest.  We would like to forward the interrupt directly 
from the host interrupt handler to qemu.  Currently, we have a 
kvm-specific interrupt handler that forwards the interrupt using 
kvm-specific interfaces.  We would like to use a generic interrupt 
handler implemented by uio, so we want a generic interrupt transfer 
mechanism.

uio already supports edge-triggered interrupts using an eventfd-like 
mechanism.  So it makes sense to extend uio to support real eventfds, 
and to make it also support level-triggered interrupts.

We can work around the lack of state eventfd by having userspace wait on 
whatever mechanism uio uses to make the interrupt state visible, and 
then use the ioctl mentioned above to inform the hypervisor of this 
state.  But it's faster and nicer to give both components an eventfd and 
let them communicate directly.

-- 
error compiling committee.c: too many arguments to function

