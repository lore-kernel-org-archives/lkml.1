Return-Path: <linux-kernel-owner+w=401wt.eu-S1422934AbXBGWoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422934AbXBGWoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 17:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161471AbXBGWoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 17:44:54 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:48941 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161470AbXBGWoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 17:44:54 -0500
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: nobh_truncate_page question
From: Dmitriy Monakhov <dmonakhov@openvz.org>
Date: Thu, 08 Feb 2007 01:45:10 +0300
Message-ID: <87iredh9jd.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [194.85.82.65]); Thu, 08 Feb 2007 01:44:35 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Could some one please explain me what's happens with nobh_truncate_page?

int nobh_truncate_page(struct address_space *mapping, loff_t from)
{
........
 if ((offset & (blocksize - 1)) == 0)
                goto out;

        ret = -ENOMEM;
        page = grab_cache_page(mapping, index);
        if (!page)
                goto out;

        to = (offset + blocksize) & ~(blocksize - 1);
        ret = a_ops->prepare_write(NULL, page, offset, to);
<<<<< This prepare_write() not balanced by appropriate commit_write()
<<<<< Currently this not is fatal because this function used only
<<<<< by ext2 and jfs witch  unbalanced prepare/commit operations
<<<<< not painful.  
        if (ret == 0) {
                kaddr = kmap_atomic(page, KM_USER0);
                memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
                flush_dcache_page(page);
                kunmap_atomic(kaddr, KM_USER0);
                set_page_dirty(page);
        }
        unlock_page(page);
        page_cache_release(page);
out:
        return ret;
}

But we can't just call commit_write after all job done because this result in
i_size increasing till block end. Where are two possible solutions:
a) Call ->commit_write() and then restore i_size to old value.
b) Leave code as it is now, but add warning comment about prepare/commit
   balance violation.

