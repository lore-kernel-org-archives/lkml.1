Return-Path: <linux-kernel-owner+w=401wt.eu-S1161098AbXCNKeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161098AbXCNKeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 06:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161094AbXCNKeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 06:34:19 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:46575 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161053AbXCNKeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 06:34:18 -0400
Subject: Re: [RFC] [Patch 1/1] IBAC Patch
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Valdis.Kletnieks@vt.edu, linux-security-module@vger.kernel.org,
       safford@watson.ibm.com, serue@linux.vnet.ibm.com,
       kjhall@linux.vnet.ibm.com, zohar@us.ibm.com,
       linux-kernel@vger.kernel.org, disec-devel@lists.sourceforge.net,
       selinux@tycho.nsa.gov
In-Reply-To: <20070313153131.GB29812@vino.hallyn.com>
References: <1173394696.5981.12.camel@localhost.localdomain>
	 <200703090319.l293JrpC009714@turing-police.cc.vt.edu>
	 <1173736041.5803.3.camel@localhost.localdomain>
	 <20070313153131.GB29812@vino.hallyn.com>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 05:46:55 -0400
Message-Id: <1173865615.5793.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 10:31 -0500, Serge E. Hallyn wrote:
> Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
> > On Thu, 2007-03-08 at 22:19 -0500, Valdis.Kletnieks@vt.edu wrote:
> > > On Thu, 08 Mar 2007 17:58:16 EST, Mimi Zohar said:
> > > > This is a request for comments for a new Integrity Based Access
> > > > Control(IBAC) LSM module which bases access control decisions
> > > > on the new integrity framework services. 
> > > > 
> > > > (Hopefully this will help clarify the interaction between an LSM 
> > > > module and LIM module.)
> > > 
> > > OK, between this and the additional LIM hooks I didn't notice in an earlier
> > > patch, we're starting to see the API.   The only problem is that although
> > > it may be the right API for *your* code, I suspect it's a non-starter without
> > > a discussion about whether it's the right *generic* API for an LIM (which will
> > > require at least one dramatic bun fight about what "Integrity" means).
> > 
> > Absolutely, we need to make sure that the set of LIM hooks is complete and that
> > nothing is missing in order to implement different types of LIM providers.  I'm 
> > copying the digsig mailing list for their input on requirements, which this API 
> > might not satisfy or perhaps address.
> 
> (Could you resend the IBAC patch to the disec list as well?)

Sure, I'm just about to post a new version of IBAC with the changes based on 
comments from the lsm and lkml lists.

> Is IBAC basically a 'demo' lsm?  It only hooks bprm_security, so you
> can't execute anything with a bad hash, right?  So really if you were to
> also hook mmap, this would completely do away with the need for digsig?
> IBAC is automatically able to use any integrity measurement modules you
> write, whether they use gpg like digsig does right now, or use the tpm?

You're absolutely correct on all accounts.

> It also shows how simple it would be to hook selinux, though I guess
> there are several ways we might want to hook selinux - 1. to check only
> security.selinux xattrs, 2. to check integrity of entry point types, 3.
> to check integrity of any files labeled by the integrity measurement
> module as needing to be checked.

Correct. Verifying the integrity of security.selinux xattrs would require 
adding security.selinux to /etc/evm.conf and calls within SELinux to 
integrity_verify_metadata() as needed. Verifying the integrity of files,
would require labeling the files with integrity measurements and
adding calls within SELinux to integrity_verify_data() as needed.

> Is there any way for the LSM itself to direct which data and metadata
> will be measured?  It looks like this is done by separately configuring
> the integrity measurement module - which seems fine to me.

Actually the current EVM implementation as an integrity provider relies on
an LSM module, or for that matter any other kernel module, to make calls 
to the integrity API: integrity_verify_metadata(), integrity_verify_data(), 
and integrity_measure().  The decision as to which files are to be measured
is left up to the LSM module.  For example, as you previously noted, IBAC
only verifies the metadata and data integrity of executables, whereas SLIM 
verifies the metadata and data integrity of SYSTEM level files and all
executables.

Mimi Zohar

