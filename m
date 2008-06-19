Return-Path: <linux-kernel-owner+w=401wt.eu-S1758633AbYFSOXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633AbYFSOXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 10:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756474AbYFSOXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 10:23:13 -0400
Received: from 187.Red-80-37-203.staticIP.rima-tde.net ([80.37.203.187]:16762
	"EHLO betty.it.uc3m.es" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755654AbYFSOXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 10:23:12 -0400
X-Greylist: delayed 711 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jun 2008 10:23:12 EDT
From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Message-Id: <200806191411.m5JEBE56008942@betty.it.uc3m.es>
Subject: zero-copy recv ?
X-ELM-OSV: (Our standard violations) hdr-charset=US-ASCII; no-hdr-encoding=1
To: linux kernel <linux-kernel@vger.kernel.org>
Date: Thu, 19 Jun 2008 16:11:14 +0200 (CEST)
Reply-To: ptb@inv.it.uc3m.es
X-Anonymously-To: 
X-message-flag: Had your Outlook virus, today?
 http://www.counterpane.com/crypto-gram-0103.html#4
X-WebTV-Stationery: Standard\; BGColor=black\; TextColor=black
X-Mailer: ELM [version 2.4ME+ PL123]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

G'day all

I've been mmapping the request's bio buffers received on my block device
driver for userspace to use directly as tcp send/receive buffers.
However ...

  1) this works fantastically for (zero-copy) tcp send (i.e.
    from the address in user space that my mmap trick provides for the
    request buffers),
    
  2) tcp recv hangs.

What's going on? I'd be grateful for any clues as to how to fix this as
it's tcp zero-copy on recv when it goes OK!

What does tcp socket recv need exactly by way of an mmapped buffer?

Is there some set of flags that needs to be set on the pages that make
up the mmap?

Recv() hangs somewhere inside the tcp recv call inside kernel paths that
I cannot trace.  I see "recv(5, ...)" via strace.  The data is sent out
on the wire from the other side and apparently comes in, but the socket
tcp recv never progresses.

If, OTOH, I have previously written the device at that point, then
reading the device causes a request to appear at the device driver
with pages carrying the flags

    40001826

(referenced|error|lru|private|writeback)

and all works fantastically in the sense that recv called with those
pages mmapped into userspace as the recv buffer works just like it
should.

When the device has not been written at that point previously, then
I see pages appearing in the request bio buffers with pretty
random-looking flags, such as

    40020801

(locked|private|readahead)

and recv does its hang trick.

Does anyone have any insight as to what is going on?

Thanks


Peter

