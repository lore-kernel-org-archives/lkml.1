Return-Path: <linux-kernel-owner+w=401wt.eu-S1758408AbZCCQMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408AbZCCQMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 11:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755905AbZCCQMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 11:12:42 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:34555 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229AbZCCQMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 11:12:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nXWrSJiOGUbPaidxXXcN2AoyGyoAGznaoLn6YKw/YaHecoEgQ303G0QWryfOpUCjve
         R1+MJrD7ye52Vn9X0pSpG0OJY3cotZGQ270Yv+S+WXxBGneyV0ofVXjfyheIyCjV7aID
         dlLez46MHm8hDKCMC2GPp4QNIjdjkDYYZKASQ=
Message-ID: <49AD56F3.6020305@gmail.com>
Date: Tue, 03 Mar 2009 17:12:35 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org
Subject: Re: [PATCH] generic debug pagealloc
References: <20090303160103.GB5812@localhost.localdomain>
In-Reply-To: <20090303160103.GB5812@localhost.localdomain>
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3.3.2009 17:01, Akinobu Mita wrote:
...
> +static void dump_broken_mem(unsigned char *mem)
> +{
> +	int i;
> +	int start = 0;
> +	int end = PAGE_SIZE - 1;
> +
> +	for (i = 0; i<  PAGE_SIZE; i++) {
> +		if (mem[i] != PAGE_POISON) {
> +			start = i;
> +			break;
> +		}
> +	}
> +	for (i = PAGE_SIZE - 1; i>= start; i--) {
> +		if (mem[i] != PAGE_POISON) {
> +			end = i;
> +			break;
> +		}
> +	}
> +	printk(KERN_ERR "Page corruption: %p-%p\n", mem + start, mem + end);
> +	print_hex_dump(KERN_ERR, "", DUMP_PREFIX_ADDRESS, 16, 1, mem + start,
> +			end - start + 1, 1);
> +}
> +
> +static void unpoison_page(struct page *page)
> +{
> +	unsigned char *mem;
> +	int i;
> +
> +	if (!page->poison)
> +		return;
> +
> +	mem = kmap_atomic(page, KM_USER0);
> +	for (i = 0; i<  PAGE_SIZE; i++) {
> +		if (mem[i] != PAGE_POISON) {
> +			dump_broken_mem(mem);

Just an optimisation: pass the i to the dump_broken_mem as a start index.

> +			break;
> +		}
> +	}
> +	kunmap_atomic(mem, KM_USER0);
> +	page->poison = false;
> +}
