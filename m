Return-Path: <linux-kernel-owner+w=401wt.eu-S1761564AbXK1Qjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761564AbXK1Qjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 11:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760966AbXK1Qj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 11:39:28 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:38466 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760043AbXK1Qj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 11:39:27 -0500
Subject: Re: git guidance
From: Dave Quigley <dpquigl@tycho.nsa.gov>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <474D8FD2.4010009@imap.cc>
References: <474C9B31.8000408@imap.cc>
	 <Pine.LNX.4.64.0711280019200.4181@fbirervta.pbzchgretzou.qr>
	 <1196262922.19921.20.camel@moss-terrapins.epoch.ncsc.mil>
	 <474D8FD2.4010009@imap.cc>
Content-Type: text/plain
Date: Wed, 28 Nov 2007 11:37:17 -0500
Message-Id: <1196267837.19921.41.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-11-28 at 16:57 +0100, Tilman Schmidt wrote:
> Dave Quigley schrieb:
> > There is a project listed on the kernel.org git page called guilt. I
> > find it very useful. It is much more responsive than stgit and it
> > actually has a git backend which quilt does not.
> > 
> > On Wed, 2007-11-28 at 00:20 +0100, Jan Engelhardt wrote:
> >> On Nov 27 2007 23:33, Tilman Schmidt wrote:
> >> >
> >> >Well, it did. So now I'm back to keeping a virgin kernel source tree
> >> >alongside my development area in order to produce diffs. That can't
> >> >be right?
> >> >
> >> No, it can't. Use stgit/quilt ;p
> 
> In which respect would stgit/quilt/guilt help me? At first glance
> they just seem to add another level of complexity.
> 
> Thanks,
> Tilman
> 

These tools allow you to maintain a set of patches with very little
effort. More importantly it removes a lot of the git specifics from your
development process. For example this is how I use guilt for a new patch
set.

I take my fresh tree and do a guilt-init in the base. This will create a
new patch series. I then need to create a patch to modify something LSM
related (guilt-new <patch_name>). Things like stgit/quilt/git use the
idea of a stack of patches. At this point if you were to type
guilt-series you would only see the one patch we just created. This
patch is going to be one logical set of changes (it should also produce
a compilable and working kernel). You can make whatever modifications
you need to make to your files and at this point you need to do one of
two things. If they were already in the tree you just type guilt-refresh
and under your .git/patches/<branch_name> directory you will see a file
named <patch_name> which contains your patch. Otherwise you need to do a
guilt-add <file_name> and then a guilt-refresh. The idea here is that
you have a moved your workflow from managing a series of commits and
then breaking out patches from a final version to one where you think in
terms of the patches and make modifications to them instead. In my
example I said I was doing something LSM related. Lets say the first
patch added a new hook and its implementation in the various modules. We
can now add a second patch using the guilt-new command and this one will
add uses of that new hook. At this point we have a stack that looks like
this.

<patch that adds users>
<patch that adds hook>

I can pop and push patches onto this stack to have a version of my
kernel tree at any state within the patch set. At this point lets say we
have posted the patch set and have feedback. I need to apply this
feedback to the patch that adds the LSM hook. Since my top patch
(guilt-top) is currently at the one that adds the users of the hook I
need to pop off that patch and get to the one that creates the hook
(guilt-pop). After doing this I'm at a kernel tree state which just has
the changes which add the hook. I make my modifications, type
guilt-refresh to create a new patch and then guilt-push my second patch
on and make sure everything is still working.

As you can see there is almost no git knowledge required to use this
system and it allows you to focus on development instead of the
versioning system. One useful feature is that when Linus adds new
patches and I want to rebase my set against the current tree It only
takes 3 commands to rebase the patch set (Assuming all goes well).

guilt-push -a #push all patches onto the stack
git-fetch #pull down the index
guilt-rebase FETCH_HEAD #Rebase our patches should do a merge and
#reapply all patches

These are just some basics about guilt. Jeff has written a better
tutorial with a sample repository for you to work with if your
interested. I don't know if this will help your development process but
I can tell you from experience breaking patches by hand was a pain in
the ass and a huge waste of time and I'm glad to have a tool like this
now.

