Return-Path: <linux-kernel-owner+w=401wt.eu-S1755613AbYIOP3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbYIOP3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 11:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbYIOP3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 11:29:17 -0400
Received: from smtp2.smiths.com ([192.208.34.51]:33756 "EHLO smtp2.smiths.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959AbYIOP3Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 11:29:16 -0400
X-Greylist: delayed 1124 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Sep 2008 11:29:16 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Server process stalled during massive thread creation : scheduler problem ?
Date: Mon, 15 Sep 2008 09:10:30 -0600
Message-ID: <531F9EE7AD1E874595D59997FD3EAEED043D7666@COSSMGMBX05.EMAIL.CORP.TLD>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Server process stalled during massive thread creation : scheduler problem ?
Thread-Index: AckXRTFAtHq+8ZixTFCYQy8go1dkFQ==
From: "Cornelius, Martin (DWBI)" <Martin.Cornelius@smiths-heimann.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 15 Sep 2008 15:10:31.0526 (UTC) FILETIME=[31F79060:01C91745]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello scheduler hackers,

i just realized a behaviour of the scheduler that gets me thinking...

This is my test scenario:
On an otherwise unloaded machine, i run a server process that accepts
TCP connections, and after a client has connected, just echoes all the
packets that the client sends. A single client (sitting on another
machine) connects to the server, and then continuously sends packets (of
about 1000 bytes), and reads the echo. For each packet, the client
measures the round-trip-time time it takes to send the packet and
receive the echo. If nothing else happens on the server, this times are
always very short, a few millseconds or less.

While this echoing test is running, i set the server machine under
massive CPU load by starting a load-generating process that starts a
couple of threads. All threads run an endless loop without any I/O or
other blocking.

Behavior with 2.6.27rc6: If the number of threads started in the
load-generating process is sufficiently large (> 100), the server
process seems to be stalled during the startup of the load-generator.
With 100 threads in the load generator, the client observes one or two
round-trip-times of more than 1 second during load-generator startup.
When the load generator starts 1000 threads simultanously, the client is
stalled several times, one of them lasting more than 30 seconds. 
However, this stalling only appears during the startup of the
load-generator. After some time, the round trip times observed by the
client settle down, and from that point on are all reasonably short
again.

I also conducted this test with older kernels:

2.4.36: With this kernel, behaviour was really weird: When the server
was loaded with >100 threads, the client was stalled again and again for
several seconds, than ran smoothly for some time, until another period
of stalling began. It looked like the scheduler screwed up periodically,
until the bubble birsted and the stalling disappeared for a few seconds.

2.6.25.16: The client is only stalled during the startup of the load
generating process. However, for really long times. With 200 threads in
the load generator, i observered stalling for more than a minute.

Thus, the current kernel seems to pass this test best, but not
perfectly. Of course one might argue (like my colleagues do) that this
test presents a completely unrealistic scenario: hundreds of threads
started at the sime time, all not blocking. However, if i think of a
'BIG' java application server, i can imagine that a similar situation
could arise. From this perspective, one might say the behaviour of the
scheduler is not optimal and should be improved. If a server does not
respond for one minute, it's clients might (reasonably but erronously in
this case) conclude that the server is severely broken.

What do you think ?

BTW, the server was equipped with a dual-core Pentium CPU 3.40GHz.


 
************************************************
The information contained in, or attached to, this e-mail, may contain confidential information and is intended solely for the use of the individual or entity to whom they are addressed and may be subject to legal privilege.  If you have received this e-mail in error you should notify the sender immediately by reply e-mail, delete the message from your system and notify your system manager.  Please do not copy it for any purpose, or disclose its contents to any other person.  The views or opinions presented in this e-mail are solely those of the author and do not necessarily represent those of the company.  The recipient should check this e-mail and any attachments for the presence of viruses.  The company accepts no liability for any damage caused, directly or indirectly, by any virus transmitted in this email.
************************************************
