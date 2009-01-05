Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbZAEDSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbZAEDSn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 22:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbZAEDSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 22:18:32 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:41264 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbZAEDSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 22:18:31 -0500
Date: Sun, 4 Jan 2009 21:18:27 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morgan <morgan@kernel.org>
Subject: Re: [PATCH] CRED: Fix regression in cap_capable() as shown up by
	sys_faccessat() [ver #2]
Message-ID: <20090105031827.GA10185@us.ibm.com>
References: <24959.1230694093@redhat.com> <20081230134248.GA30124@lst.de> <21275.1230736542@redhat.com> <alpine.LRH.1.10.0901051301590.14359@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.1.10.0901051301590.14359@tundra.namei.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Morris (jmorris@namei.org):
> On Wed, 31 Dec 2008, David Howells wrote:
> 
> > 
> > Here's an improved patch.  It differentiates the use of objective and
> > subjective capabilities by making capable() only check current's subjective
> > caps, but making has_capability() check only the objective caps of whatever
> > process is specified.
> > 
> > It's a bit more involved, but I think it's the right thing to do.
> 
> I think it's the right approach, too, and the patch seems ok to me.  I've 
> applied it to 
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next
> 
> and expect to push it to Linus in the next day or so.  It's not a trivial 
> change, and could do with more review (Serge?).

(Andrew Morgan cc'd for more review)

Yes, I'm sorry, I've been staring at it on and off all weekend...  From
a high level it looks right, but i think there's a problem with naming
here (which also could be said to have obfuscated the original bug).
The security_capable() should be security_capable_eff() or somesuch,
and security_task_capable() should be security_task_capable_real() or
something.  In fact the current-as-implicit optimization could be put
off for a kernel release or so while we just have
security_capable_eff(tsk, cap) and security_real_eff(tsk, cap), or
just security_capable(tsk, cap, flag) where flag is CAP_EFF or CAP_REAL.

I've been holding off on saying this since sat night bc when i read it
back it looks petty, but every time i read the patch i'm more convinced
that the type of capability checked must be made explicit to make this
maintainable (maybe even reviewable).

I'm also not thrilled about security_task_capable() and
security_ops->task_capable() having different args and semantics, but
of course I see the reason for it and figure if there's a way to improve
on that we can do it later.

Anyway David the patch on its own doesn't look incorrect.  So far
the only code which manipulates subjective caps is in fact
sys_faccessat through cap_set_effective() right?  If so this at
least looks safe, looking through capable/has_capability callers.

Finally, may i just say that i love the fact that a syscall is
checking the real user's access rights and so sets eff creds to
have the caps of the real user :)  Hmm, did you at one time call
the subjective creds 'working' or 'acting' creds?  Might be a good
name.  Subj/obj always makes me pause to think, and real/eff while
seemingly natural could be confusing in cases like this.
cap_set_acting() -  i like it...

thanks,
-serge

> It seems that more testing should be done in linux-next vs. waiting for 
> the merge window.
> 
> 
> - James
> -- 
> James Morris
> <jmorris@namei.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
