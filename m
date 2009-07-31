Return-Path: <linux-kernel-owner+w=401wt.eu-S1751338AbZGaFMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338AbZGaFMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 01:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbZGaFMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 01:12:48 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:34662 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbZGaFMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 01:12:47 -0400
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Jul 2009 01:12:47 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ctS7iUdwUEy7hefVc1XWdcH/KoaP1VHByfuewpGWDIqrzwTGSc/Qdb3BlgtOBWUj5l
         5/LqSAI0aGVGVkysC7kQKoKoVjRKzKECg6/Vu64VTM/Hnkv0761MBXurUHOFYYlTufdY
         1iB67buCgujRFOYfresew87STbbA3NzWMPDng=
Date: Fri, 31 Jul 2009 07:05:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: linux-next: manual merge of the reiserfs-bkl tree with Linus'
	tree
Message-ID: <20090731050505.GA6115@nowhere>
References: <20090713115114.a871ea68.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090713115114.a871ea68.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 11:51:14AM +1000, Stephen Rothwell wrote:
> Hi Frédéric,
> 
> Today's linux-next merge of the reiserfs-bkl tree got a conflict in
> fs/reiserfs/journal.c between commit
> 8aa7e847d834ed937a9ad37a0f2ad5b8584c1ab0 ("Fix congestion_wait()
> sync/async vs read/write confusion") from Linus' tree and commit
> e533d8da923c77ed58940309c401584bffda75e0 ("reiserfs: kill-the-BKL") from
> the reiserfs-bkl tree.
> 
> Just context changes.  I fixed it up as best I could (see below) and can
> carry the fix for a while.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc fs/reiserfs/journal.c
> index 9062220,86c1ff4..0000000
> --- a/fs/reiserfs/journal.c
> +++ b/fs/reiserfs/journal.c
> @@@ -996,8 -984,13 +984,13 @@@ static int reiserfs_async_progress_wait
>   {
>   	DEFINE_WAIT(wait);
>   	struct reiserfs_journal *j = SB_JOURNAL(s);
> - 	if (atomic_read(&j->j_async_throttle))
> + 
> + 	if (atomic_read(&j->j_async_throttle)) {
> + 		reiserfs_write_unlock(s);
>  -		congestion_wait(WRITE, HZ / 10);
>  +		congestion_wait(BLK_RW_ASYNC, HZ / 10);
> + 		reiserfs_write_lock(s);
> + 	}
> + 
>   	return 0;
>   }
>   


Sorry to answer that late. That's the right fix, thanks Stephen!

I've pushed the latest update/rebase of the reiserfs/kill-bkl tree
there:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git \
reiserfs/kill-bkl

I've changed the branch name because the previous one had a fixed rc version
inside. This new branch will keep beeing the most up to date.
Could you please drop the old branch and integrate this new one?

Thanks a lot,
Frederic.


