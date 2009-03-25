Return-Path: <linux-kernel-owner+w=401wt.eu-S1759144AbZCYLAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759144AbZCYLAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 07:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756723AbZCYLA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 07:00:29 -0400
Received: from mail09.linbit.com ([212.69.161.110]:45545 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbZCYLA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 07:00:29 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 02/12] DRBD: activity_log
Date: Wed, 25 Mar 2009 11:57:27 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
References: <1237823287-12734-1-git-send-email-philipp.reisner@linbit.com> <200903251127.23287.philipp.reisner@linbit.com> <20090325104641.GB11935@one.firstfloor.org>
In-Reply-To: <20090325104641.GB11935@one.firstfloor.org>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903251157.27549.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 March 2009 11:46:41 Andi Kleen wrote:
> > > > +	mutex_lock(&mdev->md_io_mutex); /* protects md_io_buffer,
> > > > al_tr_cycle, ... */
> > >
> > > Doing checksumming inside a lock looks nasty.
> >
> > Well, that is a mutex, not a spinlock. We need to hold that lock here,
>
> Yes it's independent. If it takes a lot of CPU time you'll likely have
> a bottle neck. It's normally a bad idea to do anything CPU intensive
> under a lock covering more than your current limited object.
>

We are talking about this checksum and copy to IO page loop:

	for (i = 0; i < mx; i++) {
		extent_nr = lc_entry(mdev->act_log,
				     mdev->al_tr_cycle+i)->lc_number;
		buffer->updates[i+1].pos = cpu_to_be32(mdev->al_tr_cycle+i);
		buffer->updates[i+1].extent = cpu_to_be32(extent_nr);
		xor_sum ^= extent_nr;
	}
	for (; i < AL_EXTENTS_PT; i++) {
		buffer->updates[i+1].pos = __constant_cpu_to_be32(-1);
		buffer->updates[i+1].extent = __constant_cpu_to_be32(LC_FREE);
		xor_sum ^= LC_FREE;
	}

Without being a CPU expert, my guess is that the single XOR instruction
is carried out while the CPU stalls waiting for the next load instruction
to complete.

Sorry, I still do not take the argument that this is "CPU intensive".

-Phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.

