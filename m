Return-Path: <linux-kernel-owner+w=401wt.eu-S936111AbXG0Mfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936111AbXG0Mfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 08:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756380AbXG0Mfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 08:35:42 -0400
Received: from mail.zelnet.ru ([80.92.97.13]:53089 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755436AbXG0Mfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 08:35:41 -0400
Message-ID: <46A9E691.5080308@namesys.com>
Date: Fri, 27 Jul 2007 16:35:29 +0400
From: Edward Shishkin <edward@namesys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060411
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>, Nitin Gupta <nitingupta910@gmail.com>,
       Richard Purdie <rpurdie@openedhand.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       reiserfs-devel@vger.kernel.org
Subject: Re: 2.6.23-rc1-mm1: reiser4 <-> lzo compile error
References: <20070725040304.111550f4.akpm@linux-foundation.org> <20070725182221.GG3572@stusta.de>
In-Reply-To: <20070725182221.GG3572@stusta.de>
X-Enigmail-Version: 0.86.0.0
X-Enigmail-Supports: pgp-inline, pgp-mime
Content-Type: multipart/mixed;
 boundary="------------060305090705050407030405"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060305090705050407030405
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Adrian Bunk wrote:

><--  snip  -->
>
>...
>  LD      .tmp_vmlinux1
>lib/built-in.o: In function `lzo1x_1_compress':
>(.text+0x13eae): multiple definition of `lzo1x_1_compress'
>fs/built-in.o:(.text+0x117075): first defined here
>make[1]: *** [.tmp_vmlinux1] Error 1
>
><--  snip  -->
>
>AFAIR, we once had a patch in -mm changing reiser4 to use the
>LZO code that is now in the kernel?
>
>cu
>Adrian
>
>  
>
Sorry, guys, I am not happy with the modified LZO:
the compressor tries to test bytes which are out of bounds.

The attached module testlzo.c causes an oops in the second pass:
AFAIK, both, @m and @m_pos should be in [wrkmem, wrkmem + 64K);
I have attached trace.txt with their actual values.

Not ready to migrate to this library.

Any ideas?

Thanks,
Edward.

P.S.
kernel: 2.6.23-rc1-mm1
box: x86

--------------060305090705050407030405
Content-Type: text/x-csrc;
 name="testlzo.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="testlzo.c"

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/lzo.h>
#include <linux/vmalloc.h>

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("Compress 64K zeroed chunk");

#define CHUNK_SIZE 65536
#define NR_PASSES 2

static int __init lkp_init( void )
{
	int i;
	int ret;
	void * wrkmem;
	unsigned char * src_buf;
	unsigned char * dst_buf;
	size_t src_len;
	size_t dst_len;

	src_len = CHUNK_SIZE;
	dst_len = lzo1x_worst_compress(src_len);

	printk("<1> Testing LZO: start...\n");

	wrkmem = vmalloc(LZO1X_1_MEM_COMPRESS);
	if (!wrkmem)
		goto enomem;
	src_buf = vmalloc(src_len);
	if (!src_buf) {
		vfree(wrkmem);
		goto enomem;
	}
	memset(src_buf, 0, src_len);

	dst_buf = vmalloc(dst_len);
	if (!dst_buf) {
		vfree(wrkmem);
		vfree(src_buf);
		goto enomem;
	}
	for (i = 0; i < NR_PASSES; i++) {
		size_t out_len;
		ret = lzo1x_1_compress(src_buf, src_len,
				       dst_buf, &out_len,
				       wrkmem);
		if (ret)
			break;
		printk("pass %d: compressed to %d bytes\n", i, out_len);
	}
	vfree(wrkmem);
	vfree(src_buf);
	vfree(dst_buf);
	return ret;
 enomem:
	printk("vmalloc failed\n");
	return -ENOMEM;
}

static void __exit lkp_cleanup( void )
{
	printk("<1>Testing LZO : finish\n");
}
module_init(lkp_init);
module_exit(lkp_cleanup);

--------------060305090705050407030405
Content-Type: text/plain;
 name="trace.txt"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="trace.txt"

UHJvZ3JhbSByZWNlaXZlZCBzaWduYWwgU0lHU0VHViwgU2VnbWVudGF0aW9uIGZhdWx0Lgow
eGMwMmVmZWM4IGluIF9sem8xeF8xX2RvX2NvbXByZXNzIChpbj0weGUwOGM5MDAwICIiLCBp
bl9sZW49VmFyaWFibGUgImluX2xlbiIgaXMgbm90IGF2YWlsYWJsZS4KKSBhdCBsem8xeF9j
b21wcmVzcy5jOjEzMAoxMzAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
aXArKzsKKGdkYikgcCBtCiQyID0gKGNvbnN0IHVuc2lnbmVkIGNoYXIgKikgMHhlMDhkOTAw
MCA8QWRkcmVzcyAweGUwOGQ5MDAwIG91dCBvZiBib3VuZHM+CihnZGIpIHAgd3JrbWVtCiQz
ID0gKHZvaWQgKikgMHhlMDhiODAwMAooZ2RiKSBwIG0gLSB3cmttZW0KJDQgPSAxMzUxNjgK
KGdkYikgcCBtX3BvcwokNSA9IChjb25zdCB1bnNpZ25lZCBjaGFyICopIDB4ZTA4YzkwMDUg
IiIKKGdkYikgcCBtX3BvcyAtIHdya21lbQokNiA9IDY5NjM3Cg==
--------------060305090705050407030405--
