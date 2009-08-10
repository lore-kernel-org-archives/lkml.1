Return-Path: <linux-kernel-owner+w=401wt.eu-S1753129AbZHJUrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbZHJUrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 16:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbZHJUrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 16:47:03 -0400
Received: from mail-yw0-f193.google.com ([209.85.211.193]:46081 "EHLO
	mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbZHJUrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 16:47:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=J5Qr127Jv69CrL+TXSuzVSLEk6uFxx3FNQjwDws8KgbeDAVgkYyW/IrczrEXb/2hOm
         aAH850fiupp/9Vc9gPTRUGS4Ieq9CK9W2Jea3bI5ppZmtTUYyTAytGXFQzhI6DofmUvG
         vT7iD/iWZZ+W/ZKV8biBcMqDGCAvQIKb+/RKo=
MIME-Version: 1.0
Date: Mon, 10 Aug 2009 16:47:02 -0400
Message-ID: <a1b36c3a0908101347t796dedbat2ecb0535c32f325b@mail.gmail.com>
Subject: vma_merge issue
From: Bill Speirs <bill.speirs@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello-

I came across an issue where adjacent pages are not properly coalesced
together when changing protections on them. This can be shown by doing
the following:

1) Map 3 pages with PROT_NONE and MAP_PRIVATE | MAP_ANONYMOUS
2) Set the middle page's protection to PROT_READ | PROT_WRITE
3) Set the middle page's protection back to PROT_NONE

You are left with 3 entries in /proc/self/map where you should only
have 1. If you only change the protection to PROT_READ in step 2, then
it is properly merged together. I noticed in mprotect.c the following
comment in the function mprotect_fixup; I'm not sure if it applies or
not:
        /*
         * If we make a private mapping writable we increase our commit;
         * but (without finer accounting) cannot reduce our commit if we
         * make it unwritable again.
         *
         * FIXME? We haven't defined a VM_NORESERVE flag, so mprotecting
         * a MAP_NORESERVE private mapping to writable will now reserve.
         */

I think this only applies to setting charged = nrpages; however,
VM_ACCOUNT is also added to newflags. Could it be that the adjacent
blocks don't have VM_ACCOUNT and so the call to vma_merge cannot merge
because the flags for the adjacent vma are not the same?

Can anyone shed some light on this? While it isn't an issue for 3
pages, I'm mmaping 200K+ pages and changing the perms on random pages
throughout and then back but I quickly run into the max_map_count when
I don't actually need that many mappings.

Thanks...

Bill-
