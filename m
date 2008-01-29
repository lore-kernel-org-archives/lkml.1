Return-Path: <linux-kernel-owner+w=401wt.eu-S1764041AbYA2Oej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764041AbYA2Oej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 09:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764898AbYA2Oe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 09:34:26 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:58092
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758298AbYA2OeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 09:34:24 -0500
Date: Tue, 29 Jan 2008 15:34:17 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 1/6] mmu_notifier: Core code
Message-ID: <20080129143417.GI7233@v2.random>
References: <20080128202840.974253868@sgi.com> <20080128202923.609249585@sgi.com> <20080129135914.GF7233@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129135914.GF7233@v2.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 02:59:14PM +0100, Andrea Arcangeli wrote:
> The down_write is garbage. The caller should put it around
> mmu_notifier_register if something. The same way the caller should
> call synchronize_rcu after mmu_notifier_register if it needs
> synchronous behavior from the notifiers. The default version of
> mmu_notifier_register shouldn't be cluttered with unnecessary locking.

Ooops my spinlock was gone from the notifier head.... so the above
comment is wrong sorry! I thought down_write was needed to serialize
against some _external_ event, not to serialize the list updates in
place of my explicit lock. The critical section is so small that a
semaphore is the wrong locking choice, that's why I assumed it was for
an external event. Anyway RCU won't be optimal for a huge flood of
register/unregister, I agree the down_write shouldn't create much
contention and it saves 4 bytes from each mm_struct, and we can always
change it to a proper spinlock later if needed.
