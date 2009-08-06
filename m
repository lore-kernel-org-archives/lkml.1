Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbZHFN5C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbZHFN5C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 09:57:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755922AbZHFN5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 09:57:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61902 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919AbZHFN5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 09:57:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Gregory Haskins <ghaskins@novell.com>
Subject: Re: [PATCH 1/7] shm-signal: shared-memory signals
Date: Thu, 6 Aug 2009 15:56:55 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.2.98; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net,
       netdev@vger.kernel.org
References: <20090803171030.17268.26962.stgit@dev.haskins.net> <20090803171735.17268.37490.stgit@dev.haskins.net>
In-Reply-To: <20090803171735.17268.37490.stgit@dev.haskins.net>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908061556.55390.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Or/4tm4pTsKne3dyZLPDTdmOQwratO4Ehwda
 tXohoO81uSaAdJkA+RZy5MC2pK++qANVTwqnxKiBXJ2iOXiSWR
 V4ZoChbekBFHCSQIljSrA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 August 2009, Gregory Haskins wrote:
> shm-signal provides a generic shared-memory based bidirectional
> signaling mechanism.  It is used in conjunction with an existing
> signal transport (such as posix-signals, interrupts, pipes, etc) to
> increase the efficiency of the transport since the state information
> is directly accessible to both sides of the link.  The shared-memory
> design provides very cheap access to features such as event-masking
> and spurious delivery mititgation, and is useful implementing higher
> level shared-memory constructs such as rings.

Looks like a very useful feature in general.

> +struct shm_signal_irq {
> +       __u8                  enabled;
> +       __u8                  pending;
> +       __u8                  dirty;
> +};

Won't this layout cause cache line ping pong? Other schemes I have
seen try to separate the bits so that each cache line is written to
by only one side. This gets much more interesting if the two sides
are on remote ends of an I/O link, e.g. using a nontransparent
PCI bridge, where you only want to send stores over the wire, but
never fetches or even read-modify-write cycles.

Your code is probably optimal if you only communicate between host
and guest code on the same CPU, but not so good if it crosses NUMA
nodes or worse.

> +struct shm_signal_desc {
> +       __u32                 magic;
> +       __u32                 ver;
> +       struct shm_signal_irq irq[2];
> +};

This data structure has implicit padding of two bytes at the end.
How about adding another '__u16 reserved' to make it explicit?

> +	/*
> +	 * We always mark the remote side as dirty regardless of whether
> +	 * they need to be notified.
> +	 */
> +	irq->dirty = 1;
> +	wmb();   /* dirty must be visible before we test the pending state */
> +
> +	if (irq->enabled && !irq->pending) {
> +		rmb();
> +
> +		/*
> +		 * If the remote side has enabled notifications, and we do
> +		 * not see a notification pending, we must inject a new one.
> +		 */
> +		irq->pending = 1;
> +		wmb(); /* make it visible before we do the injection */
> +
> +		s->ops->inject(s);
> +	}

Barriers always confuse me, but the rmb() looks slightly wrong. AFAIU
it only prevents reads after the barrier from being done before the
barrier, but you don't do any reads after it.

The (irq->enabled && !irq->pending) check could be done before the
irq->dirty = 1 arrives at the bus, but that does not seem to hurt, it
would at most cause a duplicate ->inject().

Regarding the scope of the barrier, did you intentionally use the
global versions (rmb()/wmb()) and not the lighter single-system
(smp_rmb()/smp_wmb()) versions? Your version should cope with remote
links over PCI but looks otherwise optimized for local use, as I
wrote above.

	Arnd <><
