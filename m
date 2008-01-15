Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbYAOSbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbYAOSbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 13:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754383AbYAOSbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 13:31:33 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:59660 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbYAOSbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 13:31:32 -0500
Date: Tue, 15 Jan 2008 19:31:32 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Adrian Bunk <bunk@kernel.org>, rjw@sisk.pl,
       pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without HOTPLUG_CPU
Message-ID: <20080115183132.GD18338@uranus.ravnborg.org>
References: <20080114140910.GA8507@uranus.ravnborg.org> <20080114145854.GA31695@elte.hu> <20080114150553.GA3524@elte.hu> <20080114152440.GA9174@elte.hu> <20080114201214.GC9257@uranus.ravnborg.org> <20080115151742.GB10722@elte.hu> <20080115162513.GA18338@uranus.ravnborg.org> <20080115171146.GA2377@one.firstfloor.org> <20080115182142.GC18338@uranus.ravnborg.org> <20080115182904.GA3393@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115182904.GA3393@one.firstfloor.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 07:29:04PM +0100, Andi Kleen wrote:
> On Tue, Jan 15, 2008 at 07:21:42PM +0100, Sam Ravnborg wrote:
> > With default options to gcc my .config produces ~65 warnings
> > but with -fno-unit-a-time I get 112 warnings.
> > Solely due to less inlining done by gcc.
> > 
> > So there are two sources for the 'randomization':
> > a) The actual config
> > b) The sometimes agressive inlining
> 
> Inlining should not be random.  And how does inlining cause such a warning?
Consider:

static int __init foo()
{
	// ...
}

static int bar()
{
	// ...
	if (foo())
		// ...
}

gcc will often inline foo into bar - and then all code are suddenly
part of .text and no section mismatch.
But you add anohter call to foo() somewhere so gcc decide no longer
to inline foo() and we then have a reference from .text to .init.text.

> > 
> > a) will be addressed by having separate sections for each
> > __init* type that is at link time combined where it belongs.
> 
> One problem I ran into the past was that older binutils seem
> to have some exponential behaviour with a lot of named sections
> and run very slowly.
This is more the -ffunction-section issue I guess.
What we are dealig with here is ~20 more sections and the kernel has
~100 section today (or more). So not a huge increase.

	Sam
