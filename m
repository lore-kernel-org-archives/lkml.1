Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbZAFQro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbZAFQro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 11:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbZAFQrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 11:47:32 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:53295 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbZAFQra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 11:47:30 -0500
Date: Tue, 6 Jan 2009 10:47:27 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morgan <morgan@kernel.org>
Subject: Re: [PATCH] CRED: Fix regression in cap_capable() as shown up by
	sys_faccessat() [ver #2]
Message-ID: <20090106164727.GC9773@us.ibm.com>
References: <20090105190722.GA11087@us.ibm.com> <20090105031827.GA10185@us.ibm.com> <24959.1230694093@redhat.com> <20081230134248.GA30124@lst.de> <21275.1230736542@redhat.com> <alpine.LRH.1.10.0901051301590.14359@tundra.namei.org> <28352.1231159413@redhat.com> <6521.1231189936@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6521.1231189936@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> Serge E. Hallyn <serue@us.ibm.com> wrote:
> 
> > You have the 'acting_as' name for subj/eff, which I like.  Is there
> > another name you could use in place of 'real' in the  name
> > task_real_capable()?
> 
> Ummm...  'Actual' or 'Assigned' perhaps?
> 
> > I do find this version much easier to read.  It seems easier to
> > track capable+current_cred() vs real_capable+get_task_cred().  Could
> > you do a few benchmarks to gauge whether the difference the
> > optimization makes?
> 
> Yeah...  My main objection is passing around two or three superfluous arguments
> in the common case.  Most of the time, the only necessary argument to
> sec->capable():
> 
> 	int (*capable) (struct task_struct *tsk, const struct cred *cred,
> 			int cap, int audit);
> 
> is cap; tsk, cred and audit are all superfluous in the (very) common case.
> 
> How about:
> 
> 	int (*fast_capable) (int cap);
> 
> which assumes current, current_cred() and SECURITY_CAP_AUDIT?

Well I'd rather it be called acting_capable() or self_acting_capable(),
but the realy issue is how to make that work through the security_ops()
layer without needless code duplication.  It'd be ideal if it's doable,
I agree.

> Benchmarking is tricky, given that the individual savings will be relatively
> small in comparison to the code that calls them.
> 
> However, if I can get rid of three arguments passed into each of
> security_capable(), selinux_capable() and cap_capable(), that really should
> speed things up if you call it enough times, especially as current is held in a
> register on some archs.
> 
> I'll see what I can do.
> 
> > I'm looking at a several-week-old linux-next, but only see one use of
> > capable on another task which audits, and that is in commoncap for
> > traceme, so it seems reasonable.
> 
> Should has_capability() be out of lines and have security_real_capable() merged
> into it?  And the same for has_capability_noaudit() and
> security_real_capable_noaudit()?
> 
> > So yeah, I do like this version better.
> 
> Perhaps a separate patch to optimise capable().  As I said, I'll see about
> benchmarking it.

Cool, thanks.  In the meantime, I guess your first patch is in
security-next anyway, right?

-serge
