Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468AbZJRWtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbZJRWtQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 18:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755440AbZJRWtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 18:49:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:45927 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755431AbZJRWtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 18:49:14 -0400
X-Authenticated: #20192376
X-Provags-ID: V01U2FsdGVkX18oFkcmO1sovr+InZl/wsLn99xDlOVecjHjsDGKBL
	aMUXQCSHtBA8KH
From: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
To: linux-kernel@vger.kernel.org
Subject: Make totalhigh_pages of consistent type.
Date: Mon, 19 Oct 2009 00:49:27 +0200
Message-Id: <1255906168-19279-1-git-send-email-andreas.fenkart@streamunlimited.com>
X-Mailer: git-send-email 1.6.4.3
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Printing the value of totalhigh_pages requires casting, like in
this print message:

arch/x86/mm/init_32.c:
  printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, "
      "%dk reserved, %dk data, %dk init, %ldk highmem)\n",
    ...
    (unsigned long)(totalhigh_pages << (PAGE_SHIFT-10)));

The need for casting is due to totalhigh_pages being of different
type, when CONFIG_HIGHMEM is set/unset.

include/linux/highmem.h:
  #ifdef CONFIG_HIGHMEM
  
  extern unsigned long totalhigh_pages;
  
  #else /* CONFIG_HIGHMEM */
  
 -#define totalhigh_pages 0
 +#define totalhigh_pages 0UL
  ...

For C files there should be no problem, because 0/0UL are both
valid C and denote the same value. Assembly files are not
affected, since linux/highmem.h can not be included from
assembly.

