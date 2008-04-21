Return-Path: <linux-kernel-owner+w=401wt.eu-S1758891AbYDUXK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891AbYDUXK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 19:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758536AbYDUXKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 19:10:46 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:34800 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758415AbYDUXKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 19:10:44 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 22/53] PNP: factor pnp_init_resource_table() and pnp_clean_resource_table()
Date: Mon, 21 Apr 2008 17:10:37 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080418204955.342963315@ldl.fc.hp.com> <48097886.9000907@keyaccess.nl> <480CDFDB.3020703@keyaccess.nl>
In-Reply-To: <480CDFDB.3020703@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804211710.38660.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 April 2008 12:41:31 pm Rene Herman wrote:
> isapnp_get_resources didn't allocate simply since it hasn't been called yet; 
> there's nothing to get from an inactive device. It is pnp_assign_resources 
> which constructs the table which isapnp_set_resources then puts to the hardware.

Yes, right.  I reproduced this on an ACPI system where the BIOS leaves
a couple devices disabled.

> Getting things working also needs setting pnp_res->index (to nport, nmem, 
> nirq, ndma in pnp_assign_resources) so that the isapnp_set_resources which 
> follows sets to the correct hardware index, but at that point position in 
> the list and the index are mixing together in unhealthy ways -- in the 
> pnp_assign_foo helpers, pnp_get_resource(.., idx) just get the "idx-th" 
> resource of the correct type in the list but it seems it really should be 
> getting the resource of the correct type with its ->index set to "idx".

I don't mind setting pnp_res->index in the generic pnp_assign_* code.
We have to do that already in pnp_set_current_resources() (the /sys
interface), and I don't see a good way around it.

In pnp_assign_resources(), we currently assume that all independent
options appear before any dependent ones because we compute nport,
nmem, etc by iterating through the independent options first.  Then
we use those nport, nmem, etc values as the "index" (CSR index for
ISAPNP, nth resource type in the template for PNPBIOS and PNPACPI).
I don't know whether this assumption is in the spec, but at least
we've assumed it for a long time.

I'm trying to figure out the cases where pnp_assign_resources()
has to pay attention to pre-existing configuration.  It looks like
the common case is that we'll start with an empty resource list, and
we can just find non-conflicting values and use pnp_add_foo_resource().

But I'm concerned about all the IORESOURCE_AUTO stuff.  Seems like
we should only get to pnp_assign_foo() with !IORESOURCE_AUTO if
(a) we've used /sys to set some but not all resources, or (b) the
BIOS described fewer things in _CRS than in _PRS (which seems like
a BIOS bug).  But I'm not comfortable with this yet.

> Anyways, currently things really don't work though, due to
> 
> 1) pnp_assign_resources needing to construct the list and
> 2) it needing to match resources by their index.
> 
> (do note that pnp_assign_foo are the only callers of pnp_check_foo and they 
> could be either merged together or at least not communicate via "idx" but 
> simply by passing the res/pnp_res).

Yes, I'd like to do that.  But I think I'd better wait or I'll never
get anything finished :-)

> Also note -- manually set resources are skipped in pnp_assign_resources, yet 
> they also definitely need their index initialized for use by 
> isapnp_set_resources.

Yes.  "Manually set resources" includes ones from /sys and also the
resources we discover from active devices.  We should already be setting
those in the /sys and ISAPNP "read resources" paths.

Bjorn
