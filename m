Return-Path: <linux-kernel-owner+w=401wt.eu-S933202AbYDQNMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202AbYDQNMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 09:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759357AbYDQNMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 09:12:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:34484 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759235AbYDQNMO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 09:12:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,671,1199692800"; 
   d="scan'208";a="373612538"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Mapping PCI BAR through /sys/devices/pci* sets cache-disableandwrite-through
Date: Thu, 17 Apr 2008 06:14:31 -0700
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEEE5D0C7@orsmsx423.amr.corp.intel.com>
In-Reply-To: <1208409631.10327.5.camel@koto.keithp.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Mapping PCI BAR through /sys/devices/pci* sets cache-disableandwrite-through
Thread-Index: AcigUbTD7+LneCUJSkejxl+CUh9dkQAOfKxw
References: <1208367626.5245.5.camel@koto.keithp.com> <924EFEDD5F540B4284297C4DC59F3DEEE5CEA9@orsmsx423.amr.corp.intel.com> <1208409631.10327.5.camel@koto.keithp.com>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Keith Packard" <keithp@keithp.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
X-OriginalArrivalTime: 17 Apr 2008 13:12:13.0241 (UTC) FILETIME=[A6AEFA90:01C8A08C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Keith Packard [mailto:keithp@keithp.com] 
>Sent: Wednesday, April 16, 2008 10:21 PM
>To: Pallipadi, Venkatesh
>Cc: linux-kernel; Siddha, Suresh B
>Subject: RE: Mapping PCI BAR through /sys/devices/pci* sets 
>cache-disableandwrite-through
>
>On Wed, 2008-04-16 at 15:23 -0700, Pallipadi, Venkatesh wrote:
>
>> Setting flags "_PAGE_PCD | _PAGE_PWT" maps to PAT_3 which is 
>"UC". So,
>> the mapping X server will get is UC and if X sets MTRR to WC, it will
>> not have any effect on this mapping, which will be still UC. 
>There may
>> be apps which depend on this /sys/ interface giving UC 
>mapping always...
>
>Sure, but X wants WC in the biggest way (our measurements show WC being
>more than 6 times faster for writes, the operation we do the most of).
>
>Jesse Barnes suggested using the fact that the BAR was prefetchable to
>guess that this region should not be mapped UC. I don't know of any
>other information available at this API that would help make a better
>choice; there are no ioctls on /sys files that we could use to
>manipulate the mapping.

Yes. But, the API being there for some time may mean that there is some
user who always wants UC behavior with or without PREFETCHABLE flag.
With PAT changes we thought of ioctl and then settled on new interface.

>> With PAT patches, we now have /sys/devices/pci*resource_wc 
>(in addition
>> to resource) for any PREFETCHABLE region. So, X has to change to use
>> that new interface to get WC mapping.
>
>Yeah, we'll do that when it becomes available. Would it make sense in
>the pre-PAT world to use Jesse's guess?
>

Yes. Easiest way to do that will be to use UC_MINUS (Just set PCD bit
and not PWT bit) until PAT changes.
Ioremap() uses UC_MINUS, it should not have any side effects to other
users who expect this mapping to be UC without any MTRR setting.

>In any case, we'll continue to use the fact that mprotect is 
>also broken
>to get our WC mapping working (using mprotect PROT_NONE followed by
>mprotect PROT_READ|PROT_WRITE causes the CD and WT bits to get 
>cleared).
>We're fortunate in this case that we've found a bug to exploit that
>gives us the desired behaviour.
>

Noo.. Now we have one more thing in PAT to do list :-(. To go and plug
those mprotect APIs to prevent users from doing things like this.

Thanks,
Venki

