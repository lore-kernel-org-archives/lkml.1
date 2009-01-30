Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbZA3DBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbZA3DBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 22:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbZA3DBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 22:01:21 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:56674 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbZA3DBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 22:01:20 -0500
To: Paul Turner <pjt@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0901162229420.12858@kitami.corp.google.com>
	<20090124181924.d633523c.akpm@linux-foundation.org>
	<20090125120818.GA4454@x200.localdomain>
	<m1r62obev3.fsf@fess.ebiederm.org>
	<Pine.LNX.4.64.0901291719520.26444@kitami.corp.google.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 29 Jan 2009 19:01:31 -0800
In-Reply-To: <Pine.LNX.4.64.0901291719520.26444@kitami.corp.google.com> (Paul Turner's message of "Thu\, 29 Jan 2009 17\:26\:52 -0800 \(PST\)")
Message-ID: <m1bptp8pkk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: pjt@google.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, adobriyan@gmail.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Paul Turner <pjt@google.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: Migration of kernel interfaces to seq_files breaks pread() consumers
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Turner <pjt@google.com> writes:
>
> Thanks Eric,
>
> Moving the position into the seq_file structure is much cleaner.  Basic 
> tests seem to work ok.

Thanks.

> Few comments:
> - seq_open needs its fmode opened up to take advantage of this [patch 
> below]

Good point.
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
                                   

> - There's still the inherent problem of reads peturbing other reads (both 
> read and pread).  Our applications should be ok with this, however it does 
> deviate from the supposedly thread-safe pread semantics.

I don't see this not being thread safe.

If the data that is returned is stable.  We should not see anything
changing.  Otherwise it is all bets are off in any case.

Because seq_read happens under m->lock I don't see how there will
be anything thread unsafe.

The position that changes is just an internal implementation detail to
keep track of which data that we have cached.

>
> - Paul
>
> ---
>  fs/seq_file.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/fs/seq_file.c b/fs/seq_file.c
> index cd63d69..aa3621f 100644
> --- a/fs/seq_file.c
> +++ b/fs/seq_file.c
> @@ -48,8 +48,6 @@ int seq_open(struct file *file, const struct seq_operations
> *op)
>  	 */
>  	file->f_version = 0;
>  
> -	/* SEQ files support lseek, but not pread/pwrite */
> -	file->f_mode &= ~(FMODE_PREAD | FMODE_PWRITE);
>  	return 0;
>  }
>  EXPORT_SYMBOL(seq_open);
> -- 
> 1.5.4.5
