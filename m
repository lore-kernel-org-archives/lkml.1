Return-Path: <linux-kernel-owner+w=401wt.eu-S1753914AbYK1Iho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbYK1Iho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 03:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbYK1Ihf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 03:37:35 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44799 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752404AbYK1Ihf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 03:37:35 -0500
X-Sasl-enc: xkyq7ip1TsNNkJy4i3Hpc+TpNxFi/zFOGY2q6bLEtsxP 1227861453
Date: Fri, 28 Nov 2008 17:37:27 +0900 (WST)
From: Ian Kent <raven@themaw.net>
To: Jan Blunck <jblunck@suse.de>
cc: Daniel Lezcano <dlezcano@fr.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bharata@linux.vnet.ibm.com
Subject: Re: union mount status
In-Reply-To: <alpine.LFD.2.00.0811211627400.5827@zeus.themaw.net>
Message-ID: <alpine.LFD.2.00.0811281728210.13916@zeus.themaw.net>
References: <48F51B6C.2080000@fr.ibm.com> <20081015191144.GJ29067@bolzano.suse.de> <alpine.LFD.2.00.0811211627400.5827@zeus.themaw.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008, Ian Kent wrote:

> On Wed, 15 Oct 2008, Jan Blunck wrote:
> 
> > On Wed, Oct 15, Daniel Lezcano wrote:
> > 
> > > Hi all,
> > > 
> > > What is the status of this patchset ?
> > > Bharata Rao told me, no consensus was reached yet.
> > > After looking at Jan Blunk's ftp server, it looks like the latest 
> > > patchset was for 2.6.25-mm1. Is anyone working on this patchset right now ?
> > 
> > Not that I know of.
> > 
> > The state is as follows: we (David Woodhouse, Bharata Rao, Erez Zadok and me)
> > agreed on a more or less final version of the whiteout patches. I haven't
> > posted them yet since I know that Al Viro isn't convinced of the idea that
> > they are actaully necessary. My plan was to solve the readdir() issues first,
> > because they are the biggest roadblock IMHO. Bharata worked on some glibc
> > readdir stuff but I don't know how that went.
> 
> I'm trying to work through applying your patches to a current kernel so I 
> can have a decent look through them.

OK, I've applied your patch series from 2.6.23-mm1-2007-11-16 to the
linux-2.6 tree. I expect there are some mistakes due to the struct path 
changes that have gone on since these were done.

Are you willing to have a look through them to check they are as 
you expect.

I had a problem with union-mount-access.diff as you can see below, any 
suggestions about how to get around this?:

Subject: union-mount: don't report EROFS for union mounts

From: Ian Kent <raven@themaw.net>
** Mmmm .. I'll need to change these, but what to !! **

SuS v2 requires we report a read only fs too. For union-mounts this is a very
expensive check. So I'm lazy and just disable the check if we are on a lower
layer of an union.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---

 fs/open.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/fs/open.c b/fs/open.c
index 715266d..6f357e3 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -488,6 +488,9 @@ asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
 	 * inherently racy and know that the fs may change
 	 * state before we even see this result.
 	 */
+	/* OOPS: no struct nameidata anymore
+	 if (!(nd.um_flags & LAST_LOWLEVEL) && __mnt_is_readonly(nd.path.mnt))
+	 */
 	if (__mnt_is_readonly(path.mnt))
 		res = -EROFS;
 

