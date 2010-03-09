Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab0CIQte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 11:49:34 -0500
Received: from nfitmail.nfit.au.dk ([130.225.31.129]:12644 "EHLO
	smtp.nfit.au.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752552Ab0CIQtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 11:49:33 -0500
X-Greylist: delayed 512 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Mar 2010 11:49:33 EST
To: linux-kernel@vger.kernel.org
Subject: Mapping perf event files twice
From: Soeren Sandmann <sandmann@daimi.au.dk>
Date: 09 Mar 2010 17:40:59 +0100
Message-ID: <ye8aauha1no.fsf@camel18.daimi.au.dk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-NFIT-RelayAddr: 130.225.16.137
X-Sim: 7161aca306f20f6d854659c9f1bd2a56546b6dff11635bcc21164c9baa2ceaea
X-NFIT-Solido-Score: 0.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In the branch where perf_mmap is backed with vmalloc memory, this
code:

        data->user_page = all_buf;
        data->data_pages[0] = all_buf + PAGE_SIZE;
        data->data_order = ilog2(nr_pages);
        data->nr_pages = 1;

sets data->nr_pages to 1. This interferes with Sysprof which tries to
map the file twice consecutively to handle overflows automatically,
and therefore hits this in perf_mmap():

        if (atomic_inc_not_zero(&event->mmap_count)) {
                if (nr_pages != event->data->nr_pages)
                        ret = -EINVAL;
                goto unlock;
        }

Because event->data->nr_pages is 1 and Sysprof uses 32 pages, it gets
-EINVAL.

Possibly Sysprof shouldn't be playing this game, but if mapping the
file twice is not supported, then maybe perf_mmap() should just
explicitly forbid it.


Thanks,
Soren
