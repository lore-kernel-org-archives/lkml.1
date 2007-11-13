Return-Path: <linux-kernel-owner+w=401wt.eu-S1760009AbXKMDNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760009AbXKMDNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 22:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbXKMDN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 22:13:26 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55402 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752138AbXKMDNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 22:13:25 -0500
Date: Mon, 12 Nov 2007 19:13:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Check length at deprecated_sysctl_warning.
Message-Id: <20071112191320.55e49462.akpm@linux-foundation.org>
In-Reply-To: <200711130307.lAD37Nee045340@www262.sakura.ne.jp>
References: <200711080257.lA82vQfA015942@www262.sakura.ne.jp>
	<20071107192211.c1c22e97.akpm@linux-foundation.org>
	<200711080819.lA88J8Pv072259@www262.sakura.ne.jp>
	<m14pfr6bnf.fsf@ebiederm.dsl.xmission.com>
	<200711130307.lAD37Nee045340@www262.sakura.ne.jp>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 12:07:23 +0900 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:

> Andrew, please replace previous patch with this one.
> This one returns -ENOTDIR.
> ----------
> 
> Original patch forgot to check args->nlen.
> I don't know why args->nlen == CTL_MAXNAME is rejected,
> but it has been rejected traditionally.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  kernel/sysctl.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff -puN kernel/sysctl.c~sysctl-check-length-at-deprecated_sysctl_warning kernel/sysctl.c
> --- a/kernel/sysctl.c~sysctl-check-length-at-deprecated_sysctl_warning
> +++ a/kernel/sysctl.c
> @@ -2609,6 +2609,10 @@ static int deprecated_sysctl_warning(str
>  	int name[CTL_MAXNAME];
>  	int i;
>  
> +	/* Check args->nlen. */
> +	if (args->nlen <= 0 || args->nlen >= CTL_MAXNAME)

I believe (args->nlen > CTL_MAXNAME) was correct.

> +		return -ENOTDIR;

Ho hum.  Why does that code return -ENOTDIR on error anyway?

> +
>  	/* Read in the sysctl name for better debug message logging */
>  	for (i = 0; i < args->nlen; i++)
>  		if (get_user(name[i], args->name + i))
