Return-Path: <linux-kernel-owner+w=401wt.eu-S1752214AbZDMSNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbZDMSNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 14:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbZDMSNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 14:13:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51018 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbZDMSND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 14:13:03 -0400
Date: Mon, 13 Apr 2009 20:11:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
       Mike Travis <travis@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mm-commits@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Dave Jones <davej@redhat.com>, Len Brown <lenb@kernel.org>
Subject: Re: mmotm 2009-04-10-02-21 uploaded - forkbombed by work_for_cpu
Message-ID: <20090413181126.GA6669@elte.hu>
References: <200904100922.n3A9MOIV013828@imap1.linux-foundation.org> <4609.1239456126@turing-police.cc.vt.edu> <alpine.LFD.2.00.0904130847500.4583@localhost.localdomain> <20090413171853.GA4601@elte.hu> <20090413102749.4ca3a217.akpm@linux-foundation.org> <alpine.LFD.2.00.0904131040350.4583@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904131040350.4583@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 13 Apr 2009, Andrew Morton wrote:
> >
> >  static void drv_write(struct drv_cmd *cmd)
> >  {
> > -	unsigned int i;
> > +	unsigned int cpu;
> >  
> > -	for_each_cpu(i, cmd->mask) {
> > -		work_on_cpu(i, do_drv_write, cmd);
> > -	}
> > +	for_each_cpu(cpu, cmd->mask)
> > +		smp_call_function_single(cpu, do_drv_write, cmd, 1);
> 
> Ok, that's just -wrong-.
> 
> Doesn't anybody else see anything odd in doing
> 
> 	for_each_cpu(cpu, cmd->mask)
> 		smp_call_function_single(cpu, ..);
> 
> and react to it?
> 
> IOW, why not just do
> 
> 	smp_call_function_many(cmd->mask, do_drv_write, cmd, 1);
> 
> here?

Uhm, yes. The ancient version did:

        for_each_cpu_mask(i, cmd->mask) {
                set_cpus_allowed(current, cpumask_of_cpu(i));
                do_drv_write(cmd);
        }

and we just kept that pattern while somewhat mindlessly converting 
it around, and never realized how it collapses to a nice masked API 
version when the right IPI-call primitive is used.

	Ingo
