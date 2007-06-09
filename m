Return-Path: <linux-kernel-owner+w=401wt.eu-S1760063AbXFINop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063AbXFINop (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 09:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757091AbXFINof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 09:44:35 -0400
Received: from mail.suse.de ([195.135.220.2]:47150 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756097AbXFINoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 09:44:34 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [AppArmor 38/45] AppArmor: Module and LSM hooks
Date: Sat, 9 Jun 2007 15:44:31 +0200
User-Agent: KMail/1.9.5
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070514110607.549397248@suse.de> <200706041630.49316.agruen@suse.de> <20070609125839.GH27793@elf.ucw.cz>
In-Reply-To: <20070609125839.GH27793@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706091544.31971.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 June 2007 14:58, Pavel Machek wrote:
> > > How will kernel work with very long paths? I'd suspect some problems,
> > > if path is 1MB long and I attempt to print it in /proc
> > > somewhere.
> > 
> > Pathnames are only used for informational purposes in the kernel, except 
> > in AppArmor of course. /proc only uses pathnames in a few places, 
> > but /proc/mounts will silently fail and produce garbage entries. That's 
> > not ideal of course; we should fix that somehow.
> 
> > Note that this has nothing to do with the AppArmor discussion ...
> 
> This has everything to do with AA discussion.

How pathnames are used in /proc has *nothing* to do with AppAmor.

> You took unreliable, for-user-info kernel subsystem, and made security
> subsystem depend on it. Oops.

Wrong. I said that the kernel uses pathnames for informational purposes only, 
not that they are unreliable. Don't turn words around in my mouth. The dcache 
has a *very* precise idea of pathnames, because this is what it is there for.

The pathnames that d_path computes exactly reflect what the dcache knows. 
(This requires the d_path fixes that are included in the AppArmor series and 
have also been posted independently, and the reasons why these fixes are 
needed are well explained in the mails.) The resulting pathnames are anything 
but unreliable.

> > > Perhaps vfs should be modified not to allow such crazy paths? But 
> > > placing limit in aa is ugly. 
> > 
> > Dream on. Redefining fundamental vfs semantics is not an option; we should 
> > rather make sure that we fail gracefully. Considering the
> 
> And instead of fixing "too long pathnames are problem in kernel" in any
> clean way, you "simply" included
> configurable-but-impossible-to-configure-right limit into
> apparmor. And now you want that merged. Dream on.

The choice here is between the following two things: either allow pathnames to 
grow to arbitrary lengths, or cap them at some point. The former has the 
benefit of working with all possible pathnames, and the drawback that users 
can consume arbitrary amounts of kernel memory by constructing arbitrarily 
long paths.

The latter has the benefit of limiting the amount of kernel memory consumed to 
some upper bound, and the drawback that access to exceptionally long paths 
(beyond the arbitrary limit) is denied. So in a sense, the limit in AppArmor 
does what you are asking for: it modifies things so that the kernel does not 
allow "such crazy paths". It does not introduce this as a vfs limit though, 
because the vfs has all right not to care.

Andreas
