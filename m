Return-Path: <linux-kernel-owner+w=401wt.eu-S1758802AbYH0Q6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802AbYH0Q6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbYH0Q5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:57:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34673 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223AbYH0Q5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:57:54 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs / Novell
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [patch] file capabilities: Add no_file_caps switch
Date: Wed, 27 Aug 2008 18:57:48 +0200
User-Agent: KMail/1.9.9
Cc: "Andrew G. Morgan" <morgan@kernel.org>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
References: <200808262057.51606.agruen@suse.de> <200808271729.18220.agruen@suse.de> <20080827160439.GA12085@us.ibm.com>
In-Reply-To: <20080827160439.GA12085@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808271857.48651.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 27 August 2008 18:04:39 Serge E. Hallyn wrote:
> Quoting Andreas Gruenbacher (agruen@suse.de):
> > On Wednesday, 27 August 2008 15:52:06 Serge E. Hallyn wrote:
> > > Quoting Andreas Gruenbacher (agruen@suse.de):
> > > > Hello,
> > > >
> > > > here is a patch allowing to disable file capabilities via a kernel
> > > > command line option (once compiled in with
> > > > CONFIG_SECURITY_FILE_CAPABILITIES).
> > > >
> > > > We would like to ship our next round of products with file
> > > > capabilities compiled in, yet we feel that too many system utilities
> > > > are still file capabilitiy unaware, and so we would like to turn them
> > > > off by default initially. File capabilities can be used to grant
> > > > privileges to binaries which otherwise look "harmless", which is a
> > > > security risk until utilities like rpm have learned how to install
> > > > and verify capabilities, etc.
> > > >
> > > > Any objections?
> > >
> > > Hi Andreas,
> > >
> > > No objections in general - if it makes you more comfortable shipping
> > > kernels with CONFIG_SECURITY_FILE_CAPABILITIES=y then it's worthwhile.
> > > However, can you elaborate on your concerns?
> >
> > We don't have the time left for developing the few missing pieces and
> > properly integrating file capabilities into our products (use in various
> > packages, support in rpm, system management, manuals, release notes), and
> > so I would like to have a way to turn them off by default for now.
> >
> > > In particular, if as you say above the concern is really just that a
> > > file might have capabilities accidentally (or maliciously) enabled,
> > > then we should be able to just check for file_caps_enabled() at
> > > get_file_caps(), refusing to fill in the file capabilities.
> >
> > My main concern is accidental granting of capabilities because of admin
> > unawareness / lack of tool support. This could be taken care of by not
> > loading the capabilities from disk.
> >
> > > The other changes which you are canceling out confuscate the code but
> > > actually make no difference.
> >
> > Well, the other difference is that with
> > CONFIG_SECURITY_FILE_CAPABILITIES=y you currently lose the ability to
> > pass on capabilities to other processes. Do you have good arguments why
> > this feature is unnecessary?
>
> Yes, mainly that you don't actually have that ability anyway, because
> when CONFIG_SECURITY_FILE_CAPABILITIES=n, then CAP_SETPCAP is not in the
> system-wide capability bounding set, and without CAP_SETPCAP you cannot
> pass capabilities to another process.
>
> You can do it if you have a custom initrd that adds CAP_SETPCAP to the
> bounding set early enough, but it has to be done by pid=1.  As far as I
> have seen there are 0 users of the feature.

Alright, this should suffice and we won't have to care about this case then.

What remains is a way to disable the loading of capabilities from the kernel 
command line, but this is a rather trivial patch. Would you like to write 
that? Shall i send a patch?

> If, however, you really do have such users, then we must go with a
> version of your patch.  We may then want to consider altogether
> replacing the CONFIG_SECURITY_FILE_CAPABILITIES boolean with a default
> value for file_caps_enabled.  That may actually end up cleaner than
> the current code by removing all of the #ifdefs.

Most ifdefs would go away by adding a file_caps_enabled variable / #define in 
capability.h and using that. I would suggest to make this on-by-default as 
the common case will eventually be on, and that way, we won't have to carry 
the kernel command-line option code forever.

> (Also note that if you have such users, you'll want to ask David
> Howells not to push the patch he has floated removing the ability to
> pass caps to another task altogether when
> CONFIG_SECURITY_FILE_CAPABILITIES=n :)

I was actually about to ask for making this behavior change pertinent instead 
of having it depend on CONFIG_SECURITY_FILE_CAPABILITIES :)

Thanks,
Andreas
