Return-Path: <linux-kernel-owner+w=401wt.eu-S1751502AbZFSHa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbZFSHa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 03:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbZFSHat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 03:30:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49076 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbZFSHat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 03:30:49 -0400
Date: Fri, 19 Jun 2009 17:30:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: backtrace symbols are bolixed...
Message-Id: <20090619173052.8460f1a9.sfr@canb.auug.org.au>
In-Reply-To: <20090619.002101.45610359.davem@davemloft.net>
References: <20090619.002101.45610359.davem@davemloft.net>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Fri, 19 Jun 2009 00:21:01 -0700 (PDT) David Miller <davem@davemloft.net> wrote:
>
> Sometime in the last day or so backtrace symbol printouts
> have become useless:
> 
> [    0.000000] WARNING: at mm/bootmem.c:535 __stop_notes+0xbb10/0x1d660()
> [    0.000000] Modules linked in:
> [    0.000000] Call Trace:
> [    0.000000]  [00000000008611b4] __stop_notes+0xbb10/0x1d660
> [    0.000000]  [000000000086195c] __stop_notes+0xc2b8/0x1d660
> [    0.000000]  [0000000000861a28] __stop_notes+0xc384/0x1d660
> [    0.000000]  [0000000000858678] __stop_notes+0x2fd4/0x1d660
> [    0.000000]  [000000000085684c] __stop_notes+0x11a8/0x1d660
> [    0.000000]  [00000000006e8bdc] _etext+0xfffffffffffe59f4/0xe18
> [    0.000000]  [0000000000000000] (null)
> 
> I'll try to bisect but maybe someone can figure it out quickly
> meanwhile.

Try the following patch:

From: Mike Frysinger <vapier@gentoo.org>
Date: Mon, 15 Jun 2009 07:52:48 -0400
Subject: [PATCH] kallsyms: fix inverted valid symbol checking

The previous commit (17b1f0de) introduced a slightly broken consolidation
of the memory text range checking.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 scripts/kallsyms.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 3cb5789..64343cc 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -167,11 +167,11 @@ static int symbol_valid_tr(struct sym_entry *s)
 	for (i = 0; i < ARRAY_SIZE(text_ranges); ++i) {
 		tr = &text_ranges[i];
 
-		if (s->addr >= tr->start && s->addr < tr->end)
-			return 0;
+		if (s->addr >= tr->start && s->addr <= tr->end)
+			return 1;
 	}
 
-	return 1;
+	return 0;
 }
 
 static int symbol_valid(struct sym_entry *s)
-- 
1.6.3.1


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
