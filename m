Return-Path: <linux-kernel-owner+w=401wt.eu-S1762005AbXGQDEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762005AbXGQDEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 23:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755160AbXGQDEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 23:04:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37585 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753820AbXGQDEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 23:04:21 -0400
Date: Mon, 16 Jul 2007 20:03:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: block/bsg.c
Message-Id: <20070716200357.15dd8c64.akpm@linux-foundation.org>
In-Reply-To: <469C1FA9.3090809@garzik.org>
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>
	<469C11B1.8000302@garzik.org>
	<20070716175347.bea345dd.akpm@linux-foundation.org>
	<469C1423.3090908@garzik.org>
	<20070716180908.e15325bd.akpm@linux-foundation.org>
	<469C1FA9.3090809@garzik.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007 21:47:21 -0400 Jeff Garzik <jeff@garzik.org> wrote:

> hrm.  uninitialized_var(x) does not silence the warning, on my compiler:
> 
> [jgarzik@pretzel misc-2.6]$ rpm -q gcc
> gcc-4.1.2-13.fc6
> 
> @@ -1358,6 +1358,8 @@ udf_load_partition(struct super_block *sb, kernel_lb_addr
>             	{
>             		kernel_lb_addr ino;
> + 			uninitialized_var(ino.partitionReferenceNum);
> +
>                	if (!UDF_SB_LASTBLOCK(sb))

[erk, wordwrapping!]

> still yields
> 
> fs/udf/super.c: In function ‘udf_fill_super’:
> fs/udf/super.c:1359: warning: ‘ino.partitionReferenceNum’ may be used 
> uninitialized in this function
> 

We use it as

-	int foo;
+	int uninitialized_var(foo);

so what you have is effectively


		kernel_lb_addr ino;

		ino.partitionReferenceNum = ino.partitionReferenceNum;


so it still warns.



Hopefully this will work:

		kernel_lb_addr uninitialized_var(ino);

	
