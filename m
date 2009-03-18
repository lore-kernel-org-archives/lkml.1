Return-Path: <linux-kernel-owner+w=401wt.eu-S1757840AbZCRMI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840AbZCRMI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 08:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757664AbZCRMIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 08:08:09 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:26043 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757778AbZCRMIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 08:08:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GxQL5tqSX+ByZgJzDyfNi3VXHzy5hOt5RE7R8iRbVieMUV2evQiORzorr2i2udRV2SXLEcgo4I/YnGPSS6O1X2rHz5MtC7Q211WlZFjDLyemTAYX3cCLMO9vc3XLJtNhdTVuGl1TOP+DxOieZ+ITAq0BfsE6SjYAZ2birJWshxI=  ;
X-YMail-OSG: 4d8FR4AVM1krPISq0ZR8MMB_GndmCiv48VIAsv5h6os_wdCcngqGqf3nexIZPgdxO9khHqOqT40U6DhgZfKGM657Luw24umPR3UJE1aJzCjg7JUT6EnyHKz4HiAl0tzw_.98Qhfoy2bCquaqRUvgTjlctuaSZ8e2AgHdiBAXxfBMgztoaxScIzbUCI2pkyjbuAplNLpS__hg_FcWQlNNpxd.qnQ-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/4] fs: Warn about writing !uptodate buffers
Date: Wed, 18 Mar 2009 23:07:54 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
References: <n> <1237311235-13623-4-git-send-email-jack@suse.cz> <1237311235-13623-5-git-send-email-jack@suse.cz>
In-Reply-To: <1237311235-13623-5-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903182307.54737.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 March 2009 04:33:55 Jan Kara wrote:
> Make submit_bh() warn about writing !uptodate buffers. Hopefully this
> warns us about writing garbage (although bugs in write EIO handling
> are going to trigger this as well as they already trigger the warning
> in mark_buffer_dirty()).
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/buffer.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 22c0144..985f617 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2997,6 +2997,8 @@ int submit_bh(int rw, struct buffer_head * bh)
>  	BUG_ON(!buffer_locked(bh));
>  	BUG_ON(!buffer_mapped(bh));
>  	BUG_ON(!bh->b_end_io);
> +	if (rw & WRITE)
> +		WARN_ON_ONCE(!buffer_uptodate(bh));

Yes very nice assertion to have. Arguably I think it should be a BUG_ON
because it is definitely some state corruption at least, and writing
garbage data to disk at worst. But WARN_ON for now is probably best.

I have some patches to fix up some problems with EIO handling in the
VM (and I think solves the the buffer warning too). I have to get them
out and try to get them merged again... at which point this should
probably be turned into a bug.

Acked-by: Nick Piggin <npiggin@suse.de>
