Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbYBGF6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbYBGF6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 00:58:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbYBGF5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 00:57:55 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56417 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752106AbYBGF5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 00:57:54 -0500
Date: Wed, 6 Feb 2008 21:58:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] CPU isolation extensions
Message-Id: <20080206215805.17a0c919.akpm@linux-foundation.org>
In-Reply-To: <47AA9807.7090402@qualcomm.com>
References: <47AA9807.7090402@qualcomm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Feb 2008 21:32:55 -0800 Max Krasnyansky <maxk@qualcomm.com> wrote:

> Linus, please pull CPU isolation extensions from
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/maxk/cpuisol-2.6.git for-linus

The feature as a whole seems useful, and I don't actually oppose the merge
based on what I see here.  As long as you're really sure that cpusets are
inappropriate (and bear in mind that Paul has a track record of being wrong
on this :)).  But I see a few glitches


- There are two separate and identical implementations of
  cpu_unusable(cpu).  Please do it once, in a header, preferably with C
  function, not macros.

- The Kconfig help is a bit scraggly:

+config CPUISOL_STOPMACHINE
+	bool "Do not halt isolated CPUs with Stop Machine (HIGHLY EXPERIMENTAL)"
+	depends on CPUISOL && STOP_MACHINE && EXPERIMENTAL
+	help
+          If this option is enabled kernel will not halt isolated CPUs when Stop Machine

"the kernel"

text is too wide

+          is triggered.
+          Stop Machine is currently only used by the module insertion and removal logic.
+          Please note that at this point this feature is highly experimental and maybe
+          dangerous. It is not known to really brake anything but can potentially 
+          introduce an instability.

s/maybe/may be/
s/brake/break/


Neither this text, nor the changelog nor the code comments tell us what the
potential instability with stopmachine *is*?  Or maybe I missed it.

- Adding new sysfs files without updating Documentation/ABI/ makes Greg
  cry.

- Why is cpu_isolated_map exported to modules?  Just for api consistency,
  it appears?


pre-existing problems:

- isolated_cpu_setup() has an on-stack array of NR_CPUS integers.  This
  will consume 4k of stack on ia64 (at least).  We'll just squeak through
  for a ittle while, but this needs to be fixed.  Just move it into
  __initdata.

- isolated_cpu_setup() expects that the user can provide an up-to-1024
  character kernel boot parameter.  Is this reasonable given cpu command
  line limits, and given that NR_CPUS will surely grow beyond 1024 in the
  future?


