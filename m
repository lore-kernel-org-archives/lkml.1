Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbYCQQQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbYCQQQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 12:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbYCQQQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 12:16:44 -0400
Received: from web36615.mail.mud.yahoo.com ([209.191.85.32]:46758 "HELO
	web36615.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751736AbYCQQQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 12:16:43 -0400
X-YMail-OSG: fEGTjJwVM1mRdlL.RsDb0r5pxVnGc3Arde_DFhe9EA6ZPqVxyIt3thM7E37wUYV1fpUCnjVWtA--
X-RocketYMMF: rancidfat
Date: Mon, 17 Mar 2008 09:16:42 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] cgroups: implement device whitelist lsm (v3)
To: "Serge E. Hallyn" <serue@us.ibm.com>,
       Casey Schaufler <casey@schaufler-ca.com>
Cc: Stephen Smalley <sds@epoch.ncsc.mil>, "Serge E. Hallyn" <serue@us.ibm.com>,
       James Morris <jmorris@namei.org>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Linux Containers <containers@lists.osdl.org>, Greg KH <greg@kroah.com>,
       Pavel Emelianov <xemul@openvz.org>
In-Reply-To: <20080317140853.GC5875@sergelap.austin.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <784599.23478.qm@web36615.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Serge E. Hallyn" <serue@us.ibm.com> wrote:

> Quoting Casey Schaufler (casey@schaufler-ca.com):
> ...
> > In particular, capabilities are not an access control mechanism,
> > they are a privilege mechanism. A lot of discussion about LSM has
> > centered around the appropriate charactoristics of an LSM, and
> > these discussions always assume that the LSM in question is
> > exactly an access control mechanism. If we split the LSM into
> > a LACM for access control and an LPM for privilege management
> > maybe we can eliminate the most contentious issues.
> > 
> > Does anyone know why that would be stoopid before I whack out
> > patches?
> 
> No I'd like to see those patches.  It would ideally allow LSM to become
> *purely* restrictive and LPM to be purely empowering, presumably making
> the resulting hook sets easier to review and maintain.  The LPM wouldn't
> (I assume) gain any *new* hook points so we wouldn't be adding any new
> places for hooks to be overriden by a rootkit.

I don't expect to put in any additional hooks points, although
it's safe to bet that someone will want to pretty quickly. What
I see as the big concern is our old friend the granularity question.
I can pretty well predict that we'll have quite a bruhaha over
whether each hook point should have it's own hook or if they should
be shared based on the privilege supported. For example, in namei.c
the function generic_permission() currently calls
capable(CAP_DAC_OVERRIDE). The privilege supported approach would
be to create a hook that gets used in many places that is a drop-in
replacement for that,

        if (capable(CAP_DAC_OVERRIDE))
becomes
        if (lpm_dac_override())

The alternative is to go the same route as the LSM, where it
becomes

        if (lpm_generic_permission_may_exec())

The former scheme is much easier to implement. It also would
mean that if would wanted to implement a finer granularity on
DAC overrides (e.g. CAP_DAC_READ, CAP_DAC_WRITE, CAP_DAC_EXECUTE)
you would have to introduce new hooks. That wouldn't be any worse
than today's situation where you would have to change the argument
passed to capable as far as the calling (e.g. generic_permission)
code is concerned, but it would mean updating all the LPMs. I
currently count 1084 calls to capable (sloppy grep method) and that's
way too many hooks in my mind. But, if there's anyone who thinks
that the way to go is for each existing capable call to be a hook,
feel free to make a convincing argument.

This should be fun.


Casey Schaufler
casey@schaufler-ca.com
