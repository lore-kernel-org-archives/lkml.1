Return-Path: <linux-kernel-owner+w=401wt.eu-S1751800AbYJNNT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbYJNNT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 09:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbYJNNTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 09:19:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:22439 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbYJNNTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 09:19:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=Pad7XNfNIInIEmpYL4EFq+NdSu0JDW5/qvO6yOU9vih7hN87uqs31/oFTQ0sc8UGH8
         ec/6ksDo0gGW+GdBFf6rUnyayTyGYBFXyOd6I78WJpnqTz1NHQX1id60EmNZTevf17G+
         jujpeHxU5p6M0e5RKL8ZlUhkqNa+m033D3GL4=
Message-ID: <48F49C53.1070103@tuffmail.co.uk>
Date: Tue, 14 Oct 2008 14:19:15 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] fastboot: fix row order in bootgraph.pl
References: <48F49C0F.7050705@tuffmail.co.uk>
In-Reply-To: <48F49C0F.7050705@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When bootgraph.pl parses a file, it gives one row for each initcall's 
pid.  But they are displayed in random (perl hash) order.  Let's
sort the pids by the start time of their first initcall instead.

This helps trace module initcalls, where each has a separate pid.  
bootgraph.pl will show module initcalls during the initramfs; it may
also be adapted to show subsequent module initcalls.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

diff --git a/scripts/bootgraph.pl b/scripts/bootgraph.pl
index ea2b079..d2c61ef 100644
--- a/scripts/bootgraph.pl
+++ b/scripts/bootgraph.pl
@@ -108,9 +108,9 @@ my $threshold = ($maxtime - $firsttime) / 60.0;
 my $stylecounter = 0;
 my %rows;
 my $rowscount = 1;
+my @initcalls = sort { $start{$a} <=> $start{$b} } keys(%start);
 my $key;
-my $value;
-while (($key,$value) = each %start) {
+foreach $key (@initcalls) {
 	my $duration = $end{$key} - $start{$key};
 
 	if ($duration >= $threshold) {
@@ -121,7 +121,7 @@ while (($key,$value) = each %start) {
 			$rows{$pid} = $rowscount;
 			$rowscount = $rowscount + 1;
 		}
-		$s = ($value - $firsttime) * $mult;
+		$s = ($start{$key} - $firsttime) * $mult;
 		$s2 = $s + 6;
 		$e = ($end{$key} - $firsttime) * $mult;
 		$w = $e - $s;


