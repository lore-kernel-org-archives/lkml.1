Return-Path: <linux-kernel-owner+w=401wt.eu-S1758158AbXEaCYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbXEaCYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 22:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754432AbXEaCYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 22:24:38 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:52258 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbXEaCYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 22:24:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:x-url:organization:user-agent:sender;
        b=UoMGfAoI6C8PhlvWBrgKXhvDN9MKe1kiikOBLwqLyFHbJSSB2btNgjaMoET7Bq/7OZHYUSB0gBe+QCmqLLH925zUinhaGD7PkT6Yfg0ubcX2p3skQ8+NZ5G4EdY9JZ/TOoZsza6Zk7VhUpiWnwqtB6Qpwbdui5C8ekIE6ghVlHo=
Date: Wed, 30 May 2007 23:24:27 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: John Levon <levon@movementarian.org>
Cc: linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       alan@lxorguk.ukuu.org.uk, davej@redhat.com, ak@muc.de
Subject: [PATCH][OPROFILE] x86: Use for_each_possible_cpu to allocate msrs
	(was [PATCH] x86: fix oprofile double free (was Re: Multiple free
	during oprofile unload))
Message-ID: <20070531022427.GA21633@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	John Levon <levon@movementarian.org>, linux-kernel@vger.kernel.org,
	chrisw@sous-sol.org, alan@lxorguk.ukuu.org.uk, davej@redhat.com,
	ak@muc.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
Organization: OOPS Labs
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The fix for the fix needed a fix: allocate_msrs() was using
for_each_online_cpu(), but nmi_setup uses for_each_possible_cpu(), and
in my test machine, a Dell Poweredge 1950 I have 2 dual core Xeons,
which makes for 4 possible cores, but wait, they are HT capable, so...

[acme@mica linux-2.6.21.3.orig]$ dmesg | grep Allowing
SMP: Allowing 8 CPUs, 4 hotplug CPUs
[acme@mica linux-2.6.21.3.orig]$

We have 8 possible CPUs, but only 4 online, b00m. Fix it by making
allocate_msrs agree with nmi_setup, i.e. make both use
for_each_possible_cpu().

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---


diff -uNrp linux-2.6.21.3.orig/arch/i386/oprofile/nmi_int.c linux-2.6.21.3.new/arch/i386/oprofile/nmi_int.c
--- linux-2.6.21.3.orig/arch/i386/oprofile/nmi_int.c	2007-05-30 23:08:33.000000000 -0300
+++ linux-2.6.21.3.new/arch/i386/oprofile/nmi_int.c	2007-05-30 23:09:17.000000000 -0300
@@ -154,7 +154,7 @@ static int allocate_msrs(void)
 	size_t counters_size = sizeof(struct op_msr) * model->num_counters;
 
 	int i;
-	for_each_online_cpu(i) {
+	for_each_possible_cpu(i) {
 		cpu_msrs[i].counters = kmalloc(counters_size, GFP_KERNEL);
 		if (!cpu_msrs[i].counters) {
 			success = 0;
