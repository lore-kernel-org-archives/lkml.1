Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbZHLOAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbZHLOAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 10:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbZHLOAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 10:00:45 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:52707 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752074AbZHLOAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 10:00:44 -0400
Subject: Re: [RFC PATCH] kbuild: Do not select symbols with unmet
	dependencies
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <200908121436.58490.arnd@arndb.de>
References: <20090812112308.30683.24700.stgit@pc1117.cambridge.arm.com>
	 <200908121436.58490.arnd@arndb.de>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 12 Aug 2009 15:00:24 +0100
Message-Id: <1250085624.20332.48.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Aug 2009 14:00:25.0714 (UTC) FILETIME=[3DD6D520:01CA1B55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-12 at 14:36 +0200, Arnd Bergmann wrote:
> On Wednesday 12 August 2009, Catalin Marinas wrote:
> > The "select" statement in Kconfig files allows the enabling of options
> > even if they have unmet direct dependencies (i.e. "depends on" expands
> > to "no"). Currently, the "depends on" clauses are used in calculating
> > the visibility but they do not affect the reverse dependencies in any
> > way.
> > 
> > The patch introduces additional tracking of the "depends on" statements
> > and does not allow selecting an option if its direct dependencies are
> > not met, also printing a warning.
> > 
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Sam Ravnborg <sam@ravnborg.org>
> 
> I guess this will change the behaviour of a number of subsystems,
> likely causing unexpected regressions. I think your change
> makes sense, but we need to be much more careful.

It would indeed cause regressions, that's why I'm only asking for
comments currently.

> Can you extract a list of configuration symbols that are
> impacted by your patch?

I can generate a list with allyesconfig but it looks like it breaks some
common usage in Linux. For example, the VIDEO_* entries in
drivers/media/video/Kconfig under the "Encoders/decoders and other
helper chips" menu automatically inherit a dependency on
!VIDEO_HELPER_CHIPS_AUTO. This option is enabled to allow other config
options to select whatever they need. But it would fail with my patch
because of the direct dependency of the VIDEO_* options on
!VIDEO_HELPER_CHIPS_AUTO.

It needs a bit more thinking here and maybe writing something like:

menu "..." if !VIDEO_HELPER_CHIPS_AUTO

rather than

menu "..."
	depends on !VIDEO_HELPER_CHIPS_AUTO

though the parser (after modifying the zconf.y to handle this) seems to
consider both dependencies at the same level

-- 
Catalin

