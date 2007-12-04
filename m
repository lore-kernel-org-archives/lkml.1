Return-Path: <linux-kernel-owner+w=401wt.eu-S1752170AbXLDX0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbXLDX0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 18:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbXLDX0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 18:26:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbXLDX0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 18:26:10 -0500
Message-ID: <4755E174.7040106@ce.jp.nec.com>
Date: Tue, 04 Dec 2007 18:23:32 -0500
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Gary Hade <garyhade@us.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Greg KH <gregkh@suse.de>, jbeulich@novell.com
Subject: Re: [PATCH] pci: Omit error message for benign allocation failure
References: <4755AC14.20605@ce.jp.nec.com> <20071204214907.GB9194@us.ibm.com>
In-Reply-To: <20071204214907.GB9194@us.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gary,

Gary Hade wrote:
> On Tue, Dec 04, 2007 at 02:35:48PM -0500, Jun'ichi Nomura wrote:
>> On a system with PCI-to-PCI bridges, following errors are observed:
>>
>> PCI: Failed to allocate mem resource #8:100000@d8200000 for 0000:02:00.0
>> PCI: Failed to allocate mem resource #6:10000@0 for 0000:03:01.0
>>
>> '#6' is for expansion ROM and '#8' for the bridge where the device
>> with the expansion ROM is connected.
> 
> I believe there is a good chance that may be another instance
> of the regression caused by my "Avoid creating P2P prefetch
> window for expansion ROMs" patch that was recently reported by
> Jan Beulich.
>   http://marc.info/?l=linux-kernel&m=119555581103023&w=2

Sorry, I was not clear about that.
I've seen the above errors even with 2.6.22 and RHEL5, which is
based on 2.6.18.
So it's not a regression.

> I am working on a better fix for the problem that the patch
> was attempting to address but this is turning out to be much
> more difficult than I expected.  If I don't have a solution
> very soon I plan to publish a revert patch.
> 
>> But I think the failure is benign because the allocation is
>> not necessary for these resources.
> 
> This is an interesting idea.  Could you elaborate?  As far
> as I can tell, the kernel always tries to allocate memory
> for expansion ROMs which it also exports to user level.

Kernel always tries to. But it's best effort basis, IMO.
(Maybe your patch is going to fix that?)
In the 1st stage (pcibios_allocate_resources, etc.),
it allocates resources based on PCI configuration provided by BIOS,
except for expansion ROMs.
In the 2nd stage (pci_assign_unassigned_resources, etc.),
it allocates resources for unallocated ones including expansion ROMs.
The 2nd stage doesn't reprogram the bridge settings.
So if the expansion ROM is under the bridge where other resource
is already allocated, the allocation failure occurs.
There are comments in drivers/pci/setup-bus.c:
  /* Helper function for sizing routines: find first available
     bus resource of a given type. Note: we intentionally skip
     the bus resources which have already been assigned (that is,
     have non-NULL parent resource). */

Fixing the above might be a better solution.
But I don't know if there are any users who need it.

> I have assumed that some drivers or user level apps may
> need to access this space.  Is this not true?

I haven't heard of applications which depend on the kernel resource
allocation for expansion ROMs.
X is a big user of expansion ROMs but I heard it solves the resource
conflict itself.
If there is a counter example, I would like to know it.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America
