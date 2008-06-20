Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbYFTLp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbYFTLp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 07:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbYFTLpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 07:45:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53473 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbYFTLpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 07:45:49 -0400
Date: Fri, 20 Jun 2008 13:45:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: andi@firstfloor.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] X86: reboot-notify additions
Message-ID: <20080620114524.GH7439@elte.hu>
References: <E1K95kd-00081i-B6@eag09.americas.sgi.com> <20080619110214.GJ15228@elte.hu> <20080619145453.GA11929@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080619145453.GA11929@sgi.com>
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

> > > +#define SYS_INSANE	0x0004	/* Notify of system error/panic/oops */
> > > +/* For the SYS_INSANE case, no locks should be taken by the called-back
> > > + * function.  The kernel is ready for an immediate reboot.
> > > + */

please use standard comment blocks, something like this:

  /*
   * Notify of system error/panic/oops
   *
   * No locks should be taken by the called-back function.
   * The kernel is ready for an immediate reboot.
   */
  #define SYS_INSANE	0x0004

> > > +++ linux/kernel/kexec.c
> > > @@ -1001,6 +1001,9 @@ asmlinkage long sys_kexec_load(unsigned 
> > >  		if (result)
> > >  			goto out;
> > >  	}
> > > +
> > > +	blocking_notifier_call_chain(&reboot_notifier_list, SYS_RESTART, NULL);

this puts an extra blocking call into a kexec critical path.

>  			struct pt_regs fixed_regs;
> +        		struct raw_notifier_head rh;
> +        		rh.head = reboot_notifier_list.head;
> +        		raw_notifier_call_chain(&rh, SYS_EMERGENCY, NULL);

that's very nasty. Now callbacks which put themselves on a blocking list 
will be called without locking.

>  void emergency_restart(void)
>  {
> +	struct raw_notifier_head rh;
> +
> +	rh.head = reboot_notifier_list.head;
> +	raw_notifier_call_chain(&rh, SYS_EMERGENCY, NULL);

ditto.

this patch is still far from being acceptable.

	Ingo
