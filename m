Return-Path: <linux-kernel-owner+w=401wt.eu-S1761474AbYFTPob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761474AbYFTPob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 11:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760883AbYFTPoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 11:44:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46833 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757127AbYFTPoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 11:44:14 -0400
Date: Fri, 20 Jun 2008 17:43:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, andi@firstfloor.org,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] X86: reboot-notify additions
Message-ID: <20080620154354.GA6656@elte.hu>
References: <E1K95kd-00081i-B6@eag09.americas.sgi.com> <20080619110214.GJ15228@elte.hu> <20080619145453.GA11929@sgi.com> <m1d4mdksau.fsf@frodo.ebiederm.org> <20080620151650.GA5606@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080620151650.GA5606@sgi.com>
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


* Cliff Wickman <cpw@sgi.com> wrote:

> --- linux.orig/kernel/sys.c
> +++ linux/kernel/sys.c
> @@ -267,9 +267,16 @@ out_unlock:
>   *	reboot the system.  This is called when we know we are in
>   *	trouble so this is our best effort to reboot.  This is
>   *	safe to call in interrupt context.
> + *
> + *	The reboot_notifier_list uses a header for a blocking-form scan.
> + *	Use a local header suitable for a non-blocking scan.
>   */
>  void emergency_restart(void)
>  {
> +	struct raw_notifier_head rh;
> +
> +	rh.head = reboot_notifier_list.head;
> +	raw_notifier_call_chain(&rh, SYS_EMERGENCY, NULL);
>  	machine_emergency_restart();
>  }

that's still not a good idea - a blocking notifier list is that: a list 
that has stuff which might block. emergency_restart() might get called 
by non-blocking codepaths as well and it expects the restart to occur.

	Ingo
