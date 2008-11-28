Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbYK1TvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbYK1TvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 14:51:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYK1Tuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 14:50:54 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55433 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbYK1Tux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 14:50:53 -0500
To: Arjan van de Ven <arjan@infradead.org>
Cc: <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
       systemtap@sources.redhat.com
Subject: Re: dynamic function tracing
References: <20081128101922.451e254a@infradead.org>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Fri, 28 Nov 2008 14:50:47 -0500
Message-ID: <y0mk5anpr3c.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


arjan wrote:

> [...]  What I would like to do (read: usecase) is mark a function as
> interesting (because it has some performance issue or whatever), and
> then I want to get all functions it calls (recursive) traced
> automatically for the duration of that function. [...]

FWIW, the systemtap expression for this is:

# stap para-callgraph.stp 'kernel.function("FOO")' 'kernel.function("BAR")'

where "FOO" is a pattern matching all the interesting functions that
BAR might indirectly call, and BAR is a pattern matching the trigger
function(s), whose call lifetime the thread's FOO calls should be
included.  Some latent problems are still preventing kprobes-based
probes from working quite everywhere in the kernel, so FOO/BAR can't
yet be something quite as broad as kernel.function("*").  But
restricted to individual drivers or source subtrees, it tends to work.

On utrace-patched kernels and current systemtap, and dwarf debug info
all around, those patterns can also refer to user-space functions:

# stap para-callgraph.stp 'module("ext3").function("*")' 'process("ls").function("main")' -c ls

     0 ls(13543):->ext3_permission inode=0xffff88032e1b0190 mask=0x1 
     8 ls(13543): ->ext3_check_acl inode=0xffff88032e1b0190 mask=0x1 
    12 ls(13543):  ->ext3_get_acl inode=0xffff88032e1b0190 type=0x8000 
    16 ls(13543):   ->ext3_iget_acl inode=0xffff88032e1b0190 i_acl=0xffff88032e1b00d8 
    20 ls(13543):   <-ext3_iget_acl return=0x0 
    23 ls(13543):  <-ext3_get_acl return=0x0 
    26 ls(13543): <-ext3_check_acl return=0xfffffffffffffff5 
    29 ls(13543):<-ext3_permission return=0x0 
     0 ls(13543):->ext3_permission inode=0xffff88032e057b70 mask=0x1 
     4 ls(13543): ->ext3_check_acl inode=0xffff88032e057b70 mask=0x1 
     7 ls(13543):  ->ext3_get_acl inode=0xffff88032e057b70 type=0x8000 
    11 ls(13543):   ->ext3_iget_acl inode=0xffff88032e057b70 i_acl=0xffff88032e057ab8 
[...]
  6390 ls(13543):   ->ext3_check_dir_entry function=0xffffffffa00461a9 dir=0xffff88031b49b250 de=0xffff88031581fc58 bh=0xffff88031b46d580 offset=0x1c58 
  6393 ls(13543):   <-ext3_check_dir_entry return=0x1 
  6397 ls(13543):   ->ext3fs_dirhash name=0xffff88031581fc60 len=0xc hinfo=0xffff8802ea881d98 
  6401 ls(13543):    ->str2hashbuf msg=0xffff88031581fc60 len=0xc buf=0xffff8802ea881c68 num=0x4 
  6404 ls(13543):    <-str2hashbuf 
  6407 ls(13543):   <-ext3fs_dirhash return=0x0 
  6412 ls(13543):   ->ext3_htree_store_dirent dir_file=0xffff8801005bc480 hash=0x188f0bd6 minor_hash=0x4497695a dirent=0xffff88031581fc58 
  6416 ls(13543):    ->kzalloc size=0x3d flags=0xd0 
  6420 ls(13543):    <-kzalloc return=0xffff880172712770 
  6423 ls(13543):   <-ext3_htree_store_dirent return=0x0 
  6428 ls(13543):   ->ext3_check_dir_entry function=0xffffffffa00461a9 dir=0xffff88031b49b250 de=0xffff88031581fc6c bh=0xffff88031b46d580 offset=0x1c6c 
  6432 ls(13543):   <-ext3_check_dir_entry return=0x1 
[...]
   254 ls(13543):       <-ext3_get_group_desc return=0xffff880326e493e0 
   258 ls(13543):       ->constant_test_bit nr=0x0 addr=0xffff88029092a000 
   262 ls(13543):       <-constant_test_bit return=0x1 
   265 ls(13543):      <-__ext3_get_inode_loc return=0x0 
   268 ls(13543):     <-ext3_get_inode_loc return=0x0 
   273 ls(13543):     ->__ext3_journal_get_write_access where=0xffffffffa0044410 handle=0xffff88032508c000 bh=0xffff88029092a000 
   277 ls(13543):     <-__ext3_journal_get_write_access return=0x0 
   281 ls(13543):    <-ext3_reserve_inode_write return=0x0 
   286 ls(13543):    ->ext3_mark_iloc_dirty handle=0xffff88032508c000 inode=0xffff880162d62008 iloc=0xffff8802ea8818a8 
   290 ls(13543):     ->ext3_get_inode_flags ei=0xffff880162d61e78 
   293 ls(13543):     <-ext3_get_inode_flags 
   298 ls(13543):     ->__ext3_journal_dirty_metadata where=0xffffffffa0044430 handle=0xffff88032508c000 bh=0xffff88029092a000 
   302 ls(13543):     <-__ext3_journal_dirty_metadata return=0x0 
   306 ls(13543):     ->brelse bh=0xffff88029092a000 
   309 ls(13543):     <-brelse 
   312 ls(13543):    <-ext3_mark_iloc_dirty return=0x0 
   315 ls(13543):   <-ext3_mark_inode_dirty return=0x0 
   319 ls(13543):   ->__ext3_journal_stop where=0xffffffffa00443f0 handle=0xffff88032508c000 
   322 ls(13543):   <-__ext3_journal_stop return=0x0 
   325 ls(13543):  <-ext3_dirty_inode 
   329 ls(13543):  ->__ext3_journal_stop where=0xffffffffa0044780 handle=0xffff88032508c000 
   334 ls(13543):  <-__ext3_journal_stop return=0x0 
   337 ls(13543): <-ext3_ordered_write_end return=0x40 
   342 ls(13543):<-ext3_file_write return=0x40 

- FChE
