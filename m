Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbYJVV5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbYJVV5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 17:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbYJVV5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 17:57:05 -0400
Received: from server.lespinasse.org ([64.142.28.226]:55024 "EHLO
	server.lespinasse.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbYJVV5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 17:57:05 -0400
X-Greylist: delayed 1647 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Oct 2008 17:57:05 EDT
Date: Wed, 22 Oct 2008 14:29:34 -0700
From: Michel Lespinasse <walken@zoy.org>
To: linux-kernel@vger.kernel.org
Subject: NFS 5-minute hangs upon S3 resume using 2.6.27 client
Message-ID: <20081022212934.GA24143@zoy.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This has been mentionned in bugzilla already, but I'd like to draw attention
before it gets too late for 2.6.28.

The following is a common cause of 5-minute NFS hangs here:

* Client has TCP connections to the NFS server, goes to S3 sleep for few hours.
* TCP connections die on the server side.
  (not 100% sure why, do they use some kind of keepalive ???)
* Client resumes from S3.
* Client sends NFS requests down its TCP connections, gets back RST packet.
* [Client hangs for exactly 300 seconds here]
* Client establishes new TCP connections to the NFS server,
  and recovers from the hang.

A tcpdump trace is attached at the end of bugzilla bug 11154:
http://bugzilla.kernel.org/show_bug.cgi?id=11154

Should the client immediately try to reconnect when its existing connection
receives an RST packet ? (the 5 minute delay would make sense to me if
RST was received in reply to a SYN, but I'm not sure about it in the case
of an existing open TCP connection).

If the 5 minute delay after an RST is necessary, could the client avoid it
by explicitly closing/reopening its connections using suspend/resume hooks ?

(I can not work around the issue locally by mounting/unmounting my NFS
shares around the suspend/resume because rootfs also on NFS...)

This NFS setup was working fine in 2.6.24. There has been issues with
2.6.25 and 2.6.26, but I did not confirm if they are the same bug.
2.6.25 usualy recovers after some variable delay and 2.6.26 usualy
does not recover. Bugs 11154 and 11061 have more details about this,
also Ian Campbell has been tracking an NFS issue under load that
appeared at around the same time.

Hope this helps,

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
