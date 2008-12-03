Return-Path: <linux-kernel-owner+w=401wt.eu-S1762766AbYLCUhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762766AbYLCUhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756177AbYLCUVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 15:21:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56091 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758440AbYLCUVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 15:21:49 -0500
Date: Wed, 3 Dec 2008 12:20:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: adobriyan@gmail.com, mingo@elte.hu, viro@ZenIV.linux.org.uk,
       vegard.nossum@gmail.com, ebiederm@xmission.com, Yoshiya.Koyama@hp.com,
       rjw@sisk.pl, penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org,
       kay.sievers@vrfy.org, linux-fsdevel@vger.kernel.org
Subject: Re: v2.6.28-rc1: readlink /proc/*/exe returns uninitialized data to
 userspace
Message-Id: <20081203122048.b46f9fda.akpm@linux-foundation.org>
In-Reply-To: <20081203171854.GC17014@kroah.com>
References: <19f34abd0810251014s7968557br38e43aa0b9cdcf09@mail.gmail.com>
	<200810252241.53601.rjw@sisk.pl>
	<m163nggvhq.fsf@frodo.ebiederm.org>
	<19f34abd0810261408w61b1e2dbvb9a0e16ce5a10022@mail.gmail.com>
	<19f34abd0811040139t8334502i7a5d8501c5fe95ac@mail.gmail.com>
	<20081104151234.GH28946@ZenIV.linux.org.uk>
	<20081106100410.GN4890@elte.hu>
	<20081107190544.GA1551@kroah.com>
	<20081107231205.GA2528@x200.localdomain>
	<20081111141412.b52469d2.akpm@linux-foundation.org>
	<20081203171854.GC17014@kroah.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2008 09:18:54 -0800
Greg KH <greg@kroah.com> wrote:

> On Tue, Nov 11, 2008 at 02:14:12PM -0800, Andrew Morton wrote:
> > On Sat, 8 Nov 2008 02:12:05 +0300
> > Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > 
> > > On Fri, Nov 07, 2008 at 11:05:44AM -0800, Greg KH wrote:
> > > > On Thu, Nov 06, 2008 at 11:04:10AM +0100, Ingo Molnar wrote:
> > > > > 
> > > > > * Al Viro <viro@ZenIV.linux.org.uk> wrote:
> > > > > 
> > > > > > On Tue, Nov 04, 2008 at 10:39:19AM +0100, Vegard Nossum wrote:
> > > > > > > On Sun, Oct 26, 2008 at 10:08 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > > > > > > # uname -a
> > > > > > > Linux localhost.localdomain 2.6.25.11-97.fc9.i686 #1 SMP Mon Jul 21
> > > > > > > 01:31:09 EDT 2008 i686 i686 i386 GNU/Linux
> > > > > > > # prelink -mRf /sbin/udevd
> > > > > > > # ./a.out /proc/564/exe
> > > > > > > warning: /proc/564/exe: got return value 38, expected 11
> > > > > > > 2f7362696e2f7564657664005f47387942426e5952446e566f306868202864656c6574656429
> > > > > > > /sbin/udevd _G8yBBnYRDnVo0hh (deleted)
> > > > > > > 
> > > > > > > Yoshiya Koyama reports that the problem exists on RHEL 2.6.9-42.ELsmp too.
> > > > > > > 
> > > > > > > I don't think it's exactly the same problem as originally reported,
> > > > > > > because I definitely wasn't using prelinking (the prelink binary
> > > > > > > wasn't even installed on the machine until today). But finding the
> > > > > > > root cause of this may solve both problems.
> > > > > > 
> > > > > > switch_names() buggered in case of short names on both sides.  That should
> > > > > > help:
> > > > > > 
> > > > > > >From 2acda856910b774717e0290bbf948c7dee0f2e1a Mon Sep 17 00:00:00 2001
> > > > > > From: Al Viro <viro@zeniv.linux.org.uk>
> > > > > > Date: Mon, 3 Nov 2008 15:03:50 -0500
> > > > > > Subject: [PATCH] fix switch_names() breakage in short-to-short case
> > > > > > 
> > > > > > We want ->name.len to match the resulting name on *both*
> > > > > > source and target
> > > > > > 
> > > > > > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > > > > 
> > > > > please credit kmemcheck in the commit message and use an appropriate 
> > > > > Reported-by line as well. Thanks,
> > > > 
> > > > Did this fix ever get merged into Linus's tree?
> > > 
> > > So far no.
> > 
> > I queued the below for 2.6.28 inclusion and tagged for -stable
> > backporting.  
> 
> 
> What ever happened to this patch?  Did it not make it into Linus's tree
> somehow?
> 

Stuck in -mm.  Sent to Al on Dec 1, ignored.  As usual.

Al, what's going on?  Are you thinking that I'm planning on merging
these myself?  Because if you're on the To: then my intention is that the
patch be processed by yourself.


