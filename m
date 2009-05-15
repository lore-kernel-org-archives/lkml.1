Return-Path: <linux-kernel-owner+w=401wt.eu-S1753058AbZEOUKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbZEOUKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 16:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbZEOUJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 16:09:55 -0400
Received: from gw.goop.org ([64.81.55.164]:37716 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbZEOUJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 16:09:54 -0400
Message-ID: <4A0DCC11.10307@goop.org>
Date: Fri, 15 May 2009 13:09:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] xen /proc/mtrr implementation
References: <1242170864-13560-1-git-send-email-jeremy@goop.org> <20090513133021.GA7277@elte.hu> <4A0ADBA2.2020300@goop.org> <20090515182757.GA19256@elte.hu>
In-Reply-To: <20090515182757.GA19256@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Right now there's no MTRR support under Xen guests and the Xen 
> hypervisor was able to survive, right? Why should we do it under 
> dom0?
>   

Because dom0 has direct hardware access, and is running real device 
drivers.  domU guests don't see physical memory, and so MTRR has no 
relevance for them.

> The MTRR code is extremely fragile, we dont really need an added 
> layer there. _Especially_ since /proc/mtrr is an obsolete API.
>   

There's no added layer there.  I'm just adding another implementation of 
mtrr_ops.

/proc/mtrr is in wide use today.  It may be planned for obsolescence, 
but there's no way you can claim its obsolete today (my completely 
up-to-date F10 X server is using it, for example).  We don't break 
oldish usermode ABIs in new kernels.

Besides, the MTRR code is also a kernel-internal API, used by DRM and 
other drivers to configure the system MTRR state.  Those drivers will 
either perform badly or outright fail if they can't set the appropriate 
cachability properties.  That is not obsolete in any way.

> If you want to allow a guest to do MTRR ops, you can do it by 
> catching the native kernel accesses to the MTRR space. There's no 
> guest side support needed for that.
>   

MTRR can't be virtualized like that.  It can't be meaningfully 
multiplexed, and must be set in a uniform way on all physical CPUs.  
Guests run on virtual CPUs, and don't have any knowledge of what the 
mapping of VCPU to PCPU is, or even any visibility of all PCPUs.

It is not a piece of per-guest state; it is system-wide property, 
maintained by Xen.  These patches add the mechanism for dom0 (=hardware 
control domain) to tell Xen what state they should be in.

    J
