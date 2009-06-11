Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbZFKRcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbZFKRcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 13:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbZFKRcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 13:32:08 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:33301 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbZFKRcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 13:32:07 -0400
Date: Thu, 11 Jun 2009 19:32:06 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Giangiacomo Mariotti <giangiacomo.mariotti@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Possible memory leak in
	arch/cris/arch-v32/drivers/cryptocop.c
Message-ID: <20090611173206.GE12383@axis.com>
References: <2aac3c260906110930k49d70eb9o9922795a5bfdadf8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2aac3c260906110930k49d70eb9o9922795a5bfdadf8@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm having trouble with this patch, it seems horribly whitespace damaged.
Also, this leak has already been reported (bugzilla 11363) and
fixed in our local repo.

The following patch is what I have queued for the CRIS-tree:

From: Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [PATCH] CRISv32: Fix potential null reference in cryptocop driver.

The code didn't test the pointer to the newly allocated
memory, but a parameter sent in as value.
Since the input parameter was most often set, the code
would have used a null pointer if the kmalloc failed.
If the input parameter was not set, the code would
leak the allocated buffer.

http://bugzilla.kernel.org/show_bug.cgi?id=11363

Reported-by: Daniel Marjamäki <danielm77@spray.se>
Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v32/drivers/cryptocop.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/cris/arch-v32/drivers/cryptocop.c b/arch/cris/arch-v32/drivers/cryptocop.c
index 67c61ea..fd529a0 100644
--- a/arch/cris/arch-v32/drivers/cryptocop.c
+++ b/arch/cris/arch-v32/drivers/cryptocop.c
@@ -1395,7 +1395,7 @@ static int create_md5_pad(int alloc_flag, unsigned long long hashed_length, char
 	if (padlen < MD5_MIN_PAD_LENGTH) padlen += MD5_BLOCK_LENGTH;
 
 	p = kmalloc(padlen, alloc_flag);
-	if (!pad) return -ENOMEM;
+	if (!p) return -ENOMEM;
 
 	*p = 0x80;
 	memset(p+1, 0, padlen - 1);
@@ -1427,7 +1427,7 @@ static int create_sha1_pad(int alloc_flag, unsigned long long hashed_length, cha
 	if (padlen < SHA1_MIN_PAD_LENGTH) padlen += SHA1_BLOCK_LENGTH;
 
 	p = kmalloc(padlen, alloc_flag);
-	if (!pad) return -ENOMEM;
+	if (!p) return -ENOMEM;
 
 	*p = 0x80;
 	memset(p+1, 0, padlen - 1);
-- 
1.6.1

On Thu, Jun 11, 2009 at 06:30:17PM +0200, Giangiacomo Mariotti wrote:
> From ee8e71f0ae1356b324906efc8e858b29025c60ef Mon Sep 17 00:00:00 2001
> From: Giangiacomo Mariotti <giangiacomo.mariotti@gmail.com>
> Date: Thu, 11 Jun 2009 18:13:52 +0200
> Subject: [PATCH] Possible mem leak
> 
> ---
>  arch/cris/arch-v32/drivers/cryptocop.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/cris/arch-v32/drivers/cryptocop.c
> b/arch/cris/arch-v32/drivers/cryptocop.c
> index 67c61ea..fd529a0 100644
> --- a/arch/cris/arch-v32/drivers/cryptocop.c
> +++ b/arch/cris/arch-v32/drivers/cryptocop.c
> @@ -1395,7 +1395,7 @@ static int create_md5_pad(int alloc_flag,
> unsigned long long hashed_length, char
>  	if (padlen < MD5_MIN_PAD_LENGTH) padlen += MD5_BLOCK_LENGTH;
> 
>  	p = kmalloc(padlen, alloc_flag);
> -	if (!pad) return -ENOMEM;
> +	if (!p) return -ENOMEM;
> 
>  	*p = 0x80;
>  	memset(p+1, 0, padlen - 1);
> @@ -1427,7 +1427,7 @@ static int create_sha1_pad(int alloc_flag,
> unsigned long long hashed_length, cha
>  	if (padlen < SHA1_MIN_PAD_LENGTH) padlen += SHA1_BLOCK_LENGTH;
> 
>  	p = kmalloc(padlen, alloc_flag);
> -	if (!pad) return -ENOMEM;
> +	if (!p) return -ENOMEM;
> 
>  	*p = 0x80;
>  	memset(p+1, 0, padlen - 1);
> --
> 
> -- 
> You highest men whom my eyes have seen, this is my doubt about you and
> my secret laughter: I guess that you would call my overman—devil!
> What is great is so alien to your souls that the overman would be
> terrifying to you in his goodness ...
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
