Return-Path: <linux-kernel-owner+w=401wt.eu-S932079AbZJKMrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbZJKMrQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 08:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598AbZJKMrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 08:47:14 -0400
Received: from verein.lst.de ([213.95.11.210]:40308 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570AbZJKMrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 08:47:13 -0400
Date: Sun, 11 Oct 2009 14:46:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, xfs-masters@oss.sgi.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [xfs-masters] INFO: possible circular locking dependency detected
Message-ID: <20091011124616.GA4081@lst.de>
References: <alpine.LFD.2.00.0910110108160.4921@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0910110108160.4921@localhost.localdomain>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has been around for a long time, the VM calls into fput and thus
->release with the mmap_sem held, which makes it really hard for a
filesystem to avoid a lock inversion if it uses a lock both in ->release
and the I/O path.

I have a workaround for this to only acquire the XFS iolock with a
trylock in the release path and leave cleaning up stale preallocations
until the final iput.  It's not pretty, but given that we're unlikely
to see the VM fixed I might aswell finally send it for inclusion.

