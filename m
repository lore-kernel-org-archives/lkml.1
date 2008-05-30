Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbYE3WlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbYE3WlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 18:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbYE3Wky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 18:40:54 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:20535 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbYE3Wkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 18:40:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=tlQUw6TiR/I4FvMjVzhtPe7EOArL29YIoI4FzxIWQEIlMV5uenETQcTmtRlyaMy5HyQVguCMSXsABXE7VV1R/IOaSuuLgeuA+VWHrwptRYVZXqRsd3XQzHLZEXxrNayBD+I9F7/AJs/OSab76/Ba7zLoUfH7O/sQb9VMqUiWWBY=
Date: Sat, 31 May 2008 02:36:03 +0300
To: Casey Schaufler <casey@schaufler-ca.com>, Paul Moore <paul.moore@hp.com>
Cc: linux-security-module@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH BUGFIX -rc4] Smack: Respect 'unlabeled' netlabel mode
Message-ID: <20080530233603.GA2994@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

In case of Smack 'unlabeled' netlabel option, Smack passes a _zero_
initialized 'secattr' to label a packet/sock. This causes an 
[unfound domain label error]/-ENOENT by netlbl_sock_setattr().
Above Netlabel failure leads to Smack socket hooks failure causing 
an always-on socket() -EPERM error.

Such packets should have a netlabel domain agreed with netlabel to 
represent unlabeled packets. Fortunately Smack net ambient label 
packets are agreed with netlabel to be treated as unlabeled packets. 

Treat all packets coming out from a 'unlabeled' Smack system as
coming from the smack net ambient label.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index b5c8f92..03735f4 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1292,6 +1292,8 @@ static void smack_to_secattr(char *smack, struct netlbl_lsm_secattr *nlsp)
 		}
 		break;
 	default:
+		nlsp->domain = kstrdup(smack_net_ambient, GFP_ATOMIC);
+		nlsp->flags = NETLBL_SECATTR_DOMAIN;
 		break;
 	}
 }

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

