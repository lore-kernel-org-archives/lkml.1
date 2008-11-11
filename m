Return-Path: <linux-kernel-owner+w=401wt.eu-S1751876AbYKKStV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbYKKStV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 13:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbYKKStI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 13:49:08 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:55746 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbYKKStG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 13:49:06 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=EcV3NQhKYK4bElKR3wQA:9 a=fXO4iBP7w9r5L00l2OMA:7 a=L1snkDh3vlAsi0gyFmMzq7qbrNYA:4 a=MSl-tDqOz04A:10 a=w9JcUHXQiIwA:10
Message-ID: <4919D39F.1070009@shaw.ca>
Date: Tue, 11 Nov 2008 12:49:03 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: "Altobelli, David" <david.altobelli@hp.com>
CC: Nobin Mathew <nobin.mathew@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Grant Grundler <grundler@parisc-linux.org>
Subject: Re: sharing interrupt between PCI device
References: <4910E8AC.7050407@shaw.ca> <20081108172716.GA28039@colo.lackof.org> <4915E43E.4010206@gmail.com> <20081108191536.GC28039@colo.lackof.org> <8d6898730811092235u4a41c664vd641d2792dee4c50@mail.gmail.com> <20081110075115.GA13239@colo.lackof.org> <20081110075827.GE2093@elte.hu> <8d6898730811100231j2ca5e8ceub0d5137c1ef1f9d0@mail.gmail.com> <8d6898730811100742g31711b9ck9e046d77273d0113@mail.gmail.com> <20081110203454.GB18188@colo.lackof.org> <8d6898730811102057u55b9495fxf640af7df3271878@mail.gmail.com> <92D64232F2316045B18937D5C9996B152252BB941B@GVW1144EXB.americas.hpqcorp.net>
In-Reply-To: <92D64232F2316045B18937D5C9996B152252BB941B@GVW1144EXB.americas.hpqcorp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Altobelli, David wrote:
>>> On Mon, Nov 10, 2008 at 4:01 PM, Nobin Mathew <nobin.mathew@gmail.com> wrote:
>>>> Yes USB Virtual Controller has input devices like keyboard and mouse
>>>> (routed through hpilo card (remote console)), so those things stops
>>>> working when we remove hpilo driver.
>>>>
> 
> That is not quite correct.  Nothing is routed through hpilo.
> 
> The problem is that there is a shared hardware resource in iLO function 2 (hpilo),
> and it is used by iLO function 4 (uhci_hcd kdb/mouse).  When hpilo is unloaded,
> the pci_device_disable() call removes the ability for this function to act as a
> busmaster, which stops the uhci_hcd from functioning correctly.
> 
> Reloading hpilo will enable the remote console again.
> 
> Removing the pci_disable_device() "fixes" the problem, but doing that worries me.

I suspect that removing the pci_disable_device in that driver is 
probably the best solution. It's not really mandatory to disable the 
device in all cases, we have other devices that have similar issues and 
so can't be disabled. As long as it can't generate interrupts or 
otherwise affect the system after the module is unloaded (but it sounds 
like it doesn't use interrupts anyway).

It's not really a good hardware design (mucking with one PCI function on 
the device shouldn't disable functionality on other functions), but what 
can you do..
