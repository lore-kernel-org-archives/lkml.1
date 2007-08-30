Return-Path: <linux-kernel-owner+w=401wt.eu-S1760690AbXH3OBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760690AbXH3OBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 10:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756257AbXH3OBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 10:01:04 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:1742 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089AbXH3OBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 10:01:01 -0400
In-Reply-To: <46D5BBFA.5060200@austin.ibm.com>
To: jschopp <jschopp@austin.ibm.com>, Nathan Lynch <ntl@pobox.com>
Cc: Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       Paul Mackerras <paulus@samba.org>, Paul Mackerras <pmac@au1.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Thomas Q Klein <tklein@de.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2.6.23] ibmebus: Prevent bus_id collisions
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OF9D1ED44F.896DCCC5-ONC1257347.0044D256-C1257347.004CFB07@de.ibm.com>
Date: Thu, 30 Aug 2007 16:00:56 +0200
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 30/08/2007 16:00:57,
	Serialize complete at 30/08/2007 16:00:57
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nathan Lynch <ntl@pobox.com> wrote on 29.08.2007 20:12:32:

> > Previously, ibmebus derived a device's bus_id from its location code. 
The
> > location code is not guaranteed to be unique, so we might get bus_id
> > collisions if two devices share the same location code. The OFDT 
full_name,
> > however, is unique, so we use that instead.
> 
> This is a userspace-visible change, but I guess it's unavoidable.
> Will anything break?

Nope. Userspace programs should not depend on ibmebus' way of naming the 
devices; especially since some overly long loc_codes tended to be 
truncated and thus rendered useless. I have tested IBM's DLPAR tools 
against the changed kernel, and they didn't break.
 
> Also, I dislike this approach of duplicating the firmware device tree
> path in sysfs.

Why? Any specific reasons for your dislike?

> Are GX/ibmebus devices guaranteed to be children of
> the same node in the OF device tree?  If so, their unit addresses will
> be unique, and therefore suitable values for bus_id.  I believe this
> is what the powerpc vio bus code does.

While there's no such guarantee (as in "officially signed document"), yes, 
I expect future GX devices to also appear beneath the OFDT root node. For 
the existing devices, the unit addresses are already part of the device 
name, so I save the need to use sprintf() again. Plus, I rather like using 
the full_name since it also contains a descriptive name as opposed to 
being just nondescript numbers, helping the layman (ie user) to make sense 
out of a dev_id.

jschopp <jschopp@austin.ibm.com> wrote on 29.08.2007 20:33:30:

> > +   len = strlen(dn->full_name + 1);
> > +   bus_len = min(len, BUS_ID_SIZE - 1);
> > +   memcpy(dev->ofdev.dev.bus_id, dn->full_name + 1
> > +          + (len - bus_len), bus_len);
> > +   for (i = 0; i < bus_len; i++)
> > +      if (dev->ofdev.dev.bus_id[i] == '/')
> > +         dev->ofdev.dev.bus_id[i] = '_';
> > 
> >     /* Register with generic device framework. */
> >     if (ibmebus_register_device_common(dev, dn->name) != 0) {
> 
> What happens when the full name is > 31 characters?  It looks to me that 
it 
> will be truncated, which takes away the uniqueness guarantee.

There are currently two GX devices, eHCA and eHEA, which both reside 
beneath the root node - this is required by architecture for those 
devices. Unless they invent a device called 
"supercalifragilisticexpialidocious", devices in the root note will have a 
full_name of less than 31 chars. Even in that case, the truncation occurs 
at the beginning, so the @xxx part that makes the nodes unique will stay 
in place.

If any more GX devices appear on the scene, I expect them to appear in the 
root node as well. The substitution of "/" by "_" is a safeguard so 
possible weird OFDT setups don't break the kernel.
 
> There must be an individual property that is guaranteed to be unique and 

> less than 32 characters.  How about "ibm,my-drc-index"?  That looks like 
a 
> good candidate.

On first glance, it does, however the attribute might not be present in 
all cases. Architecture states it only needs to be present on systems with 
dynamic reconfiguration enabled.

All things considered, I still like the idea of using the full_name most. 
No offense.

Regards,
  Joachim
