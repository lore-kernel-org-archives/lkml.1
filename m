Return-Path: <linux-kernel-owner+w=401wt.eu-S1762708AbYEHONU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762708AbYEHONU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 10:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbYEHONM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 10:13:12 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:56994 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbYEHONK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 10:13:10 -0400
Message-ID: <48230A29.9020008@s5r6.in-berlin.de>
Date: Thu, 08 May 2008 16:11:53 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Alistair John Strachan <alistair@devzero.co.uk>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.26-rc1
References: <alpine.LFD.1.10.0805031205330.2971@woody.linux-foundation.org>	<20080504160904.GF19717@sgi.com>	<Pine.LNX.4.64.0805051656180.3218@bombadil.infradead.org>	<200805060902.25835.alistair@devzero.co.uk>	<20080506073134.424780a3@gaivota>	<48206C73.80509@s5r6.in-berlin.de>	<20080506161346.183f367c@gaivota>	<4820B524.5080100@s5r6.in-berlin.de>	<20080506170623.53732e78@gaivota>	<4820C3D8.6040403@s5r6.in-berlin.de>	<20080506193928.5acfc84d@gaivota>	<4820EB69.9090907@s5r6.in-berlin.de> <20080508094820.33ea42f4@gaivota>
In-Reply-To: <20080508094820.33ea42f4@gaivota>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab wrote:
> In the case of those tuners, all have the same dependencies:
> DVB or V4L and I2C. That's the reason why I've removed the
> individual dependencies.

Which I just wrote is dangerous.  It is easy to get wrong, and it is not
maintainable.

Here is what I would do:

config TUNER_1
	tristate "Tuner 1"
	depends on ACTUAL_DEP1_OF_T1 && ACTUAL_DEP2_OF_T1

config TUNER_2
	tristate "Tuner 2"
	depends on ACTUAL_DEP1_OF_T2 && ACTUAL_DEP2_OF_T2
	select ACTUAL_DEP3_OF_T2

In this example, ACTUAL_DEP3_OF_T2 does not have further dependencies
itself.

And if you believe that Kconfig should assist with runtime dependencies
too, not just build-time dependencies, and you believe that the "help"
and "comment" directives are insufficient for that, then add
meta-options like this:

config META_TUNER_A
	tristate "Meta-tuner A"
	select TUNER_1
	depends on ACTUAL_DEP1_OF_T1 && ACTUAL_DEP2_OF_T1  # for TUNER_1
	select TUNER_2
	depends on ACTUAL_DEP1_OF_T2 && ACTUAL_DEP2_OF_T2  # for TUNER_2
	select ACTUAL_DEP3_OF_T2                           # for TUNER_2
	help
	  Adds support for cards which contain tuner 1 and/or tuner 2.

So, like I said before, I recommend:

  - If an option has an actual build requirement, state it explicitly
    by "depends on" (or alternatively "select") directly at this option.

    Alternatively, enclose this option or a block of options which
    have identical dependencies in an "if"/ "endif" block, conditional
    on this common dependency.

  - Whenever you use "select", *copy* all dependencies of option A to
    option B if B selects A.

    Alternatively, replace "select" by "select ... if C" and *copy*
    all dependencies of option A to option C.

This is because the Kconfig files (1.) must correctly state all build
dependencies and (2.) must be maintainable.

If you "select" a lot, you will have of course a lot of dependencies to
copy.  That's the nature of "select".  You can't get around that.  Not
as long as there is no "select" which recursively checks and maybe
selects dependencies of dependencies.
-- 
Stefan Richter
-=====-==--- -=-= -=---
http://arcgraph.de/sr/
