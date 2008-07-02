Return-Path: <linux-kernel-owner+w=401wt.eu-S1763513AbYGBL2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763513AbYGBL2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755406AbYGBL17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:27:59 -0400
Received: from p01c11o144.mxlogic.net ([208.65.144.67]:47165 "EHLO
	p01c11o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbYGBL16 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:27:58 -0400
X-Greylist: delayed 1427 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jul 2008 07:27:58 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: nfs client readdir caching issue?
Date: Wed, 2 Jul 2008 12:03:55 +0100
Message-ID: <0F10A59FDFFDFD4E9BEBD7365DE6725501EC3707@uk-email.terastack.bluearc.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: nfs client readdir caching issue?
Thread-Index: AcjcM1HCEjwpPwVoQbafOKQEnNv5+Q==
From: "Andy Chittenden" <andyc@bluearc.com>
To: <linux-kernel@vger.kernel.org>
X-Spam: [F=0.1000000000; S=0.100(2008062001)]
X-MAIL-FROM: <andyc@bluearc.com>
X-SOURCE-IP: [62.190.48.218]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Very rarely, we're seeing various problems on a linux kernel client
(seen on various versions) with ls on directories from an NFS server
that haven't changed:

* looping ls (strace -v shows getdents returning the same names over
again).
* duplicate directory entries.
* missing directory entries.

I've hunted google but can only see problems where NFS servers have
returned duplicate cookies. I've packet captured the readdirplus on one
of the directories and see no duplicate cookies. The problems remain
until the directory is touched, the NFS server is unmounted or some
other event happens (the data is flushed from the cache?).

I think we then got lucky and got two packet captures from different
clients running the same linux kernel. On these clients, the ls output
was ok - no loops, no duplicates, no missing entries. Both captures
showed two readdirplus requests returning the same entries in the same
order but the amount of data in the responses was different. One capture
showed the server returned 1724 bytes, 10 entries, last cookie of 12,
followed by the next readdirplus returning a length of 948 bytes, 5
entries, a first cookie value of 13. In the other capture, the responses
returned 2204 bytes, 13 entries, a last cookie of 17 and 468 bytes, 2
entries, a first cookie of 19.

In the past we've found that ls has returned duplicate entries on this
directory (but didn't have a capture at the time) and those duplicate
entries are the ones that are returned as the last 3 entries in the
first response of the second capture and the first 3 entries in the
second response of the first capture.

So what I think has happened in this particular case, is that at some
point in the past, the directory was read OK with packets similar to the
first capture. Next, the client decided to get rid of the first page of
cached readdir responses from memory for some reason (running low on
memory?) but kept the second page. Subsequently, the readdir cache needs
repopulating so the client sends a readdirplus specifying cookie of 0
and this time it gets a response which is similar to the first packet of
the second capture and thus we now have in cache duplicate names and
cookie values.

So is this possible? Is there some easy way to provoke it? Does this
mean the client's readdir cache is broken?

Please cc me on any response.

-- 
Andy, BlueArc Engineering


