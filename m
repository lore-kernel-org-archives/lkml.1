Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbYH2RMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbYH2RMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 13:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbYH2RLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 13:11:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61894 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbYH2RLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 13:11:53 -0400
X-Greylist: delayed 790 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Aug 2008 13:11:53 EDT
Date: Fri, 29 Aug 2008 12:11:57 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Markku Savela <msa@moth.iki.fi>
Cc: Theodore Tso <tytso@mit.edu>, pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: Frustrated with capabilities..
Message-ID: <20080829171157.GB19672@hallyn.com>
References: <87hc96by8x.fsf@burp.tkv.asdf.org> <20080828141826.GA6797@ucw.cz> <200808281445.m7SEjYsB007502@burp.tkv.asdf.org> <20080828174854.GM26987@mit.edu> <200808291018.m7TAIcqJ030105@burp.tkv.asdf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808291018.m7TAIcqJ030105@burp.tkv.asdf.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Markku Savela (msa@moth.iki.fi):
> > From: Theodore Tso <tytso@mit.edu>
> 
> > The reason for that was to avoid bugs where a program that wasn't
> > expecting to be setuid (or just written by a stupid progammer) exec's
> > some program which wasn't expecting to have root privileges then bad
> > things happen.  The classic example of this was running the mail
> > program, which was setuid or setgid to the mail user/group, and then
> > typing "!/bin/sh" which would exec a shell running with those
> > privileges (because the mail program didn't know to drop its
> > privileges).
> 
> Considering the current case, without the file capabilites, I note
> 
> - if the caller of /bin/sh is ROOT, the capabities are inherited. Thus
>   my request has no relevance in that case.

You're misinterpreting the empirical evidence.

If the caller is root, then capabilities are not "inherited."  Rather,
if you are running in !issecure(SECURE_NOROOT) (which everyone is right
now), then we fake an all-powerful root by filling the file capability
sets at exec.  So it's not that the task's capabliities are inherited.
Rather, it's that as the capabilities are recalculated, we pretend that
the file had full capability sets.

That's very different, but leads to the same results in your example
above.

> - if the caller does first setuid to non-root, the capabilities are
>   cleared, unless KEEP_CAPS is explicitly set. Thus, my requested
>   change would not cause problems with your buggy mail program.
> 
> - if the caller goes through all the trouble of setting KEEP_CAPS and
>   changing to non-root, I would expect it to be sensible that the
>   caller also intends the execve code to inherit capabilities.
> 
> As an experiment and example, I made a small patch to Ubuntu 2.6.24
> kernel, to make it work like I think it should: if KEEP_CAPS is set,
> they are inherited (see at end).
> 
> I'm ok with the current kernel code, which seems to clear the
> KEEP_CAPS on execve. Thus, each executable must again re-enable it, if
> it needs capabilities inherited further...
> 
> 
> > So in the capabilities model, the capabilities do *not* inherit unless
> > the a particular file explicitly states that it should inherit the
> > capabilities.  It's the principle of least privilege taken to its
> > logical conclusion.
> 
> I'm looking at network oriented devices, where executables or
> interpreted content from network sources is executed by helper
> applications or directly as executables. Depending on the source of
> the "code", the helper application or the downloaded exectuable may be
> allowed to run with different permissions (capabilities, uid/gid
> etc). [For example, look at android security model with manifests of
> requested and declared permissions, but applied to everything
> downloaded or installed].
> 
> File capabilities (nor selinux) won't work, because the "helper
> applications" need to be executed with different capabilities and
> permissions, depending on the "manifests" of the downloaded
> "code". Obviously, serious permissions are granted only to properly
> verified "code" (signed).

Both capabilities and selinux will allow:

	1. the same binaries to be executed with different
	   privileges/permissions depending on the context of
	   the caller.

	2. different binaries to be executed by the same caller
	   resulting in different privileges/permissions.

(that answers your next question)

>   [Any ideas how selinux would help to enforce a permission which is
>   dynamically defined by installing application?]

-serge
