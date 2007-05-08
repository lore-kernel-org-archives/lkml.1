Return-Path: <linux-kernel-owner+w=401wt.eu-S1032260AbXEHVtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032260AbXEHVtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968390AbXEHVtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:49:18 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58800 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968385AbXEHVtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:49:15 -0400
Date: Tue, 8 May 2007 16:49:14 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Andrew Morton <akpm@linux-foundation.org>, jeffschroeder@computer.org,
       Chris Wright <chrisw@sous-sol.org>,
       Karl MacMillan <kmacmillan@mentalrootkit.com>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>
Subject: Re: [PATCH 2/2] file capabilities: accomodate >32 bit capabilities
Message-ID: <20070508214914.GA27582@sergelap.austin.ibm.com>
References: <20070508191548.GA29913@sergelap.austin.ibm.com> <20070508191704.GC29913@sergelap.austin.ibm.com> <20070508205826.GH6375@schatzie.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508205826.GH6375@schatzie.adilger.int>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andreas Dilger (adilger@clusterfs.com):
> On May 08, 2007  14:17 -0500, Serge E. Hallyn wrote:
> > As the capability set changes and distributions start tagging
> > binaries with capabilities, we would like for running an older
> > kernel to not necessarily make those binaries unusable.
> > 
> > 	(0. Enable the CONFIG_SECURITY_FS_CAPABILITIES option
> > 	   when CONFIG_SECURITY=n.)
> > 	(1. Rename CONFIG_SECURITY_FS_CAPABILITIES to
> > 	   CONFIG_SECURITY_FILE_CAPABILITIES)
> > 	2. Introduce CONFIG_SECURITY_FILE_CAPABILITIES_STRICTXATTR
> > 	   which, when set, prevents loading binaries with capabilities
> > 	   set which the kernel doesn't know about.  When not set,
> > 	   such capabilities run, ignoring the unknown caps.
> > 	3. To accomodate 64-bit caps, specify that capabilities are
> > 	   stored as
> > 	   	u32 version; u32 eff0; u32 perm0; u32 inh0;
> > 		u32 eff1; u32 perm1; u32 inh1; (etc)
> 
> Have you considered how such capabilities will be used in the future?

There have been all sorts of suggestions, including very fine-grained
breakdowns of existing capabilities as well as capabilities for
non-privileged operations.

Other candidates for upcoming capabilities will be to satisfy
containers/vserver/openvz, where a distinction needs to be made between
CAP_DAC_OVERRIDE inside the user namespace, and the global
CAP_DAC_OVERRIDE.  Although the path i've been pursuing (for which I
should really send out the prelim patches I've been sitting on)
follow David Howell's and Eric Biederman's suggestions of using the
keyrings to store capabilities to other user namespaces.  Still new
capabilities may be desirable to guard CLONE_NEW_NS etc (rather than
CAP_SYS_ADMIN).

> One of the important use cases I can see today is the ability to
> split the heavily-overloaded e.g. CAP_SYS_ADMIN into much more fine
> grained attributes.

Sounds plausible, though it suffers from both making capabilities far
more cumbersome (i.e. finding the right capability for what you wanted
to do) and backward compatibility.  Perhaps at that point we should
introduce security.capabilityv2 xattrs.  A binary can then carry
security.capability=CAP_SYS_ADMIN=p, and
security.capabilityv2=cap_may_clone_mntns=p.

> What we definitely do NOT want to happen is an application that needs
> priviledged access (e.g. e2fsck, mount) to stop running because the
> new capabilities _would_ have been granted by the new kernel and are
> not by the old kernel and STRICTXATTR is used.
> 
> To me it would seem that having extra capabilities on an old kernel
> is relatively harmless if the old kernel doesn't know what they are.
> It's like having a key to a door that you don't know where it is.

If we ditch the STRICTXATTR option do the semantics seem sane to you?

thanks,
-serge
