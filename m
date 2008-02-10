Return-Path: <linux-kernel-owner+w=401wt.eu-S1752195AbYBJPGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbYBJPGw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 10:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbYBJPGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 10:06:42 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:54489 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbYBJPGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 10:06:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:mime-version:content-type;
        b=ZFNUvvPARwx2G4KX1RcPE4mUe+lpI0r/vEjSGeZezK1M0tu59qGYCI9DprkHNO11hwWHQ5/31dszdPZtSh/N8ljd7K2CgKbGTrG1Sr814aIGAYrt8VOE+VoCGVsnxzKVUmQIKovmb3/hML+fvc2HxNObBy0RkALTvc1ogKYzfHw=
Date: Sun, 10 Feb 2008 23:06:35 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Patrick McHardy <kaber@trash.net>
cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Krzysztof Piotr Oledzki <ole@ans.pl>,
       "David S. Miller" <davem@davemloft.net>,
       cups-bugs <cups-bugs@easysw.com>,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: cups slow on linux-2.6.24
Message-ID: <Pine.LNX.4.64.0802102257420.14442@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 5, 2008 9:47 PM, Patrick McHardy wrote:
>> On Feb 5, 2008 4:16 PM, Jozsef Kadlecsik wrote:
>> Patrick, I suppose you need a patch against the latest git, don't you?
> Yes, please. I'll take you first patch for -stable though if you
> send me a Signed-off-by: line.

Please note the lastest git commit is missing one part (which was in 
Jozsef's original patch).

 	commit b2155e7f70b3f058efe94c0c459db023b05057bd
 	Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
 	Date:   Thu Feb 7 17:54:56 2008 -0800

 	    [NETFILTER]: nf_conntrack: TCP conntrack reopening fix


I've tested the following missing patch, and it solves the cups slow 
printing problem.


Thanks,
Jeff

--- a/net/netfilter/nf_conntrack_proto_tcp.c.org	2008-02-10 22:45:49 +0800
+++ a/net/netfilter/nf_conntrack_proto_tcp.c	2008-02-10 22:45:56 +0800
@@ -945,7 +945,7 @@

  	ct->proto.tcp.state = new_state;
  	if (old_state != new_state
-	    && new_state == TCP_CONNTRACK_CLOSE)
+	    && new_state == TCP_CONNTRACK_FIN_WAIT)
  		ct->proto.tcp.seen[dir].flags |= IP_CT_TCP_FLAG_CLOSE_INIT;
  	timeout = ct->proto.tcp.retrans >= nf_ct_tcp_max_retrans
  		  && tcp_timeouts[new_state] > nf_ct_tcp_timeout_max_retrans
