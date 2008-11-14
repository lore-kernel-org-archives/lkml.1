Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbYKNA4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbYKNA4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 19:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbYKNA4C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 19:56:02 -0500
Received: from kroah.org ([198.145.64.141]:43121 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754638AbYKNA4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 19:56:00 -0500
Date: Thu, 13 Nov 2008 16:55:38 -0800
From: Greg KH <greg@kroah.com>
To: Yu Zhao <yu.zhao@intel.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "achiang@hp.com" <achiang@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 15/16 v6] PCI: document the SR-IOV sysfs entries
Message-ID: <20081114005538.GA21161@kroah.com>
References: <20081022083809.GA3757@yzhao12-linux.sh.intel.com> <20081022084515.GO3773@yzhao12-linux.sh.intel.com> <20081106043318.GB30292@kroah.com> <20081106044613.GA30397@kroah.com> <4913AF89.2050504@intel.com> <20081107031837.GB30003@kroah.com> <20081113065024.GA3038@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081113065024.GA3038@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 02:50:24PM +0800, Yu Zhao wrote:
> On Fri, Nov 07, 2008 at 11:18:37AM +0800, Greg KH wrote:
> > On Fri, Nov 07, 2008 at 11:01:29AM +0800, Zhao, Yu wrote:
> > > Greg KH wrote:
> > >> On Wed, Nov 05, 2008 at 08:33:18PM -0800, Greg KH wrote:
> > >>> On Wed, Oct 22, 2008 at 04:45:15PM +0800, Yu Zhao wrote:
> > >>>>  Documentation/ABI/testing/sysfs-bus-pci |   33 
> > >>>> +++++++++++++++++++++++++++++++
> > >>>>  1 files changed, 33 insertions(+), 0 deletions(-)
> > >>>>
> > >>>> diff --git a/Documentation/ABI/testing/sysfs-bus-pci 
> > >>>> b/Documentation/ABI/testing/sysfs-bus-pci
> > >>>> index ceddcff..41cce8f 100644
> > >>>> --- a/Documentation/ABI/testing/sysfs-bus-pci
> > >>>> +++ b/Documentation/ABI/testing/sysfs-bus-pci
> > >>>> @@ -9,3 +9,36 @@ Description:
> > >>>>  		that some devices may have malformatted data.  If the
> > >>>>  		underlying VPD has a writable section then the
> > >>>>  		corresponding section of this file will be writable.
> > >>>> +
> > >>>> +What:		/sys/bus/pci/devices/.../iov/enable
> > >>> Are you sure this is still the correct location with your change to
> > >>> struct device?
> > >> Nevermind, this is correct.
> > >> But the bigger problem is that userspace doesn't know when these
> > >> attributes show up.  So tools like udev and HAL and others can't look
> > >> for them as they never get notified, and they don't even know if they
> > >> should be looking for them or not.
> > >> Is there any way to tie these attributes to the "main" pci device so
> > >> that they get created before the device is announced to the world?
> > >> Doing that would solve this issue.
> > >> thanks,
> > >> greg k-h
> > >
> > > Currently PCI subsystem has /sys/.../{vendor,device,...} bundled to the 
> > > main PCI device (I suppose this means the entries are created by 
> > > 'device_add')
> > >
> > > And after the PCI device is announced, 
> > > /sys/.../{config,resourceX,rom,vpd,iov,...} get created depending on if 
> > > these features are supported.
> > 
> > And that's a bug.  Let's not continue to make the same bug here as well.
> > 
> > > Making dynamic entries tie to the main PCI device would require PCI 
> > > subsystem to allocate different 'bus_type' for the devices, right?
> > 
> > No, it would just mean they need to be all added before the device is
> > fully registered with the driver core.
> 
> I looked into the PCI and driver core code again, but didn't figured out how
> to do it.
> 
> A 'pci_dev' is added by pci_bus_add_device() via device_add(), which creates
> sysfs entries according to 'dev_attrs' in the 'pci_bus_type'. If we want those
> dynamic entries to appear before the uevent is triggered, we have to bundle
> them into the 'dev_attrs'. Is this right way for the dynamic entries? Or I
> missed something?

Yes, that is correct.

Or you can add attributes before device_add() is called to the device,
which is probably much easier to do, right?

There are also "conditional" attributes, which get only displayed if
some kind of condition is met, I think you want to use those.

thanks,

greg k-h
