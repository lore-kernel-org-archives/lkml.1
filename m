Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbZHMGpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbZHMGpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 02:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZHMGpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 02:45:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59318 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258AbZHMGpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 02:45:19 -0400
Message-ID: <4A83B680.5000508@suse.de>
Date: Thu, 13 Aug 2009 08:45:20 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [REGRESSION] _end symbol missing from Symbol.map
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

with 2.6.31 'crash' on x86_64 falls flat on its face as the '_end' symbol
is missing from the System.map file.

The culprit is commit 091e52c3551d3031343df24b573b770b4c6c72b6,
which moved the '_end' symbol into it's own section.
Apparently this causes kallsyms to not reference it properly.

So either we'd need to revert part of the patch to not
include _end in it's own section:

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 59f31d2..1422df5 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -376,9 +376,7 @@ SECTIONS
                __brk_limit = .;
        }
 
-       .end : AT(ADDR(.end) - LOAD_OFFSET) {
-               _end = .;
-       }
+       _end = .;
 
        /* Sections to be discarded */
        /DISCARD/ : {

or someone has to fixup kallsyms. But this is far beyond my comfort zone.

Cheers,

Hannes
---
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
