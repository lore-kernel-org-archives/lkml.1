Return-Path: <linux-kernel-owner+w=401wt.eu-S1759434AbXLLQlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434AbXLLQlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 11:41:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756493AbXLLQkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 11:40:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756503AbXLLQky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 11:40:54 -0500
Date: Wed, 12 Dec 2007 11:40:13 -0500
From: Dave Jones <davej@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [crash] kernel BUG at drivers/cpufreq/cpufreq.c:1060!
Message-ID: <20071212164013.GA2359@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	"Rafael J. Wysocki" <rjw@sisk.pl>
References: <20071212091144.GA11986@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071212091144.GA11986@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 10:11:44AM +0100, Ingo Molnar wrote:

 > 2.6.24-rc4-git5, got this cpufreq crash on x86 64-bit, during 'make 
 > randconfig' random bootup testing:

You hit all the fun bugs.

Just before we initialise cpufreqs notifier list..

 > Testing NMI watchdog ... <4>WARNING: CPU#0: NMI appears to be stuck (0->0)!

eek?

 > powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ processors (1 cpu cores) (version 2.20.00)
 > powernow-k8: BIOS error - no PSB or ACPI _PSS objects
 > ------------[ cut here ]------------
 > kernel BUG at drivers/cpufreq/cpufreq.c:1060!

The actual BUG you hit is 

        if (unlikely(lock_policy_rwsem_write(cpu)))
                BUG();

It _looks_ like we're leaking a refcount on that lock, but
I don't see where.  It's a shame you can't reproduce this easily,
as cpufreq.debug=7 would give us more clues.
(And CONFIG_CPUFREQ_DEBUG=y)

I'll think about this some more.

	Dave

-- 
http://www.codemonkey.org.uk
