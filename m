Return-Path: <linux-kernel-owner+w=401wt.eu-S1756513AbXFUPzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbXFUPzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 11:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbXFUPzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 11:55:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34223 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165AbXFUPy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 11:54:59 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Date: Thu, 21 Jun 2007 17:54:19 +0200
User-Agent: KMail/1.9.5
Cc: Karl MacMillan <kmacmill@redhat.com>, Greg KH <greg@kroah.com>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Crispin Cowan <crispin@novell.com>, Pavel Machek <pavel@ucw.cz>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1181931330.17547.866.camel@moss-spartans.epoch.ncsc.mil> <1181946250.9809.45.camel@localhost.localdomain> <1182173585.7236.53.camel@moss-spartans.epoch.ncsc.mil>
In-Reply-To: <1182173585.7236.53.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 3795
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200706211754.19708.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 June 2007 15:33, Stephen Smalley wrote:
> On Fri, 2007-06-15 at 18:24 -0400, Karl MacMillan wrote:
> > There are two things:
> >
> > 1) relabeling (non-tranquility) is very problematic in general because
> > revocation is hard (and non-solved in Linux). So you would have to
> > address concerns about that.
>
> I think we need to distinguish between relying on restorecond-like
> mechanisms for the security of SELinux vs. relying on them for emulating
> pathname-based security.  The former would be a problem.  The latter is
> no worse than pathname-based security already, because pathname-based
> security is inherently ambiguous and non-tranquil, and revocation isn't
> addressed fully in AA either.

Emulation using lazy relabeling introduces a window where the files have the 
wrong label. In those windows, the pathname based policy is being violated, 
and unintended side effects are suddenly possible. This includes granting of 
access to files that applications should no longer have access to according 
to the pathname based policy, which would be similar to what happens when a 
process keeps an open file handle right now. But it also includes denial of 
access to files that applications should have access to, and this might cause 
those applications to fail. So this is where relabeling from user space is 
much worse.

The only way to get rid of the denial of service problem would be to make the 
rename and relabel an atomic operation. The time this can take is huge 
though, so that's not acceptable.

Another, less catastrophic problem is that rename has always been relatively 
fast and inexpensive, and I'm sure plenty of applications rely on this 
performance characteristic. Making rename a very expensive operation in at 
least some cases (which are more than theoretical) would hurt those 
applications, and nothing much could be done about it.

Adding better new-file mechanisms to SELinux probably is a good idea, and it 
would weaken the SELinux seurity model for all I can tell. It doesn't address 
the relabeling problem though.

Andreas
