Return-Path: <linux-kernel-owner+w=401wt.eu-S1751783AbZJTK1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbZJTK1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 06:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbZJTK1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 06:27:11 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:47849 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbZJTK1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 06:27:09 -0400
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, dlezcano@fr.ibm.com, jack@ucw.cz,
       andrea@cpushare.com, sukadev@us.ibm.com,
       Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       mingo@elte.hu, Alexey Dobriyan <adobriyan@gmail.com>
References: <20091020041337.GA31623@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 20 Oct 2009 03:27:00 -0700
In-Reply-To: <20091020041337.GA31623@us.ibm.com> (Sukadev Bhattiprolu's message of "Mon\, 19 Oct 2009 21\:13\:37 -0700")
Message-ID: <m1r5sywebv.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: *  7.0 XM_URI_RBL URI's domain appears in surbl.xmission.com
	*      [URIs: lkml.org]
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] pidns: Fix a leak in /proc inodes and dentries
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> writes:

> Fix a leak in /proc dentries and inodes with pid namespaces.
>
> This fix reverts the commit 7766755a2f249e7e0. The leak was reported by
> Daniel Lezcano - see  http://lkml.org/lkml/2009/10/2/159.
>
> To summarize the thread, when container-init is terminated, it sets the
> PF_EXITING flag and then zaps all the other processes in the container.
> When those processes exit, they are expected to be reaped by the container-
> init and as a part of reaping, the container-init should flush any /proc
> dentries associated with the processes. But because the container-init is
> itself exiting and the following PF_EXITING check, the dentires are not
> flushed, resulting in leak in /proc inodes and dentries.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

> Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
> Reported-by: Daniel Lezcano <dlezcano@fr.ibm.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Jan Kara <jack@ucw.cz>
> Cc: Andrea Arcangeli <andrea@cpushare.com>
>
> ---
>  fs/proc/base.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> Index: linux-2.6/fs/proc/base.c
> ===================================================================
> --- linux-2.6.orig/fs/proc/base.c	2009-10-19 20:28:51.000000000 -0700
> +++ linux-2.6/fs/proc/base.c	2009-10-19 20:29:03.000000000 -0700
> @@ -2580,8 +2580,7 @@ static void proc_flush_task_mnt(struct v
>  	name.len = snprintf(buf, sizeof(buf), "%d", pid);
>  	dentry = d_hash_and_lookup(mnt->mnt_root, &name);
>  	if (dentry) {
> -		if (!(current->flags & PF_EXITING))
> -			shrink_dcache_parent(dentry);
> +		shrink_dcache_parent(dentry);
>  		d_drop(dentry);
>  		dput(dentry);
>  	}
