Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181Ab0A1GsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab0A1GsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 01:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819Ab0A1GsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 01:48:08 -0500
Received: from mail.windriver.com ([147.11.1.11]:49559 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab0A1GsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 01:48:06 -0500
Message-ID: <4B61357A.5080001@windriver.com>
Date: Thu, 28 Jan 2010 14:58:02 +0800
From: Hui Zhu <hui.zhu@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Sam Ravnborg <sam@ravnborg.org>, ozan@pardus.org.tr,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org,
       teawater@gmail.com
Subject: [PATCH] markup_oops.pl: fix get "No matching code found" when first
 line of range is the faulting instruction
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2010 06:46:53.0102 (UTC) FILETIME=[ACECFCE0:01CA9FE5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry guys, the prev mail for this patch is ugly.
I make a new mail for it.

I got a "No matching code found" when I use markup_oops.pl parse a error in a x8664 module.

cat e.c
#include <linux/version.h>
#include <linux/kernel.h>
#include <linux/module.h>


int init_module(void)
{
	char	*buf = 0;

	buf[0] = 3;

	return 0;
}

void cleanup_module(void)
{
	//char	*buf = 0;

	//buf[0] = 3;
}

MODULE_AUTHOR("Hui Zhu");
MODULE_LICENSE("GPL");


0000000000000000 <init_module>:
init_module():
/home/teawater/study/kernel/stack2core/example/e.c:10
   0:	c6 04 25 00 00 00 00 	movb   $0x3,0x0
   7:	03 
/home/teawater/study/kernel/stack2core/example/e.c:13
   8:	31 c0                	xor    %eax,%eax
   a:	c3                   	retq   
   b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000000010 <cleanup_module>:
cleanup_module():
/home/teawater/study/kernel/stack2core/example/e.c:20
  10:	f3 c3                	repz retq 
  12:	90                   	nop    
  13:	90                   	nop    
Disassembly of section .modinfo:

This is because the faulting instruction "movb   $0x3,0x0" is the first line of the range.

In the markup_oops.pl:
main::(./scripts/markup_oops.pl:245):
245:				if (InRange($1, $target)) {
  DB<2> p $line
ffffffffa001b000:	c6 04 25 00 00 00 00 	movb   $0x3,0x0
  DB<3> p $counter
0

It just set $center in next loop.
So it cannot get the $center.

And even if $center is set to the right value 0.
if ($center == 0) {
	print "No matching code found \n";
	exit;
}

So I make a patch change this part to:
	}
	if ($state == 1) {
And this is another part is not OK too:
if ($center == 0) {
The first line $center will be 0, so I change the default value and decide to:
my $center  = -1;
if ($center == -1) {

Thanks,
Hui

Signed-off-by: Hui Zhu <teawater@gmail.com>

---
 scripts/markup_oops.pl |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/scripts/markup_oops.pl
+++ b/scripts/markup_oops.pl
@@ -214,7 +214,7 @@ if ($module ne "") {
 
 my $counter = 0;
 my $state   = 0;
-my $center  = 0;
+my $center  = -1;
 my @lines;
 my @reglines;
 
@@ -246,7 +246,8 @@ while (<FILE>) {
 				$state = 1;
 			}
 		}
-	} else {
+	}
+	if ($state == 1) {
 		if ($line =~ /^([a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9]+)\:/) {
 			my $val = $1;
 			if (!InRange($val, $target)) {
@@ -269,7 +270,7 @@ if ($counter == 0) {
 	exit;
 }
 
-if ($center == 0) {
+if ($center == -1) {
 	print "No matching code found \n";
 	exit;
 }
