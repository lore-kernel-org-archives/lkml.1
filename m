Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbZDZQjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbZDZQjt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 12:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbZDZQjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 12:39:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57774 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781AbZDZQjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 12:39:39 -0400
Date: Sun, 26 Apr 2009 18:39:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: Jonathan Corbet <corbet@lwn.net>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] remove the BKL: remove "BKL auto-drop" assumption
	from ext3_remount()
Message-ID: <20090426163924.GD6236@elte.hu>
References: <1240492586-6654-1-git-send-email-abogani@texware.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240492586-6654-1-git-send-email-abogani@texware.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alessio Igor Bogani <abogani@texware.it> wrote:

> Fix ext3_remount()'s "schedule() drops the BKL automatically" assumption,
> when ext3_mark_recovery_complete(), which can sleep, does not do that it can
> lock up.
> 
> Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
> ---
>  fs/ext3/super.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index dc905f9..3fa457a 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -2561,9 +2561,11 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
>  			 * We have to unlock super so that we can wait for
>  			 * transactions.
>  			 */
> +			unlock_kernel();
>  			unlock_super(sb);
>  			ext3_mark_recovery_complete(sb, es);
>  			lock_super(sb);
> +			lock_kernel();

Shouldnt this be a conditional-unlock, so that if the remount moves 
away from under the BKL we dont break in this place?

	Ingo
