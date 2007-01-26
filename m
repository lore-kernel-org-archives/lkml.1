Return-Path: <linux-kernel-owner+w=401wt.eu-S1751669AbXAZVyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbXAZVyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 16:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbXAZVyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 16:54:23 -0500
Received: from imap.vc.cvut.cz ([147.32.240.222]:36883 "EHLO imap.vc.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbXAZVyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 16:54:22 -0500
X-Greylist: delayed 1847 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jan 2007 16:54:22 EST
Message-ID: <1169846450.45ba70b2698c2@imap.vc.cvut.cz>
Date: Fri, 26 Jan 2007 22:20:50 +0100
From: vandrove@vc.cvut.cz
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: ncpfs and TCP vs UDP
References: <45BA2437.4000803@drzeus.cx>
In-Reply-To: <45BA2437.4000803@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.0
X-Originating-IP: 65.113.40.130
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pierre Ossman <drzeus-list@drzeus.cx>:

> Hi Petr,

Hello,

> I was hoping you could give me some input on another concern I have.
> Which of TCP and UDP is the preferred transport for NCP? The client for
> Windows seems to use TCP, which would suggest that that is the most
> tested dialect. I also did a quick test with bonnie++:

TCP is definitely preferred.  There are couple of reasons why you should prefer TCP:

(1) There is server configuration option to disable NCP/UDP.  You cannot disable
NCP/TCP that easily.

(2) TCP (NCP over TCP) retransmits only missing data, and it can ask for
retransmit much sooner as it knows what link latency is.  NCP/UDP can only ask
for complete packet retransmission, and it has no good idea what's link latency
because there is no ACK from server when it receives request - you can only
resend after usual link latency + time for process request, so you'll wait
longer for retransmit, and on retransmit you need to send again complete request
(which can be 64KB of data if you use 64KB buffer size...)

(3) To avoid problems with retransmits ncpfs uses default buffer size 60KB for
TCP (SOCK_STREAM), while 1KB for UDP/IPX (it must be multiple of sector size, so
using 1.4KB is not an option).  So if you read 1 page, you get 1 request/reply
when using TCP, but 4 requests/replies in UDP/IPX.  And as all this is fully
synchronous, and for today's link latency is dominating factor, it will take 4
times longer...

(4) Theoretically with TCP you should never need retransmits as TCP takes care
of that.  Unfortunately due to server implementation you still cannot have more
than one request in flight (at least with NW5 - I never tried it with NW6 as
spec says I should not do that, and NW5 implementation agreed with spec).

> Machine Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
>         500M  1569  19  1714  10   826   9  1414  18  1569   9  65.2   3
>              ------Sequential Create------ --------Random Create--------
>              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
>        files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
>           16   460  14   897  16   556  15   491  15  1131  13   320   6

What was 'Block' size ?  For 1KB block size you should get more or less same
speed for TCP and UDP.  If you have link with big latency and big throughput,
then for 2KB block TCP should be 2 times faster, for 60KB block 60 times faster,
and above 60KB block difference should stay on 1:60.

You can try bumping NCP/UDP block size to 60KB as well, but my exprience with
switches and NetWare is that in such cases you can get into situation with
deterministic packet loss - like that from 40 UDP packets sent back to back to
server every 12th gets lost - and if you resend, again 12th packet gets lost,
again and again until you have some luck, or until client decides that server is
dead.
                                                          Petr

