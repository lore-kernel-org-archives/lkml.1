Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbYH0QEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbYH0QEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbYH0QEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:04:42 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42466 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549AbYH0QEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:04:41 -0400
Date: Wed, 27 Aug 2008 11:04:39 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: "Andrew G. Morgan" <morgan@kernel.org>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: [patch] file capabilities: Add no_file_caps switch
Message-ID: <20080827160439.GA12085@us.ibm.com>
References: <200808262057.51606.agruen@suse.de> <20080827135206.GA12919@us.ibm.com> <200808271729.18220.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808271729.18220.agruen@suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andreas Gruenbacher (agruen@suse.de):
> On Wednesday, 27 August 2008 15:52:06 Serge E. Hallyn wrote:
> > Quoting Andreas Gruenbacher (agruen@suse.de):
> > > Hello,
> > >
> > > here is a patch allowing to disable file capabilities via a kernel
> > > command line option (once compiled in with
> > > CONFIG_SECURITY_FILE_CAPABILITIES).
> > >
> > > We would like to ship our next round of products with file capabilities
> > > compiled in, yet we feel that too many system utilities are still file
> > > capabilitiy unaware, and so we would like to turn them off by default
> > > initially. File capabilities can be used to grant privileges to binaries
> > > which otherwise look "harmless", which is a security risk until utilities
> > > like rpm have learned how to install and verify capabilities, etc.
> > >
> > > Any objections?
> >
> > Hi Andreas,
> >
> > No objections in general - if it makes you more comfortable shipping
> > kernels with CONFIG_SECURITY_FILE_CAPABILITIES=y then it's worthwhile.
> > However, can you elaborate on your concerns?
> 
> We don't have the time left for developing the few missing pieces and properly 
> integrating file capabilities into our products (use in various packages, 
> support in rpm, system management, manuals, release notes), and so I would 
> like to have a way to turn them off by default for now.
> 
> > In particular, if as you say above the concern is really just that a
> > file might have capabilities accidentally (or maliciously) enabled, then
> > we should be able to just check for file_caps_enabled() at
> > get_file_caps(), refusing to fill in the file capabilities.
> 
> My main concern is accidental granting of capabilities because of admin 
> unawareness / lack of tool support. This could be taken care of by not 
> loading the capabilities from disk.
> 
> > The other changes which you are canceling out confuscate the code but
> > actually make no difference.
> 
> Well, the other difference is that with CONFIG_SECURITY_FILE_CAPABILITIES=y 
> you currently lose the ability to pass on capabilities to other processes. Do 
> you have good arguments why this feature is unnecessary?

Yes, mainly that you don't actually have that ability anyway, because
when CONFIG_SECURITY_FILE_CAPABILITIES=n, then CAP_SETPCAP is not in the
system-wide capability bounding set, and without CAP_SETPCAP you cannot
pass capabilities to another process.

You can do it if you have a custom initrd that adds CAP_SETPCAP to the
bounding set early enough, but it has to be done by pid=1.  As far as I
have seen there are 0 users of the feature.  I would expect most people
would find it easier to recompile a tweaked kernel changing the #define
of CAP_INIT_BSET.

If, however, you really do have such users, then we must go with a
version of your patch.  We may then want to consider altogether
replacing the CONFIG_SECURITY_FILE_CAPABILITIES boolean with a default
value for file_caps_enabled.  That may actually end up cleaner than
the current code by removing all of the #ifdefs.  Does that sound ok
to you?  Andrew Morgan, would you be ok with that?

(Also note that if you have such users, you'll want to ask David
Howells not to push the patch he has floated removing the ability to
pass caps to another task altogether when CONFIG_SECURITY_FILE_CAPABILITIES=n :)

> I don' think that 
> having this feature was a good idea in the first place, but taking it away 
> now after several years may break current users which may not have gotten 
> converted, yet.

thanks,
-serge
