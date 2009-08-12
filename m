Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbZHLBxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbZHLBxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 21:53:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755098AbZHLBxC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 21:53:02 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:38266 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbZHLBxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 21:53:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=RbsSTvZ9kTpl49bXZA7eA1S4PIfmfTFkEf8nl/LelrNeC/LG1Jv42xYGfrQ5PNQz0H
         kQuuRDJSbi+jFWc4kpR0wSfhwmlI06bQVEiEWeSJe/2tEXYO5hbbKwMPBPupio37jOng
         y9moS32M3+JBePtr043VzrZJ6KeSUZWjJ2GjU=
MIME-Version: 1.0
Date: Wed, 12 Aug 2009 09:53:01 +0800
Message-ID: <505766fa0908111853y7030399ewb07d4cec6829fd16@mail.gmail.com>
Subject: Sparc miss chance to fix recoverable fault in copy_from_user
From: hyl <heyongli@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if kernel code access the invalid address, ie, copy_from_user then tlb
miss handler
finally report error in sunv4_dtlb_errorthen halt. instead of halt,
should call do_sparc64_fault
to fix such fault by search extable.

a dirty fix like this can work( little testing,just boot and test the
copy_from_user).


--- a/arch/sparc/kernel/sun4v_tlb_miss.S
+++ b/arch/sparc/kernel/sun4v_tlb_miss.S
@@ -124,7 +124,7 @@ sun4v_dtlb_load:
 	mov	%g3, %o2		! PTE
 	mov	HV_MMU_DMMU, %o3	! flags
 	ta	HV_MMU_MAP_ADDR_TRAP
-	brnz,pn	%o0, sun4v_dtlb_error
+	brnz,pn	%o0, sun4v_dtlb_prot
 	 mov	%g2, %o1		! restore %o1
 	mov	%g1, %o0		! restore %o0
 	mov	%g5, %o2		! restore %o2



am i miss understanding the merged sparc/spar64?

this problem found on sparc64, via a simple module just access address 0
via copy_from_user. another simple test is kgdb, issue a cmd:
x 0
