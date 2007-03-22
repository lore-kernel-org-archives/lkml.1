Return-Path: <linux-kernel-owner+w=401wt.eu-S934168AbXCVSHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934168AbXCVSHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 14:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934169AbXCVSHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 14:07:12 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53495 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934168AbXCVSHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 14:07:10 -0400
Date: Thu, 22 Mar 2007 13:07:07 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Ian Kent <raven@themaw.net>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Cedric Le Goater <clg@fr.ibm.com>, sukadev@us.ibm.com,
       Andrew Morton <akpm@osdl.org>, Dave Hansen <haveblue@us.ibm.com>,
       Herbert Poetzl <herbert@13thfloor.at>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Replace pid_t in autofs with struct pid reference
Message-ID: <20070322180707.GA15692@sergelap.austin.ibm.com>
References: <1174063618.3397.58.camel@raven.themaw.net> <m1hcslm1tc.fsf@ebiederm.dsl.xmission.com> <20070319200839.GB19449@sergelap.austin.ibm.com> <m1odmpvuft.fsf@ebiederm.dsl.xmission.com> <20070320201548.GA21312@sergelap.austin.ibm.com> <m17itbmypc.fsf@ebiederm.dsl.xmission.com> <20070320214125.GA5585@sergelap.austin.ibm.com> <m1r6rjlgl9.fsf@ebiederm.dsl.xmission.com> <20070321205834.GB21517@sergelap.austin.ibm.com> <1174530523.4635.25.camel@raven.themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174530523.4635.25.camel@raven.themaw.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Ian Kent (raven@themaw.net):
> How does this affect getting ids for waitq request packets of other user
> space processes triggering mounts? I'm guessing that they would need to
> belong to the appropriate namespace for this mechanism to funtion
> correctly.

A feature of the pid namespaces is that any process in a cloned
namespace still has a valid pid in all ancestore pid namespaces.  So
when a process triggers a mount, either it is in the same or a decendent
pid namespace as the process which did the mounting, in which case the
pid sent to the mounter is correct;  or it is in some other namespace,
and it will get '0'.  The latter shouldn't happen in a proper setup, and
should be safe to ignore in an improper setup.

For instance, so long as any clone(CLONE_NEWPID) is always done along
with a CLONE_NEWNS, and process in the child namespace which mounts an
autofs instance, processes in the parent pid namespace won't trigger
automounts.  But if somehow they did (i.e. with shared submounts or by
not doing CLONE_NEWNS), pid 0 will be reported.

thanks,
-serge
