Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbZGFWDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbZGFWDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 18:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbZGFWDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 18:03:40 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:64549 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbZGFWDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 18:03:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=e91jno3N74UfAq09X3AsG9164WkFFJb2EJs9aa593bVD/96Ka5H1jZIOFyVIbLWgcP
         9d6XoSUYuqIYn8MgVhpq3MTSaR2k5kowRRal5kbaz9F2tuBXG2BErc9yjXp+UTcZg6yx
         J/T9tDunj/9UKW7nhLtny9fhXx5HCj4dbz2+k=
MIME-Version: 1.0
Date: Mon, 6 Jul 2009 23:03:42 +0100
X-Google-Sender-Auth: d2ff4a89c363db2b
Message-ID: <b0943d9e0907061503r7a89a4e2lb5bc76b89e3e8ca6@mail.gmail.com>
Subject: Possible memory leak via inotify_add_watch
From: Catalin Marinas <catalin.marinas@arm.com>
To: Eric Paris <eparis@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

I'm getting a few kmemleak reports like the one below (it may as well
be just a false positive). All of these allocations happened during
udevd.

unreferenced object 0xc399fd80 (size 84):
  comm "udevd", pid 879, jiffies 4294897228
  backtrace:
    [<c01e0c3a>] create_object+0xfa/0x250
    [<c01e1e7d>] kmemleak_alloc+0x5d/0x70
    [<c01dac1b>] kmem_cache_alloc+0x14b/0x190
    [<c0213800>] sys_inotify_add_watch+0xc0/0x2a0
    [<c010300c>] sysenter_do_call+0x12/0x38
    [<ffffffff>] 0xffffffff

Printing this object with gdb on /proc/kcore shows:

(gdb) print {struct inotify_inode_mark_entry}0xc399fd80
$2 = {fsn_entry = {mask = 134250504, refcnt = {counter = 1}, inode = 0x0,
    group = 0x0, i_list = {next = 0x0, pprev = 0x0}, g_list = {
      next = 0xc399fd98, prev = 0xc399fd98}, lock = {raw_lock = {
        slock = 1028}, magic = 3735899821, owner_cpu = 4294967295,
      owner = 0xffffffff, dep_map = {key = 0xc0d3e59c, class_cache = 0x0,
        name = 0xc068413d "&entry->lock"}}, free_i_list = {next = 0x6b6b6b6b,
      prev = 0x6b6b6b6b}, free_g_list = {next = 0x6b6b6b6b,
      prev = 0x6b6b6b6b}, free_mark = 0xc0213720 <inotify_free_mark>}, wd = 28}

It seems that is was freed via fsnotify_destroy_mark_by_entry() since
group and inode members are NULL and it was removed from any list. The
fsn_entry.refcnt, however, is still 1. Kmemleak cannot find any
pointer to this object (though it doesn't track alloc_pages memory
blocks).

Thanks.

-- 
Catalin
