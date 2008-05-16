Return-Path: <linux-kernel-owner+w=401wt.eu-S1760010AbYEPWbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010AbYEPWbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 18:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755436AbYEPWbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 18:31:11 -0400
Received: from saeurebad.de ([85.214.36.134]:47018 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811AbYEPWbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 18:31:09 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: bootmem: Double freeing a PFN on nodes spanning other nodes
CC: Linux MM Mailing List <linux-mm@kvack.org>
Date: Sat, 17 May 2008 00:30:55 +0200
Message-ID: <87skwhyj8g.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When memory nodes overlap each other, the bootmem allocator is not aware
of this and might pass the same page twice to __free_pages_bootmem().

As I traced the code, this should result in bad_page() calls on every
boot but noone has yet reported something like this and I am wondering
why.

__free_pages_bootmem() boils down to either free_hot_cold_page() or
__free_one_page().  Either path should lead to setting the page private
or buddy:

free_hot_cold_page() sets ->private to the page block's migratetype (and
sets PG_private).

__free_one_page sets ->private to the page's order (and sets PG_private
and PG_buddy).

If a page is passed in twice, free_pages_check() should now warn (via
bad_page()) on the flags set above.

Am I missing something?  Thanks in advance.

	Hannes
