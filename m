Return-Path: <linux-kernel-owner+w=401wt.eu-S932502AbYEBR0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502AbYEBR0y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 13:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbYEBR0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 13:26:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbYEBR0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 13:26:44 -0400
Message-ID: <481B4EC5.6060507@redhat.com>
Date: Fri, 02 May 2008 12:26:29 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@lazybastard.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] find dynamic stack allocations in checkstack.pl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, checkstack.pl only looks for fixed subtractions from the stack
pointer.  However, things like this:

void function(int size)
{
        char stackbuster[size << 2];
...

are certainly worth pointing out, I think.

This could perhaps be done more cleanly, and the following patch only
adds "dynamic" REs for x86 and x86_64, but it works:

0x00b0 crypto_cbc_decrypt_inplace [cbc]:                Dynamic (%rax)
0x00ad crypto_pcbc_decrypt_inplace [pcbc]:              Dynamic (%rax)
0x02f6 crypto_pcbc_encrypt_inplace [pcbc]:              Dynamic (%rax)
0x036c _crypto_xcbc_digest_setkey [xcbc]:               Dynamic (%rax)
...

(Inspired by Keith Owens' old stack-check script)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6.25/scripts/checkstack.pl
===================================================================
--- linux-2.6.25.orig/scripts/checkstack.pl	2008-05-02 12:18:15.426407528 -0500
+++ linux-2.6.25/scripts/checkstack.pl	2008-05-02 12:18:25.989469552 -0500
@@ -26,8 +26,12 @@
 # $& (whole re) matches the complete objdump line with the stack growth
 # $1 (first bracket) matches the size of the stack growth
 #
+# $dre is similar, but for dynamic stack redutions:
+# $& (whole re) matches the complete objdump line with the stack growth
+# $1 (first bracket) matches the dynamic amount of the stack growth
+#
 # use anything else and feel the pain  ;) 
-my (@stack, $re, $x, $xs);
+my (@stack, $re, $dre, $x, $xs);
 {
 	my $arch = shift;
 	if ($arch eq "") {
@@ -47,9 +51,11 @@ my (@stack, $re, $x, $xs);
 	} elsif ($arch =~ /^i[3456]86$/) {
 		#c0105234:       81 ec ac 05 00 00       sub    $0x5ac,%esp
 		$re = qr/^.*[as][du][db]    \$(0x$x{1,8}),\%esp$/o;
+		$dre = qr/^.*[as][du][db]    (%.*),\%esp$/o;
 	} elsif ($arch eq 'x86_64') {
 		#    2f60:	48 81 ec e8 05 00 00 	sub    $0x5e8,%rsp
 		$re = qr/^.*[as][du][db]    \$(0x$x{1,8}),\%rsp$/o;
+		$dre = qr/^.*[as][du][db]    (\%.*),\%rsp$/o;
 	} elsif ($arch eq 'ia64') {
 		#e0000000044011fc:       01 0f fc 8c     adds r12=-384,r12
 		$re = qr/.*adds.*r12=-(([0-9]{2}|[3-9])[0-9]{2}),r12/o;
@@ -142,6 +148,22 @@ while (my $line = <STDIN>) {
 		next if ($size < 100);
 		push @stack, "$intro$size\n";
 	}
+	elsif (defined $dre && $line =~ m/$dre/) {
+		my $size = "Dynamic ($1)";
+
+		next if $line !~ m/^($xs*)/;
+		my $addr = $1;
+		$addr =~ s/ /0/g;
+		$addr = "0x$addr";
+
+		my $intro = "$addr $func [$file]:";
+		my $padlen = 56 - length($intro);
+		while ($padlen > 0) {
+			$intro .= '	';
+			$padlen -= 8;
+		}
+		push @stack, "$intro$size\n";
+	}
 }
 
 print sort bysize @stack;

