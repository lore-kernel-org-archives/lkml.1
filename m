Return-Path: <linux-kernel-owner+w=401wt.eu-S1760018AbXIXWIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018AbXIXWIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 18:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbXIXWI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 18:08:28 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:51991 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745AbXIXWI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 18:08:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=XbpU9ljX5x4VxHAgwFfTsuxXeP8n7mxxvgH9lnnkzFmpEC4chlq9KH9xhFxldDJIlhZ77S2sqSlXOkc7uLQ5WIDa5lE/LZNvFpmwbyEfwgeinUabT4z8BJysm8EYOzkNWIygOi8YPn8j32h1YlxyEHb+DA8u1MO6Mw0wMuhINxo=
Date: Tue, 25 Sep 2007 01:08:17 +0300
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com
Subject: i386: Fix null interrupt handler (ignore_int) message ?
Message-ID: <20070924220817.GA3447@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm getting little confused by some ignore_int (null interrupt handler) code in
head.S. Code notifies the user about the unknown raised interrupt by below
string:

int_msg:
	.asciz "Unknown interrupt or fault at EIP %p %p %p\n"

and prints it using below code path:

ignore_int:
	pushl %eax; pushl %ecx; pushl %edx; pushl %es; pushl %ds
	[...]
	pushl 16(%esp); pushl 24(%esp); 
	pushl 32(%esp); pushl 40(%esp); 
	pushl $int_msg
	[...]
	call printk

** But here's the state of stack before calling printk:

     ???            <-- 40(%esp)             
     ???            <-- 36(%esp)
     --> (Automatically pushed by the processor)
     %eflags        <-- 32(%esp)
     %cs	    <-- 28(%esp)
     %eip	    <-- 24(%esp)
     error-code     <-- 20(%esp)
     --> (Pushed by first lines of ignore_int)
     %eax	    <-- 16(%esp)
     %ecx	    <--	12(%esp)
     %edx	    <-- 8(%esp)
     %es	    <-- 4(%esp)
     %ds	    <-- %esp      

Does 40(%esp) hold a meaningfule value here ?. Also why passing 4 arguments after
the string to prinkt while the string only has 3 conversion specifications (i.e.,
3 * %p) ?.

Best regards,

-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
