Return-Path: <linux-kernel-owner+w=401wt.eu-S1758011AbZBKVXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011AbZBKVXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 16:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbZBKVXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 16:23:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57087 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616AbZBKVXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 16:23:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: ACPI: S4 disappeared [mmotm 2009-02-10-16-35]
Date: Wed, 11 Feb 2009 22:22:21 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc4-tst; KDE/4.2.0; x86_64; ; )
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@suse.cz>
References: <200902110036.n1B0aBZs013975@imap1.linux-foundation.org> <200902111643.10191.rjw@sisk.pl> <20090211162247.GA32301@elte.hu>
In-Reply-To: <20090211162247.GA32301@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902112222.22470.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 February 2009, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > On Wednesday 11 February 2009, Jiri Slaby wrote:
> > > On 02/11/2009 09:51 AM, Jiri Slaby wrote:
> > > > On 02/11/2009 01:36 AM, akpm@linux-foundation.org wrote:
> > > >> The mm-of-the-moment snapshot 2009-02-10-16-35 has been uploaded
> > > > 
> > > > Hi,
> > > > 
> > > > I've found out, that S4 disappeared in this release, in comparison to mmotm
> > > > based on 2.6.29-rc2:
> > > > -ACPI: (supports S0 S1 S3 S4 S5)
> > > > +ACPI: (supports S0 S1 S3 S5)
> > > > 
> > > > Any ideas what could have caused this?
> > > 
> > > I think this one
> > > ARCH_HIBERNATION_POSSIBLE=n
> > > because
> > > SMP=y
> > > since
> > >  config ARCH_HIBERNATION_POSSIBLE
> > >         def_bool y
> > > -       depends on !SMP || !X86_VOYAGER
> > > +       depends on !SMP
> > > 
> > > The condition was wrong, ok, anyway it worked. Would
> > > depends on !SMP || EXPERIMENTAL
> > > make sense? The smp is handled in disable_nonboot_cpus manner, right?
> > 
> > Ah, someone removed X86_VOYAGER and left this gem.  I guess that went in
> > through -tip (Ingo CCed).
> > 
> > After removing X86_VOYAGER, ARCH_HIBERNATION_POSSIBLE should always be set
> > on x86.  Just make it
> > 
> > config ARCH_HIBERNATION_POSSIBLE
> >          def_bool y
> 
> heh, indeed :-) Fixed via the commit below.

Would it be viable to fold that into aced3ce, so that bisectability is not
broken between the two?

Rafael

 
> ---------------->
> From 17993b49b1f540aace8e9b4242530d0b3376eb2a Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Wed, 11 Feb 2009 17:20:51 +0100
> Subject: [PATCH] x86: make hibernation always-possible
> 
> This commit:
> 
>   aced3ce: x86/Voyager: remove HIBERNATION Kconfig quirk
> 
> Made hibernation only available on UP - instead of making it available
> on all of x86. Fix it.
> 
> Reported-by: Jiri Slaby <jirislaby@gmail.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/Kconfig |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 4a27aa4..148c112 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -140,7 +140,6 @@ config HAVE_CPUMASK_OF_CPU_MAP
>  
>  config ARCH_HIBERNATION_POSSIBLE
>  	def_bool y
> -	depends on !SMP
>  
>  config ARCH_SUSPEND_POSSIBLE
>  	def_bool y
