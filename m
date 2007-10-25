Return-Path: <linux-kernel-owner+w=401wt.eu-S1758899AbXJYEAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899AbXJYEAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 00:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750736AbXJYEAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 00:00:39 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:34084 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750726AbXJYEAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 00:00:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=NyMo1IZsYpBw+cUC05wXjRE3VYqXxU12Al2hkkkFKI+L5FYz7tC7kfSgBXP12cCzr7M6RvbYpeWI3aDLJRACQ+VvwJadKdu+7gJKuIoFs5r7qYY1HUDpQqlnugbiq/J5kW3JlUz0b0I9k6JGmWd0yraDNUMqcb+oNMT1XJfUkFk=  ;
X-YMail-OSG: u4unes4VM1kfl1MwERbMdxjh4PXUq83XoDhZoIYJN00op40.DsH1MKCEJJ2owURiZZSjwWlymQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 5/5] Make wait_on_retry_sync_kiocb killable
Date: Thu, 25 Oct 2007 13:53:57 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <11927463623428-git-send-email-matthew@wil.cx> <11927463623950-git-send-email-matthew@wil.cx>
In-Reply-To: <11927463623950-git-send-email-matthew@wil.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710251353.57881.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 October 2007 08:26, Matthew Wilcox wrote:
> Use TASK_KILLABLE to allow wait_on_retry_sync_kiocb to return -EINTR.
> All callers then check the return value and break out of their loops.
>
> Signed-off-by: Matthew Wilcox <matthew@wil.cx>
> ---
>  fs/read_write.c |   17 ++++++++++++-----
>  1 files changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 124693e..3196a3b 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -218,14 +218,15 @@ Einval:
>  	return -EINVAL;
>  }
>
> -static void wait_on_retry_sync_kiocb(struct kiocb *iocb)
> +static int wait_on_retry_sync_kiocb(struct kiocb *iocb)
>  {
> -	set_current_state(TASK_UNINTERRUPTIBLE);
> +	set_current_state(TASK_KILLABLE);
>  	if (!kiocbIsKicked(iocb))
>  		schedule();
>  	else
>  		kiocbClearKicked(iocb);
>  	__set_current_state(TASK_RUNNING);
> +	return fatal_signal_pending(current) ? -EINTR : 0;

Although the EINTR never gets to userspace anyway, is there a good
reason why the last patch for do_generic_mapping_read doesn't pass
back -EINTR?
