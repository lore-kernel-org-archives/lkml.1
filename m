Return-Path: <linux-kernel-owner+w=401wt.eu-S1754496AbYCVELs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbYCVELs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 00:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbYCVELh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 00:11:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41793 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbYCVELg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 00:11:36 -0400
Date: Sat, 22 Mar 2008 04:11:32 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Trond.Myklebust@netapp.com, dhowells@redhat.com
Subject: Re: [patch 3/6] vfs: mountinfo stable peer group id
Message-ID: <20080322041131.GA10722@ZenIV.linux.org.uk>
References: <20080313212641.989467982@szeredi.hu> <20080313212735.741834181@szeredi.hu> <20080319114844.GK10722@ZenIV.linux.org.uk> <E1Jc1Ln-0003jm-Bt@pomaz-ex.szeredi.hu> <20080319182005.GP10722@ZenIV.linux.org.uk> <E1Jc3Ad-0004Xu-58@pomaz-ex.szeredi.hu> <20080320214319.GS10722@ZenIV.linux.org.uk> <20080322034950.GY10722@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080322034950.GY10722@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2008 at 03:49:50AM +0000, Al Viro wrote:

> 	Shifting increment from mnt_set_mountpoint() and commit_tree()
> to theirs callers and collapsing where possible, we get the following:
> 	* decrement in release_mounts() when resetting ->mnt_parent
> 	* increment in propagate_mnt() after call of mnt_set_mountpoint()
> 	* decrement in attach_recursive_mnt() in the loop calling
> commit_tree() for clones (on mountpoint of each clone).
> 	* increment in umount_tree() at the point where we update d_mounted.

... except that it'd give a leak in case of mount to shared mountpoint
failing halfway through - we'll get double increments since umount_tree()
would hit the mountpoints of cloned trees with extra increment, even though 
reference from root of cloned to its mountpoint is _already_ a ghost.

OTOH, we probably don't want to bother with counting those anyway - i.e.
it's simply a bad definition and the right one would be along the lines of
"number of vfsmounts that are doomed to be eaten by release_mounts() and
that have ->mnt_parent pointing to us".  IOW, dropping the 2nd and 3rd
in the above would do the right thing - anything chewed by umount_tree()
*will* go to release_mounts() and ones in flight are what we are interested
in...
