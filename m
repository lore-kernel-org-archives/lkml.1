Return-Path: <linux-kernel-owner+w=401wt.eu-S1752923AbZEDGJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbZEDGJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 02:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbZEDGJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 02:09:32 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:54889 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbZEDGJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 02:09:31 -0400
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, Jake Edge <jake@lwn.net>,
       Arjan van de Ven <arjan@infradead.org>, Eric Paris <eparis@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Roland McGrath <roland@redhat.com>,
       mingo@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <alpine.LRH.2.00.0905040917240.20251@tundra.namei.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 03 May 2009 23:09:24 -0700
In-Reply-To: <alpine.LRH.2.00.0905040917240.20251@tundra.namei.org> (James Morris's message of "Mon\, 4 May 2009 09\:27\:29 +1000 \(EST\)")
Message-ID: <m1r5z5jt63.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: jmorris@namei.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@redhat.com, roland@redhat.com, alan@lxorguk.ukuu.org.uk, eparis@redhat.com, arjan@infradead.org, jake@lwn.net, linux-security-module@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;James Morris <jmorris@namei.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1141]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] proc: avoid leaking eip, esp, or wchan to non-privileged processes (fwd)
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> writes:

> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index aa763ab..cd3c0d7 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -319,6 +319,9 @@ static int proc_pid_wchan(struct task_struct *task, char
> *buffer)
>  	unsigned long wchan;
>  	char symname[KSYM_NAME_LEN];
>
> +	if (!ptrace_may_access(task, PTRACE_MODE_READ))
> +		return 0;
> +
>  	wchan = get_wchan(task);
>
>  	if (lookup_symbol_name(wchan, symname) < 0)

If the symbol is in the kernel it should be safe to return it's
name, all that is an information leak of a different sort.
Overall I expect we should return  -EPERM here and not simply
an empty file.

Have you tested these patches against ps top and similar common
tools?

Eric
