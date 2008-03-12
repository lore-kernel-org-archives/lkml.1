Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450AbYCLKum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbYCLKum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 06:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYCLKuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 06:50:32 -0400
Received: from styx.suse.cz ([82.119.242.94]:47504 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750972AbYCLKub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 06:50:31 -0400
Date: Wed, 12 Mar 2008 11:50:29 +0100
From: Jan Kara <jack@suse.cz>
To: Duane Griffin <duaneg@dghda.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       Theodore Tso <tytso@mit.edu>, sct@redhat.com, akpm@linux-foundation.org,
       adilger@clusterfs.com
Subject: Re: [RFC, PATCH 4/6] jbd: refactor nested journal log recovery
	loop into separate functions
Message-ID: <20080312105029.GA3090@duck.suse.cz>
References: <a047dfbd7855d5f484ae8a3434f6a073302505be.1204685366.git.duaneg@dghda.com> <8644b32ddec999bbc1da0ac55ad7b66d0b8176de.1204685366.git.duaneg@dghda.com> <20080311143550.GB6544@atrey.karlin.mff.cuni.cz> <20080312010205.GA14667@dastardly.plus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080312010205.GA14667@dastardly.plus.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 12-03-08 01:02:05, Duane Griffin wrote:
> On Tue, Mar 11, 2008 at 03:35:50PM +0100, Jan Kara wrote:
> >   Hmm, if I read your patch correctly, previously we aborted journal
> > replay when we found a block with unknown block magic but now we
> > continue replaying. Why have you done such change? And similarly when
> > some error happened when parsing revoke records block...
> 
> You are right, that was an error on my part. Thanks for your careful
> review. Please find below an incremental patch. I'll roll this into the
> main patch before posting the next version.
  Yup, looks fine.

									Honza
> 
> Cheers,
> Duane.
> 
> -- 
> "I never could learn to drink that blood and call it wine" - Bob Dylan
> 
> diff --git a/fs/jbd/recovery.c b/fs/jbd/recovery.c
> index 453c5fe..34db55a 100644
> --- a/fs/jbd/recovery.c
> +++ b/fs/jbd/recovery.c
> @@ -673,16 +673,22 @@ static int do_one_pass(journal_t *journal,
>  		case JFS_REVOKE_BLOCK:
>  			/* If we aren't in the REVOKE pass, then we can
>  			 * just skip over this block. */
> -			if (pass == PASS_REVOKE) {
> -				err = scan_revoke_records(
> -					journal, bh, next_commit_ID, info);
> +			if (pass != PASS_REVOKE)
> +				break;
> +
> +			err = scan_revoke_records(journal, bh,
> +						  next_commit_ID, info);
> +			if (err) {
> +				brelse(bh);
> +				goto failed;
>  			}
>  			break;
>  
>  		default:
>  			jbd_debug(3, "Unrecognised magic %d, end of scan.\n",
>  				  blocktype);
> -			break;
> +			brelse(bh);
> +			goto done;
>  		}
>  
>  		brelse(bh);
> @@ -695,6 +701,7 @@ static int do_one_pass(journal_t *journal,
>  			goto failed;
>  	}
>  
> +done:
>  	/*
>  	 * We broke out of the log scan loop: either we came to the
>  	 * known end of the log or we found an unexpected block in the
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
