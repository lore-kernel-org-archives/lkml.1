Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbYIYUuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbYIYUuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 16:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbYIYUuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 16:50:03 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:50917 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752705AbYIYUuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 16:50:01 -0400
Subject: Re: [PATCH 1/2] VMware detection support for x86 and x86-64
From: Zachary Amsden <zach@vmware.com>
To: Alok Kataria <akataria@vmware.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alok kataria <alokkataria1@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Yan Li <elliot.li.tech@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
       "rjmaomao@gmail.com" <rjmaomao@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Daniel Hecht <dhecht@vmware.com>
In-Reply-To: <1222320201.23524.135.camel@alok-dev1>
References: <20080221115452.GB13948@elte.hu>
	 <20080907234510.GA24133@yantp.cn.ibm.com>	 <20080908140423.GG11993@elte.hu>
	 <35f686220809241928k3669e30bi8a98b440443c4bff@mail.gmail.com>
	 <48DB15DB.8040501@zytor.com> <1222317978.23524.117.camel@alok-dev1>
	 <48DB1984.8020704@zytor.com> <1222318928.23524.121.camel@alok-dev1>
	 <48DB1BCE.2070106@zytor.com>  <1222320201.23524.135.camel@alok-dev1>
Content-Type: text/plain
Date: Thu, 25 Sep 2008 13:48:14 -0700
Message-Id: <1222375694.27056.179.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-24 at 22:23 -0700, Alok Kataria wrote:
> On Wed, 2008-09-24 at 22:04 -0700, H. Peter Anvin wrote:
> > Alok Kataria wrote:
> > >>>
> > >> You accessed a bloody I/O port!
> > >>
> > >> If you think it's harmless because it was an IN, you're sorely mistaken.
> > >
> > > Hi Peter,
> > >
> > > It would be really helpful if you could explain me when can this go
> > > wrong or what kinds of problems can this cause on native hardware.
> > >
> >
> > You accessed an unknown I/O port.
> >
> > This means you caused an unknown action in an unknown peripheral device.
> >
> > This could cause ANYTHING to happen.

Peter's right.  The hardware device simply sees an I/O request to a port
and a read / write.  The actual internal implementation may not even see
whether it is a R/W, and may do anything.  Some of our virtual hardware
is activated in strange ways, reads where you would expect writes, etc.

For example, a device made by Exploder Technologies has two ports, 3686,
and 3687.  Read access to port 3686 returns the status register and any
access at all to port 3687 moves the robot arm, activating the
thermonuclear self destruct device and destroying the earth.  I have
such a device in my basement, but I have to be careful not to issue any
I/O to port 3687 on it, whether it is writes OR reads.

A less contrived example is a LFSR that returns a new cryptographically
random value on every read.  Reading a register would cause a state
change in the hardware, and this could be fatal to something that
requires exact synchronization of tokens, perhaps securID type
applications.

All that said, we've never encountered an I/O device that uses this ISA
port for anything at all.  However, some old broken hardware might
misdecode bus addresses and try to service the I/O request anyway.  So
while it might be an acceptible way for us to use in VMware tools where
it only ever makes sense to install in a VM anyway, it could be
considered non-appropriate for general kernel application.

The whole backdoor thing is also broken because it requires
non-architectural side effects to operate (IN instructions can not
arbitrarily change all GPRs).  This can confuse applications which are
very smart and try to single step over the instruction by emulating it,
logging the port I/O, then restoring GPRs to the state before execution
and writing the 1 register affected by the IN.  Such clever debuggers
and profiling tools have been written.

Zach

