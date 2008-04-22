Return-Path: <linux-kernel-owner+w=401wt.eu-S1760785AbYDVVCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760785AbYDVVCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 17:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbYDVVCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 17:02:12 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:37203 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbYDVVCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 17:02:10 -0400
Message-ID: <480E5246.5000804@keyaccess.nl>
Date: Tue, 22 Apr 2008 23:01:58 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 22/53] PNP: factor pnp_init_resource_table() and pnp_clean_resource_table()
References: <20080418204955.342963315@ldl.fc.hp.com> <48097886.9000907@keyaccess.nl> <480CDFDB.3020703@keyaccess.nl> <200804211710.38660.bjorn.helgaas@hp.com>
In-Reply-To: <200804211710.38660.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22-04-08 01:10, Bjorn Helgaas wrote:

> Yes, right.  I reproduced this on an ACPI system where the BIOS leaves
> a couple devices disabled.

Ah, good, not just  isapnp then. I was starting to feel lonely here, sitting 
atop my pile of ISA crap...

>> Getting things working also needs setting pnp_res->index (to nport, nmem, 
>> nirq, ndma in pnp_assign_resources) so that the isapnp_set_resources which 
>> follows sets to the correct hardware index, but at that point position in 
>> the list and the index are mixing together in unhealthy ways -- in the 
>> pnp_assign_foo helpers, pnp_get_resource(.., idx) just get the "idx-th" 
>> resource of the correct type in the list but it seems it really should be 
>> getting the resource of the correct type with its ->index set to "idx".
> 
> I don't mind setting pnp_res->index in the generic pnp_assign_* code.
> We have to do that already in pnp_set_current_resources() (the /sys
> interface), and I don't see a good way around it.
> 
> In pnp_assign_resources(), we currently assume that all independent
> options appear before any dependent ones because we compute nport,
> nmem, etc by iterating through the independent options first.  Then
> we use those nport, nmem, etc values as the "index" (CSR index for
> ISAPNP, nth resource type in the template for PNPBIOS and PNPACPI).
> I don't know whether this assumption is in the spec, but at least
> we've assumed it for a long time.

Did this just address my position/index worry above?

It seems you designed the list to be basically in any order, judging by 
things such as pnp_new_resource which'll happily reuse resources of the 
correct type at any position in the list. Yet, pnp_assign_foo() and friends 
retrieve resources (through pnp_get_resource) by position in the list and 
not by the index. I'm not overly sure of failure scenarios but isn't this 
mixing up position and index in a bad way?

> I'm trying to figure out the cases where pnp_assign_resources()
> has to pay attention to pre-existing configuration.  It looks like
> the common case is that we'll start with an empty resource list, and
> we can just find non-conflicting values and use pnp_add_foo_resource().

Yes...

> But I'm concerned about all the IORESOURCE_AUTO stuff.  Seems like
> we should only get to pnp_assign_foo() with !IORESOURCE_AUTO if
> (a) we've used /sys to set some but not all resources, or (b) the
> BIOS described fewer things in _CRS than in _PRS (which seems like
> a BIOS bug).  But I'm not comfortable with this yet.

Sounds right to me. Note that the /sys stuff is also not a corner case 
situation either, as it's the way to force at least ISAPnP hardware to 
manual settings.

>> (do note that pnp_assign_foo are the only callers of pnp_check_foo and they 
>> could be either merged together or at least not communicate via "idx" but 
>> simply by passing the res/pnp_res).
> 
> Yes, I'd like to do that.  But I think I'd better wait or I'll never
> get anything finished :-)

Well, the idea here was that getting rid of one "idx" here so that things 
communicate directly removes at least one possible ordering artifact...

>> Also note -- manually set resources are skipped in pnp_assign_resources, yet 
>> they also definitely need their index initialized for use by 
>> isapnp_set_resources.
> 
> Yes.  "Manually set resources" includes ones from /sys and also the
> resources we discover from active devices.  We should already be setting
> those in the /sys and ISAPNP "read resources" paths.

Hmm, yes, that sounds true...

Rene.
