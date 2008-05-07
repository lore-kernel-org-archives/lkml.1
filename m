Return-Path: <linux-kernel-owner+w=401wt.eu-S1758864AbYEGO1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864AbYEGO1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 10:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbYEGO1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 10:27:06 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:63144 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbYEGO1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 10:27:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=wFU3bkhgMD3lyCTdk8tYu00WzephllId+9uOk8/0ljdZZontN8GfzSh/zWLizv5ncwGv/Aq+PYpx1c9w7klUqcMaNZPZ8NUAcgAydSAbtcgMVn6Tjy8bcDcRTftniysYwqGtIieJjkqnAIs7MSjd0tarrFzBd0U53+wCmapZk1I=
Message-ID: <91b13c310805070726k7eb1384ex7d557b5dca4b567@mail.gmail.com>
Date: Wed, 7 May 2008 22:26:58 +0800
From: "rae l" <crquan@gmail.com>
To: linux-fsdevel@vger.kernel.org
Subject: It's time to hack on dentry_stat?
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have noticed that struct dentry_stat_t dentry_stat is a struct with
six fields,
but only 2 of them are used, other 4 have never been used since v2.6.11,

from include/linux/dcache.h:

struct dentry_stat_t {
        int nr_dentry;
        int nr_unused;
        int age_limit;          /* age in seconds */
        int want_pages;         /* pages requested by system */
        int dummy[2];
};
extern struct dentry_stat_t dentry_stat;

(I don't know things before v2.6.11, my local linux-2.6.git repository
can only grep to v2.6.11)

$ PAGER= git grep -w -e dentry_stat
Documentation/sysctl/fs.txt:} dentry_stat = {0, 0, 45, 0,};
fs/dcache.c:struct dentry_stat_t dentry_stat = {
fs/dcache.c: * no dcache_lock, please.  The caller must decrement
dentry_stat.nr_dentry
fs/dcache.c:            dentry_stat.nr_unused--;
fs/dcache.c:    dentry_stat.nr_dentry--;        /* For d_free, below */
fs/dcache.c:            dentry_stat.nr_unused++;
fs/dcache.c:            dentry_stat.nr_unused--;
fs/dcache.c:                    dentry_stat.nr_unused++;
fs/dcache.c:            dentry_stat.nr_unused++;
fs/dcache.c:            dentry_stat.nr_unused--;
fs/dcache.c:    dentry_stat.nr_dentry -= detached;
fs/dcache.c:                    dentry_stat.nr_unused++;
fs/dcache.c:    return (dentry_stat.nr_unused / 100) *
sysctl_vfs_cache_pressure;
fs/dcache.c:    dentry_stat.nr_dentry++;
include/linux/dcache.h:extern struct dentry_stat_t dentry_stat;
kernel/sysctl.c:                .data           = &dentry_stat,

it's the same as that of v2.6.11:

$ PAGER= git grep -w -e dentry_stat v2.6.11 --
v2.6.11:Documentation/sysctl/fs.txt:} dentry_stat = {0, 0, 45, 0,};
v2.6.11:fs/dcache.c:struct dentry_stat_t dentry_stat = {
v2.6.11:fs/dcache.c: * no dcache_lock, please.  The caller must
decrement dentry_stat.nr_dentry
v2.6.11:fs/dcache.c:            dentry_stat.nr_unused++;
v2.6.11:fs/dcache.c:                    dentry_stat.nr_unused--;
v2.6.11:fs/dcache.c:            dentry_stat.nr_dentry--;        /* For
d_free, below */
v2.6.11:fs/dcache.c:            dentry_stat.nr_unused--;
v2.6.11:fs/dcache.c:    dentry_stat.nr_dentry--;        /* For d_free, below */
v2.6.11:fs/dcache.c:            dentry_stat.nr_unused--;
v2.6.11:fs/dcache.c:                    dentry_stat.nr_unused++;
v2.6.11:fs/dcache.c:            dentry_stat.nr_unused--;
v2.6.11:fs/dcache.c:                    dentry_stat.nr_unused--;
v2.6.11:fs/dcache.c:                    dentry_stat.nr_unused++;
v2.6.11:fs/dcache.c:                            dentry_stat.nr_unused--;
v2.6.11:fs/dcache.c:                            dentry_stat.nr_unused++;
v2.6.11:fs/dcache.c:    return (dentry_stat.nr_unused / 100) *
sysctl_vfs_cache_pressure;
v2.6.11:fs/dcache.c:    dentry_stat.nr_dentry++;
v2.6.11:include/linux/dcache.h:extern struct dentry_stat_t dentry_stat;
v2.6.11:kernel/sysctl.c:                .data           = &dentry_stat,

So I think that struct is outdated and can be simplified.

--
Cheng
