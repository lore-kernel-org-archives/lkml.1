Return-Path: <linux-kernel-owner+w=401wt.eu-S965385AbZLQTSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965385AbZLQTSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 14:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965369AbZLQTSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 14:18:42 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:39903 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965357AbZLQTSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 14:18:40 -0500
To: Michael Stone <michael@laptop.org>
Cc: Ulrich Drepper <drepper@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       "Andi Kleen" <andi@firstfloor.org>, "David Lang" <david@lang.hm>,
       "Oliver Hartkopp" <socketcan@hartkopp.net>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Herbert Xu" <herbert@gondor.apana.org.au>,
       "Valdis Kletnieks" <Valdis.Kletnieks@vt.edu>,
       "Bryan Donlan" <bdonlan@gmail.com>,
       "Evgeniy Polyakov" <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       "James Morris" <jmorris@namei.org>,
       "Bernie Innocenti" <bernie@codewiz.org>,
       "Mark Seaborn" <mrs@mythic-beasts.com>
References: <1260977452-2334-1-git-send-email-michael@laptop.org>
	<1260977565-2379-2-git-send-email-michael@laptop.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 17 Dec 2009 11:18:22 -0800
In-Reply-To: <1260977565-2379-2-git-send-email-michael@laptop.org> (Michael Stone's message of "Wed\, 16 Dec 2009 10\:32\:44 -0500")
Message-ID: <m1pr6dwgsh.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH] Security: Implement prctl(PR_SET_NETWORK, PR_NETWORK_OFF) semantics.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Stone <michael@laptop.org> writes:

> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> index 23bd09c..5b38db0 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -151,6 +151,8 @@ int __ptrace_may_access(struct task_struct *task, unsigned int mode)
>  		dumpable = get_dumpable(task->mm);
>  	if (!dumpable && !capable(CAP_SYS_PTRACE))
>  		return -EPERM;
> +	if (current->network)
> +		return -EPERM;

The principle should be: you gain no privileges by ptracing.
Therefore this check should be:

	if (current->network && !task->network)
		return -EPERM;

Which keeps the ptrace logic from being a larger hammer than it needs
to be.

Eric
