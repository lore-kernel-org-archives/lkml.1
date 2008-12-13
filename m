Return-Path: <linux-kernel-owner+w=401wt.eu-S1751753AbYLMRlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbYLMRlU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 12:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976AbYLMRlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 12:41:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933AbYLMRlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 12:41:10 -0500
Date: Sat, 13 Dec 2008 09:41:05 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alex Chiang <achiang@hp.com>
cc: matthew@wil.cx, justin.chen@hp.com, linux-kernel@vger.kernel.org
Subject: Re: PCI BAR mem resource allocation "regression"
In-Reply-To: <alpine.LFD.2.00.0812130901370.3340@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0812130929100.3340@localhost.localdomain>
References: <20081213000538.GC9947@ldl.fc.hp.com> <alpine.LFD.2.00.0812130901370.3340@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 13 Dec 2008, Linus Torvalds wrote:
> 
> I'm missing some pieces I'd like to see: /proc/iomem before and after, and 
> lspci output before and after (you do give lspci output, but only one, and 
> I can't tell if it's before or after).
> 
> Also, is it just the error message, or does it actually affect 
> functionality?

Oh - one more thing. Your revert is very complex, and a simpler revert 
(that _should_ revert just the actual behavioral change) is just the 
two-liner that removes these two lines:

		if ((first->start == new->start) && (first->end == new->end))
			break;

in __insert_resource.

So can you check if your more complex revert really has the same behaviour 
as just removing those two lines?

Matthew: I do suspect that the "insert below" patch is wrong. Look at 
"pci_claim_resource()", for example: it uses insert_resource() to insert 
the PCI device resource into the resource tree. But if the PCI device 
resource has the same size as the bus window, that commit changes it to 
insert it as the _parent_ of the bus window, no?

Of course, on a PC, the only user of pci_claim_resource() would be some 
PCI quirks that should never trigger this, but it's an example of the kind 
of behavioural change that that commit introduced, and which looks 
like it could result in a wrong resource tree.

I'm not finding the original discussion that resulted in that patch, 
though, so I have a somewhat hard time to judge the reasoning. It's from 
almost three years ago, I don't remember details even if I had been 
involved with it (and judging by the sign-off path, I hadn't).

Matthew, do you remember the context of that commmit d33b6fba2?

		Linus
