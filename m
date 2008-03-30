Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbYC3Tdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbYC3Tdm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 15:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbYC3Tdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 15:33:33 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:34427 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbYC3Tdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 15:33:31 -0400
Subject: Re: [patch 3/6] vfs: mountinfo stable peer group id
From: Ram Pai <linuxram@us.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Trond.Myklebust@netapp.com, dhowells@redhat.com
In-Reply-To: <20080322041131.GA10722@ZenIV.linux.org.uk>
References: <20080313212641.989467982@szeredi.hu>
	 <20080313212735.741834181@szeredi.hu>
	 <20080319114844.GK10722@ZenIV.linux.org.uk>
	 <E1Jc1Ln-0003jm-Bt@pomaz-ex.szeredi.hu>
	 <20080319182005.GP10722@ZenIV.linux.org.uk>
	 <E1Jc3Ad-0004Xu-58@pomaz-ex.szeredi.hu>
	 <20080320214319.GS10722@ZenIV.linux.org.uk>
	 <20080322034950.GY10722@ZenIV.linux.org.uk>
	 <20080322041131.GA10722@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Sun, 30 Mar 2008 12:33:41 -0700
Message-Id: <1206905621.3694.28.camel@ram.us.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-03-22 at 04:11 +0000, Al Viro wrote:
> On Sat, Mar 22, 2008 at 03:49:50AM +0000, Al Viro wrote:
> 
> >       Shifting increment from mnt_set_mountpoint() and commit_tree()
> > to theirs callers and collapsing where possible, we get the
> following:
> >       * decrement in release_mounts() when resetting ->mnt_parent
> >       * increment in propagate_mnt() after call of
> mnt_set_mountpoint()
> >       * decrement in attach_recursive_mnt() in the loop calling
> > commit_tree() for clones (on mountpoint of each clone).
> >       * increment in umount_tree() at the point where we update
> d_mounted.
> 
> ... except that it'd give a leak in case of mount to shared mountpoint
> failing halfway through - we'll get double increments since
> umount_tree()
> would hit the mountpoints of cloned trees with extra increment, even
> though 
> reference from root of cloned to its mountpoint is _already_ a ghost.

> OTOH, we probably don't want to bother with counting those anyway -
> i.e.
> it's simply a bad definition and the right one would be along the
> lines of
> "number of vfsmounts that are doomed to be eaten by release_mounts()
> and
> that have ->mnt_parent pointing to us".  IOW, dropping the 2nd and 3rd
> in the above would do the right thing - anything chewed by
> umount_tree()
> *will* go to release_mounts() and ones in flight are what we are
> interested
> in... 

By not accounting for the ghost reference created in propagate_mnt(),
i.e case 2 and 3; the race is still on with shrink_mounts. But I think,
you are right. We don't want the shrink_mounts and friends to think that
the mounts are available to be purged, by accounting them into
mnt_ghosts.

RP




