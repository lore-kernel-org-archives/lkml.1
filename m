Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbZKHLhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbZKHLhI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 06:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbZKHLhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 06:37:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40624 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856AbZKHLhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 06:37:04 -0500
Date: Sun, 8 Nov 2009 12:36:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 02/11] Add "handle page fault" PV helper.
Message-ID: <20091108113654.GO11372@elte.hu>
References: <1257076590-29559-1-git-send-email-gleb@redhat.com>
 <1257076590-29559-3-git-send-email-gleb@redhat.com>
 <20091102092214.GB8933@elte.hu>
 <20091102160410.GF27911@redhat.com>
 <20091102161248.GB15423@elte.hu>
 <20091102162234.GH27911@redhat.com>
 <20091102162941.GC14544@elte.hu>
 <20091102174208.GJ27911@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102174208.GJ27911@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gleb Natapov <gleb@redhat.com> wrote:

> On Mon, Nov 02, 2009 at 05:29:41PM +0100, Ingo Molnar wrote:
> > 
> > * Gleb Natapov <gleb@redhat.com> wrote:
> > 
> > > On Mon, Nov 02, 2009 at 05:12:48PM +0100, Ingo Molnar wrote:
> > > > 
> > > > * Gleb Natapov <gleb@redhat.com> wrote:
> > > > 
> > > > > On Mon, Nov 02, 2009 at 10:22:14AM +0100, Ingo Molnar wrote:
> > > > > > 
> > > > > > * Gleb Natapov <gleb@redhat.com> wrote:
> > > > > > 
> > > > > > > diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> > > > > > > index f4cee90..14707dc 100644
> > > > > > > --- a/arch/x86/mm/fault.c
> > > > > > > +++ b/arch/x86/mm/fault.c
> > > > > > > @@ -952,6 +952,9 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
> > > > > > >  	int write;
> > > > > > >  	int fault;
> > > > > > >  
> > > > > > > +	if (arch_handle_page_fault(regs, error_code))
> > > > > > > +		return;
> > > > > > > +
> > > > > > 
> > > > > > This patch is not acceptable unless it's done cleaner. Currently we 
> > > > > > already have 3 callbacks in do_page_fault() (kmemcheck, mmiotrace, 
> > > > > > notifier), and this adds a fourth one. Please consolidate them into a 
> > > > > > single callback site, this is a hotpath on x86.
> > > > > > 
> > > > > This call is patched out by paravirt patching mechanism so overhead 
> > > > > should be zero for non paravirt cases. [...]
> > > > 
> > > > arch_handle_page_fault() isnt upstream yet - precisely what is the 
> > > > instruction sequence injected into do_page_fault() in the patched-out 
> > > > case?
> > > 
> > > It is introduced by the same patch. The instruction inserted is:
> > >  xor %rax, %rax
> > 
> > ok.
> > 
> > My observations still stand:
> > 
> > > > > [...] What do you want to achieve by consolidate them into single 
> > > > > callback? [...]
> > > > 
> > > > Less bloat in a hotpath and a shared callback infrastructure.
> > > > 
> > > > > [...] I mean the code will still exist and will have to be executed on 
> > > > > every #PF. Is the goal to move them out of line?
> > > > 
> > > > The goal is to have a single callback site for all the users - which 
> > > > call-site is patched out ideally - on non-paravirt too if needed. Most 
> > > > of these callbacks/notifier-chains have are inactive most of the time.
> > > > 
> > > > I.e. a very low overhead 'conditional callback' facility, and a single 
> > > > one - not just lots of them sprinkled around the code.
> > 
> > looks like a golden opportunity to get this right.
> >
> Three existing callbacks are: kmemcheck, mmiotrace, notifier. Two
> of them kmemcheck, mmiotrace are enabled only for debugging, should
> not be performance concern. And notifier call sites (two of them)
> are deliberately, as explained by comment, not at the function entry,
> so can't be unified with others. (And kmemcheck also has two different
> call site BTW)

We want mmiotrace to be generic distro capable so the overhead when the 
hook is not used is of concern.

	Ingo
