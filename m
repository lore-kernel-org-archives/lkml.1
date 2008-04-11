Return-Path: <linux-kernel-owner+w=401wt.eu-S1758813AbYDKNMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813AbYDKNMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 09:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbYDKNMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 09:12:30 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41165 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbYDKNM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 09:12:29 -0400
Date: Fri, 11 Apr 2008 22:17:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: 2.6.25-rc8-mm2
Message-Id: <20080411221714.5f917a72.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080411201724.e820122b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org>
	<20080411185703.a5407940.kamezawa.hiroyu@jp.fujitsu.com>
	<20080411192346.6872472a.kamezawa.hiroyu@jp.fujitsu.com>
	<1207910058.7212.1.camel@haji>
	<20080411195738.16e9ef92.kamezawa.hiroyu@jp.fujitsu.com>
	<20080411201724.e820122b.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2008 20:17:24 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> slab-2.6.git booted well :(
> Hmm, It seems I have to dig somewhere different...
> 
Sorry, I tested *master* branch ;), under *testing* branch it reproduced.

bisected. (see below)

I'm sorry I can't use my box for next 2 days. I can test possible fix
on Monday (in Japan). 

==bisect result==
831d78b552aade2c383cf8d75b180dd35f81a4e3 is first bad commit
commit 831d78b552aade2c383cf8d75b180dd35f81a4e3
Author: Christoph Lameter <clameter@sgi.com>
Date:   Tue Apr 8 22:26:30 2008 +0300

    SLUB: Add KICKABLE to avoid repeated kick() attempts

    Add a flag KICKABLE to be set on slabs with a defragmentation method

    Clear the flag if a kick action is not successful in reducing the
    number of objects in a slab. This will avoid future attempts to
    kick objects out.

    The KICKABLE flag is set again when all objects of the slab have been
    allocated (Occurs during removal of a slab from the partial lists).

    Reviewed-by: Rik van Riel <riel@redhat.com>
    Signed-off-by: Christoph Lameter <clameter@sgi.com>
    Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

:040000 040000 b75802b6e7f1f27589f8242a824a4a24773a56d4 c935aae1a02277f0e605069d397d315f6db430b6 M      mm

== bisect log ==

git-bisect start
# good: [0e81a8ae37687845f7cdfa2adce14ea6a5f1dd34] Linux 2.6.25-rc8
git-bisect good 0e81a8ae37687845f7cdfa2adce14ea6a5f1dd34
# bad: [28e4b71a66881df1ac343f13d06395fa01021e8e] slub: use typedefs for ->get and ->kick functions
git-bisect bad 28e4b71a66881df1ac343f13d06395fa01021e8e
# good: [9597362d354f8655ece324b01d0c640a0e99c077] Merge git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6
git-bisect good 9597362d354f8655ece324b01d0c640a0e99c077
# good: [28b8383d5d4d9b636c3734c993563bafdc2ab3c3] Merge git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb
git-bisect good 28b8383d5d4d9b636c3734c993563bafdc2ab3c3
# good: [869ab5147e1eead890245cfd4f652ba282b6ac26] SELinux: more GFP_NOFS fixups to prevent selinux from re-entering the fs code
git-bisect good 869ab5147e1eead890245cfd4f652ba282b6ac26
# good: [acd49c885e03f087c31f49e7c42ccb8befbf4009] slub: Make the order configurable for each slab cache
git-bisect good acd49c885e03f087c31f49e7c42ccb8befbf4009
# skip: [24337bca6e77ab48f459e35690b32ef20a34bda5] SLUB: Replace ctor field with ops field in /sys/slab/*
git-bisect skip 24337bca6e77ab48f459e35690b32ef20a34bda5
# good: [66892337435a0d88996057af221e8c18ff91bc14] SLUB: Add get() and kick() methods
git-bisect good 66892337435a0d88996057af221e8c18ff91bc14
# bad: [171250363fe803b4dc61301276c2693cce3e5684] SLUB: Extend slabinfo to support -D and -F options
git-bisect bad 171250363fe803b4dc61301276c2693cce3e5684
# good: [c963d891d875a9bd39ae44da623c421bc0140937] SLUB: Slab defrag core
git-bisect good c963d891d875a9bd39ae44da623c421bc0140937
# bad: [831d78b552aade2c383cf8d75b180dd35f81a4e3] SLUB: Add KICKABLE to avoid repeated kick() attempts
git-bisect bad 831d78b552aade2c383cf8d75b180dd35f81a4e3
==

Thanks,
-Kame

