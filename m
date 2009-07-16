Return-Path: <linux-kernel-owner+w=401wt.eu-S933446AbZGPWHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933446AbZGPWHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 18:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933391AbZGPWHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 18:07:36 -0400
Received: from cobra.newdream.net ([66.33.216.30]:33095 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933141AbZGPWHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 18:07:35 -0400
Date: Thu, 16 Jul 2009 15:07:35 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/20] ceph: nfs re-export support
In-Reply-To: <1247779311.12292.162.camel@heimdal.trondhjem.org>
Message-ID: <Pine.LNX.4.64.0907161459360.8026@cobra.newdream.net>
References: <1247693090-27796-8-git-send-email-sage@newdream.net>
 <1247693090-27796-9-git-send-email-sage@newdream.net>
 <1247693090-27796-10-git-send-email-sage@newdream.net>
 <1247693090-27796-11-git-send-email-sage@newdream.net>
 <1247693090-27796-12-git-send-email-sage@newdream.net>
 <1247693090-27796-13-git-send-email-sage@newdream.net>
 <1247693090-27796-14-git-send-email-sage@newdream.net>
 <1247693090-27796-15-git-send-email-sage@newdream.net>
 <1247693090-27796-16-git-send-email-sage@newdream.net>
 <1247693090-27796-17-git-send-email-sage@newdream.net> <20090716192755.GE2495@fieldses.org>
 <Pine.LNX.4.64.0907161241300.8026@cobra.newdream.net>
 <1247779311.12292.162.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009, Trond Myklebust wrote:
> On Thu, 2009-07-16 at 12:50 -0700, Sage Weil wrote:
> > On Thu, 16 Jul 2009, J. Bruce Fields wrote:
> > > On Wed, Jul 15, 2009 at 02:24:46PM -0700, Sage Weil wrote:
> > > > Basic NFS re-export support is included.  This mostly works.  However,
> > > > Ceph's MDS design precludes the ability to generate a (small)
> > > > filehandle that will be valid forever, so this is of limited utility.
> > > 
> > > Is there any hope of fixing that?
> > 
> > Yes, but it requires some additional ondisk metadata the MDS isn't 
> > maintaining yet (a parent directory backpointer on file objects).  
> > 
> > The MDS changes will mean more random IO for rename intensive workloads, 
> > but the backpointers would also be useful for rebuilding the directory 
> > tree in the event of some catastrophic metadata loss or corruption.  
> > (Currently they're only there for directories, not all files.)
> 
> Note that a filehandle that contains parent directory information is
> still not one that is valid forever. It will change in the case of a
> cross-directory rename, and so isn't a filehandle in the NFSv2/v3 sense.
> Even in the NFSv4 case, it would have to be labelled as 'volatile'.

Right.  The parent directory information in the fh it used as a hint, but 
can't be relied on because of the rename problem.  That's exactly why the 
Ceph MDS will need to be changed to maintain backpointers on all files, 
not just directories.  When that happens, reexporting via NFS will work 
reliably.  Until then, old and idle filehandles for renamed files will 
eventually go stale.

sage
