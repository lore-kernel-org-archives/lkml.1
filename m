Return-Path: <linux-kernel-owner+w=401wt.eu-S1757171AbYJNCeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171AbYJNCeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 22:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754971AbYJNCdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 22:33:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:47648 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901AbYJNCdt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 22:33:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,406,1220252400"; 
   d="scan'208";a="450852706"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 6/6 v3] PCI: document the change
Date: Tue, 14 Oct 2008 10:31:03 +0800
Message-ID: <08DF4D958216244799FC84F3514D70F00235CE27@pdsmsx415.ccr.corp.intel.com>
In-Reply-To: <20081014010827.GX25780@parisc-linux.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 6/6 v3] PCI: document the change
Thread-Index: AcktmYhTxLCgiprMR2ml1MOmkZKrXwAAYboQ
References: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5F6@pdsmsx502.ccr.corp.intel.com> <20081001160706.GI13822@parisc-linux.org> <08DF4D958216244799FC84F3514D70F00235CC69@pdsmsx415.ccr.corp.intel.com> <20081014010827.GX25780@parisc-linux.org>
From: "Dong, Eddie" <eddie.dong@intel.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Cc: "Zhao, Yu" <yu.zhao@intel.com>, <linux-pci@vger.kernel.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Grant Grundler" <grundler@parisc-linux.org>,
       "Alex Chiang" <achiang@hp.com>, "Roland Dreier" <rdreier@cisco.com>,
       "Greg KH" <greg@kroah.com>, <linux-kernel@vger.kernel.org>,
       <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
       "Dong, Eddie" <eddie.dong@intel.com>
X-OriginalArrivalTime: 14 Oct 2008 02:30:57.0081 (UTC) FILETIME=[E375E290:01C92DA4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Tue, Oct 14, 2008 at 08:23:34AM +0800, Dong, Eddie
> wrote: 
>> Matthew Wilcox wrote:
>>> Wouldn't it be more useful to have the iov/N directories
>>> be a symlink to the actual pci_dev used by the virtual
>>> function?
>> 
>> The main concern here is that a VF may be disabed such
>> as when PF enter D3 state or undergo an reset and thus
>> be plug-off, but user won't re-configure the VF in case
>> the PF return back to working state. 
> 
> If we're relying on the user to reconfigure virtual
> functions on return to D0 from D3, that's a very fragile
> system. 

No. that is the concern we don't put those configuration under VF nodes
because it will disappear.
Do I miss something?

> 
>>>> +For network device, there are:
>>>> +       - /sys/bus/pci/devices/BB:DD.F/iov/N/mac
>>>> +       - /sys/bus/pci/devices/BB:DD.F/iov/N/vlan
>>>> +               (value update will notify PF driver)
>>> 
>>> We already have tools to set the MAC and VLAN parameters
>>> for network devices.
>> 
>> Do you mean Ethtool? If yes, it is impossible for SR-IOV
>> since the configuration has to be done in PF side,
>> rather than VF. 
> 
> I don't think ethtool has that ability; ip(8) can set mac
> addresses and vconfig(8) sets vlan parameters.
> 
> The device driver already has to be aware of SR-IOV.  If
> it's going to support the standard tools (and it damn
> well ought to), then it should call the PF driver to set
> these kinds of parameters. 

OK, as if it has the VF parameter, will look into details.
BTW, the SR-IOV patch is not only for network, some other devices such
as IDE will use same code base as well and we image it could have other
parameter to set such as starting LBA of a IDE VF.



> 
>>> I'm not 100% convinced about this API.  The assumption
>>> here is that the driver will do it, but I think it
>>> should probably be in the core.  The driver probably
>>> wants to be 
>> 
>> Our concern is that the PF driver may put an default
>> state when it is loaded so that SR-IOV can work without
>> any user level configuration, but of course the driver
>> won't dynamically change it. 
>> Do u mean we remove this ability?
>> 
>>> notified that the PCI core is going to create a virtual
>>> function, and would it please prepare to do so, but I'm
>>> not convinced this should be triggered by the driver.
>>> How would the driver decide to create a new virtual
>>> function?
> 
> Let me try to explain this a bit better.
> 
> The user decides they want a new ethernet virtual
> function.  In the scheme as you have set up:
> 
> 1. User communicates to ethernet driver "I want a new VF"
> 2. Ethernet driver tells PCI core "create new VF".
> 
> I propose:
> 
> 1. User tells PCI core "I want a new VF on PCI device
> 0000:01:03.0" 
> 2. PCI core tells driver "User wants a new VF"

If user need a new VF, the VF must be already enabled or existed in OS.
Otherwise, we need to disable all VFs first and then change NumVFs to
re-enable VFs.
Spec says: "NumVFs may only be written while VF Enable is Clear"

> 
> My scheme gives us a unified way of creating new VFs,
> yours requires each driver to invent a way for the user
> to tell them to create a new VF. Unless I've
> misunderstood your code and docs. 

Assign a VF is kind of user & core job. 

> 
>>> From my reading of the SR-IOV spec, this isn't how it's
>>> supposed to work.  The device is supposed to be a fully
>>> functional PCI device that on demand can start peeling
>>> off virtual functions; it's not supposed to boot up and
>>> initialise all its virtual functions at once.
>> 
>> The spec defines either we enable all VFs or Disable.
>> Per VF enabling is not supported. Is this what you
>> concern? 
> 
> I don't think that's true.  The spec requires you to
> enable all the 
> VFs from 0 to NumVFs, but NumVFs can be lower than
> TotalVFs.  At least, that's how I read it.

Yes, but setting NumVFs can only occur when VFs are disabled.
Following are from spec.

NumVFs may only be written while VF Enable is Clear. If NumVFs is
written when VF Enable is
Set, the results are undefined.
The initial value of NumVFs is undefined.

> 
> But no, that isn't my concern.  My concern is that you've
> written a driver here that seems to be a stub driver. 
> That doesn't seem to be 
> how SR-IOV is supposed to work; it's supposed to be a
> fully-functional driver that has SR-IOV knowledge added
> to it. 

Yes, it is a full feature driver as if PF has resource in, for example
not all queues are assigned to VFs.

Thx, eddie
