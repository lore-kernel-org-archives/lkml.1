Return-Path: <linux-kernel-owner+w=401wt.eu-S1757195AbYDHWGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbYDHWGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 18:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755168AbYDHWGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 18:06:32 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:56069
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbYDHWGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 18:06:31 -0400
Date: Wed, 9 Apr 2008 00:06:27 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Avi Kivity <avi@qumranet.com>
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       Nick Piggin <npiggin@suse.de>, Steve Wise <swise@opengridcomputing.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Kanoj Sarcar <kanojsarcar@yahoo.com>, Roland Dreier <rdreier@cisco.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       kvm-devel@lists.sourceforge.net, Robin Holt <holt@sgi.com>,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH 0 of 9] mmu notifier #v12
Message-ID: <20080408220627.GP10133@duo.random>
References: <patchbomb.1207669443@duo.random> <47FBE7C9.9000701@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FBE7C9.9000701@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2008 at 12:46:49AM +0300, Avi Kivity wrote:
> That's unusual.  What happens to the notifier?  Suppose I destroy a vm 

Yes it's quite unusual.

> without exiting the process, what happens if it fires?

The mmu notifier ops should stop doing stuff (if there will be no
memslots they will be noops), or the ops can be replaced atomically
with null pointers. The important thing is that the module can't go
away until ->release is invoked or until mmu_notifier_unregister
returned 0.

Previously there was no mmu_notifier_unregister, so adding it can't be
a regression compared to #v11, even if it can fail and you may have to
retry later after returning to userland. Retrying from userland is
always safe in oom kill terms, only looping inside the kernel isn't
safe as do_exit has no chance to run.
