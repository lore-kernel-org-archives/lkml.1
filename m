Return-Path: <linux-kernel-owner+w=401wt.eu-S1753294AbZKQUws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbZKQUws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 15:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbZKQUws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 15:52:48 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:49558 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZKQUwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 15:52:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=mBVAz0QNjxGgoK2M76ONNhDmccIBcFKWb4EI+Oce2pFsXYPpsVdBZuk9lkxWH4qk9T
         IrDxgpUSDoun8bmyGqbT+snMTVo9kDgh3o4CyNuqt/xEHZrUrMoByZh7Rdj46fHLbsUn
         TjAi+7aUDNgXKyxBaKA4y0uUNU3fENrBERsI0=
MIME-Version: 1.0
Date: Tue, 17 Nov 2009 22:52:51 +0200
Message-ID: <b64f365b0911171252q42a0c102jddb2cd29af64a7a7@mail.gmail.com>
Subject: [RFC] Using "page credits" as a solution for common thrashing 
	scenarios
From: Eyal Lotem <eyal.lotem@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I apologize for not sending a patch, but I am not yet skilled enough with
Linux kernel hacking to stop with the cheap talk and show you the code.

I have encountered numerous times the following situation:

  * Small processes A, B, C happily functioning on the system (e.g: bash,
    xterm, etc).

  * Large misbehaving process D (e.g firefox) is launched, and due to
    a bug or other issue, begins to allocate and write to an extremely
    large memory working set.

  * The entire operating system and all processes become highly
    unresponsive. Sometimes to the point where I cannot even kill the
    problematic process.  SysRq keys still work, but those are usually too
    coarse.  Sometimes the OOM will start firing at random.

My analysis of this:

  * I believe that process D in this scenario is basically causing the
    kernel MM to evict all of the pages of the well-behaving A, B, C
    processes.

  * I think it is wrong for the kernel to evict the 15 pages of the bash,
    xterm, X server's working set, as an example, in order for a
    misbehaving process to have 1000015 instead of 1000000 pages in its
    working set. EVEN if that misbehaving process is accessing its working
    set far more aggressively.

Suggested solution:

 If my analysis isn't off, then I believe the following solution might
 mitigate the problem elegantly.

 1. Maintain a per-process Most-Recently-Used (MRU) page listing. This
    listing is allowed to be approximate (e.g: by use of the page table's
    Accessed and Dirty bits).

 2. Assign a number of "page credits" to each process (sort of a memory
    "niceness" level) which the kernel automatically disperses on the MRU
    pages of that process.  When the MRU set changes, the "page credits"
    are *moved* from LRU entries to new MRU entries.

 3. Each physical page accumulates all of the "page credits" of the various
    processes that use it in their MRU.  This allows shared pages to
    accumulate more credit when they are useful for more processes.

 4. Page eviction should still be global (not per-process) but should evict
    pages whose accumulated "page credits" count is lowest.

 5. per-process "page credit" levels can be maintained by user-space (using
    setrlimit or such). It probably makes sense for fork() to split the
    "page credit" levels and not duplicate them (and spawn new page credits
    out of nowhere).  While having a good way to specify per-process "page
    credits" could improve things, I don't believe it is critical to do
    this accurately in order for this to effectively prevent thrashing.

Rationale: The usefulness of a page also stems from how big of a percentage
  it is of it's user process working set.  If a single page is the entire
  working set of a process, evicting that single page is most costly than
  even evicting 100 pages of another process if that other process's
  working set is extremely large.

Highly simplified example of suggested solution (numbers are made up):

NOTE: The example does not include shared library memory use and various
other details (I do believe this solution handles those elegantly), to
avoid clutter.

 1. 3 bash processes are assigned 1 million credits each, and each of them
    use a shared 10 pages (e.g mmap'd code) and another 40 unique pages in
    their MRU working set.

    The kernel automatically assigns 20,000 credits (1M / 50) to each of
    the pages in each bash process.  The shared 10 physical pages will
    accumulate 60,000 credits each.  Each of the 120 (40 * 3) unique
    physical pages accumulates 20,000 credits.

 2. xterm, X processes are assigned 1 million credits each, and each of
    them use 200 unique pages.

    The kernel automatically assigns 5,000 credits to each of the unique
    pages, so the physical pages accumulate 5,000 credits each.

 3. a firefox process is too assigned 1 million credits. It aggressively
    allocates and writes to as many pages as the kernel allows.  Instead of
    starting to evict the above processes (bash's, xterm's, X's) which
    hinder responsiveness to the user, the kernel will find the physical
    pages with the least amount of "credits" to evict.

 4. Assuming firefox has already allocated 1 million pages before eviction
    is required, the eviction decision is faced with the following data:

    * 10 physical pages shared by the bash processes, each have 60,000
      credits.

    * 120 physical pages (40 x 3 unique pages of the bash processes), each
      with 20,000 credits.

    * 400 physical pages (of xterm and X) with 5,000 credits each.

    * 1 million physical pages (of firefox) with 1 credit each.

 5. The kernel has a "no-brainer" choice here. Instead of effectively
    pausing all of the behaving processes in order to allocate a few more
    pages for firefox, it can and should make firefox pay for its
    wastefulness.  It will evict firefox's old pages to make room for
    firefox's new pages.

    In effect, firefox's DOS attack here (on the physical page resource)
    will attack only firefox itself, and not the rest of the system.
    Firefox's DOS attack on disk I/O and other resources is still underway
    (Perhaps requiring a different solution).
