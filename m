Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbYAJJb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbYAJJb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 04:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbYAJJbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 04:31:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58001 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907AbYAJJbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 04:31:49 -0500
Date: Thu, 10 Jan 2008 10:31:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       suresh.b.siddha@intel.com, Arjan van de Ven <arjan@infradead.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: CPA patchset
Message-ID: <20080110093126.GA360@elte.hu>
References: <20080103424.989432000@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103424.989432000@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andi,

finally managed to get the time to review your CPA patchset, and i 
fundamentally agree with most of the detail changes done in it. But here 
are a few structural high-level observations:

- firstly, there's no rationale given. So we'll change ioremap()/etc.
  from doing a cflush-range instruction instead of a WBINVD. But why?
  WBINVD isnt particular fast (takes a few msecs), but why is that a
  problem? Drivers dont do high-frequency ioremap-ing. It's typically
  only done at driver/device startup and that's it. Whether module load
  time takes 1254 msecs instead of 1250 msecs is no big deal.

- secondly, obviously doing a 'flush some' instead of a 'flush all' 
  operation is risky. There's not many ways we can get the 'flush all'
  WBINVD instruction wrong (as long as we do it on all cpus, etc.). But 
  with this specific range flush we've got all the risks of accidentally
  not flushing _enough_. Especially if some boundary of a mapped area is 
  imprecisely. Accidentally leaving aliases around in the cache is
  asking for trouble as it's very hard to debug and the operations here
  (ioremap) are typically done only once per system bootup. So we'll add
  _fundamental_ fragility to an already historically fragile and 
  bug-ridden piece of code. That does not sound too smart to me and you 
  do not analyze these concerns in your submission.

- the bugfixes and cleanups to pgattr.c i like very much - but shouldnt
  they come first in the series, instead of being mixed into it?

so i'd suggest for you to reshape this ontop of the PAT patchset done by 
Venki and Suresh, with the cflush stuff kept at the very end of the 
series, and even that should be boot and .config configurable, with 
default off - at least initially. The cflush performance advantages seem 
dubious at best, and they bring in very real regression dangers.

	Ingo
