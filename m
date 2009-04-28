Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbZD1IgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbZD1IgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 04:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbZD1If6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 04:35:58 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:41175 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbZD1If4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 04:35:56 -0400
Date: Tue, 28 Apr 2009 10:38:04 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       hpa@c2micro.com, tglx@linutronix.de, hpa@linux.intel.com,
       jeremy.fitzhardinge@citrix.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: linker script: avoid ALIGN statements inside output sections
Message-ID: <20090428083804.GB17622@uranus.ravnborg.org>
References: <tip-c707f31e2e6af2d37bc742c31be0c7e96946c71f@git.kernel.org> <20090428081455.GA19736@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428081455.GA19736@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 10:14:55AM +0200, Ingo Molnar wrote:
> 
> * tip-bot for H. Peter Anvin <hpa@c2micro.com> wrote:
> 
> > Commit-ID:  c707f31e2e6af2d37bc742c31be0c7e96946c71f
> > Gitweb:     http://git.kernel.org/tip/c707f31e2e6af2d37bc742c31be0c7e96946c71f
> > Author:     H. Peter Anvin <hpa@c2micro.com>
> > AuthorDate: Mon, 27 Apr 2009 13:09:45 -0700
> > Committer:  H. Peter Anvin <hpa@c2micro.com>
> > CommitDate: Mon, 27 Apr 2009 13:09:45 -0700
> > 
> > x86: linker script: avoid ALIGN statements inside output sections
> > 
> > ALIGN statements inside output sections means that the alignment 
> > padding ends up part of the section.  This causes real problems 
> > when the section is otherwise empty.  ALIGN can be done either 
> > before the output section or as part of the output section header; 
> > the latter has the advantage that the alignment information is 
> > propagated into the appropriate ELF headers.
> > 
> > Without this patch, we produce invalid kernels in certain 
> > configurations involving X86_VSMP.
> > 
> > Reported-and-tested-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> > 
> > 
> > ---
> >  arch/x86/kernel/vmlinux_32.lds.S |   45 +++++++++++++++-----------------
> >  arch/x86/kernel/vmlinux_64.lds.S |   52 +++++++++++++++++--------------------
> >  2 files changed, 45 insertions(+), 52 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
> > index 62ad500..7197db8 100644
> > --- a/arch/x86/kernel/vmlinux_32.lds.S
> > +++ b/arch/x86/kernel/vmlinux_32.lds.S
> > @@ -37,8 +37,7 @@ SECTIONS
> >    } :text = 0x9090
> >  
> >    /* read-only */
> > -  .text : AT(ADDR(.text) - LOAD_OFFSET) {
> > -	. = ALIGN(PAGE_SIZE); /* not really needed, already page aligned */
> > +  .text : AT(ADDR(.text) - LOAD_OFFSET) ALIGN(PAGE_SIZE) {
> >  	*(.text.page_aligned)
> >  	TEXT_TEXT
> >  	SCHED_TEXT
> > @@ -52,8 +51,8 @@ SECTIONS
> >  
> >    NOTES :text :note
> >  
> > -  . = ALIGN(16);		/* Exception table */
> > -  __ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
> > +  /* Exception table */
> > +  __ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) ALIGN(16) {
> 
> 
> this construct breaks older toolchains:
> 
> /opt/crosstool/gcc-4.2.3-glibc-2.3.6/x86_64-unknown-linux-gnu/bin/x86_64-unknown-linux-gnu-ld:arch/x86/kernel/vmlinux.lds:138: 
> parse error
> 
> titan:~/tip> 
> /opt/crosstool/gcc-4.2.3-glibc-2.3.6/x86_64-unknown-linux-gnu/bin/x86_64-unknown-linux-gnu-ld -v
> GNU ld version 2.16.1
> 
> this is what it does not like:
> 
>  __ex_table : AT(ADDR(__ex_table) - 0xffffffff80000000) ALIGN(16) {

Good to know. I was yesterday wondering why we did not use this.
As part of the .lds file cleanups I move ALIGN() out of the
output section as this is where it should be.

	Sam
