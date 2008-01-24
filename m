Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbYAXM0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbYAXM0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 07:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbYAXM01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 07:26:27 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:37586
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbYAXM00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 07:26:26 -0500
Date: Thu, 24 Jan 2008 13:26:23 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Avi Kivity <avi@qumranet.com>
Cc: Christoph Lameter <clameter@sgi.com>, Robin Holt <holt@sgi.com>,
       Izik Eidus <izike@qumranet.com>, Andrew Morton <akpm@osdl.org>,
       Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [kvm-devel] [PATCH] export notifier #1
Message-ID: <20080124122623.GK7141@v2.random>
References: <4795F9D2.1050503@qumranet.com> <20080122144332.GE7331@v2.random> <20080122200858.GB15848@v2.random> <Pine.LNX.4.64.0801221232040.28197@schroedinger.engr.sgi.com> <20080122223139.GD15848@v2.random> <Pine.LNX.4.64.0801221433080.2271@schroedinger.engr.sgi.com> <479716AD.5070708@qumranet.com> <20080123105246.GG26420@sgi.com> <Pine.LNX.4.64.0801231145210.13547@schroedinger.engr.sgi.com> <4798289B.1000007@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4798289B.1000007@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 07:56:43AM +0200, Avi Kivity wrote:
> What I need is a list of (mm, va) that map the page.  kvm doesn't have 
> access to that, export notifiers do.  It seems reasonable that export 
> notifier do that rmap walk since they are part of core mm, not kvm.

Yes. Like said in earlier email we could ignore the slowdown and
duplicate the mm/rmap.c code inside kvm, but that looks a bad layering
violation and it's unnecessary, dirty and suboptimal IMHO.

> Alternatively, kvm can change its internal rmap structure to be page based 
> instead of (mm, hva) based.  The problem here is to size this thing, as we 
> don't know in advance (when the kvm module is loaded) whether 0% or 100% 
> (or some value in between) of system memory will be used for kvm.

Another issue is that for things like the page sharing driver, it's
more convenient to be able to know exactly which "sptes" belongs to a
certain userland mapping, and only that userland mapping (not all
others mappings of the physical page). So if the rmap becomes page
based, it'd be nice to still be able to find the "mm" associated with
that certain spte pointer to skip all sptes in the other "mm" during
the invalidate.
