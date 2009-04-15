Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbZDOWnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbZDOWnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 18:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbZDOWnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 18:43:07 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:41958 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbZDOWnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 18:43:05 -0400
Subject: Re: C/R without "leaks" (was: Re: Creating tasks on restart:
 userspace vs kernel)
From: Greg Kurz <gkurz@fr.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090415195629.GD26994@x200.localdomain>
References: <49E40662.2040508@cs.columbia.edu>
	 <20090414163633.GE27461@x200.localdomain>
	 <49E4D89D.9060903@cs.columbia.edu>
	 <20090415195629.GD26994@x200.localdomain>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 00:42:17 +0200
Message-Id: <1239835337.6610.6.camel@bahia>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-15 at 23:56 +0400, Alexey Dobriyan wrote:
> > Again, so to checkpoint one task in the topmost pid-ns you need to
> > checkpoint (if at all possible) the entire system ?!
> 
> One more argument to not allow "leaks" and checkpoint whole container,
> no ifs, buts and woulditbenices.
> 
> Just to clarify, C/R with "leak" is for example when process has separate
> pidns, but shares, for example, netns with other process not involved in
> checkpoint.
> 
> If you allow this, you lose one important property of checkpoint part,
> namely, almost everything is frozen. Losing this property means suddenly
> much more stuff is alive during dump and you has to account to more stuff
> when checkpointing. You effectively checkpointing on live data structures
> and there is no guarantee you'll get it right.
> 
> Example 1: utsns is shared with the rest of the world.
> 
> utsns content is modifiable only by tasks (current->nsproxy->uts_ns).
> Consequently, someone can modify utsns content while you're dumping it
> if you allow "leaks".
> 
> Did you take precautions? Where?
> 
> 	static int cr_write_utsns(struct cr_ctx *ctx, struct uts_namespace *uts_ns)
> 	{
> 	        struct cr_hdr h;
> 	        struct cr_hdr_utsns *hh;
> 	        int domainname_len;
> 	        int nodename_len;
> 	        int ret;
> 
> 	        h.type = CR_HDR_UTSNS;
> 	        h.len = sizeof(*hh);
> 
> 	        hh = cr_hbuf_get(ctx, sizeof(*hh));
> 	        if (!hh)
> 	                return -ENOMEM;
> 
> 	        nodename_len = strlen(uts_ns->name.nodename) + 1;
> 	        domainname_len = strlen(uts_ns->name.domainname) + 1;
> 
> 	        hh->nodename_len = nodename_len;
> 	        hh->domainname_len = domainname_len;
> 
> 	        ret = cr_write_obj(ctx, &h, hh);
> 	        cr_hbuf_put(ctx, sizeof(*hh));
> 	        if (ret < 0)
> 	                return ret;
> 
> 	        ret = cr_write_string(ctx, uts_ns->name.nodename, nodename_len);
> 	        if (ret < 0)
> 	                return ret;
> 
> 	        ret = cr_write_string(ctx, uts_ns->name.domainname, domainname_len);
> 	        return ret;
> 	}
> 
> You should take uts_sem.
> 
> 
> Example 2: ipcns is shared with the rest of the world
> 
> Consequently, shm segment is visible outside and live. Someone already
> shmatted to it. What will end up in shm segment content? Anything.
> 
> You should check struct file refcount or something and disable attaching
> while dumping or something.
> 
> 
> Moral: Every time you do dump on something live you get complications.
> Every single time.
> 
> 
> There are sockets and live netns as the most complex example. I'm not
> prepared to describe it exactly, but people wishing to do C/R with
> "leaks" should be very careful with their wishes.

They should close their sockets before checkpoint and find/have some way
to reconnect after. This implies some kind of C/R awareness in the code
to be checkpointed.

-- 
Gregory Kurz                                     gkurz@fr.ibm.com
Software Engineer @ IBM/Meiosys                  http://www.ibm.com
Tel +33 (0)534 638 479                           Fax +33 (0)561 400 420

"Anarchy is about taking complete responsibility for yourself."
        Alan Moore.

