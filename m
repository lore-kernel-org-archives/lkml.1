Return-Path: <linux-kernel-owner+w=401wt.eu-S1758305AbYILVMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305AbYILVMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 17:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757959AbYILVL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 17:11:57 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:53031 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757610AbYILVL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 17:11:56 -0400
From: David Sanders <linux@sandersweb.net>
Reply-To: linux@sandersweb.net
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: nops in virtual pc x86
Date: Fri, 12 Sep 2008 17:11:47 -0400
User-Agent: KMail/1.9.5
Cc: "the arch/x86 maintainers" <x86@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809121711.48558.linux@sandersweb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, I thought we determined that multibyte nops were causing virtual pc to 
die and removing them made it work fine.  Then why do I see this
$ cat /proc/cpuinfo | grep nopl

flags           : fpu vme pse tsc msr pae cx8 sep pge cmov acpi mmx fxsr sse 
sse2 constant_tsc up nopl lahf_lm
             
It seems the detection code in common.c is saying nops are supported.  Huh?

SO I ran this code:
#include <stdio.h>
#include <time.h>

int main()
{
	unsigned char nopl1[2] = { 0x90, 0xc3 };
	unsigned char nopl2[3] = { 0x66, 0x90, 0xc3 };
	unsigned char nopl3[4] = { 0x0f, 0x1f, 0x00, 0xc3 };
	unsigned char nopl4[5] = { 0x0f, 0x1f, 0x40, 0x00, 0xc3 };
	unsigned char nopl5[6] = { 0x0f, 0x1f, 0x44, 0x00, 0x00, 0xc3 };
	unsigned char nopl6[7] = { 0x66, 0x0f, 0x1f, 0x44, 0x00, 0x00, 0xc3 };
	unsigned char nopl7[8] = { 0x0f, 0x1f, 0x80, 0x00, 0x00, 0x00, 0x00, 0xc3 };
	unsigned char nopl8[9] = { 0x0f, 0x1f, 0x84, 0x00, 0x00, 0x00, 0x00, 0x00, 
0xc3 };
	
	int i;
	for (i=0;i<100000;i++) {
		((void (*)()) nopl1)();
		((void (*)()) nopl2)();
		((void (*)()) nopl3)();
		((void (*)()) nopl4)();
		((void (*)()) nopl5)();
		((void (*)()) nopl6)();
		((void (*)()) nopl7)();
		((void (*)()) nopl8)();
	}
	
	printf("Executed 800,000 NOPLs in %d ticks with no errors.\n", clock());
	return 0;
}

It seems I can run 800000 nopl's without anyone complaining in user space.

Could it perhaps depend on the context the nops appear in?

