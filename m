Return-Path: <linux-kernel-owner+w=401wt.eu-S1757131AbYLaWAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131AbYLaWAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 17:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbYLaWAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 17:00:21 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:40549 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbYLaWAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 17:00:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=R1NsTMFH7JyG5KZR8pt6zQt+TIwz3zdI/urjkd3E6nn//qfQlzqXXrHS0H0y0m0ekw
         H2jHLhZX+tMTqpKpgHykmJ2SusPK5Ca7Cm72LK7gtkYY9x6EpLU/l3938lqA7VMKBszt
         78m0vNyNcvX/ekBnb1SHPf7/HywTORLzcC0F8=
Message-ID: <84ee33570812311400m5492af64n45c645a13fe91c2c@mail.gmail.com>
Date: Wed, 31 Dec 2008 17:00:19 -0500
From: "Matt Cross" <matt.cross@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: ebtables match inverted in 2.6.28?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think the work to move ebtables to use xtables broke ebtables.
Specifically, in commit 8cc784eec6676b58e7f60419c88179aaa97bf71c the
return value of the match functions was inverted so that they return 1
(true) on matches instead of EBT_MATCH (0), and vice versa (look in
ebt_ip.c).  The logic in ebtables.c (ebt_do_table() and
EBT_MATCH_ITERATE()) expect match functions to return 0 for matches.

The patch at the end of this message fixes the problem, but seems a
little hacky to me.  Who's the right person to address this?

    -Matt


--- linux-2.6.28.orig/net/bridge/netfilter/ebtables.c   2008-12-24
18:26:37.000000000 -0500
+++ linux-2.6.28/net/bridge/netfilter/ebtables.c        2008-12-31
16:17:44.000000000 -0500
@@ -80,7 +80,7 @@
 {
        par->match     = m->u.match;
        par->matchinfo = m->data;
-       return m->u.match->match(skb, par);
+       return !m->u.match->match(skb, par);
 }

 static inline int ebt_dev_check(char *entry, const struct net_device *device)
