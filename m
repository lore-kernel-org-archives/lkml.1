Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbZCJMj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbZCJMj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 08:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbZCJMjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 08:39:49 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:16633 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbZCJMjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 08:39:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=LWOXcKpUbWlZIuT3Egi0Z6YCqaSJFRmbfNyg/7164k0Wc6Ggyx10WBIADbhKIG902w
         3pgt25VmMxrJSbG+T79M841KtxVHtvMZkUcqDO2qcGpat9Kh0vmuJWY9G1vAT7WgLeyN
         hnUyG5AlEkIjw8zMSnpNLI31Ij6RAHamZOui4=
MIME-Version: 1.0
Date: Tue, 10 Mar 2009 15:39:46 +0300
Message-ID: <a63d67fe0903100539r6ca3d789m4be81239eba2bf3b@mail.gmail.com>
Subject: smatch 1.51 released
From: Dan Carpenter <error27@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       smatch-discuss <smatch-discuss@lists.sf.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smatch follows the kernel naming scheme so odd numbers are devel
releases.  The .51 means over half finished.

Smatch is available from:  http://repo.or.cz/w/smatch.git/

This is a reimplementation that doesn't use gcc code.  The check are
written in C instead of Perl.  It's still fairly simple to write
tests.  It's a bazillion times better than the original in almost
every way.  Unfortunately it still sucks a little.  There is a
shocking high percent of false positives.

To test the whole kernel use:
make -k CHECK=/path/to/smatch C=y bzImage | tee warns.txt

To test a single file use the smatch_scripts/kchecker script.
kchecker drivers/acpi/acpica/nsxfobj.c

The output is labeled either error, warn, or info.  So "grep -w error:
warns.txt"  Most of the "info" stuff is for the
smatch_scripts/find_null_params.sh script.  Even though it's labeled
"info", grepping for "info: ignoring unreachable code." sometimes
turns up bugs.

Smatch works by tracking the flow of code.
int a;  <- state is uninitialized.
if (b) {
       a = foo();  <- state is initialized.
       if (a) {
              bar(a);  <- state is non zero.
       }
}
baz(a);  <- state is undefined.  possibly uninitialized, zero, or non-zero

It also understands some simple implications.  For example the
following code doesn't generate an error.
	ab = kzalloc();
	if (NULL == ab) {
		ret = -1;
		goto foo;
	}
   ...
foo:
	if (ret) {
		return;
	}
	ab->a = 1;  // <-- This is not an error.

There are a couple functions that use a lot of memory to check.  If
you have a gig of memory you should be ok.  If it crashes use
"kchecker --valgrind" to generate a stack dump and mail that to me.

If you can't figure out why an error gets generated it's probably a
bug.  Use "kchecker --debug" to try figure out what went wrong.

regards,
dan carpenter
