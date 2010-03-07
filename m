Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab0CGSNr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 13:13:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753165Ab0CGSNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 13:13:46 -0500
Date: Sun, 7 Mar 2010 10:12:48 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Alexey Dobriyan <adobriyan@gmail.com>, don.mullis@gmail.com,
       david@fromorbit.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: modules, "modules" and CONFIG_LIST_SORT
In-Reply-To: <4B93D63B.1040403@oracle.com>
Message-ID: <alpine.LFD.2.00.1003070959490.4033@localhost.localdomain>
References: <20100307091223.GA4895@x200> <alpine.LFD.2.00.1003070320370.4033@localhost.localdomain> <4B93D63B.1040403@oracle.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 7 Mar 2010, Randy Dunlap wrote:
> On 03/07/10 03:23, Linus Torvalds wrote:
> > 
> > Honestly, personally I'd rather have a real library that modules can link 
> > to _before_ even loading into kernel space, but that's not how we've 
> > traditionally done things. So I guess we should just revert that commit.
> 
> xfs also needs "select LIST_SORT".  I posted a patch for that a few days
> ago and now Christoph Hellwig has asked me to send the patch directly to Linus,
> but if Linus is going to revert the 'config LIST_SORT' patch, I'll skip it.

Ok, it's reverted in my tree now, I'll push out soon.

That said, I was serious about the "real library" thing. I do wonder if we 
should add a "link with standard kernel libraries" phase to the final 
module link, so that we can stop exporting silly things, and handle cases 
like this sanely without forcing it on everybody just because some module 
_might_ need it.

For example, I've always hated how we export the 'libgcc' kind of symbols 
too. I think we'd generally be _much_ better off just linking them into 
the module directly, even if that means that we'll have multiple copies. I 
hate the things like

	EXPORT_SYMBOL(__ashldi3);

that various architectures use. They have _nothing_ to do with real kernel 
interfaces, and are usually really small. And on several architectures a 
direct-linked call can be optimized by the linker in ways that external 
linkage cannot, so it might even improve code in some cases.

				Linus
