Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab0CEFUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 00:20:19 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46505 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590Ab0CEFUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 00:20:17 -0500
Date: Thu, 4 Mar 2010 21:20:14 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, zippel@linux-m68k.org, mingo@elte.hu,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       geert@linux-m68k.org, cloos@jhcloos.com
Subject: Re: [PATCH] v3 kconfig: place git SHA1 in .config output if in SCM
Message-ID: <20100305052014.GA6869@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100305025435.GA6836@linux.vnet.ibm.com> <201003050443.30431.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003050443.30431.elendil@planet.nl>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 04:43:27AM +0100, Frans Pop wrote:
> On Friday 05 March 2010, Paul E. McKenney wrote:
> > o	Added the KBUILD_CONFIG_NO_CHECK_DIRTY environment variable,
> > 	and modified scripts/setlocalversion to check it, as suggested
> > 	by James Cloos.
> 
> Just to state the obvious: this will also affect CONFIG_LOCALVERSION_AUTO.
> 
> > @@ -450,12 +457,52 @@ int conf_write(const char *name)
> >  	if (env && *env)
> >  		use_timestamp = 0;
> >
> > +	strcpy(localversion, "-?-nopath");
> > +	path = getenv(SRCTREE);
> > +	if (path && *path) {
> > +		strcpy(localversion, "-?-pipe()-failed");
> > +		if (pipe(pipefd) != 0)
> > +			goto nolocalversion;
> > +		env = getenv("KBUILD_CONFIG_NO_CHECK_DIRTY");
> 
> Is this line actually needed? AFAICT the variable is unused here and should 
> pass down through the environment to the setlocalversion script without 
> needing any help.

No, it is not needed.  This is a holdover from an earlier version that
tried passing in just that one environment variable.

Good eyes, will fix!

> > +		sprintf(cmdline, "%s/scripts/setlocalversion", path);
> > +		strcpy(localversion, "-?-fork()-failed");
> > +		pid = fork();
> 
> Do I read correctly that you're also postfixing error conditions to the 
> kernel version? Don't think that's a great idea TBH. Errors should be 
> printed to STDERR as they occur, not as pseudo version strings.

That is the intent.

> Users coming across them in config files would be very unlikely to be able 
> to make any sense of them. IMO, if no VCS version can be determined, 
> nothing should be printed.

Hmmm...  I guess I can leave stderr untouched through to the child and
add the code needed to reap the children and report any error codes.

But let's work out what the error strategy should be.  The below are my
initial guesses, I of course must defer to those more familiar with
kbuild and kconfig than am I.

1.	Oddball SCM conditions should not cause the build to fail.
	"Arrrgh!!!  What dot-file do I need to remove in order for
	my builds to start succeeding???"

2.	Errors should leave some hint in the .config file, rather
	than simply mysteriously omitting the version/dirty information.

	Yes, stderr can be captured, but if it doesn't break the build,
	it is likely to be ignored.

3.	It is OK to dump to stderr (I think), but the format should be
	something that typical error-check scripts catch.

	What would that be?  How about the following pattern that every
	build-error-check script must pay attention to?

	scripts/confdata.c:nnnn error: <perror output>

4.	Should the splat in the .config file identify the file and
	line number?  For example: "-error: scripts/confdata.c:nnnn"

5.	Anything else that I have missed?

After this is done, I am going to return to something easier to
understand, like the Linux kernel's RCU implementation.  ;-)

							Thanx, Paul
