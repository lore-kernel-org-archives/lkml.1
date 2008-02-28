Return-Path: <linux-kernel-owner+w=401wt.eu-S1762130AbYB1ALl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762130AbYB1ALl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 19:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932068AbYB1ALP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:11:15 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:33508
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760095AbYB1ALO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:11:14 -0500
Date: Thu, 28 Feb 2008 01:11:04 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, akpm@linux-foundation.org,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address
	ranges
Message-ID: <20080228001104.GB8091@v2.random>
References: <20080215064859.384203497@sgi.com> <20080215064932.620773824@sgi.com> <200802201008.49933.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0802271424390.13186@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802271424390.13186@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 02:35:59PM -0800, Christoph Lameter wrote:
> Could you be specific? This refers to page migration? Hmmm... Guess we 

If the reader schedule, the synchronize_rcu will return in the other
cpu and the objects in the list will be freed and overwritten, and
when the task is scheduled back in, it'll follow dangling pointers...
You can't use RCU if you want any of your invalidate methods to
schedule. Otherwise it's like having zero locking.

> 2. Not handle file backed mappings (XPmem could work mostly in such a 
> config)

IMHO that fits under your definition of "hacking something in now and
then having to modify it later".

> 3. Keep the refcount elevated until pages are freed in another execution 
> context.

Page refcount is not enough (the mmu_notifier_release will run in
another cpu the moment after i_mmap_lock is unlocked) but mm_users may
prevent us to change the i_mmap_lock to a mutex, but it'll slowdown
truncate as it'll have to drop the lock and restart the radix tree
walk every time so a change like this better fits as a separate
CONFIG_XPMEM IMHO.
