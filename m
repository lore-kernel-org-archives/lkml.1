Return-Path: <linux-kernel-owner+w=401wt.eu-S1754325AbZCPPbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbZCPPbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 11:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbZCPPbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 11:31:25 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:36137 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbZCPPbZ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 11:31:25 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Arjan van de Ven <arjan@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: linux-next - request_module_nowait() breaks iptables and iwl3945
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1237168684_3707P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 15 Mar 2009 21:58:04 -0400
Message-ID: <3823.1237168684@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1237168684_3707P
Content-Type: text/plain; charset=us-ascii

On recent linux-next, iptables and iwl3945 would fail to load

Bisected down to this commit:

87e10115fb652a966965da1ac305cb57e6db5a45 is first bad commit
commit 87e10115fb652a966965da1ac305cb57e6db5a45
Author: Arjan van de Ven <arjan@linux.intel.com>
Date:   Sun Feb 8 10:42:01 2009 -0800

    module: create a request_module_nowait()
    
    There seems to be a common pattern in the kernel where drivers want to
    call request_module() from inside a module_init() function. Currently
    this would deadlock.
    
    As a result, several drivers go through hoops like scheduling things via
    kevent, or creating custom work queues (because kevent can deadlock on them).
    
    This patch changes this to use a request_module_nowait() function macro instead,
    which just fires the modprobe off but doesn't wait for it, and thus avoids the
    original deadlock entirely.
    
    On my laptop this already results in one less kernel thread running..
    
    Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

:040000 040000 02a1e199052893007e41f161997e552cbc5f3c1b 89c67f6d538089bdffd8a15dfccbf4e11cd06b0b M      include
:040000 040000 dc67697b7b18db74a3cf13631877dc81dd8da83b 4edd476bccbb2ba62d34625290ec878d29158d6b M      kernel

Reverting this commit and 1ae06b4e8430b44872422cff235faa5610d3e79b (the following
cleanup fix) makes iptables and iwl3945 start working again.


--==_Exmh_1237168684_3707P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJvbIscC3lWbTT17ARAimfAKDGVXfuQ8+goYo+0PNSpSlu6xUquQCfSALK
szJHNVvLlnc1kU/wS4qCg1o=
=Az4A
-----END PGP SIGNATURE-----

--==_Exmh_1237168684_3707P--
