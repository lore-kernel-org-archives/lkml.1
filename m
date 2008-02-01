Return-Path: <linux-kernel-owner+w=401wt.eu-S965089AbYBAAOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965089AbYBAAOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 19:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbYBAAOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 19:14:09 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:51306
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbYBAAOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 19:14:08 -0500
Date: Fri, 1 Feb 2008 01:13:55 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: mmu_notifier: Move mmu_notifier_release up to get rid of the
	invalidat_all() callback
Message-ID: <20080201001355.GU7185@v2.random>
References: <20080131045750.855008281@sgi.com> <20080131045812.785269387@sgi.com> <20080131123118.GK7185@v2.random> <Pine.LNX.4.64.0801311355260.27804@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0801311421110.22290@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801311421110.22290@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 02:21:58PM -0800, Christoph Lameter wrote:
> Is this okay for KVM too?

->release isn't implemented at all in KVM, only the list_del generates
complications.

I think current code could be already safe through the mm_count pin,
becasue KVM relies on the fact anybody pinning through mm_count like
KVM does, is forbidden to call unregister and it's forced to wait the
auto-disarming when mm_users hits zero, but I feel like something's
still wrong if I think that I'm not using call_rcu to free the
notifier (OTOH we agreed the list had to be frozen and w/o readers
(modulo _release) before _release is called, so if this initial
assumption is ok it seems I may be safe w/o call_rcu?).

But it's really tricky path. Anyway this is the last of my worries
right now, it works perfectly fine with a single user obviously, and
the moment KVM threads runs remotely through GRU/XPMEM isn't happening
too soon ;) so let's concentrate on the rest first. I can say
hlist_del_init doesn't seem to provide any benefit given nobody could
possibly decide to call register or unregister after _release run.
