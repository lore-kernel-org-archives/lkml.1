Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab0BHFdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 00:33:52 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39098 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab0BHFdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 00:33:49 -0500
Date: Mon, 8 Feb 2010 05:33:41 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mimi Zohar <zohar@us.ibm.com>
Cc: Xiaotian Feng <dfeng@redhat.com>, Eric Paris <eparis@redhat.com>,
       Eugene Teo <eugene@redhat.com>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-security-module-owner@vger.kernel.org, serue@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [GIT][IMA] fix null pointer deref
Message-ID: <20100208053341.GI30031@ZenIV.linux.org.uk>
References: <1265364881-8140-1-git-send-email-dfeng@redhat.com>
 <OFD4EDD9E8.3C38BC7C-ON852576C1.004B1271-852576C1.004BCFCC@us.ibm.com>
 <alpine.LRH.2.00.1002071832080.21000@tundra.namei.org>
 <20100207075658.GF30031@ZenIV.linux.org.uk>
 <OF4ED37009.B78CBF20-ON852576C4.0012975E-852576C4.00145EA3@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF4ED37009.B78CBF20-ON852576C4.0012975E-852576C4.00145EA3@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 07, 2010 at 10:42:29PM -0500, Mimi Zohar wrote:

> > ima_path_check() side is also of BUG_ON() variety (and isn't triggered).
> 
> hm, there was quite a bit of discussion that IMA should be called from
> the security hooks (refer to http://lkml.org/lkml/2009/6/7/279),  so
> commit 6c21a7f "LSM: imbed ima calls in the security hooks" moved them.

You know, I'm -><- that close to posting a highly unprintable rant about
hooks in general, associated style of development and resulting problems.
With names named and *many* examples given.

LSM is essentially a trashcan and just about everything icky gets swept
over there.  That's fine, as long as one doesn't care whether their code
makes sense and just wants to keep it away from unfriendly eyes.

The first question one should ask is "what would be the natural point in
object life cycle to do that", not "which hooks can I plug that into and
how do I work around this, this and that".

In this case, "when is struct file freed?" became a proxy for "when is
an opened file closed?", with bogus heuristics added to distinguish the
callers.  Nothing in VFS has promised NULL ->f_path.dentry for a struct
file that hasn't been fully set up (i.e. hasn't transitioned to a state
where fput() is the proper destructor).  The fact that you guys ran into
a situation where you needed that kind of heuristics should've been
a clear indicator that something was wrong; silently adding them into
place that by design is outside of normal code was Wrong with capital WTF.

I'd better stop before that devolves into saying what I really think about
LSM, assorted Creatures From Black Lagoon slipping into fs/*.c (and mm/*.c)
once a year or so, et revolting cetera.  If I ever find a way to do that
adequately without incoherent obscenities, I'll post it.

The bottom line: minimizing patch footprint is a good thing, but NOT if
it comes at the cost of bogus kludges.
