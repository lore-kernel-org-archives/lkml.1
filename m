Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbYJFGaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbYJFGaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 02:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbYJFGar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 02:30:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43206 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773AbYJFGaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 02:30:46 -0400
Date: Mon, 6 Oct 2008 08:30:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Noonan <steven@uplinklabs.net>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       drzeus@drzeus.cx
Subject: Re: [PATCH] sdhci: 'scratch' may be used uninitialized
Message-ID: <20081006063035.GA19244@elte.hu>
References: <20081001083532.GE31009@elte.hu> <1222851025-30619-1-git-send-email-steven@uplinklabs.net> <20081005142819.GB12047@cs181140183.pp.htv.fi> <f488382f0810051553t32a24972ma7baa92605f43772@mail.gmail.com> <20081005231607.GB10747@cs181140183.pp.htv.fi> <f488382f0810051648k14b499ecj9d625c55b38ed2f0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f488382f0810051648k14b499ecj9d625c55b38ed2f0@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Noonan <steven@uplinklabs.net> wrote:

> On Sun, Oct 5, 2008 at 4:16 PM, Adrian Bunk <bunk@kernel.org> wrote:
> > On Sun, Oct 05, 2008 at 03:53:28PM -0700, Steven Noonan wrote:
> >> On Sun, Oct 5, 2008 at 7:28 AM, Adrian Bunk <bunk@kernel.org> wrote:
> >> > On Wed, Oct 01, 2008 at 01:50:25AM -0700, Steven Noonan wrote:
> >> >> The variable 'scratch' is always initialized before it's used. The
> >> >> conditional which is responsible for initialization of 'scratch' will
> >> >> always evaluate 'true' when the first loop iteration occurs, and thus,
> >> >> it's properly initialized. GCC doesn't see this, of course, so using
> >> >> the uninitialized_var() macro seems to work for silencing this case.
> >> >>
> >> >> Signed-off-by: Steven Noonan <steven@uplinklabs.net>
> >> >> ---
> >> >>  drivers/mmc/host/sdhci.c |    2 +-
> >> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >> >>
> >> >> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> >> >> index e3a8133..6257677 100644
> >> >> --- a/drivers/mmc/host/sdhci.c
> >> >> +++ b/drivers/mmc/host/sdhci.c
> >> >> @@ -177,7 +177,7 @@ static void sdhci_read_block_pio(struct sdhci_host *host)
> >> >>  {
> >> >>       unsigned long flags;
> >> >>       size_t blksize, len, chunk;
> >> >> -     u32 scratch;
> >> >> +     u32 uninitialized_var(scratch);
> >> >>...
> >> >
> >> > With which gcc version?
> >> >
> >> > I'm not getting this warning with gcc 4.3, and IMHO it doesn't make
> >> > sense to clutter the source code with such workarounds for older gcc
> >> > versions (we officially support 6 years old compilers, and warning-free
> >> > compilations with all of them are not reasonably possible).
> >> >
> >> > cu
> >> > Adrian
> >>
> >> I've seen it on GCC 4.1 and 4.2. Since lots of distributions still
> >> haven't marked GCC >4.1 stable, it makes sense to me to kill warnings
> >> for GCC 4.1 and above. I don't know of any current distribution
> >> releases using less than GCC 4.1 at the moment.
> >
> > It will clutter our code with these workarounds forever.
> >
> > And due to silencing these false warnings we will no longer get a
> > warning when one of them becomes a real bug.
> >
> > Working on the remaining warnings that are visible with gcc 4.3 is a
> > worthwhile goal, but I see no point for silencing some warnings that
> > only occur with older gcc versions (especially as long as warnings
> > that are present with all gcc versions stay unfixed).
> >
> I feel like there's a logical fallacy here. Sure, we can fix GCC 4.3
> warnings, but what about when GCC 4.3 becomes an "old version"?
> uninitialized_var and other such workarounds will still exist in the
> code. It seems like the logical progression of your argument should be
> to never fix false warnings.

Correct. Would you be interested in sending a patch for a (default-off) 
debug feature that allows the disabling of all the gcc annotations? That 
way we can do regular sweeps to determine whether old annotations are 
still relevant on latest and greatest GCC.

Something like CONFIG_CC_DEBUG_ALLOW_WARNINGS=y in lib/Kconfig.debug, 
then use that to #ifdef the uninitialized_var() 
include/linux/compiler-gcc[34].h?

Also, please try Alan's suggestion as well: does the __attribute_ 
((unused)) trick work equally well? If yes then please introduce a 
__annotate_initialized tag instead of the weird-looking 
uninitialized_var() construct.

	Ingo
