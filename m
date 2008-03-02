Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbYCBXXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbYCBXXY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 18:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756428AbYCBXXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 18:23:17 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46273 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbYCBXXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 18:23:16 -0500
Date: Sun, 2 Mar 2008 23:23:14 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [RFC] breakage in 4223cc34365e4 (h8300: uaccess.h update)
Message-ID: <20080302232314.GW27894@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	After that commit in asm-h8300/uaccess.h we have 

#define get_user(x, ptr)                                        \
({                                                              \
    int __gu_err = 0;                                           \
    uint32_t __gu_val = 0;                              \
    ^^^^^^^^^^^^^^^^^
    switch (sizeof(*(ptr))) {                                   \
    case 1:                                                     \
    case 2:                                                     \
    case 4:                                                     \
        __gu_val = *(ptr);                                      \
        break;                                                  \
    case 8:                                                     \
        memcpy(&__gu_val, ptr, sizeof (*(ptr)));                \
                               ^^^^^^^^^^^^^^^^

which, of course, is FUBAR whenever we actually hit that case - memcpy of
8 bytes into uint32_t is obviously wrong.  Why don't we simply do

#define get_user(x, ptr)                                        \
({                                                              \
    int __gu_err = 0;                                           \
    typeof(*(ptr)) __gu_val = *ptr;                             \
    switch (sizeof(*(ptr))) {                                   \
    case 1:                                                     \
    case 2:                                                     \
    case 4:                                                     \
    case 8:                                                     \
        break;                                                  \
    default:                                                    \
        __gu_err = __get_user_bad();                            \
        break;                                                  \
    }                                                           \
    (x) = __gu_val;                                             \
    __gu_err;                                                   \
})

and be done with that, anyway?
