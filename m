Return-Path: <linux-kernel-owner+w=401wt.eu-S933966AbZD3RvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933966AbZD3RvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765989AbZD3RXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:23:05 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:42840 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765990AbZD3RXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:23:02 -0400
Date: Thu, 30 Apr 2009 10:20:14 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cluster-devel@redhat.com, swhiteho@redhat.com, peterz@infradead.org
Subject: Re: [PATCH 2/2] configfs: Rework configfs_depend_item() locking
	and make lockdep happy
Message-ID: <20090430172014.GA2762@mail.oracle.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	cluster-devel@redhat.com, swhiteho@redhat.com, peterz@infradead.org
References: <1233166713-9668-1-git-send-email-louis.rilling@kerlabs.com> <1233166713-9668-3-git-send-email-louis.rilling@kerlabs.com> <20090429185231.GE4743@mail.oracle.com> <20090430091828.GB13896@hawkmoon.kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430091828.GB13896@hawkmoon.kerlabs.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A01020A.49F9DE13.01DC:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 11:18:28AM +0200, Louis Rilling wrote:
> On 29/04/09 11:52 -0700, Joel Becker wrote:
> > On Wed, Jan 28, 2009 at 07:18:33PM +0100, Louis Rilling wrote:
> > > configfs_depend_item() recursively locks all inodes mutex from configfs root to
> > > the target item, which makes lockdep unhappy. The purpose of this recursive
> > > locking is to ensure that the item tree can be safely parsed and that the target
> > > item, if found, is not about to leave.
> > > 
> > > This patch reworks configfs_depend_item() locking using configfs_dirent_lock.
> > > Since configfs_dirent_lock protects all changes to the configfs_dirent tree, and
> > > protects tagging of items to be removed, this lock can be used instead of the
> > > inodes mutex lock chain.
> > > This needs that the check for dependents be done atomically with
> > > CONFIGFS_USET_DROPPING tagging.
> > 
> > 	These patches are now in the 'lockdep' branch of the configfs
> > tree.  I'm planning to send them in the next merge window.  I've made
> > one change.
> > 
> > > + * Note: items in the middle of attachment start with s_type = 0
> > > + * (configfs_new_dirent()), and configfs_make_dirent() (called from
> > > + * create_dir()) sets s_type = CONFIGFS_DIR|CONFIGFS_USET_CREATING. In both
> > > + * cases the item is ignored. Since s_type is an int, we rely on the CPU to
> > > + * atomically update the value, without making configfs_make_dirent() take
> > > + * configfs_dirent_lock.
> > 
> > 	I've added configfs_dirent_lock in configfs_make_dirent(),
> > because it is not safe at all to rely on the fact that s_type is an int.
> > It's an atomic set on one CPU, but there's no guarantee that it's seen
> > correctly on other CPUs.  Plus, there's no real need for speed here.  So
> > we properly take configfs_dirent_lock around s_type in
> > configfs_make_dirent(), and that ensures we see things correctly on SMP.
> 
> Agreed, I was going to suggest something like this. Actually I'd push the
> initialization of s_type down to configfs_new_dirent(), so that s_type either
> is always NULL, or always shows the correct type of object.

	0, not "NULL", but yeah I think that's a good plan.

Joel

-- 

"If at first you don't succeed, cover all traces that you tried."
                                                        -Unknown

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
