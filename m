Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbZBIJWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbZBIJWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 04:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452AbZBIJWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 04:22:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39240 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbZBIJWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 04:22:32 -0500
Date: Mon, 9 Feb 2009 10:22:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kyle McMartin <kyle@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       ralf@linux-mips.org, mingo@redhat.com
Subject: Re: x86: spinlocks: define dummy __raw_spin_is_contended
Message-ID: <20090209092221.GG31890@elte.hu>
References: <20090208180341.GC11398@bombadil.infradead.org> <20090208223958.GA19888@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090208223958.GA19888@bombadil.infradead.org>
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


* Kyle McMartin <kyle@infradead.org> wrote:

> CC-ing Linus, since he just released 2.6.29-rc4, which will fail to
> build btrfs on anything besides mips or x86.

Hm, i'm not particularly fond of the spin_is_contended() trickery done in:

/*
 * btrfs_search_slot uses this to decide if it should drop its locks
 * before doing something expensive like allocating free blocks for cow.
 */
int btrfs_path_lock_waiting(struct btrfs_path *path, int level)
{
        int i;
        struct extent_buffer *eb;

        for (i = level; i <= level + 1 && i < BTRFS_MAX_LEVEL; i++) {
                eb = path->nodes[i];
                if (!eb)
                        break;
                smp_mb();
                if (spin_is_contended(&eb->lock) ||
                    waitqueue_active(&eb->lock_wq))
                        return 1;
        }
        return 0;
}

It does not look particularly cheap either, if the number of levels is high.

I'd suggest we remove that hack please and live or die by what performance
the generic locking code gives us - and fix it when it causes problems,
instead of working it around locally?

As spin-mutexes have shown (queued up for .30), working on that level is far
more rewarding in terms of improving Linux as a whole.

	Ingo
