Return-Path: <linux-kernel-owner+w=401wt.eu-S1758273AbXEORwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbXEORwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 13:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbXEORwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 13:52:09 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:47795 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbXEORwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 13:52:06 -0400
Date: Tue, 15 May 2007 19:52:03 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Jan Kara <jack@suse.cz>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.21] circular locking dependency found in QUOTA OFF
Message-ID: <20070515175203.GE18551@vanheusden.com>
References: <fa.UIDGHS72acFv9jKylmdQQwWcXPA@ifi.uio.no> <fa.fKNBJtZJWOQthlLjc1TDfY6jCLc@ifi.uio.no> <4646082D.2080502@shaw.ca> <m33b208z5f.fsf@maximus.localdomain> <46479E95.6050507@tmr.com> <20070513235341.GA4270@havoc.gtf.org> <46486DEC.1080506@tmr.com> <3262.62.177.207.163.1179152484.squirrel@klant.bhosted.nl> <6bffcb0e0705141043m6a5b7d22p11ec15723f3f8593@mail.gmail.com> <20070515140939.GB14987@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070515140939.GB14987@duck.suse.cz>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Wed May 16 19:10:49 CEST 2007
X-Message-Flag: MultiTail - tail on steroids
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm afraid it doesn't compile:

  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CHK     include/linux/compile.h
  CC      fs/dquot.o
  CC      fs/quota.o
fs/quota.c: In function `quota_sync_sb':
fs/quota.c:180: error: `I_MUTEX_NESTED' undeclared (first use in this function)
fs/quota.c:180: error: (Each undeclared identifier is reported only once
fs/quota.c:180: error: for each function it appears in.)
make[1]: *** [fs/quota.o] Error 1
make: *** [fs] Error 2


