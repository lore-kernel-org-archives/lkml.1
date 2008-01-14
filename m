Return-Path: <linux-kernel-owner+w=401wt.eu-S1754071AbYANEtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbYANEtT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 23:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbYANEtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 23:49:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:42322 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbYANEtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 23:49:07 -0500
From: Neil Brown <neilb@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Date: Mon, 14 Jan 2008 15:48:56 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18314.59832.14451.334084@notabene.brown>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 002 of 6] md: Fix use-after-free bug when dropping an rdev from an md array.
In-Reply-To: message from Al Viro on Monday January 14
References: <20080114123726.19968.patches@notabene>
	<1080114014531.20354@suse.de>
	<20080114020459.GN27894@ZenIV.linux.org.uk>
	<18314.54601.196877.828373@notabene.brown>
	<20080114034322.GO27894@ZenIV.linux.org.uk>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday January 14, viro@ZenIV.linux.org.uk wrote:
> On Mon, Jan 14, 2008 at 02:21:45PM +1100, Neil Brown wrote:
> 
> > Maybe it isn't there any more....
> > 
> > Once upon a time, when I 
> >    echo remove > /sys/block/mdX/md/dev-YYY/state
> 
> Egads.  And just what will protect you from parallel callers
> of state_store()?  buffer->mutex does *not* do that - it only
> gives you exclusion on given struct file.  Run the command
> above from several shells and you've got independent open
> from each redirect => different struct file *and* different
> buffer for each => no exclusion whatsoever.

well in -mm, rdev_attr_store gets a lock on
rdev->mddev->reconfig_mutex. 
It doesn't test is rdev->mddev is NULL though, so if the write happens
after unbind_rdev_from_array, we lose.
A test for NULL would be easy enough.  And I think that the mddev
won't actually disappear until the rdevs are all gone (you subsequent
comment about kobject_del ordering seems to confirm that) so a simple test
for NULL should be sufficient.

> 
> And _that_ is present right in the mainline tree - it's unrelated
> to -mm kobject changes.
> 
> BTW, yes, you do have a deadlock there - kobject_del() will try to evict
> children, which will include waiting for currently running ->store()
> to finish, which will include the caller since .../state *is* a child of
> that sucker.
> 
> The real problem is the lack of any kind of exclusion considerations in
> md.c itself, AFAICS.  Fun with ordering is secondary (BTW, yes, it is
> a problem - will sysfs ->store() to attribute between export_rdev() and
> kobject_del() work correctly?)

Probably not.  The possibility that rdev->mddev could be NULL would
break a lot of these.  Maybe I should delay setting rdev->mddev to
NULL until after the kobject_del.  Then audit them all.

Thanks.  I'll see what I can some up with.

NeilBrown
