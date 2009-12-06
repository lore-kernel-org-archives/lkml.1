Return-Path: <linux-kernel-owner+w=401wt.eu-S932899AbZLFQak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899AbZLFQak (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 11:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755725AbZLFQai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 11:30:38 -0500
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:63363 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbZLFQai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 11:30:38 -0500
Message-ID: <4B1BDC30.6020800@freemail.hu>
Date: Sun, 06 Dec 2009 17:30:40 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: __devinitdata, __devinitconst and const?
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail02a.mail.t-online.hu 32711; Body=1 Fuz1=1
	Fuz2=1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I would like to understand how __devinitdata and __devinitconst works. I
also would like to see what happens if I make a mistake: is it recognised
by any of the static analyze tools (i.e. by gcc or by modpost).

So I created a little test module and I tried to compile it with gcc 4.3.2.
My expectation would be that the variables a, d, e, h, a_str, d_str, e_str
and h_str are OK. I also expect that the variables b, c, f, g, b_str, c_str,
f_str and g_str are wrong because of section mismatch.

The current result, however, is a bit confusing to me. Here it is:

$ make
make -C /lib/modules/2.6.32-rc8/build M=/home/nmarci/c/hello2 modules
make[1]: Entering directory `/usr/src/linux-2.6.32-rc8'
  CC [M]  /home/nmarci/c/hello2/test.o
/home/nmarci/c/hello2/test.c:5: error: b causes a section type conflict
/home/nmarci/c/hello2/test.c:7: error: d causes a section type conflict
/home/nmarci/c/hello2/test.c:15: error: b_str causes a section type conflict
/home/nmarci/c/hello2/test.c:17: error: d_str causes a section type conflict
/home/nmarci/c/hello2/test.c:20: error: f_str causes a section type conflict
/home/nmarci/c/hello2/test.c:22: error: h_str causes a section type conflict
make[2]: *** [/home/nmarci/c/hello2/test.o] Error 1
make[1]: *** [_module_/home/nmarci/c/hello2] Error 2
make[1]: Leaving directory `/usr/src/linux-2.6.32-rc8'
make: *** [default] Error 2

Here is the source code of my test.c:

------>8------- cut here ----->8-------
#include <linux/init.h>
#include <linux/module.h>

int a __devinitdata = 0x11223344;
const int b __devinitdata = 0x55667788; // error: b causes a section type conflict
int c __devinitconst = 0x99AABBCC;
const int d __devinitconst = 0xDDEEFF00; // error: d causes a section type conflict

static int e __devinitdata = 0x12233445;
static const int f __devinitdata = 0x56677889;
static int g __devinitconst = 0x900AABBC;
static const int h __devinitconst = 0xCDDEEFF0;

char a_str[] __devinitdata = "first";
const char b_str[] __devinitdata = "second"; // error: b_str causes a section type conflict
char c_str[] __devinitconst = "third";
const char d_str[] __devinitconst = "fourth"; // error: d_str causes a section type conflict

static char e_str[] __devinitdata = "fifth";
static const char f_str[] __devinitdata = "sixth"; // error: f_str causes a section type conflict
static char g_str[] __devinitconst = "seventh";
static const char h_str[] __devinitconst = "eighth"; // error: h_str causes a section type conflict

static void __devinit probe(void)
{
	printk(KERN_ALERT "a=0x%X\n", a);
	printk(KERN_ALERT "b=0x%X\n", b);
	printk(KERN_ALERT "c=0x%X\n", c);
	printk(KERN_ALERT "d=0x%X\n", d);

	printk(KERN_ALERT "e=0x%X\n", e);
	printk(KERN_ALERT "f=0x%X\n", f);
	printk(KERN_ALERT "g=0x%X\n", g);
	printk(KERN_ALERT "h=0x%X\n", h);

	printk(KERN_ALERT "a_str=%s\n", a_str);
	printk(KERN_ALERT "b_str=%s\n", b_str);
	printk(KERN_ALERT "c_str=%s\n", c_str);
	printk(KERN_ALERT "d_str=%s\n", d_str);

	printk(KERN_ALERT "e_str=%s\n", e_str);
	printk(KERN_ALERT "f_str=%s\n", f_str);
	printk(KERN_ALERT "g_str=%s\n", g_str);
	printk(KERN_ALERT "h_str=%s\n", h_str);
}

static int __init test_init(void)
{
	printk(KERN_ALERT "Test loaded\n");
	probe();

	return 0;
}

static void __exit test_exit(void)
{
	printk(KERN_ALERT "Test unloaded\n");
}

module_init(test_init);
module_exit(test_exit);
------>8------- cut here ----->8-------

Anybody can tell me what went wrong?

Regards,

	Márton Németh