On Tue, May 15, 2007 at 04:09:39PM +0200, Jan Kara wrote:
>   Hi,
> 
>   Thanks for report. It seems like a lockdep problem. i_mutex for quota
> files is below dqonoff_sem. We were already fixing this for filesystem
> specific quota IO functions but obviously we've missed a few cases. I
> wonder why it showed up only now... Anyway, attached is a fix. Andrew,
> would you add it? Thanks.
> 
> 								Honza
> 
> On Mon 14-05-07 19:43:18, Michal Piotrowski wrote:
> > [adding Jan and fsdevel to CC]
> > 
> > Hi Folkert,
> > 
> > On 14/05/07, Folkert van Heusden <folkert@vanheusden.com> wrote:
> > >Hi,
> > >
> > >When I cleanly reboot my pc running 2.6.21 on a P4 with HT and 2GB of ram
> > >and system on an 1-filesystem IDE disk, I get the following circular
> > >locking dependency error:
> > >
> > >[330961.226405] =======================================================
> > >[330961.226489] [ INFO: possible circular locking dependency detected ]
> > >[330961.226531] 2.6.21 #5
> > >[330961.226569] -------------------------------------------------------
> > >[330961.226611] quotaoff/12249 is trying to acquire lock:
> > >[330961.226652]  (&sb->s_type->i_mutex_key#4){--..}, at: [<c120e2a1>]
> > >mutex_lock+0x8/0xa
> > >[330961.226861]
> > >[330961.226862] but task is already holding lock:
> > >[330961.226938]  (&s->s_dquot.dqonoff_mutex){--..}, at: [<c120e2a1>]
> > >mutex_lock+0x8/0xa
> > >[330961.227111]
> > >[330961.227111] which lock already depends on the new lock.
> > >[330961.227112]
> > >[330961.227225]
> > >[330961.227225] the existing dependency chain (in reverse order) is:
> > >[330961.227303]
> > >[330961.227303] -> #1 (&s->s_dquot.dqonoff_mutex){--..}:
> > >[330961.227473]        [<c1039b02>] check_prev_add+0x15b/0x281
> > >[330961.227766]        [<c1039cb3>] check_prevs_add+0x8b/0xe8
> > >[330961.228056]        [<c103b683>] __lock_acquire+0x692/0xb81
> > >[330961.228353]        [<c103bfda>] lock_acquire+0x62/0x81
> > >[330961.228643]        [<c120e322>] __mutex_lock_slowpath+0x75/0x28c
> > >[330961.228934]        [<c120e2a1>] mutex_lock+0x8/0xa
> > >[330961.229221]        [<c109fbbe>] vfs_quota_on_inode+0xc1/0x25f
> > >[330961.229513]        [<c109fdd1>] vfs_quota_on+0x75/0x79
> > >[330961.229803]        [<c10bc92d>] ext3_quota_on+0x95/0xb0
> > >[330961.230093]        [<c10a1eb2>] do_quotactl+0xc9/0x2dd
> > >[330961.230384]        [<c10a214a>] sys_quotactl+0x84/0xd6
> > >[330961.230673]        [<c1003f74>] syscall_call+0x7/0xb
> > >[330961.230963]        [<ffffffff>] 0xffffffff
> > >[330961.231268]
> > >[330961.231268] -> #0 (&sb->s_type->i_mutex_key#4){--..}:
> > >[330961.231469]        [<c10399db>] check_prev_add+0x34/0x281
> > >[330961.231759]        [<c1039cb3>] check_prevs_add+0x8b/0xe8
> > >[330961.232049]        [<c103b683>] __lock_acquire+0x692/0xb81
> > >[330961.232344]        [<c103bfda>] lock_acquire+0x62/0x81
> > >[330961.232632]        [<c120e322>] __mutex_lock_slowpath+0x75/0x28c
> > >[330961.232923]        [<c120e2a1>] mutex_lock+0x8/0xa
> > >[330961.233211]        [<c109fa6c>] vfs_quota_off+0x1cf/0x260
> > >[330961.233500]        [<c10a2088>] do_quotactl+0x29f/0x2dd
> > >[330961.233792]        [<c10a214a>] sys_quotactl+0x84/0xd6
> > >[330961.234081]        [<c1003f74>] syscall_call+0x7/0xb
> > >[330961.234503]        [<ffffffff>] 0xffffffff
> > >[330961.234795]
> > >[330961.234795] other info that might help us debug this:
> > >[330961.234796]
> > >[330961.234908] 2 locks held by quotaoff/12249:
> > >[330961.234947]  #0:  (&type->s_umount_key#15){----}, at: [<c1070b5d>]
> > >get_super+0x53/0x94
> > >[330961.235183]  #1:  (&s->s_dquot.dqonoff_mutex){--..}, at: [<c120e2a1>]
> > >mutex_lock+0x8/0xa
> > >[330961.235386]
> > >[330961.235387] stack backtrace:
> > >[330961.235462]  [<c1004d53>] show_trace_log_lvl+0x1a/0x30
> > >[330961.235535]  [<c1004d7b>] show_trace+0x12/0x14
> > >[330961.235606]  [<c1004e75>] dump_stack+0x16/0x18
> > >[330961.235679]  [<c1039352>] print_circular_bug_tail+0x6f/0x71
> > >[330961.235753]  [<c10399db>] check_prev_add+0x34/0x281
> > >[330961.235825]  [<c1039cb3>] check_prevs_add+0x8b/0xe8
> > >[330961.235897]  [<c103b683>] __lock_acquire+0x692/0xb81
> > >[330961.235969]  [<c103bfda>] lock_acquire+0x62/0x81
> > >[330961.236041]  [<c120e322>] __mutex_lock_slowpath+0x75/0x28c
> > >[330961.236113]  [<c120e2a1>] mutex_lock+0x8/0xa
> > >[330961.236185]  [<c109fa6c>] vfs_quota_off+0x1cf/0x260
> > >[330961.236257]  [<c10a2088>] do_quotactl+0x29f/0x2dd
> > >[330961.236330]  [<c10a214a>] sys_quotactl+0x84/0xd6
> > >[330961.236402]  [<c1003f74>] syscall_call+0x7/0xb
> > >[330961.236473]  =======================
> > >
> > 
> > Is this a 2.6.21 regression?
> > 
> > Regards,
> > Michal
> > 
> > -- 
> > Michal K. K. Piotrowski
> > Kernel Monkeys
> > (http://kernel.wikidot.com/start)
> -- 
> Jan Kara <jack@suse.cz>
> SuSE CR Labs

> i_mutex on quota files is special. Unlike i_mutexes for other inodes it is
> acquired under dqonoff_mutex. Tell lockdep about this lock ranking. Also
> comment and code in quota_sync_sb() seem to be bogus (as i_mutex for quota
> file can be acquired under dqonoff_mutex). Move truncate_inode_pages()
> call under dqonoff_mutex and save some problems with races...
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> 
> diff -rupX /home/jack/.kerndiffexclude linux-2.6.21/fs/dquot.c linux-2.6.21-1-quota_lockdep/fs/dquot.c
> --- linux-2.6.21/fs/dquot.c	2007-05-15 14:18:47.000000000 +0200
> +++ linux-2.6.21-1-quota_lockdep/fs/dquot.c	2007-05-15 14:22:47.000000000 +0200
> @@ -1421,7 +1421,7 @@ int vfs_quota_off(struct super_block *sb
>  			/* If quota was reenabled in the meantime, we have
>  			 * nothing to do */
>  			if (!sb_has_quota_enabled(sb, cnt)) {
> -				mutex_lock(&toputinode[cnt]->i_mutex);
> +				mutex_lock_nested(&toputinode[cnt]->i_mutex, I_MUTEX_QUOTA);
>  				toputinode[cnt]->i_flags &= ~(S_IMMUTABLE |
>  				  S_NOATIME | S_NOQUOTA);
>  				truncate_inode_pages(&toputinode[cnt]->i_data, 0);
> diff -rupX /home/jack/.kerndiffexclude linux-2.6.21/fs/quota.c linux-2.6.21-1-quota_lockdep/fs/quota.c
> --- linux-2.6.21/fs/quota.c	2006-11-29 22:57:37.000000000 +0100
> +++ linux-2.6.21-1-quota_lockdep/fs/quota.c	2007-05-15 15:15:44.000000000 +0200
> @@ -158,7 +158,6 @@ static int check_quotactl_valid(struct s
>  static void quota_sync_sb(struct super_block *sb, int type)
>  {
>  	int cnt;
> -	struct inode *discard[MAXQUOTAS];
>  
>  	sb->s_qcop->quota_sync(sb, type);
>  	/* This is not very clever (and fast) but currently I don't know about
> @@ -168,29 +167,21 @@ static void quota_sync_sb(struct super_b
>  		sb->s_op->sync_fs(sb, 1);
>  	sync_blockdev(sb->s_bdev);
>  
> -	/* Now when everything is written we can discard the pagecache so
> -	 * that userspace sees the changes. We need i_mutex and so we could
> -	 * not do it inside dqonoff_mutex. Moreover we need to be carefull
> -	 * about races with quotaoff() (that is the reason why we have own
> -	 * reference to inode). */
> +	/*
> +	 * Now when everything is written we can discard the pagecache so
> +	 * that userspace sees the changes.
> +	 */
>  	mutex_lock(&sb_dqopt(sb)->dqonoff_mutex);
>  	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
> -		discard[cnt] = NULL;
>  		if (type != -1 && cnt != type)
>  			continue;
>  		if (!sb_has_quota_enabled(sb, cnt))
>  			continue;
> -		discard[cnt] = igrab(sb_dqopt(sb)->files[cnt]);
> +		mutex_lock_nested(&sb_dqopt(sb)->files[cnt]->i_mutex, I_MUTEX_NESTED);
> +		truncate_inode_pages(&sb_dqopt(sb)->files[cnt]->i_data, 0);
> +		mutex_unlock(&sb_dqopt(sb)->files[cnt]->i_mutex);
>  	}
>  	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
> -	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
> -		if (discard[cnt]) {
> -			mutex_lock(&discard[cnt]->i_mutex);
> -			truncate_inode_pages(&discard[cnt]->i_data, 0);
> -			mutex_unlock(&discard[cnt]->i_mutex);
> -			iput(discard[cnt]);
> -		}
> -	}
>  }
>  
>  void sync_dquots(struct super_block *sb, int type)



Folkert van Heusden

-- 
www.vanheusden.com/multitail - win een vlaai van multivlaai! zorg
ervoor dat multitail opgenomen wordt in Fedora Core, AIX, Solaris of
HP/UX en win een vlaai naar keuze
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
