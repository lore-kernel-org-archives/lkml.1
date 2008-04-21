Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbYDUSlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbYDUSlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 14:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbYDUSlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 14:41:45 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:56018 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbYDUSlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 14:41:44 -0400
Message-ID: <480CDFDB.3020703@keyaccess.nl>
Date: Mon, 21 Apr 2008 20:41:31 +0200
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
References: <20080418204955.342963315@ldl.fc.hp.com> <20080418205051.704761191@ldl.fc.hp.com> <480920BB.9010506@keyaccess.nl> <200804182157.34313.bjorn.helgaas@hp.com> <48097886.9000907@keyaccess.nl>
In-Reply-To: <48097886.9000907@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19-04-08 06:43, Rene Herman wrote:

> Probably. Just a quick heads up; if you don't beat me to it I'll look at
> it in more detail over the weekend but with the current series ISAPnP is
> quite decidedly broken. Forget the OOPS for now which seems just a 
> symptom of the same thing as the "too many" warnings". Result of 
> "modprobe snd-cs4236".
> 
> I believe it's pnp_assign_resources() which has all the pnp_assign_foo()
>  helpers fail due to there not being any yet. I guess pnp_assign_mem() 
> and friends should allocate upon not finding one available and not fail?
> 
> Don't get why isapnp_get_resources() didn't allocate though. As said, 
> unless you beat me to it I'll look into it more tomorrow or sunday.

isapnp_get_resources didn't allocate simply since it hasn't been called yet; 
there's nothing to get from an inactive device. It is pnp_assign_resources 
which constructs the table which isapnp_set_resources then puts to the hardware.

Currently with the list, pnp_assign_resources doesn't construct anything. It 
finds an empty resource list and then fails all pnp_assign_foo() helpers. I 
can get things functional by making pnp_assign_foo do a pnp_add_foo_resource 
upon not finding one yet but that's a hack -- things are just not very right 
at the moment.

Getting things working also needs setting pnp_res->index (to nport, nmem, 
nirq, ndma in pnp_assign_resources) so that the isapnp_set_resources which 
follows sets to the correct hardware index, but at that point position in 
the list and the index are mixing together in unhealthy ways -- in the 
pnp_assign_foo helpers, pnp_get_resource(.., idx) just get the "idx-th" 
resource of the correct type in the list but it seems it really should be 
getting the resource of the correct type with its ->index set to "idx".

Just making it do that then again disagrees with pnpbios/acpi which do not 
set the index field, nor do I know if you'd want them to or want to keep the 
index totally isapnp specific.

Anyways, currently things really don't work though, due to

1) pnp_assign_resources needing to construct the list and
2) it needing to match resources by their index.

(do note that pnp_assign_foo are the only callers of pnp_check_foo and they 
could be either merged together or at least not communicate via "idx" but 
simply by passing the res/pnp_res).

Also note -- manually set resources are skipped in pnp_assign_resources, yet 
they also definitely need their index initialized for use by 
isapnp_set_resources.

No patches due to the huge series where I don't know where you want to take 
a different turn to end up right. Also many, many opportunities for more 
cleanup of drivers/pnp/manager.c in its post-series state but I suppose you 
want the series bisectably functional first. I'll wait for a next version 
for now I guess?

Rene.

