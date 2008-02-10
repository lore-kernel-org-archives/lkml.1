Return-Path: <linux-kernel-owner+w=401wt.eu-S1757884AbYBJNCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884AbYBJNCl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 08:02:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbYBJNCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 08:02:31 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:1671 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbYBJNCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 08:02:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=vqwOpbYPVn9jnzio9m1G5fyiHgcTyt1tQv1iHl/N5ccKTm9WuU9RplNDlhzXCB7GWFGpjeFLMuWMZgY+quLdUCcJBdMuQztgxDv0/VW7e9u7bnFqObqjIpG4h8SrR5L63lVOEpTZ/o8+d6cbDvLwixaFNSzhFkmBn1Tv2r70lqA=
Message-ID: <6101e8c40802100502g6c3c2d01ufce1ce23c7c20c5a@mail.gmail.com>
Date: Sun, 10 Feb 2008 14:02:27 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Bastian Blank" <bastian@waldi.eu.org>, "Niki Denev" <ndenev@gmail.com>,
       "Willy Tarreau" <w@1wt.eu>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH] kernel 2.6.24.1 still vulnerable to the vmsplice local root exploit
Cc: stable@kernel.org
In-Reply-To: <20080210124731.GA25396@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2e77fc10802092204t7764ff12s65304f70500e2090@mail.gmail.com>
	 <20080210063247.GQ8953@1wt.eu>
	 <2e77fc10802092238k13efb111ifcd298daaf7b4aba@mail.gmail.com>
	 <2e77fc10802100140q5c8adfb4k7db88d48cbd5f8b2@mail.gmail.com>
	 <20080210122250.GA24048@wavehammer.waldi.eu.org>
	 <2e77fc10802100439u18e89008j9181f3b445daa231@mail.gmail.com>
	 <20080210124731.GA25396@wavehammer.waldi.eu.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thx it fixed for 2.6.22

>>>>>>>

commit f6e993b835393543bab2d917f9dea75218473edd
Author: Oliver Pinter <oliver.pntr@gmail.com>
Date:   Sun Feb 10 14:03:46 2008 +0100

    [PATCH] vm: splice local root exploit fix for 2.6.22.y

    Based on Bastian Blank's patch

    Fix for CVE_2008_0009 and CVE_2008-0010

    ----->8-----

    oliver@pancs:/tmp$ ./2617_26241_root_exploit
    -----------------------------------
     Linux vmsplice Local Root Exploit
      By qaaz
      -----------------------------------
      [+] mmap: 0x0 .. 0x1000
      [+] page: 0x0
      [+] page: 0x20
      [+] mmap: 0x4000 .. 0x5000
      [+] page: 0x4000
      [+] page: 0x4020
      [+] mmap: 0x1000 .. 0x2000
      [+] page: 0x1000
      [+] mmap: 0xb7f1a000 .. 0xb7f4c000
      [-] vmsplice: Bad address

    -----8<-----

    Signed-off-by: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/fs/splice.c b/fs/splice.c
index e263d3b..d8b106e 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1182,6 +1182,12 @@ static int get_iovec_page_array(const struct
iovec __user *iov,
 		if (unlikely(!base))
 			break;

+		/* CVE-2008-0009, CVE-2008-0010 fix */
+		if(!access_ok(VERIFY_READ, base, len)) {
+			error = -EFAULT;
+			break;
+		}
+
 		/*
 		 * Get this base offset and number of pages, then map
 		 * in the user pages.


<<<<<<<

On 2/10/08, Bastian Blank <bastian@waldi.eu.org> wrote:
> On Sun, Feb 10, 2008 at 12:39:05PM +0000, Niki Denev wrote:
> > This patch is against 2.6.24.1 which has already the fix to
> vmsplice_to_user
> > With it i can't exploit the hole, and it is returns "invalid address"
>
> This is the vmsplice_to_pipe path and I have many reports that it is not
> fixed.
>
> Bastian
>
> --
> If there are self-made purgatories, then we all have to live in them.
> 		-- Spock, "This Side of Paradise", stardate 3417.7
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

oliver@pancs:/tmp$ ./2617_26241_root_exploit
-----------------------------------
 Linux vmsplice Local Root Exploit
 By qaaz
-----------------------------------
[+] mmap: 0x0 .. 0x1000
[+] page: 0x0
[+] page: 0x20
[+] mmap: 0x4000 .. 0x5000
[+] page: 0x4000
[+] page: 0x4020
[+] mmap: 0x1000 .. 0x2000
[+] page: 0x1000
[+] mmap: 0xb7f1a000 .. 0xb7f4c000
[-] vmsplice: Bad addres

-- 
Thanks,
Oliver
