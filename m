Return-Path: <linux-kernel-owner+w=401wt.eu-S1752360AbXCAMuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbXCAMuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 07:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbXCAMuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 07:50:10 -0500
Received: from main.gmane.org ([80.91.229.2]:57131 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbXCAMuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 07:50:08 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Leroy van Logchem <leroy.vanlogchem@wldelft.nl>
Subject: Re: [RFC][PATCH 0/3] VM throttling: avoid blocking occasional writers
Date: Thu, 1 Mar 2007 12:47:20 +0000 (UTC)
Message-ID: <loom.20070301T133046-12@post.gmane.org>
References: <45DED819.9040404@hitachi.com> <17888.14958.85897.289141@gargle.gargle.HOWL> <45E380DA.6090509@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 145.9.150.34 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20060601 Firefox/2.0.0.2 (Ubuntu-edgy))
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tomoki Sekiyama <tomoki.sekiyama.qu <at> hitachi.com> writes:

> thanks for your comments.


The default dirty_ratio on most 2.6 kernels tend to be too large imo.
If you are going to do sustained writes multiple times the size of
the memory you have at least two problems.

1) The precious dentry and inodecache will be dropped leaving you with
a *very* unresponsive system
2) The amount of dirty_pages which need to be flushed to disk is huge,
taking all VM while the i/o channel takes uninterruptable time to flush it.

What we really need is a 'cfq' for all processes -especially misbehaving
ones like dd if=/dev/zero of=/location/large bs=1M count=10000-.
If you want to DoS the 2.6 kernel, start a ever running dd write and
you know what I mean. Huge latencies due the fact that all name_to_inode
caches are lost and have to be fetched from disk again only to be quickly
flushed again and again. I already explained this disaster scenario with
Linus, Andrew and Jens; hoping for a auto-tuning solution which takes
diskspeed per partition into account.

At the moment we cope with this feature by preserving imported caches with
sysctl vm.vfs_cache_pressure = 1, vm.dirty_ratio = 2 combined with
vm.dirty_background_ratio = 1. Some benchmarks may get worse but you have
a more resiliant server.

I hope the VM subsystem will cope with applications which do not advise
what to do with the cached pages. For now we use posix_fadvice DONT_NEED
as patch to Samba 3 in order to at least be able to write larger then
memory files without discarding the important slab caches.


