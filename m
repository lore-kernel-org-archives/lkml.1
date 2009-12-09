Return-Path: <linux-kernel-owner+w=401wt.eu-S1751881AbZLIIhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbZLIIhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 03:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbZLIIhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 03:37:13 -0500
Received: from RELAY.ANDREW.CMU.EDU ([128.2.10.212]:53528 "EHLO
	relay.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbZLIIhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 03:37:12 -0500
Date: Wed, 9 Dec 2009 03:36:56 -0500
From: Ben Blum <bblum@andrew.cmu.edu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, menage@google.com, bblum@andrew.cmu.edu
Subject: Re: [RFC] [PATCH 1/5] cgroups: revamp subsys array
Message-ID: <20091209083656.GB14114@andrew.cmu.edu>
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
> 
> >  	ret = parse_cgroupfs_options(data, &opts);
> >  	if (ret)
> >  		goto out_err;
> > @@ -1367,6 +1401,8 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
> >  			free_cg_links(&tmp_cg_links);
> >  			goto drop_new_super;
> >  		}
> > +		/* done with subsys stuff and no other failure case */
> > +		up_read(&subsys_mutex);
> >  
> >  		/* EBUSY should be the only error here */
> >  		BUG_ON(ret);
> > @@ -1415,6 +1451,7 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
> >   drop_new_super:
> >  	deactivate_locked_super(sb);
> >   out_err:
> > +	up_read(&subsys_mutex);
> >  	kfree(opts.release_agent);
> >  	kfree(opts.name);

There's another problem here. deactivate_locked_super() calls kill_sb(),
which tries to down_read(&subsys_mutex), and rwsems can't recurse. This
can be fixed by just moving the up_read(&subsys_mutex); at the end to
before each 'goto' in each error case, though, so not a big deal.

-- bblum
