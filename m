Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbYKVT2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbYKVT2A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 14:28:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbYKVT1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 14:27:49 -0500
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:37280 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075AbYKVT1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 14:27:48 -0500
Date: Sat, 22 Nov 2008 20:27:47 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UBIFS: endian handling fixes and annotations
Message-ID: <20081122192747.GB21433@Chamillionaire.breakpoint.cc>
References: <1227287970-14684-1-git-send-email-dedekind@infradead.org> <1227287970-14684-3-git-send-email-dedekind@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1227287970-14684-3-git-send-email-dedekind@infradead.org>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Artem Bityutskiy | 2008-11-21 19:19:24 [+0200]:

>index 9ee6508..3f1f16b 100644
>--- a/fs/ubifs/key.h
>+++ b/fs/ubifs/key.h
>@@ -345,7 +345,7 @@ static inline int key_type_flash(const struct ubifs_info *c, const void *k)
> {
> 	const union ubifs_key *key = k;
> 
>-	return le32_to_cpu(key->u32[1]) >> UBIFS_S_KEY_BLOCK_BITS;
>+	return le32_to_cpu(key->j32[1]) >> UBIFS_S_KEY_BLOCK_BITS;

If you would change such references to something like
|return le32_to_cpup(&key->j32[1]) >> UBIFS_S_KEY_BLOCK_BITS;
then on powerpc

  text    data     bss     dec     hex filename
155384    1284      24  156692   26414 ubifs-b4.ko
155372    1284      24  156680   26408 ubifs-after.ko

because now it is possible to load the value as LE from memory instead
of loading it BE and swapping it afterwads.

> }
> 
> /**
>@@ -416,7 +416,7 @@ static inline unsigned int key_block_flash(const struct ubifs_info *c,
> {
> 	const union ubifs_key *key = k;
> 
>-	return le32_to_cpu(key->u32[1]) & UBIFS_S_KEY_BLOCK_MASK;
>+	return le32_to_cpu(key->j32[1]) & UBIFS_S_KEY_BLOCK_MASK;
> }

This and the previous change look like a bugfix for something that
should trigger during recovery or something? Shouldn't I fail in
ubifs_validate_entry() during recovery?

> /**
>diff --git a/fs/ubifs/recovery.c b/fs/ubifs/recovery.c
>index 77d26c1..bed9742 100644
>--- a/fs/ubifs/recovery.c
>+++ b/fs/ubifs/recovery.c
>@@ -168,12 +168,12 @@ static int write_rcvrd_mst_node(struct ubifs_info *c,
> 				struct ubifs_mst_node *mst)
> {
> 	int err = 0, lnum = UBIFS_MST_LNUM, sz = c->mst_node_alsz;
>-	uint32_t save_flags;
>+	__le32 save_flags;
> 
> 	dbg_rcvry("recovery");
> 
> 	save_flags = mst->flags;
>-	mst->flags = cpu_to_le32(le32_to_cpu(mst->flags) | UBIFS_MST_RCVRY);
>+	mst->flags |= cpu_to_le32(UBIFS_MST_RCVRY);

another micro optimisation would be to use __constant_cpu_to_le32()

Sebastian
