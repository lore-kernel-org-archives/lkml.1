Return-Path: <linux-kernel-owner+w=401wt.eu-S1751656AbYCDI1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656AbYCDI1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbYCDI05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:26:57 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:33479 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbYCDI04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:26:56 -0500
Date: Tue, 4 Mar 2008 09:03:59 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Adrian Bunk <bunk@kernel.org>,
       Alexey Starikovskiy <aystarik@gmail.com>, lenb@kernel.org,
       astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] x86: phase out forced inlining
Message-ID: <20080304080335.GA5776@uranus.ravnborg.org>
References: <20080301183550.GC25835@cs181133002.pp.htv.fi> <20080303085720.GD15943@elte.hu> <20080303091314.GC4457@cs181133002.pp.htv.fi> <20080303091714.GA18250@elte.hu> <20080303093103.GA23651@uranus.ravnborg.org> <20080303103933.GC21190@elte.hu> <20080303113451.GF4457@cs181133002.pp.htv.fi> <20080303114533.GA4183@elte.hu> <20080303121335.GA15381@elte.hu> <20080303224231.86c22ed0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303224231.86c22ed0.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 10:42:31PM -0800, Andrew Morton wrote:
> On Mon, 3 Mar 2008 13:13:35 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > +config OPTIMIZE_INLINING
> > +	bool "Allow gcc to uninline functions marked 'inline'"
> > +	default y
> > +	help
> > +	  This option determines if the kernel forces gcc to inline the functions
> > +	  developers have marked 'inline'. Doing so takes away freedom from gcc to
> > +	  do what it thinks is best, which is desirable for the gcc 3.x series of
> > +	  compilers. The gcc 4.x series have a rewritten inlining algorithm and
> > +	  disabling this option will generate a smaller kernel there. Hopefully
> > +	  this algorithm is so good that allowing gcc4 to make the decision can
> > +	  become the default in the future, until then this option is there to
> > +	  test gcc for this.
> 
> urgh.  This will cause whatever problem
> 4507a6a59cfc6997e532cd812a8bd244181e6205 fixed five years ago to resurface
> for incautious gcc-3.x users.
> 
> I'd suggest that this
> 
> > +#ifndef CONFIG_OPTIMIZE_INLINING
> 
> become something along the lines of
> 
> > +#ifndef CONFIG_OPTIMIZE_INLINING && (__GNUC__ > 3)
> 
> It would be nice to be able to feed the gcc version into the Kconfig logic,
> really..
We can do this using a few environment options.

Somewhere in a Makefile:
export CC_MAJOR=`magic`
export CC_MINOR=`more magic`

And in a Kconfig file:

config CC_MAJOR
	string
	option env=CC_MAJOR


And then we can do:
config CC_DEFAULT_INLINE
	bool "Force inline of functions annotated inline"
	default y if CC_MAJOR = 04

Shall I try to cook up a patch for this?
[I may get access to my dev box tonight - cannot promise..]

	Sam
