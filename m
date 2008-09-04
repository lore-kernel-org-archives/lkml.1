Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbYIDO5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbYIDO5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 10:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbYIDO44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 10:56:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59143 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbYIDO44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 10:56:56 -0400
Date: Thu, 4 Sep 2008 16:56:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       arozansk@redhat.com, dzickus@redhat.com, Thomas.Mingarelli@hp.com,
       ak@linux.intel.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH RFC] NMI Re-introduce un[set]_nmi_callback
Message-ID: <20080904145617.GB28095@elte.hu>
References: <20080904130048.31841.3329.sendpatchset@prarit.bos.redhat.com> <1220535463.8609.223.camel@twins> <48BFF0C0.7060208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48BFF0C0.7060208@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Prarit Bhargava <prarit@redhat.com> wrote:

>> Why is the DIE_NMIWATCHDOG notifier not sufficient for this driver?
>
> Peter -- good question.  The HP systems with this HW will use the 
> hpwdt driver in place of the default nmi watchdog.  When the HW 
> detects a problem, the HW will generate a single NMI that the driver 
> will handle.  The driver doesn't want the NMI to be rejected due to a 
> reason code.  I'm sure that Thomas Mingarelli, who is cc'd, can 
> provide further details.
>
> From our quick conversation as well, you raised an interesting point 
> about oprofile, kgdb, and other subsystems that use the NMI notifier 
> chains -- they may be impacted by the NMI callback.
>
> Don (dzickus) or Aris, do you have any thoughts on how to get around 
> the second issue?  We could check to see if anything is registered on 
> the notifier chain and the fail to register the callback.

i'd much rather attack this general problem from this angle:

  static inline unsigned char get_nmi_reason(void)
  {
          return inb(0x61);
  }

that port 61H read is both arcane (on modern chipsets) and broken on 
multiple levels. It's racy and SMP unsafe to begin with, if there's any 
mixture of intentional cross-CPU or CPU self-generated NMIs mixed with 
chipset generated NMIs.

One possible approach would be to get rid of it, and to perhaps register 
a low-priority die notifier on systems where we know port 61 
reads+writes to be safe and desired. Modern systems will emit MCEs in 
most cases anyway, not NMIs.

	Ingo
