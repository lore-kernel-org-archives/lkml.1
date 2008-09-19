Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbYISRms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbYISRms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 13:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbYISRmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 13:42:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:57582 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbYISRmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 13:42:39 -0400
Subject: PTE access rules & abstraction
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linux Memory Management List <linux-mm@kvack.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Hugh Dickins <hugh@veritas.com>
Content-Type: text/plain
Date: Fri, 19 Sep 2008 10:42:19 -0700
Message-Id: <1221846139.8077.25.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

Just yesterday, I was browsing through the users of set_pte_at() to
check something, and stumbled on a (new ?) bug that will introduce
subtle problems on at least powerpc and s390.

No big deal, I'll send a fix, but I'm becoming concerned with how
fragile our page table & PTE access has become.

(The bug btw is that we ptep_get_and_clear followed by a set_pte_at, at
least on those architectures, you -must- flush before you put something
new after you have cleared a PTE, I'll have to fixup our implementation
of the new pte_modify_start/commit).

With the need of the various virtual machines on x86, we've seen new
page table accessors being created like there is no tomorrow, changes in
the PTEs are accessed that may or may not be things we can rely on being
stable in arch code, etc...

Unfortunately, the arch code often has a very intimate relationship to
how page tables are handled. The rules for locking, what can and cannot
be done within a single PTE lock section, what can or cannot be done on
a PTE, for example after it's been cleared, etc... vary in subtle ways
and the way the things are today, the situation is very messy and
fragile.

Maybe it's time to have one head in "charge" of the page table access to
try to keep some sanity, maybe it's time to write down some rules (for
example, can we rely now and forever that set_pte_at() will -never- be
called to write on top of an already valid PTE ?, etc...).

But maybe it's time to try to move the abstraction up a bit, maybe along
the lines of what Nick proposed a while ago, some kind of transactional
model. That would give a lot more freedom to architectures to have their
own PTE access rules and optimisations. 

Comments ? Ideas ?

Cheers,
Ben.

