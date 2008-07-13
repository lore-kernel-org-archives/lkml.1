Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbYGMWph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbYGMWph (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 18:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753745AbYGMWp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 18:45:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:44351 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028AbYGMWp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 18:45:28 -0400
Subject: Re: Multiple MSI, take 3
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Matthew Wilcox <matthew@wil.cx>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "jgarzik@pobox.com" <jgarzik@pobox.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
       "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>
In-Reply-To: <m1iqv9a030.fsf@frodo.ebiederm.org>
References: <20080711005719.GO14894@parisc-linux.org>
	 <m1iqvc91li.fsf@frodo.ebiederm.org>
	 <20080711215943.GW1678@linux-os.sc.intel.com>
	 <m1d4lkauxc.fsf@frodo.ebiederm.org> <1215834720.7549.154.camel@pasglop>
	 <m13amf3eak.fsf@frodo.ebiederm.org> <1215848161.7549.166.camel@pasglop>
	 <m1iqv9a030.fsf@frodo.ebiederm.org>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 08:44:04 +1000
Message-Id: <1215989044.7549.219.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-07-13 at 15:30 -0700, Eric W. Biederman wrote:
> You are correct.  Using the existing irq handling logic will cause us
> to drop irqs and to loose information if two messages are sent close
> to each other.  Which is very nasty.
> 
> With a little care we can avoid that problem by having a 32 bit bitmap
> of which sub irqs have fired so we can make all of them pending
> without loosing information.  That does requires a new handle_irq
> method.

And we end up re-doing the logic that the core already provides ... for
individual irqs :-)

> One of the primary purposes of masking irqs in hardware is to prevent
> them from screaming.  Unlikely with edge triggered irqs but not a
> capability I would like to give up.

Have you seen screaming MSIs yet ? We -could- if necessary add a hook
to irq_chip for that case if it really ever happens...

> Multi-msi has the problem that cpu affinity can not be changed on a
> per message basis without an iommu.  Which is a portability problem
> and a problem on common architectures.

It's a minor problem I believe. It's mostly an API issue in fact, and
I'm happy to live with it rather than the other approach which sounds
just ... gross. Sorry but you are reproducing locally within an IRQ what
the whole IRQ is about to differenciate them in the first place.

It also makes it harder to remove the "irq" argument to handlers which
is something Jeff started looking into and that I quite like.

> Therefore to support multi-msi it must be handled as a special case,
> we can not treat the individual messages like normal irqs.

We can, that's what they are. They just are IRQs with -some-
restrictions on -some- platforms (mostly affinity on x86 and need to
soft-mask, which are fairly minor in my book).

Ben.


