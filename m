Return-Path: <linux-kernel-owner+w=401wt.eu-S1757491AbYLaWTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbYLaWTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 17:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbYLaWTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 17:19:07 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:61638 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbYLaWTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 17:19:06 -0500
Date: Wed, 31 Dec 2008 14:17:24 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Mark Fasheh <mfasheh@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com, jack@suse.cz
Subject: Re: [PATCH 19/56] mm: Export pdflush_operation()
Message-ID: <20081231221723.GA14548@mail.oracle.com>
Mail-Followup-To: Mark Fasheh <mfasheh@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
	jack@suse.cz
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com> <1229982517-3455-20-git-send-email-mfasheh@suse.com> <20081222160104.6633cd77.akpm@linux-foundation.org> <20081225010544.GB17410@wotan.suse.de> <20081231192854.GK17410@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081231192854.GK17410@wotan.suse.de>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.495BEFC6.0152:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 11:28:54AM -0800, Mark Fasheh wrote:
> On Wed, Dec 24, 2008 at 05:05:44PM -0800, Mark Fasheh wrote:
> > On Mon, Dec 22, 2008 at 04:01:04PM -0800, Andrew Morton wrote:
> > > On Mon, 22 Dec 2008 13:48:00 -0800
> > > Mark Fasheh <mfasheh@suse.com> wrote:
> > > 
> > > > OCSF2 will need to queue up work for periodic syncing of quotas
> > > > among nodes in the cluster. pdflush() is good thread for this so
> > > > export it's controlling function so that OCFS2 can use it.
> > > 
> > > I trust that nothing will explode if pdflush_operation() fails
> > > to do anything and returns -1?
> > 
> > Hmm, Jan do you have any opinion here? I'm wondering if we just need our own
> > thread for this after all...
> > 	--Mark
> 
> Ok, looking at this closer, it seems like this could be a problem after all.
> Starving the quota syncing thread doesn't seem like a great idea either.

	Definitely don't like the pdflush method.  You guys are right
that it is buggy.
 
> The following patch changes things to use a workqueue. Really, this doesn't
> seem like a big deal anyway - the workqueue has reasonable overhead.

	I like the patch overall.  A couple comments.

> I could add this on top of my upstream branch along with a revert of the
> 'mm: Export pdflush_operation()' patch, or I could work this into the patch
> series so we never get the export patch in the 1st place.

	Regarding merge, I'd rather drop the export patch and merge this
with the patch that uses pdflush_operation().

> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> index a5f6e2a..07deec5 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -780,7 +780,7 @@ static int ocfs2_local_free_info(struct super_block *sb, int type)
>  	/* At this point we know there are no more dquots and thus
>  	 * even if there's some sync in the pdflush queue, it won't
>  	 * find any dquots and return without doing anything */
> -	del_timer_sync(&oinfo->dqi_sync_timer);
> +	cancel_delayed_work_sync(&oinfo->dqi_sync_work);
>  	iput(oinfo->dqi_gqinode);
>  	ocfs2_simple_drop_lockres(OCFS2_SB(sb), &oinfo->dqi_gqlock);
>  	ocfs2_lock_res_free(&oinfo->dqi_gqlock);

	Ok, I found what I was looking for.  The workqueue is not
flushed when unmounting a single volume, and I wanted to be sure that
was correct.  It is, as vfs_quota_disable() calls ->write_info() before
calling ->free_file_info() here.  So we can just cancel any delayed work
and forget about it safely.

> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index a79e67b..25ccf22 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1326,6 +1326,10 @@ static int __init ocfs2_init(void)
>  		mlog(ML_ERROR, "Unable to create ocfs2 debugfs root.\n");
>  	}
>  
> +	status = ocfs2_quota_setup();
> +	if (status)
> +		goto leave;
> +
>  	ocfs2_set_locking_protocol();
>  
>  	status = register_quota_format(&ocfs2_quota_format);

	Don't you need to shutdown the quota workqueue if
register_quota_format() fails?

Joel

-- 

Life's Little Instruction Book #80

	"Slow dance"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
