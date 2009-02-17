Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbZBQUB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbZBQUB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 15:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZBQUBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 15:01:20 -0500
Received: from smtp6.tech.numericable.fr ([82.216.111.42]:48567 "EHLO
	smtp6.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbZBQUBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 15:01:19 -0500
Message-ID: <499B178B.9090601@numericable.fr>
Date: Tue, 17 Feb 2009 21:01:15 +0100
From: etienne <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: [PATCH] SMACK netfilter smacklabel socket match
References: <fa.O38YY4pVfLlMFJNBI3mhgn+qOcQ@ifi.uio.no> <fa.c87eBVWyCqqi9h1c54QlwKDAIbg@ifi.uio.no> <fa.f7jv/+EnhNJziduAqQS3XHiU6/A@ifi.uio.no> <fa.1A5YyyPb1uCn//vnk7baNJGI0IM@ifi.uio.no> <fa.HFpMNTzIQ1+pODZB3+XkfnipCfo@ifi.uio.no> <fa.3IBoeBnwT1eZcqeO6DAE1tHBYc4@ifi.uio.no>
In-Reply-To: <fa.3IBoeBnwT1eZcqeO6DAE1tHBYc4@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello,


i was playing with smack, trying to do funny things
Alas, when I use a 'labelled process' and try to access internet, packet are dropped sooner or later (because of ip options)

I tried to 
echo 0.0.0.0/0 @ > /smack/netlabel 
with no success...


looking at security/smack/smack_lsm.c:smack_host_label
the following lines

bestmask.s_addr = 0;
...
if ((miap->s_addr | bestmask.s_addr) == bestmask.s_addr)
   continue;

if the dest we try to reach match the 0.0.0.0/0, this condition will be true (either because we have a better match or because, well (miap->s_addr | bestmask.s_addr) == bestmask.s_addr == 0

So let the 0.0.0.0/0 a chance!

I realize this patch is a little ugly, a cleaner way would be to insert  struct smk_netlbladdr sorted from longest to smallest mask and break the loop as soon as we have a match...
regards,
Etienne 



Signed-off-by: Etienne <etienne.basset@numericable.fr>
------
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 0278bc0..9d2576d 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1540,7 +1540,7 @@ static char *smack_host_label(struct sockaddr_in *sip)
                 * If the list entry mask is less specific than the best
                 * already found this entry is uninteresting.
                 */
-               if ((miap->s_addr | bestmask.s_addr) == bestmask.s_addr)
+               if ( ((miap->s_addr | bestmask.s_addr) == bestmask.s_addr) &&  (miap->s_addr | bestmask.s_addr) != 0  )
                        continue;
                /*
                 * This is better than any entry found so far.
