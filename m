Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbZFFXDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbZFFXDl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 19:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbZFFXDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 19:03:34 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:38663 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752004AbZFFXDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 19:03:33 -0400
X-Trace: 210661819/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.119.212/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.119.212
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgQGAEaSKkpPRXfU/2dsb2JhbACBT8skgjGBWQU
X-IronPort-AV: E=Sophos;i="4.41,316,1241391600"; 
   d="scan'208";a="210661819"
Date: Sat, 6 Jun 2009 23:29:45 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Mimi Zohar <zohar@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       James Morris <jmorris@namei.org>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] integrity: fix IMA inode leak
In-Reply-To: <alpine.LFD.2.01.0906061433490.6847@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0906062312310.12529@sister.anvils>
References: <Pine.LNX.4.64.0906062109580.8365@sister.anvils>
 <alpine.LFD.2.01.0906061416170.6847@localhost.localdomain>
 <alpine.LFD.2.01.0906061433490.6847@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Jun 2009, Linus Torvalds wrote:
> On Sat, 6 Jun 2009, Linus Torvalds wrote:
> > On Sat, 6 Jun 2009, Hugh Dickins wrote:
> > >
> > > CONFIG_IMA=y inode activity leaks iint_cache and radix_tree_node objects
> > > until the system runs out of memory.  Nowhere is calling ima_inode_free()
> > > a.k.a. ima_iint_delete().  Fix that by calling it from destroy_inode().
> > 
> > Shouldn't we call it from "security_inode_free()" instead? And shouldn't 
> > it be allocated in "security_inode_alloc()"? That sounds like the correct 
> > nesting here, since the whole integrity thing is under the security 
> > module.
> > 
> > Hmm?

I wondered the same: quite possibly, but I tend to assume there was reason
to do it like that; and thought it best to mirror the security_inode_alloc,
ima_inode_alloc with ima_inode_free, security_inode_free for now.

(I also disliked the obfuscescent #define ima_iint_delete ima_inode_free
in ima_iint.c!)

> 
> Oh well. I applied the patch as-is, since it seems to fix a real issue. 

Thanks, yes.  There is a possibility that it will reveal some warnings
from iint_free which were hidden before; but I've not seen them in normal
working, and I'd anyway prefer a few warnings to my boxes OOMing.  Though
it was only by mistake that I had CONFIG_IMA=y in the first place.

> 
> But I do think fs/inode.c shouldn't care about things like that, and have 
> it internal to security_inode_alloc/free(). But I guess that's a separate 
> cleanup.

The IMA stuff all looks rather bolted in on top; I did fail to persuade
Mimi to move the shmem and shm hooks down a level, so for now at least
they'll stay as they are.

Hugh
