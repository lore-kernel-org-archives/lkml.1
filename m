Return-Path: <linux-kernel-owner+w=401wt.eu-S1751955AbZLIFvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbZLIFvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 00:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbZLIFvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 00:51:35 -0500
Received: from RELAY.ANDREW.CMU.EDU ([128.2.10.212]:49679 "EHLO
	relay.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbZLIFvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 00:51:35 -0500
Date: Wed, 9 Dec 2009 00:50:16 -0500
From: Ben Blum <bblum@andrew.cmu.edu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, menage@google.com, bblum@andrew.cmu.edu
Subject: Re: [RFC] [PATCH 1/5] cgroups: revamp subsys array
Message-ID: <20091209055016.GA12342@andrew.cmu.edu>
Mail-Followup-To: Li Zefan <lizf@cn.fujitsu.com>,
	linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
	akpm@linux-foundation.org, menage@google.com
References: <20091204085349.GA18867@andrew.cmu.edu> <20091204085508.GA18912@andrew.cmu.edu> <4B1E0283.70108@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1E0283.70108@cn.fujitsu.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 03:38:43PM +0800, Li Zefan wrote:
> > @@ -1291,6 +1324,7 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
> >  	struct cgroupfs_root *new_root;
> >  
> >  	/* First find the desired set of subsystems */
> > +	down_read(&subsys_mutex);
> 
> Hmm.. this can lead to deadlock. sget() returns success with sb->s_umount
> held, so here we have:
> 
> 	down_read(&subsys_mutex);
> 
> 	down_write(&sb->s_umount);
> 
> On the other hand, sb->s_umount is held before calling kill_sb(),
> so when umounting we have:
> 
> 	down_write(&sb->s_umount);
> 
> 	down_read(&subsys_mutex);

Unless I'm gravely mistaken, you can't have deadlock on an rwsem when
it's being taken for reading in both cases? You would have to have at
least one of the cases being down_write.

In fairness to readability, perhaps subsys_mutex should instead be
subsys_rwsem? It seemed to me to be that calling it "mutex" was
conventional anyway.

-- bblum
